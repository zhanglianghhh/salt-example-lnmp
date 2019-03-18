# yum安装部署 memcached

memcached-install:
  ## yum 安装
  pkg.installed:
    - names:
      - memcached

  ## 加入开机自启动
  service.running:
    - name: memcached
    - enable: True
    - restart: True
    - require:
      - pkg: memcached-install

