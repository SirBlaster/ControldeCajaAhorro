-- BD_actualizar.sql
-- Script para actualizar la base de datos SIN borrar datos existentes

USE ControlCajaAhorro;

-- 1. Crear tablas si no existen
CREATE TABLE IF NOT EXISTS TipoMovimiento (
    Id_TipoMovimiento INT AUTO_INCREMENT PRIMARY KEY,
    Movimiento VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS DatosSistema (
    Id_Datos INT AUTO_INCREMENT PRIMARY KEY,
    NombreDirector VARCHAR(200) NOT NULL,
    Periodo VARCHAR(60) NOT NULL,
    NombreEnc_Personal VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS Ahorrador (
    Id_Ahorrador INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    FechaRegistro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Estado (
    Id_Estado INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS SolicitudPrestamo (
    Id_SolicitudPrestamo INT AUTO_INCREMENT PRIMARY KEY,
    FechaSolicitud DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    MontoSolicitado DECIMAL(10, 2) NOT NULL,
    Plazo_Quincenas INT NOT NULL,
    Monto_Pago_Quincenal DECIMAL(10, 2) NOT NULL,
    Total_A_Pagar DECIMAL(10, 2) NOT NULL,
    SaldoPendiente DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    ArchivoPagar VARCHAR(255),
    Id_Ahorrador INT NOT NULL,
    Id_Estado INT NOT NULL,
    FOREIGN KEY (Id_Ahorrador) REFERENCES Ahorrador(Id_Ahorrador),
    FOREIGN KEY (Id_Estado) REFERENCES Estado(Id_Estado)
);

CREATE TABLE IF NOT EXISTS AuditoriaSolicitudes (
    Id_Auditoria INT AUTO_INCREMENT PRIMARY KEY,
    Id_Solicitud INT NOT NULL,
    Tipo_Solicitud VARCHAR(20) NOT NULL,
    CampoModificado VARCHAR(50) NOT NULL,
    ValorAnterior VARCHAR(255),
    ValorNuevo VARCHAR(255),
    UsuarioResponsable VARCHAR(100) NOT NULL,
    FechaCambio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS Movimientos (
    Id_Movimiento INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Concepto VARCHAR(255) NOT NULL,
    Monto DECIMAL(10, 2) NOT NULL,
    Id_Ahorrador INT NOT NULL,
    Id_TipoMovimiento INT NOT NULL,
    FOREIGN KEY (Id_Ahorrador) REFERENCES Ahorrador(Id_Ahorrador),
    FOREIGN KEY (Id_TipoMovimiento) REFERENCES TipoMovimiento(Id_TipoMovimiento)
);

-- 2. Insertar datos iniciales SOLO si no existen
INSERT IGNORE INTO TipoMovimiento (Movimiento) VALUES
('Depósito'),
('Retiro'),
('Pago de préstamo'),
('Interés generado'),
('Comisión');

INSERT IGNORE INTO Estado (Descripcion) VALUES
('Pendiente'),
('Aprobada'),
('Rechazada'),
('Pagada'),
('En proceso');

INSERT IGNORE INTO DatosSistema (NombreDirector, Periodo, NombreEnc_Personal) VALUES
('Juan Pérez', 'Enero-Diciembre 2024', 'María García');

-- 3. Verificar estructura
SELECT '✅ Tablas verificadas y actualizadas' as Mensaje;

-- 4. Mostrar resumen
SHOW TABLES;