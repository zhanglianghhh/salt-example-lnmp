# 使用的编程语言
{% if grains['host'] == 'salt03-web' or grains['host'] == 'salt04-web' or grains['host'] == 'salt05-web' %}
program_info:
  program: php
{% endif %}

