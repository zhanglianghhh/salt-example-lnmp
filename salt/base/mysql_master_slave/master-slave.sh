#!/bin/sh

mysql_rep_salt_path="/app/software/salt-manage/mysql_rep"
mysql_master="salt03-web"
mysql_slave="salt04-web,salt05-web"

# 数据从 minion 拉取回来后，存放的位置
push_path="/var/cache/salt/master/minions/${mysql_master}/files"

# 加载环境变量 
# 如果脚本放到crontab中执行，会缺少环境变量，所以需要添加以下3行
. /etc/profile
. ~/.bash_profile
. /etc/bashrc

# 脚本所在目录即脚本名称
script_dir=$( cd "$( dirname "$0"  )" && pwd )
script_name=$(basename ${0})
# 文件目录
files_dir="${script_dir}/files"
[ ! -d ${files_dir} ] && {
  mkdir -p ${files_dir}
}


##########################################################
## 系统初始化
salt -L "${mysql_master},${mysql_slave}" state.sls init.init

##########################################################
## 安装数据库
salt -L "${mysql_master},${mysql_slave}" state.sls mysql.mysql_install && \
salt -L "${mysql_master},${mysql_slave}" state.sls mysql.mysql_service && \
salt -L "${mysql_master},${mysql_slave}" state.sls mysql.mysql_pswd_init && {

  ##########################################################
  ## 主从复制实现操作
  # 主从复制主操作
  salt -L "${mysql_master}" state.sls mysql_master_slave.master_slave_rep_master 


  # 判断是否执行过，如果已执行那么久不再次执行了
  #[ ! -f ${files_dir}/master.info.txt -o ! -f ${files_dir}/salt_rep_back.sql.gz ] && {
    # 将master.info.txt 和 salt_rep_back.sql.gz 从minion拉取到master
    salt "${mysql_master}" cp.push ${mysql_rep_salt_path}/master.info.txt
    salt "${mysql_master}" cp.push ${mysql_rep_salt_path}/salt_rep_back.sql.gz

    # 拷贝到当前目录的files中
    \cp -a ${push_path}${mysql_rep_salt_path}/master.info.txt ${files_dir}
    \cp -a ${push_path}${mysql_rep_salt_path}/salt_rep_back.sql.gz ${files_dir}
  #}

  # 主从复制从操作
  salt -L "${mysql_slave}" state.sls mysql_master_slave.master_slave_rep_slave 
}


