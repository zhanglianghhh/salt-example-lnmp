# 内核参数修改----执行完毕后自动生效
# 注意使用方式
net.ipv4.ip_local_port_range:
  sysctl.present:
    - config: /etc/sysctl.conf
    - value: 10000 65000

fs.file-max:
  sysctl.present:
    - config: /etc/sysctl.conf
    - value: 2000000

net.ipv4.ip_forward:
  sysctl.present:
    - config: /etc/sysctl.conf
    - value: 1

vm.swappiness:
  sysctl.present:
    - config: /etc/sysctl.conf
    - value: 0

