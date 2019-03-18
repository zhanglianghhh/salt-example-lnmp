# web 服务器
{% if grains['host'] == 'salt03-web' or grains['host'] == 'salt04-web' or grains['host'] == 'salt05-web' %}
web_info:
  web: nginx
{% endif %}

