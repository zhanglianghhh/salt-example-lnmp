<?php
  $memcache = new Memcached();
  $memcache->addServer("{{ memcached_host }}", 11211);

  $duration='120';  //// 设置缓存值，有效时间3600秒，如果有效时间设置为0,则表示该缓存值永久存在的（系统重启前）
  $datetime=date('Y-m-d H:i:s');
  $memcache_datetime=$memcache->get('datetime');
  echo $datetime, "==>now datetime info" . "<br>";
  echo $memcache_datetime, "==>now memcached info" . "<br>";
  echo "   " . "<br>";

  ## 如果 memcache 中的数据为 空字符串或者 null ，那么重新赋值
  if ($memcache_datetime == null)
  {
    $memcache->set('datetime',$datetime,$duration);
    echo "{{ hostname }}==", $memcache->get('datetime'), "==>memcached update, duration $duration s";
  }
  else
  {
    echo "{{ hostname }}==", $memcache->get('datetime'), "==>memcached already exist, duration $duration s";
  }
?>

