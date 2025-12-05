<?php
// src/config/database.php

class Database {
    private static $instance = null;
    private $connection;
    
    private function __construct() {
        // Configuración para Docker
        $host = getenv('DB_HOST') ?: 'mysql';  // 'mysql' = nombre del servicio en docker-compose
        $dbname = getenv('DB_NAME') ?: 'ControlCajaAhorro';
        $username = getenv('DB_USER') ?: 'caja_user';
        $password = getenv('DB_PASSWORD') ?: 'caja_password';
        
        try {
            $this->connection = new PDO(
                "mysql:host=$host;dbname=$dbname;charset=utf8mb4",
                $username,
                $password,
                [
                    PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC
                ]
            );
        } catch(PDOException $e) {
            die("Error de conexión a la base de datos: " . $e->getMessage());
        }
    }
    
    public static function getInstance() {
        if (self::$instance === null) {
            self::$instance = new Database();
        }
        return self::$instance->connection;
    }
}

// Función helper para obtener conexión rápidamente
function getDB() {
    return Database::getInstance();
}
?>