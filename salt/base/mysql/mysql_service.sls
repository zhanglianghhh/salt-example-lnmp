# mysql 配置与服务

# 导入 mysql 变量
{% from 'mysql/mysql_var.info' import mysql_salt_path, mysql_version, mysql_compile, mysql_password %}

include:
  - mysql.mysql_install

# mysql 配置文件
mysql-conf:
  file.managed:
    - name: /etc/my.cnf
    - source: salt://mysql/files/mysql-{{ mysql_version() }}_my.cnf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - cmd: mysql-install
    - template: jinja
    - defaults:
      Server_Id: "server-id={{ pillar['database_info']['server-id'] }}"
      Read_Only: "read_only={{ pillar['database_info']['read_only'] }}"

# mysql 数据库初始化
database-init:
  cmd.run:
    - name: . /etc/profile && cd /app/mysql && ./scripts/mysql_install_db --basedir=/app/mysql/ --datadir=/app/mysql/data/ --user=mysql
    - onlyif: test "{{ pillar['database_info']['database'] }}" = "mysql"
    ### 判断是否有 mysql 库
    - unless: test -d /app/mysql/data/mysql
    - require:
      - cmd: mysql-install

# 加入系统管理  开机自启动
mysql-system-manage:
  cmd.run:
    - name: . /etc/profile && cd /app/mysql && cp -a support-files/mysql.server /etc/init.d/mysqld && chmod 755 /etc/init.d/mysqld && chkconfig --add mysqld && chkconfig mysqld on
    - onlyif: test "{{ pillar['database_info']['database'] }}" = "mysql"
    - unless: chkconfig --list | grep 'mysqld.*3:on'
    - require: 
      - cmd: mysql-install
      - cmd: database-init

# mysql service
mysql-service:
  service.running:
    - name: mysqld
    - enable: True
    ### reload 没有，因此用 restart
    - restart: True
    - require:
      - cmd: mysql-system-manage
    - watch:
      - file: mysql-conf

