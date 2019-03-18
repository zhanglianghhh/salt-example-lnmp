# 添加或修改环境变量
## 在 /etc/bashrc 修改
bashrc-config:
  file.append:
    - name: /etc/bashrc
    - text:
      ### 对操作历史添加 时间 信息
      - export HISTTIMEFORMAT="%F %T $(whoami) "
      ### 对操作添加 rsyslog 日志
      - export PROMPT_COMMAND='{ msg=$(history 1 | { read x y; echo $y; });logger "[euid=$(whoami)]":$(who am i):[`pwd`]"$msg"; }'

