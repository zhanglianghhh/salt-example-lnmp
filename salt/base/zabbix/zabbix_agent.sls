# zabbix agent 端部署

# 导入zabbix变量
{% from 'zabbix/zabbix_var.info' import zabbix_salt_path, zabbix_version, zabbix_db_host, zabbix_db_name, zabbix_db_user, zabbix_db_pwd, zabbix_root_user, mysql_root_pwd %}

include:
  - zabbix.zabbix_yum_rpm

# yum安装zabbix agent
zabbix-agent-yum:
  ## yum安装zabbix agent
  pkg.installed:
    - names:
      - zabbix-agent
    - require:
      - cmd: zabbix-yum-rpm

# zabbix 客户端配置
zabbix-config-agent:
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://zabbix/files/zabbix_agentd.conf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - pkg: zabbix-agent-yum
    - template: jinja
    - defaults:
      zabbix_server_hostname: {{ pillar['monitor_info']['monitor']['zabbix_server_hostname'] }}
      zabbix_agent_hostname: {{ grains['host'] }}

# 启动zabbix agent
# 加入开机自启动
zabbix-agent:
  service.running:
    - name: zabbix-agent
    - enable: True
    - reload: True
    - require:
      - pkg: zabbix-agent-yum
    - watch:
      - file: zabbix-config-agent

