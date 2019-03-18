# nginx 配置

include:
  - nginx.nginx_install

# nginx 配置文件
nginx-conf:
  file.managed:
    - name: /app/nginx/conf/nginx.conf
    - source: salt://nginx/files/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - cmd: nginx-install

# 创建目录，业务使用
nginx-busi-online:
  file.directory:
    - name: /app/nginx/conf/online
    - makedirs: True
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - require:
      - cmd: nginx-install

# 创建目录，业务下线使用
nginx-busi-offline:
  file.directory:
    - name: /app/nginx/conf/offline
    - makedirs: True
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - require:
      - cmd: nginx-install

# 加入系统管理
nginx-system-manage:
  file.managed:
    - name: /usr/lib/systemd/system/nginx.service
    - source: salt://nginx/files/nginx.service
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - cmd: nginx-install

# nginx service
nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - watch:
      - file: nginx-busi-online

