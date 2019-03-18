# keepalived 配置

include:
  - keepalived.keepalived_install

# keepalived 配置文件
keepalived-conf:
  file.managed:
    - name: /app/keepalived/etc/keepalived/keepalived.conf
    - source: salt://keepalived/files/keepalived.conf
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - cmd: keepalived-install
    - template: jinja
    - defaults:
      Router_Id: haproxy_ha
      Vrrp_Instance: haproxy_ha
      State: {{ pillar['high_available_info']['high_state'] }}
      Interface: eth0
      Priority: {{ pillar['high_available_info']['high_priority'] }}
      Virtual_Ip: 172.16.1.110

# keepalived 系统管理文件
keepalived-system-manage:
  file.managed:
    - name: /usr/lib/systemd/system/keepalived.service
    - source: salt://keepalived/files/keepalived.service
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - cmd: keepalived-install
      - file: keepalived-conf

# keepalived service
keepalived-service:
  service.running:
    - name: keepalived
    - enable: True
    - restart: True
    - watch:
      - file: keepalived-system-manage

