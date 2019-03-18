# 添加 www 用户  用于web服务

user-www:
  group.present:
    - name: www
    - gid: 1200

  user.present:
    - name: www
    - fullname: www
    - createhome: False
    - shell: /sbin/nologin
    - uid: 1200
    - gid: 1200

