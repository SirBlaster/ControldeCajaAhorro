<?php
// includes/db.php
$host = getenv('DB_HOST') ?: 'mysql';
$user = getenv('DB_USER') ?: 'root';
$pass = getenv('DB_PASSWORD') ?: '';
$dbname = getenv('DB_NAME') ?: 'ControlCajaAhorro';

$maxAttempts = 10;
$attempt = 0;
$waitSeconds = 2;
$conn = null;

while ($attempt < $maxAttempts) {
    $conn = @new mysqli($host, $user, $pass, $dbname);
    if ($conn && !$conn->connect_error) {
        $conn->set_charset('utf8mb4');
        break;
    }
    $attempt++;
    sleep($waitSeconds);
}

if (!$conn || $conn->connect_error) {
    error_log("DB connection failed after {$attempt} attempts: " . ($conn ? $conn->connect_error : 'no connection'));
    // No mostrar detalles al usuario en producción
    die("Error de conexión a la base de datos. Intente más tarde.");
}
