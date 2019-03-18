# 数据库信息
# 包含配置文件信息
# 注意和 zabbix pillar 不同 的写法
{% if grains['host'] == 'salt03-web' %}
database_info:
  database: mysql
  role: master
  server-id: 1
  read_only: "OFF"
{% elif grains['host'] == 'salt04-web' %}
database_info:
  database: mysql
  role: slave
  server-id: 2
  read_only: "ON"
{% elif grains['host'] == 'salt05-web' %}
database_info:
  database: mysql
  role: slave
  server-id: 3
  read_only: "ON"
{% elif grains['host'] == 'salt150-master' %}
database_info:
  database: mariadb
  read_only: "OFF"
{% endif %}

