# 因为memcached扩展是基于libevent的事件处理的, 首先需要安装libmemcached
# 包来源：https://launchpad.net/libmemcached/+download

# 导入 libiconv 变量
{% from 'php_memcached/memcached_var.info' import php_memcached_salt_path, libmemcached_version, php_memcached_version, php_dir, php_memcached_path, memcached_host %}

include:
  - php_memcached.php_memcached_pkg

libmemcached-install:
  ## 将 tar 包传到目标机器
  file.managed:
    - name: {{ php_memcached_salt_path() }}/libmemcached-{{ libmemcached_version() }}.tar.gz
    - source: salt://php_memcached/files/libmemcached-{{ libmemcached_version() }}.tar.gz
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion

  ## 安装 libmemcached
  cmd.run:
    - name: . /etc/profile && cd {{ php_memcached_salt_path() }} && tar xf libmemcached-{{ libmemcached_version() }}.tar.gz && cd libmemcached-{{ libmemcached_version() }} && ./configure --prefix=/usr/local/libmemcached --with-memcached && make && make install
    - onlyif: test "{{ pillar['program_info']['program'] }}" = "php"
    - unless: test -d /usr/local/libmemcached
    - require:
      - file: libmemcached-install

