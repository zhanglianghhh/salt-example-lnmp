# epel 源信息
yum-epel:
  file.managed:
    - name: /etc/yum.repos.d/epel.repo 
    - source: salt://init/files/epel.repo
    - user: root
    - group: root
    - mode: 644
    # 如有改动，那么源文件会在 minion的cache目录中备份 /var/cache/salt/minion/file_backup
    - backup: minion

