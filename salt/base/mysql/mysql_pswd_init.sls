# mysql 用户初始化

# 导入 mysql 变量
{% from 'mysql/mysql_var.info' import mysql_salt_path, mysql_version, mysql_compile, mysql_password, mysql_test_user, mysql_test_password %}

include:
  - mysql.mysql_service

# 初始化MySQL root用户的密码
mysql-pwd-init:
  cmd.run:
    ### 设置localhost密码, 设置本地主机密码【注意主机信息】, 创建远程登录账号并设置密码, 删除无密码的用户 【上面几步顺序不能乱】, 刷新权限信息
    ### $(hostname) 获取主机信息
    - name: . /etc/profile && mysqladmin -uroot password {{ mysql_password() }} && mysqladmin -uroot -h$(hostname) password {{ mysql_password() }} && mysql -uroot -p{{ mysql_password() }} -e "grant all on *.* to root@'%' identified by '{{ mysql_password() }}';" && mysql -uroot -p{{ mysql_password() }} -e "delete from mysql.user where password = '';" && mysql -uroot -p{{ mysql_password() }} -e "flush privileges;" 
    - onlyif: test "{{ pillar['database_info']['database'] }}" = "mysql"
    ### 如果 unless 后面的返回为 0 那么不执行上面 name的命令，否则执行
    ### . /etc/profile 是为了得到mysql执行命令的环境变量
    - unless: . /etc/profile && mysql -uroot -p{{ mysql_password() }} -e "flush privileges;"
    - require:
      - cmd: database-init
      - service: mysql-service

# 给test库创建用户和密码  用于测试
mysql-test-init:
  cmd.run:
    - name: . /etc/profile && mysql -uroot -p{{ mysql_password() }} -e"grant all privileges on test.* to {{ mysql_test_user() }}@'{{ grains['host'] }}' identified by '{{ mysql_test_password() }}'; grant all privileges on test.* to {{ mysql_test_user() }}@'%' identified by '{{ mysql_test_password() }}'; flush privileges;"
    - onlyif: test "{{ pillar['database_info']['database'] }}" = "mysql"
    - unless: . /etc/profile && mysql -h{{ grains['host'] }} -u{{ mysql_test_user() }} -p{{ mysql_test_password() }} -e "show databases;"
    - require:
      - cmd: database-init
      - service: mysql-service

