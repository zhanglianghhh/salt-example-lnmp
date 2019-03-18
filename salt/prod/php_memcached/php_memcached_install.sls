# 安装memcached扩展
# 包来源：https://pecl.php.net/package/memcached

# 导入 libiconv 变量
{% from 'php_memcached/memcached_var.info' import php_memcached_salt_path, libmemcached_version, php_memcached_version, php_dir, php_memcached_path, memcached_host %}

include:
  - php_memcached.libmemcached_install

# 安装部署memcached扩展
php-memcached-install:
  ## 将 tar 包传到目标机器
  file.managed:
    - name: {{ php_memcached_salt_path() }}/memcached-{{ php_memcached_version() }}.tgz
    - source: salt://php_memcached/files/memcached-{{ php_memcached_version() }}.tgz
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion

  ## 安装 memcached 扩展
  cmd.run:
    - name: . /etc/profile && cd {{ php_memcached_salt_path() }} && tar xf memcached-{{ php_memcached_version() }}.tgz && cd memcached-{{ php_memcached_version() }} && {{ php_dir() }}/bin/phpize && ./configure --with-php-config={{ php_dir() }}/bin/php-config --disable-memcached-sasl --with-libmemcached-dir=/usr/local/libmemcached && make && make install 
    - onlyif: test "{{ pillar['program_info']['program'] }}" = "php"
    - unless: find {{ php_dir() }}/lib/php/extensions -type f | grep 'memcached.so'
    - require:
      - file: php-memcached-install

# 添加扩展信息
# /app/php/bin/php -m | grep memcached  可查看是否安装 该扩展
add-extension:
  file.append:
    - name: {{ php_dir() }}/lib/php.ini
    - text:
      - "; ####"
      - "; ## add extension ##"
      - extension=memcached.so
    - require:
      - cmd: php-memcached-install

# 需要重启服务
php-extension-service:
  service.running:
    - name: php-fpm
    - enable: True
    - restart: True
    - watch:
      - file: add-extension

