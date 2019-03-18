# 安装 mysql

# 导入 mysql 变量
{% from 'mysql/mysql_var.info' import mysql_salt_path, mysql_version, mysql_compile, mysql_password %}

include:
  - mysql.mysql_pkg

mysql-install:
  ## tar 包传输
  file.managed:
    - name: {{ mysql_salt_path() }}/mysql-{{ mysql_version() }}.tar.gz
    - source: salt://mysql/files/mysql-{{ mysql_version() }}.tar.gz
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion
    - require:
      - pkg: mysql-pkg

  ## 编译安装
  cmd.run:
    ### 操作：添加mysql用户、解压tar包、编译安装、建立软连接
    - name: . /etc/profile && useradd -s /sbin/nologin -M mysql && cd {{ mysql_salt_path() }} && tar xf mysql-{{ mysql_version() }}.tar.gz && cd mysql-{{ mysql_version() }} && {{ mysql_compile() }} && make && make install && ln -s /app/mysql-{{ mysql_version() }} /app/mysql
    - onlyif: test "{{ pillar['database_info']['database'] }}" = "mysql"
    - unless: test -f /app/mysql/bin/mysql
    - require:
      - file: mysql-install

# 添加MySQL的环境变量
mysql-env:
  file.append:
    - name: /etc/profile
    - text:
      - "####"
      - "# add mysql envriment"
      - export PATH="/app/mysql/bin:${PATH}"
    - require:
      - cmd: mysql-install

