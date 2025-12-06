<?php
return [
  'db' => [
    'host' => getenv('DB_HOST') ?: 'db',
    'dbname' => getenv('DB_NAME') ?: 'appdb',
    'user' => getenv('DB_USER') ?: 'appuser',
    'pass' => getenv('DB_PASS') ?: 'apppass',
    'charset' => 'utf8mb4'
  ]
];
