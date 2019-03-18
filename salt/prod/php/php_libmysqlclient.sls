# 放置 libmysqlclient.so.18 

php-libmysqlclient:
  ## 将 文件 传到目标机器
  file.managed:
    - name: /usr/lib64/libmysqlclient.so.18
    - source: salt://php/files/libmysqlclient.so.18
    - makedirs: True
    - user: root
    - group: root
    - mode: 755
    - backup: minion

