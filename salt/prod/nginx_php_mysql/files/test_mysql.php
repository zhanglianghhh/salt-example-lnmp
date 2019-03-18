<?php
  $link01=mysql_connect('{{ mysql_host01 }}','{{ mysql_test_user }}','{{ mysql_test_password }}') or mysql_error();
  if ($link01) {
    echo '{{ hostname }} Connected mysql host {{ mysql_host01 }} successfully!';
  }
  else {
    echo mysql_error();
  }

  echo "   " . "<br>";
  $link02=mysql_connect('{{ mysql_host02 }}','{{ mysql_test_user }}','{{ mysql_test_password }}') or mysql_error();
  if ($link02) {
    echo '{{ hostname }} Connected mysql host {{ mysql_host02 }} successfully!';
  }
  else {
    echo mysql_error();
  }

  echo "   " . "<br>";
  $link03=mysql_connect('{{ mysql_host03 }}','{{ mysql_test_user }}','{{ mysql_test_password }}') or mysql_error();
  if ($link03) {
    echo '{{ hostname }} Connected mysql host {{ mysql_host03 }} successfully!';
  }
  else {
    echo mysql_error();
  }

?>


