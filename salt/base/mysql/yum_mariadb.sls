# yum mariadb

# 导入 mysql 变量
{% from 'mysql/mysql_var.info' import mysql_password %}

# yum 安装 mariadb
yum-mariadb:
  ## 包安装
  pkg.installed:
    - names:
      - mariadb
      - mariadb-server

  ## 配置文件管理
  file.managed:
    - name: /etc/my.cnf
    - source: salt://mysql/files/yum_mariadb_my.cnf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - pkg: yum-mariadb

  ## 加入开机自启动并启动服务
  service.running:
    ### 具体的服务名称
    ### systemctl status mariadb.service  那么名称就为 mariadb
    - name: mariadb
    - enable: True
    - restart: True
    - watch:
      - file: yum-mariadb

  ## 初始化MySQL root用户的密码
  cmd.run:
    ### 设置local密码, 设置密码【注意主机信息】, 用于远程登录, 删除无密码的用户 【上面几步顺序不能乱】, 刷新权限信息
    ### $(hostname) 获取主机信息
    - name: mysqladmin -uroot password {{ mysql_password() }} && mysqladmin -uroot -h$(hostname) password {{ mysql_password() }} && mysql -uroot -p{{ mysql_password() }} -e "grant all on *.* to root@'%' identified by '{{ mysql_password() }}';" && mysql -uroot -p{{ mysql_password() }} -e "delete from mysql.user where password = '';" && mysql -uroot -p{{ mysql_password() }} -e "flush privileges;" 
    ### 如果 unless 后面的返回为 0 那么不执行上面 name的命令，否则执行
    - unless: mysql -uroot -p{{ mysql_password() }} -e "flush privileges;"
    - require:
      - pkg: yum-mariadb

