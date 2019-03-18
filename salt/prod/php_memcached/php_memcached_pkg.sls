# 如果需要适用sasl, 也可以在安装libmemcahced前安装cyrus-sasl-devel

php-memcached-pkg:
  pkg.installed:
    - names:
      - cyrus-sasl-devel

