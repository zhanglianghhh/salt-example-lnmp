# salt-example-lnmp
SaltStack自动化部署中小型Web架构

## 1.主机部署模块规划
服务器序号 | 操作系统版本 | 内网IP | 外网IP（模拟） | 主机名称 | 部署模块
---|---|---|---|---|---
---- | ---- | ---- | 10.0.0.110 | ---- | Keepalived虚拟IP地址
01 | CentOS7.5 | 172.16.1.111 | 10.0.0.111 | salt01-haproxy | haproxy、salt-minion、zabbix-agent
02 | CentOS7.5 | 172.16.1.112 | 10.0.0.112 | salt02-haproxy | haproxy、salt-minion、zabbix-agent
03 | CentOS7.5 | 172.16.1.113 | 无 | salt03-web | Nginx+PHP、Mysql(master)、salt-minion、zabbix-agent
04 | CentOS7.5 | 172.16.1.114 | 无 | salt04-web | Nginx+PHP、Mysql(slave)、salt-minion、zabbix-agent
05 | CentOS7.5 | 172.16.1.115 | 无 | salt05-web | Nginx+PHP、Mysql(slave)、salt-minion、zabbix-agent、memcached
06 | CentOS7.5 | 172.16.1.150 | 无 | salt150-master | salt-master、salt-minion、zabbix-server、zabbix-agent、Mariadb【zabbix使用】
07 | CentOS7.5 | 172.16.1.15 | 10.0.0.15 | GateWay00 | 用于salt03-web、salt04-web、salt05-web的网关服务器，实现公网访问目的

## 2.系统架构
![架构图](https://raw.githubusercontent.com/zhanglianghhh/salt-example-lnmp/master/salt-example-lnmp.png)

## 3.在本地Windows 机器的hosts 文件追加信息
作用：模拟域名解析访问。


```
# 文件路径：C:\Windows\System32\drivers\etc\hosts
# 追加信息如下
# SaltStack 实战  其中salt00-keepalived为VIP
10.0.0.110      salt00-keepalived
172.16.1.111    salt01-haproxy
172.16.1.112    salt02-haproxy
172.16.1.113    salt03-web
172.16.1.114    salt04-web
172.16.1.115    salt05-web
172.16.1.150    salt150-master
```

## 4.案例执行步骤
#### 步骤1：先执行如下脚本：

```
salt-example-lnmp/salt/base/mysql_master_slave/master-slave.sh
```
##### 具体实现：
	1、MySQL数据库编译安装
	2、实现数据库的主从同步

##### 说明：
	由于MySQL主从复制，需要将主数据库的信息从salt-minion拉到salt-master，然后再由salt-master分发到从数据库的salt-minion端。因此数据库部分需要单独执行。

#### 步骤2：
```
slat '*' state.highstate
```
##### 具体实现：
	1、监控组件部署
	2、其他业务组件部署

## 5.测试验证URL
#### 部署完毕后的验证【本地有host解析】

```
# zabbix 安装
http://salt150-master/zabbix  或
http://172.16.1.150/zabbix

## zabbix 安装登录后的地址
http://172.16.1.150/zabbix/zabbix.php?action=dashboard.view

# nginx PHP mysql 整合
http://salt03-web:8090/test_mysql.php
http://salt04-web:8090/test_mysql.php
http://salt05-web:8090/test_mysql.php

# PHP 和 memcached 整合
http://salt03-web:8090/test_memcached.php
http://salt04-web:8090/test_memcached.php
http://salt05-web:8090/test_memcached.php

# haproxy01 验证
http://salt01-haproxy:8888/haproxy-status   # 状态访问
http://salt01-haproxy/test_mysql.php        # 查看 test_mysql.php
http://salt01-haproxy/test_memcached.php    # 查看 test_memcached.php

# haproxy02 验证
http://salt02-haproxy:8888/haproxy-status   # 状态访问
http://salt02-haproxy/test_mysql.php        # 查看 test_mysql.php
http://salt02-haproxy/test_memcached.php    # 查看 test_memcached.php

# keepalived 验证  
# 可以停止 salt01-haproxy 机器，看 VIP 是否漂移
http://salt00-keepalived:8888/haproxy-status    # 状态访问
http://salt00-keepalived/test_mysql.php         # 查看 test_mysql.php
http://salt00-keepalived/test_memcached.php     # 查看 test_memcached.php
```

