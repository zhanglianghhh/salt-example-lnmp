base:
  '*':
    # base 目录
    - base.database
    - base.nosql
    - base.monitor
    # prod 目录
    - prod.web
    - prod.program
    - prod.proxy
    - prod.high_available

