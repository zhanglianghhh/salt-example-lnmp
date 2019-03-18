# php 配置

# 导入 php 变量
{% from 'php/php_var.info' import php_salt_path, php_version, libiconv_version, libiconv_insert, libiconv_append, php_compile %}

include:
  - php.php_install

# php 的 ini 配置
php-ini:
  cmd.run:
    - name: . /etc/profile && cd {{ php_salt_path() }}/php-{{ php_version() }} && cp -a php.ini-production /app/php/lib/php.ini
    - onlyif: test "{{ pillar['program_info']['program'] }}" = "php"
    - unless: test -f /app/php/lib/php.ini
    - require:
      - cmd: php-install

# php 的 conf 配置
php-conf:
  cmd.run:
    - name: . /etc/profile && cd /app/php/etc/ && cp -a php-fpm.conf.default php-fpm.conf
    - onlyif: test "{{ pillar['program_info']['program'] }}" = "php"
    - unless: test -f /app/php/etc/php-fpm.conf
    - require:
      - cmd: php-install

# 加入系统管理
php-system-manage:
  cmd.run:
    - name: . /etc/profile && cd {{ php_salt_path() }}/php-{{ php_version() }} && \cp -a sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm && chmod +x /etc/init.d/php-fpm && chkconfig --add php-fpm && chkconfig  php-fpm on
    - onlyif: test "{{ pillar['program_info']['program'] }}" = "php"
    - unless: chkconfig --list | grep 'php-fpm.*3:on'
    - require: 
      - cmd: php-install

php-service:
  service.running:
    - name: php-fpm
    - enable: True
    - restart: True
    - watch:
      - cmd: php-ini
      - cmd: php-conf


