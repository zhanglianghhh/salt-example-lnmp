base:
  '*':
    # 机器初始化安装与配置
    - init.init

  # mariadb yum 部署，用作于zabbix的数据库
  # pillar 匹配
  'database_info:database:mariadb':
    - match: pillar
    - mysql.yum_mariadb

  # mysql 编译安装，用于业务组件数据存储
  'database_info:database:mysql':
    - match: pillar
    - mysql.mysql_install
    - mysql.mysql_service
    - mysql.mysql_pswd_init

  # memcached yum 部署，用于session缓存
  'nosql_info:nosql:memcached':
    - match: pillar
    - memcached.memcached_install

  # zabbix-server yum 部署，用于监控服务端
  'monitor_info:monitor:zabbix_server:True':
    - match: pillar
    - zabbix.zabbix_yum_rpm
    - zabbix.zabbix_server

  # zabbix-server yum 部署，用于监控客户端
  'monitor_info:monitor:zabbix_agent:True':
    - match: pillar
    - zabbix.zabbix_yum_rpm
    - zabbix.zabbix_agent


prod:
  # nginx 编译安装
  'web_info:web:nginx':
    - match: pillar
    - nginx.nginx_install
    - nginx.nginx_service

  # php 相关信息
  'program_info:program:php':
    - match: pillar
    # php 编译安装
    - php.php_pkg
    - php.libiconv_install
    - php.php_libmysqlclient
    - php.php_install
    - php.php_service
    # php 和 Nginx、MySQL整合
    - nginx_php_mysql.nginx_php_mysql_union
    # php 和 memcached 整合
    - php_memcached.php_memcached_pkg
    - php_memcached.libmemcached_install
    - php_memcached.php_memcached_install
    - php_memcached.php_memcached_union

  # haproxy 编译安装
  'proxy_info:proxy:haproxy':
    - match: pillar
    - haproxy.haproxy_install
    - haproxy.haproxy_service

  # keepalived 编译安装
  'high_available_info:high_available:keepalived':
    - match: pillar
    - keepalived.keepalived_install
    - keepalived.keepalived_service



