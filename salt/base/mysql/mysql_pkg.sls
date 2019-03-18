# 编译安装MySQL时，必要安装的包
mysql-pkg:
  pkg.installed:
    - names:
      - ncurses-devel
      - libaio-devel
      - cmake

