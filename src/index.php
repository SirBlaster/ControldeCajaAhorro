<?php
// src/index.php - TU APLICACIÓN DE CAJA DE AHORRO
require_once 'config/database.php';

// Obtener conexión a BD
$db = getDB();

// Ejemplo: Listar ahorradores
echo "<!DOCTYPE html>";
echo "<html lang='es'>";
echo "<head>";
echo "    <meta charset='UTF-8'>";
echo "    <meta name='viewport' content='width=device-width, initial-scale=1.0'>";
echo "    <title>Sistema de Control de Caja de Ahorro</title>";
echo "    <style>";
echo "        body { font-family: Arial, sans-serif; margin: 40px; }";
echo "        .container { max-width: 1200px; margin: 0 auto; }";
echo "        h1 { color: #2c3e50; }";
echo "        .card { background: #f8f9fa; padding: 20px; border-radius: 8px; margin: 20px 0; }";
echo "        .success { color: green; }";
echo "        .error { color: red; }";
echo "    </style>";
echo "</head>";
echo "<body>";
echo "    <div class='container'>";
echo "        <h1>🏦 Sistema de Control de Caja de Ahorro</h1>";
echo "        <div class='card'>";
echo "            <h2>✅ Sistema Dockerizado Funcionando</h2>";

// Test de conexión a BD
try {
    $stmt = $db->query("SELECT DATABASE() as db_name");
    $db_info = $stmt->fetch();
    echo "<p class='success'>Conectado a base de datos: <strong>" . $db_info['db_name'] . "</strong></p>";
    
    // Listar tablas
    $stmt = $db->query("SHOW TABLES");
    $tablas = $stmt->fetchAll(PDO::FETCH_COLUMN);
    
    echo "<h3>Tablas en el sistema:</h3>";
    echo "<ul>";
    foreach ($tablas as $tabla) {
        echo "<li>$tabla</li>";
    }
    echo "</ul>";
    
} catch (Exception $e) {
    echo "<p class='error'>Error de conexión a BD: " . $e->getMessage() . "</p>";
}

echo "            <hr>";
echo "            <h3>Servidor:</h3>";
echo "            <p>PHP: " . phpversion() . "</p>";
echo "            <p>Servidor: " . $_SERVER['SERVER_SOFTWARE'] . "</p>";
echo "        </div>";
echo "        <div class='card'>";
echo "            <h3>Funcionalidades:</h3>";
echo "            <ul>";
echo "                <li><a href='#'>Gestionar Ahorradores</a></li>";
echo "                <li><a href='#'>Registrar Movimientos</a></li>";
echo "                <li><a href='#'>Solicitar Préstamos</a></li>";
echo "                <li><a href='#'>Consultar Reportes</a></li>";
echo "            </ul>";
echo "        </div>";
echo "    </div>";
echo "</body>";
echo "</html>";
