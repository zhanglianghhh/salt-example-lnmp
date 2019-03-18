# haproxy 配置

include:
  - haproxy.haproxy_install

# haproxy 配置文件
haproxy-conf:
  file.managed:
    - name: /app/haproxy/etc/haproxy.cfg
    - source: salt://haproxy/files/haproxy.cfg
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - cmd: haproxy-install

# 加入系统管理
haproxy-system-manage:
  file.managed:
    - name: /etc/init.d/haproxy
    - source: salt://haproxy/files/haproxy.init.service
    - user: root
    - group: root
    - mode: 775
    - backup: minion
    - require:
      - cmd: haproxy-install
      - file: haproxy-conf

  cmd.run:
    - name: . /etc/profile && chkconfig --add haproxy && chkconfig haproxy on
    - onlyif: test "{{ pillar['proxy_info']['proxy'] }}" = "haproxy"
    - unless: chkconfig --list | grep 'haproxy.*3:on'
    - require: 
      - file: haproxy-system-manage

# haproxy service
haproxy-service:
  service.running:
    - name: haproxy
    - enable: True
    ### reload 支持不好，因此用 restart
    - restart: True
    - watch:
      - file: haproxy-conf

