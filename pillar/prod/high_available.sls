# 高可用keepalived 的 pillar 信息
{% if grains['host'] == 'salt01-haproxy' %}
high_available_info:
  high_available: keepalived
  high_state: MASTER
  high_priority: 100
{% elif grains['host'] == 'salt02-haproxy' %}
high_available_info:
  high_available: keepalived
  high_state: BACKUP
  high_priority: 50
{% endif %}

