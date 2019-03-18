# php 和 memcached整合

# 导入 libiconv 变量
{% from 'php_memcached/memcached_var.info' import php_memcached_salt_path, libmemcached_version, php_memcached_version, php_dir, php_memcached_path, memcached_host %}

include:
  - php_memcached.php_memcached_install

php-memcached-union:
  file.managed:
    - name: {{ php_memcached_path() }}/test_memcached.php
    - source: salt://php_memcached/files/test_memcached.php
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - template: jinja
    - defaults:
      memcached_host: {{ memcached_host() }}
      hostname: {{ grains['host'] }}

