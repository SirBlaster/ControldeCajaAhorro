<?php
// php/login.php
session_start();
require_once __DIR__ . '/../.. /lib/database.php'; // ajustar segun estructura


if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    header('Location: /login.html');
    exit;
}

$email = trim($_POST['email'] ?? '');
$password = $_POST['password'] ?? '';

if ($email === '' || $password === '') {
    header('Location: /login.html?error=' . urlencode('Todos los campos son obligatorios.'));
    exit;
}

// PREPARED STATEMENT para evitar SQL injection
$stmt = $conn->prepare("SELECT Id_Ahorrador, Contrasena, Id_Rol, Nombre FROM Usuarios WHERE Email = ?");
if (!$stmt) {
    error_log("Prepare failed: " . $conn->error);
    header('Location: /login.html?error=' . urlencode('Error interno.'));
    exit;
}
$stmt->bind_param('s', $email);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows !== 1) {
    // usuario no encontrado
    $stmt->close();
    header('Location: /login.html?error=' . urlencode('Usuario o contraseña incorrectos.'));
    exit;
}

$stmt->bind_result($id, $hash, $id_rol, $nombre);
$stmt->fetch();
$stmt->close();

// Verificar contraseña (hash guardado con password_hash)
if (!password_verify($password, $hash)) {
    header('Location: /login.html?error=' . urlencode('Usuario o contraseña incorrectos.'));
    exit;
}

// Login exitoso: setear sesión segura
session_regenerate_id(true);
$_SESSION['user_id'] = $id;
$_SESSION['user_name'] = $nombre;
$_SESSION['user_role'] = $id_rol;

// Redirigir según rol (ejemplo)
if ($id_rol == 1) {
    header('Location: /php/Admin/dashboard.php');
} else {
    header('Location: /php/Usuario/dashboard.php');
}
exit;
