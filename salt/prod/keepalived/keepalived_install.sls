# 安装 keepalived

# 导入 keepalived 变量
{% from 'keepalived/keepalived_var.info' import keepalived_salt_path, keepalived_version %}

keepalived-install:
  ## tar 包传输
  file.managed:
    - name: {{ keepalived_salt_path() }}/keepalived-{{ keepalived_version() }}.tar.gz
    - source: salt://keepalived/files/keepalived-{{ keepalived_version() }}.tar.gz
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion

  ## 安装
  cmd.run:
    ### 解压 编译 安装 建立软连接
    - name: . /etc/profile && cd {{ keepalived_salt_path() }} && tar xf keepalived-{{ keepalived_version() }}.tar.gz && cd keepalived-{{ keepalived_version() }} && ./configure --prefix=/app/keepalived-{{ keepalived_version() }} && make && make install && ln -s /app/keepalived-{{ keepalived_version() }} /app/keepalived
    - onlyif: test "{{ pillar['high_available_info']['high_available'] }}" = "keepalived"
    - unless: test -f /app/keepalived/sbin/keepalived
    - require:
      - file: keepalived-install

