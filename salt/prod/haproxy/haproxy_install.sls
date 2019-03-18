# 安装 haproxy

# 导入 haproxy 变量
{% from 'haproxy/haproxy_var.info' import haproxy_salt_path, haproxy_version %}

haproxy-install:
  ## tar 包传输
  file.managed:
    - name: {{ haproxy_salt_path() }}/haproxy-{{ haproxy_version() }}.tar.gz
    - source: salt://haproxy/files/haproxy-{{ haproxy_version() }}.tar.gz
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion

  ## 部署
  cmd.run:
    - name: . /etc/profile && cd {{ haproxy_salt_path() }} && tar xf haproxy-{{ haproxy_version() }}.tar.gz && cd haproxy-{{ haproxy_version() }} && make TARGET=linux26 ARCH=x86_64 PREFIX=/app/haproxy-{{ haproxy_version() }} && make install PREFIX=/app/haproxy-{{ haproxy_version() }} && ln -s /app/haproxy-{{ haproxy_version() }} /app/haproxy 
    - onlyif: test "{{ pillar['proxy_info']['proxy'] }}" = "haproxy"
    - unless: test -f /app/haproxy/sbin/haproxy
    - require:
      - file: haproxy-install

