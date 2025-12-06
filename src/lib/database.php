<?php
// src/config/database.php

class Database {
    private static $instance = null;
    private $connection;
    
    private function __construct() {
        // IMPORTANTE: 'mysql' es el NOMBRE DEL SERVICIO en docker-compose
        $host = 'mysql';  // ← NO cambiar a localhost
        $dbname = 'ControlCajaAhorro';
        $username = 'caja_user';
        $password = 'caja_password';
        
        try {
            $this->connection = new PDO(
                "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
                $username,
                $password,
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                    PDO::ATTR_TIMEOUT => 10  // Timeout de 10 segundos
                ]
            );
        } catch(PDOException $e) {
            // Mejor mensaje de error
            die("<h2>Error de conexión a la base de datos</h2>
                 <p><strong>Detalles:</strong> " . $e->getMessage() . "</p>
                 <p><strong>Host intentado:</strong> $host</p>
                 <p><strong>Base de datos:</strong> $dbname</p>
                 <p>Verifica que MySQL esté corriendo y accesible desde el contenedor.</p>");
        }
    }
    
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new Database();
        }
        return self::$instance->connection;
    }
}

// Función helper
function getDB() {
    return Database::getInstance();
}
?>