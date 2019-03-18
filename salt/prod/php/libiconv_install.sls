# 安装 libiconv

# 导入 libiconv 变量
{% from 'php/php_var.info' import php_salt_path, php_version, libiconv_version, libiconv_insert, libiconv_append, php_compile %}

libiconv-install:
  ## 将 tar 包传到目标机器
  file.managed:
    - name: {{ php_salt_path() }}/libiconv-{{ libiconv_version() }}.tar.gz
    - source: salt://php/files/libiconv-{{ libiconv_version() }}.tar.gz
    - makedirs: True
    - user: root
    - group: root
    - mode: 644
    - backup: minion

  ## 安装 libiconv
  cmd.run:
    ### 注意：编译之后 make 会报错，然后修改 make 生成的 srclib/stdio.h 文件 ，之后再 make && make install
    ### 参考文章：https://blog.csdn.net/yuan1125/article/details/51050102   libiconv编译出错解决
    - name: . /etc/profile && cd {{ php_salt_path() }} && tar xf libiconv-{{ libiconv_version() }}.tar.gz && cd libiconv-{{ libiconv_version() }} && ./configure --prefix=/usr/local/libiconv && make || (sed -i '/^_GL_WARN_ON_USE (gets, /i \{{ libiconv_insert() }}' srclib/stdio.h && sed -i '/^_GL_WARN_ON_USE (gets, /a \{{ libiconv_append() }}' srclib/stdio.h && make && make install)
    - onlyif: test "{{ pillar['program_info']['program'] }}" = "php"
    - unless: test -f /usr/local/libiconv/bin/iconv
    - require:
      - file: libiconv-install

