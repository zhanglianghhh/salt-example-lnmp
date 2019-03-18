# 需要安装指定的zabbix版本，因此需要rpm包

# 导入zabbix变量
{% from 'zabbix/zabbix_var.info' import zabbix_salt_path, zabbix_version, zabbix_db_host, zabbix_db_name, zabbix_db_user, zabbix_db_pwd, zabbix_root_user, mysql_root_pwd %}

zabbix-yum-rpm:
  ## 将rpm 包传到目标机器
  file.managed:
    - name: {{ zabbix_salt_path() }}/zabbix-release-{{ zabbix_version() }}-1.el7.noarch.rpm
    - source: salt://zabbix/files/zabbix-release-{{ zabbix_version() }}-1.el7.noarch.rpm
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion

  ## rpm 安装
  cmd.run:
    - name: . /etc/profile && cd {{ zabbix_salt_path() }} && rpm -Uvh zabbix-release-{{ zabbix_version() }}-1.el7.noarch.rpm
    - unless: rpm -qa | grep 'zabbix-release-{{ zabbix_version() }}-1.el7.noarch'
    - require:
      - file: zabbix-yum-rpm

