# 依赖 epel 源
include:
  - init.yum_epel

# 必要的包安装
pkg-installed:
  pkg.installed:
    ## # systemctl tab 补全
    - name: bash-completion
    - name: screen
    - name: pcre
    - name: pcre-devel
    - name: openssl
    - name: openssl-devel
    - name: nfs-utils
    - name: rpcbind
    - name: lrzsz
    - name: sysstat
    - name: nmap
    - name: nc
    - name: tree
    - name: telnet
    - name: dos2unix
    # 编译包经常使用
    - name: gcc
    - name: gcc-c++
    - name: glibc
    - name: make
    - name: autoconf
    # 依赖
    - require:
      - file: yum-epel

