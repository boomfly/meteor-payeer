<?php
error_reporting(0);
$orderid = $argv[1];
$key = md5('123');
$m_params = base64_encode(openssl_encrypt($argv[2], 'AES-256-CBC', $key, OPENSSL_RAW_DATA));
echo $m_params;
?>
