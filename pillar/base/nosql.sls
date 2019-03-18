# nosql 信息
{% if grains['host'] == 'salt05-web' %}
nosql_info:
  nosql: memcached
{% endif %}

