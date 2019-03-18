# 安装 php

# 导入 php 变量
{% from 'php/php_var.info' import php_salt_path, php_version, libiconv_version, libiconv_insert, libiconv_append, php_compile %}

include:
  - php.php_pkg
  - php.libiconv_install
  - php.php_libmysqlclient

php-install:
  ## 将 tar 包传到目标机器
  file.managed:
    - name: {{ php_salt_path() }}/php-{{ php_version() }}.tar.gz
    - source: salt://php/files/php-{{ php_version() }}.tar.gz
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion

  ## 安装 php
  cmd.run:
    - name: . /etc/profile && cd {{ php_salt_path() }} && tar xf php-{{ php_version() }}.tar.gz && cd php-{{ php_version() }} && {{ php_compile() }} && touch ext/phar/phar.phar && make && make install && ln -s /app/php-{{ php_version() }} /app/php
    - onlyif: test "{{ pillar['program_info']['program'] }}" = "php"
    - unless: test -f /app/php/bin/php
    - require:
      - pkg: php-pkg
      - cmd: libiconv-install
      - file: php-libmysqlclient
      - file: php-install


