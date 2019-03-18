# 其中 salt150-maste 172.16.1.150 机器，不仅是 zabbix 客户端，还是服务端
# 只包含 zabbix 的属性 【服务端 客户端】
monitor_info:
  monitor:
    {% if grains['host'] == 'salt150-master' %}
    zabbix_server: True
    {% endif %}
    zabbix_agent: True
    zabbix_server_hostname: 'salt150-master'

