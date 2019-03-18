# 别名设置
## 在 /etc/bashrc 设置
alias-set:
  file.append:
    - name: /etc/bashrc
    - text:
      ### 添加注释的方法----两端加 双引号
      - "# grep color"
      - alias grep='grep --color=auto'
      - alias egrep='grep -E --color=auto'
      - alias cp='cp -i'
      - alias l.='ls -d .* --color=auto'
      - alias ll='ls -l --color=auto'
      - alias ls='ls --color=auto'
      - alias mv='mv -i'
      - alias rm='rm -i'

