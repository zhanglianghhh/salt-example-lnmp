# 负载均衡服务器
{% if grains['host'] == 'salt01-haproxy' or grains['host'] == 'salt02-haproxy' %}
proxy_info:
  proxy: haproxy
{% endif %}

