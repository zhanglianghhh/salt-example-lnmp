# shell 脚本会调用该sls文件，因此请使用shell脚本执行
# 主从复制 slave操作

# mysql 主从 slave端操作

# 导入 mysql 变量
{% from 'mysql/mysql_var.info' import mysql_salt_path, mysql_version, mysql_password, mysql_rep_password, mysql_rep_salt_path %}

# 将主MySQL的备份文件导入从库
master-slave-rep-slave-01:
  file.managed:
    - name: {{ mysql_rep_salt_path() }}/salt_rep_back.sql.gz
    - source: salt://mysql_master_slave/files/salt_rep_back.sql.gz
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion

  cmd.run:
    - name: . /etc/profile && cd {{ mysql_rep_salt_path() }} && cp -a salt_rep_back.sql.gz salt_rep_back.sql.gz_bak && gzip -d salt_rep_back.sql.gz && mv salt_rep_back.sql.gz_bak salt_rep_back.sql.gz && mysql -uroot -p{{ mysql_password() }} < salt_rep_back.sql && systemctl restart mysqld.service 
    - onlyif: test "{{ pillar['database_info']['database'] }}" = "mysql" && test "{{ pillar['database_info']['role'] }}" = "slave"
    - unless: . /etc/profile && test -f {{ mysql_rep_salt_path() }}/salt_rep_back.sql && (mysql -uroot -p{{ mysql_password() }} -e"select user,host from mysql.user;" | grep 'rep')
    - require:
      - file: master-slave-rep-slave-01

# 配置master.info文件 与 开启从库开关
master-slave-rep-slave-02:
  file.managed:
    - name: {{ mysql_rep_salt_path() }}/master.info.txt
    - source: salt://mysql_master_slave/files/master.info.txt
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - cmd: master-slave-rep-slave-01

  cmd.run:
    - name: . /etc/profile && systemctl restart mysqld.service && cd {{ mysql_rep_salt_path() }} && awk '{print "mysql -uroot -p{{ mysql_password() }} -e\"", $0 ,"\""}' master.info.txt | bash && mysql -uroot -p{{ mysql_password() }} -e"start slave;"
    - onlyif: test "{{ pillar['database_info']['database'] }}" = "mysql" && test "{{ pillar['database_info']['role'] }}" = "slave"
    - unless: . /etc/profile && (mysql -uroot -p{{ mysql_password() }} -e"show slave status \G;" | grep 'Slave_IO_Running.*Yes$') && (test -f $(mysql -uroot -p{{ mysql_password() }} -e"show slave status \G" | grep 'Master_Info_File' | awk -F' ' '{print $2}'))
    - require:
      - file: master-slave-rep-slave-02

