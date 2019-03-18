# nginx_php_mysql 整合

# 导入变量
{% from 'nginx_php_mysql/nginx_php_mysql_var.info' import nginx_php_conf_path, php_mysql_conf_path, mysql_host01, mysql_host02, mysql_host03, mysql_test_user, mysql_test_password %}

# php 和 MySQL 整合
php-mysql-union:
  file.managed:
    - name: {{ php_mysql_conf_path() }}/test_mysql.php
    - source: salt://nginx_php_mysql/files/test_mysql.php
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - backup: minion
    - template: jinja
    - defaults:
      mysql_host01: {{ mysql_host01() }}
      mysql_host02: {{ mysql_host02() }}
      mysql_host03: {{ mysql_host03() }}
      mysql_test_user: {{ mysql_test_user() }}
      mysql_test_password: {{ mysql_test_password() }}
      hostname: {{ grains['host'] }}

# nginx 和 php 整合
nginx-php-union:
  file.managed:
    - name: {{ nginx_php_conf_path() }}/nginx_php.conf
    - source: salt://nginx_php_mysql/files/nginx_php.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - backup: minion

  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: nginx-php-union


