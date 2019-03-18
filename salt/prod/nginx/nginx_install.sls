# 安装 Nginx

# 导入 nginx 变量
{% from 'nginx/nginx_var.info' import nginx_salt_path, nginx_version %}

nginx-install:
  ## tar 包传输
  file.managed:
    - name: {{ nginx_salt_path() }}/nginx-{{ nginx_version() }}.tar.gz
    - source: salt://nginx/files/nginx-{{ nginx_version() }}.tar.gz
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion

  cmd.run:
    - name: . /etc/profile && cd {{ nginx_salt_path() }} && tar xf nginx-{{ nginx_version() }}.tar.gz && cd nginx-{{ nginx_version() }} && ./configure --prefix=/app/nginx-{{ nginx_version() }} --user=www --group=www --with-http_ssl_module --with-stream --with-http_stub_status_module --with-file-aio && make && make install && cd /app && ln -s /app/nginx-{{ nginx_version() }} nginx
    - onlyif: test "{{ pillar['web_info']['web'] }}" = "nginx"
    - unless: test -f /app/nginx/sbin/nginx
    - require:
      - file: nginx-install

