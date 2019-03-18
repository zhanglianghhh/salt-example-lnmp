# shell 脚本会调用该sls文件，因此请使用shell脚本执行
# 主从复制 master操作

# mysql 主从 master端操作

# 导入 mysql 变量
{% from 'mysql/mysql_var.info' import mysql_salt_path, mysql_version, mysql_password, mysql_rep_password, mysql_rep_salt_path %}

# 创建并授权用于复制的用户rep
master-slave-rep-master-01:
  cmd.run:
    - name: . /etc/profile && mysql -uroot -p{{ mysql_password() }} -e "grant replication slave on *.* TO 'rep'@'%' identified by '{{ mysql_rep_password() }}';" && mysql -uroot -p{{ mysql_password() }} -e "flush privileges;"
    ### 只有目标主机的pillar信息中MySQL的属性是master才会执行
    - onlyif: test "{{ pillar['database_info']['database'] }}" = "mysql" && test "{{ pillar['database_info']['role'] }}" = "master"
    - unless: . /etc/profile && grep 'server-id={{ pillar['database_info']['server-id'] }}' /etc/my.cnf && (mysql -uroot -p{{ mysql_password() }} -e"select user,host from mysql.user;" | grep 'rep')


# 锁表
# 得到binlog的位置点
# 对主MySQL的数据库打包
# 解锁
master-slave-rep-master-02:
  cmd.run:
    - name: . /etc/profile && mkdir -p {{ mysql_rep_salt_path() }} &&  mysql -uroot -p{{ mysql_password() }} -e "flush table with read lock;" && echo "CHANGE MASTER TO MASTER_HOST='$(hostname)', MASTER_PORT=3306, MASTER_USER='rep',MASTER_PASSWORD='{{ mysql_rep_password() }}',MASTER_LOG_FILE='$(mysql -uroot -p{{ mysql_password() }} -e "show master status;" | grep 'mysql-bin' | awk -F'\t' '{print $1}')',MASTER_LOG_POS=$(mysql -uroot -p{{ mysql_password() }} -e "show master status;" | grep 'mysql-bin' | awk -F'\t' '{print $2}');" > {{ mysql_rep_salt_path() }}/master.info.txt && mysqldump -uroot -p{{ mysql_password() }} -A -B --events | gzip > {{ mysql_rep_salt_path() }}/salt_rep_back.sql.gz && mysql -uroot -p{{ mysql_password() }} -e "unlock table;"
    - onlyif: test "{{ pillar['database_info']['database'] }}" = "mysql" && test "{{ pillar['database_info']['role'] }}" = "master"
    ### 如果需要重新开始主从复制，那么删除 master.info.txt salt_rep_back.sql.gz  即可
    ### 并在 slave 端  关闭主从复制，删除 master.info，重启MySQL服务
    - unless: test -f {{ mysql_rep_salt_path() }}/master.info.txt && test -f {{ mysql_rep_salt_path() }}/salt_rep_back.sql.gz
    - require:
      - cmd: master-slave-rep-master-01

