# zabbix server 端部署

# 导入zabbix变量
{% from 'zabbix/zabbix_var.info' import zabbix_salt_path, zabbix_version, zabbix_db_host, zabbix_db_name, zabbix_db_user, zabbix_db_pwd, zabbix_root_user, mysql_root_pwd %}

include:
  - zabbix.zabbix_yum_rpm

# yum安装zabbix server
zabbix-server-yum:
  ## yum安装zabbix server
  pkg.installed:
    - names:
      - zabbix-server-mysql
      - zabbix-web-mysql
      - zabbix-get
    - require:
      - cmd: zabbix-yum-rpm

# 中文支持
# wqy-microhei-fonts 为中文支持，zabbix自带的中文支持不好
zabbix-support-cn:
  cmd.run:
    - name: . /etc/profile && yum -y install wqy-microhei-fonts && cd /usr/share/zabbix/fonts && mv graphfont.ttf graphfont.ttf_salt_$(date +%Y%d%d%H%M%S).bak && cp -a /usr/share/fonts/wqy-microhei/wqy-microhei.ttc graphfont.ttf
    - onlyif: test "{{ pillar['monitor_info']['monitor']['zabbix_server'] }}" = "True"
    - unless: test -f /usr/share/zabbix/fonts/graphfont.ttf && (file /usr/share/zabbix/fonts/graphfont.ttf | grep -v 'symbolic')
    - require:
      - pkg: zabbix-server-yum

# zabbix的httpd配置
# 主要是了修改时区
zabbix-config-httpd:
  file.managed:
    - name: /etc/httpd/conf.d/zabbix.conf
    - source: salt://zabbix/files/zabbix.conf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - pkg: zabbix-server-yum

# zabbix 服务端配置
# 配置数据库密码
zabbix-config-server:
  file.managed:
    - name: /etc/zabbix/zabbix_server.conf
    - source: salt://zabbix/files/zabbix_server.conf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - pkg: zabbix-server-yum
    - template: jinja
    - defaults:
      zabbix_db_host: {{ zabbix_db_host() }}
      zabbix_db_name: {{ zabbix_db_name() }}
      zabbix_db_user: {{ zabbix_db_user() }}
      zabbix_db_pwd: {{ zabbix_db_pwd() }}

# 创建zabbix使用库与授权
zabbix-mysql-grant:
  cmd.run:
    - name: . /etc/profile && mysql -h{{ zabbix_db_host() }} -u{{ zabbix_root_user() }} -p{{ mysql_root_pwd() }} -e"create database {{ zabbix_db_name() }} character set utf8; grant all privileges on {{ zabbix_db_name() }}.* to {{ zabbix_db_user() }}@'localhost' identified by '{{ zabbix_db_pwd() }}'; grant all privileges on {{ zabbix_db_name() }}.* to {{ zabbix_db_user() }}@'{{ zabbix_db_host() }}' identified by '{{ zabbix_db_pwd() }}'; grant all privileges on {{ zabbix_db_name() }}.* to {{ zabbix_db_user() }}@'%' identified by '{{ zabbix_db_pwd() }}'; flush privileges;"
    - onlyif: test "{{ pillar['monitor_info']['monitor']['zabbix_server'] }}" = "True"
    - unless: . /etc/profile && (mysql -h{{ zabbix_db_host() }} -u{{ zabbix_root_user() }} -p{{ mysql_root_pwd() }} -e"select user,host from mysql.user;" | grep '{{ zabbix_db_user() }}')
    - require:
      - pkg: zabbix-server-yum

# 初始化数据库表信息
zabbix-mysql-init:
  cmd.run:
    - name: . /etc/profile && zcat /usr/share/doc/zabbix-server-mysql*/create.sql.gz | mysql -h{{ zabbix_db_host() }} -u{{ zabbix_db_user() }} -p{{ zabbix_db_pwd() }} {{ zabbix_db_name() }}
    - onlyif: test "{{ pillar['monitor_info']['monitor']['zabbix_server'] }}" = "True"
    - unless: . /etc/profile && test $(mysql -h{{ zabbix_db_host() }} -u{{ zabbix_db_user() }} -p{{ zabbix_db_pwd() }} -e"use {{ zabbix_db_name() }}; show tables;" | wc -l) -gt 3
    - require:
      - cmd: zabbix-mysql-grant

# 启动zabbix server和httpd
# 加入开机自启动
zabbix-service:
  service.running:
    - name: zabbix-server
    - enable: True
    - reload: True
    - require:
      - pkg: zabbix-server-yum
    - watch:
      - file: zabbix-config-server

httpd-service:
  service.running:
    - name: httpd
    - enable: True
    - restart: True
    - require:
      - pkg: zabbix-server-yum
    - watch:
      - file: zabbix-config-httpd

