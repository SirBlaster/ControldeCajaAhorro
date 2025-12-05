-- ==========================================
-- 1. CONFIGURACIÓN INICIAL
-- ==========================================
DROP DATABASE IF EXISTS sistema_caja;
CREATE DATABASE sistema_caja CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sistema_caja;

-- ==========================================
-- 2. TABLAS CATÁLOGOS
-- ==========================================

-- ROLES
CREATE TABLE Rol (
    Id_Rol INT AUTO_INCREMENT PRIMARY KEY,
    Rol VARCHAR(50) NOT NULL
);

INSERT INTO Rol (Rol) VALUES 
('Administrador'),
('Ahorrador'),
('SuperUsuario');

-- ESTADOS (SOLO LOS 3 QUE SOLICITASTE)
CREATE TABLE Estado (
    Id_Estado INT AUTO_INCREMENT PRIMARY KEY,
    Estado VARCHAR(50) NOT NULL
);

INSERT INTO Estado (Estado) VALUES
( 'Pendiente'  ),   -- 1
( 'Aprobado'   ),   -- 2
( 'Rechazado'  );   -- 3

-- TIPOS DE MOVIMIENTO
CREATE TABLE TipoMovimiento (
    Id_TipoMovimiento INT AUTO_INCREMENT PRIMARY KEY,
    Movimiento VARCHAR(50) NOT NULL
);

INSERT INTO TipoMovimiento (Movimiento) VALUES
('Depósito'),       -- 1
('Retiro'),         -- 2
('Pago Préstamo');  -- 3

-- DATOS DEL SISTEMA
CREATE TABLE DatosSistema (
    Id_Datos INT AUTO_INCREMENT PRIMARY KEY,
    NombreDirector VARCHAR(200),
    Periodo VARCHAR(50),
    NombreEnc_Personal VARCHAR(200)
);

INSERT INTO DatosSistema (NombreDirector, Periodo, NombreEnc_Personal)
VALUES ('Sidney René Toledo Martínez', '2025-2026', 'Teresa de Jesús Hernández Reyes');

-- ==========================================
-- 3. USUARIOS
-- ==========================================

CREATE TABLE Usuarios (
    Id_Ahorrador INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Paterno VARCHAR(50) NOT NULL,
    Materno VARCHAR(50) NOT NULL,
    Institucional VARCHAR(100),
    Personal VARCHAR(100),
    No_Empleado INT,
    RFC VARCHAR(13),
    CURP VARCHAR(18),
    Contrasena VARCHAR(255),
    Tarjeta VARCHAR(20),
    Id_Rol INT NOT NULL,
    CONSTRAINT fk_usuario_rol FOREIGN KEY (Id_Rol) REFERENCES Rol(Id_Rol)
);

-- ADMIN POR DEFECTO
INSERT INTO Usuarios (Nombre, Paterno, Materno, Institucional, No_Empleado, Contrasena, Id_Rol) 
VALUES ('Administrador', 'General', 'Sistema', 'admin@itsx.edu.mx', 1, '12345', 1);

-- ==========================================
-- 4. AHORRO (SALDOS)
-- ==========================================

CREATE TABLE Ahorro (
    Id_Ahorro INT AUTO_INCREMENT PRIMARY KEY,
    MontoAhorrado DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    Id_Ahorrador INT NOT NULL,
    FOREIGN KEY (Id_Ahorrador) REFERENCES Usuarios(Id_Ahorrador) ON DELETE CASCADE
);

-- ==========================================
-- 5. SOLICITUDES
-- ==========================================

-- AHORRO
CREATE TABLE Solicitud_Ahorro (
    Id_SolicitudAhorro INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    Monto DECIMAL(10, 2),
    ArchivoNomina VARCHAR(255),
    ArchivoSolicitud VARCHAR(255),
    Id_Ahorrador INT NOT NULL,
    Id_Estado INT NOT NULL DEFAULT 1,
    FOREIGN KEY (Id_Ahorrador) REFERENCES Usuarios(Id_Ahorrador),
    FOREIGN KEY (Id_Estado) REFERENCES Estado(Id_Estado)
);

-- PRÉSTAMO
CREATE TABLE Solicitud_Prestamo (
    Id_SolicitudPrestamo INT AUTO_INCREMENT PRIMARY KEY,
    FechaSolicitud DATETIME DEFAULT CURRENT_TIMESTAMP,
    MontoSolicitado DECIMAL(10, 2) NOT NULL,
    Plazo_Quincenas INT NOT NULL,
    Monto_Pago_Quincenal DECIMAL(10, 2),
    Total_A_Pagar DECIMAL(10, 2) NOT NULL,
    SaldoPendiente DECIMAL(10, 2) NOT NULL,
    ArchivoPagare VARCHAR(255) NOT NULL,
    Id_Ahorrador INT NOT NULL,
    Id_Estado INT NOT NULL DEFAULT 1,
    FOREIGN KEY (Id_Ahorrador) REFERENCES Usuarios(Id_Ahorrador),
    FOREIGN KEY (Id_Estado) REFERENCES Estado(Id_Estado)
);

-- ==========================================
-- 6. MOVIMIENTOS Y AUDITORÍA
-- ==========================================

CREATE TABLE Movimientos (
    Id_Movimiento INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    Concepto VARCHAR(255),
    Monto DECIMAL(10, 2),
    Id_Ahorrador INT NOT NULL,
    Id_TipoMovimiento INT NOT NULL,
    FOREIGN KEY (Id_Ahorrador) REFERENCES Usuarios(Id_Ahorrador),
    FOREIGN KEY (Id_TipoMovimiento) REFERENCES TipoMovimiento(Id_TipoMovimiento)
);

CREATE TABLE AuditoriaSolicitudes (
    Id_Auditoria INT AUTO_INCREMENT PRIMARY KEY,
    Id_Solicitud INT,
    Tipo_Solicitud VARCHAR(20),
    CampoModificado VARCHAR(50),
    ValorAnterior VARCHAR(255),
    ValorNuevo VARCHAR(255),
    UsuarioResponsable VARCHAR(100),
    FechaCambio DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ==========================================
-- 7. ÍNDICES
-- ==========================================

CREATE INDEX idx_solicitud_ahorrador ON Solicitud_Ahorro(Id_Ahorrador);
CREATE INDEX idx_solicitudp_ahorrador ON Solicitud_Prestamo(Id_Ahorrador);
CREATE INDEX idx_movimientos_ahorrador ON Movimientos(Id_Ahorrador);
CREATE INDEX idx_movimientos_tipo ON Movimientos(Id_TipoMovimiento);
CREATE INDEX idx_auditoria_solicitud ON AuditoriaSolicitudes(Id_Solicitud);

-- ==========================================
-- 8. TRIGGERS
-- ==========================================
DELIMITER //

-- TRIGGER: actualizar saldo de ahorro
CREATE TRIGGER actualizar_saldo_ahorro
AFTER INSERT ON Movimientos
FOR EACH ROW
BEGIN
    IF NEW.Id_TipoMovimiento = 1 THEN
        UPDATE Ahorro SET MontoAhorrado = MontoAhorrado + NEW.Monto
        WHERE Id_Ahorrador = NEW.Id_Ahorrador;
    END IF;

    IF NEW.Id_TipoMovimiento = 2 THEN
        UPDATE Ahorro SET MontoAhorrado = MontoAhorrado - NEW.Monto
        WHERE Id_Ahorrador = NEW.Id_Ahorrador;
    END IF;
END;
//

-- TRIGGER: actualizar deuda préstamo
CREATE TRIGGER actualizar_deuda_prestamo
AFTER INSERT ON Movimientos
FOR EACH ROW
BEGIN
    IF NEW.Id_TipoMovimiento = 3 THEN
        UPDATE Solicitud_Prestamo
        SET SaldoPendiente = SaldoPendiente - NEW.Monto
        WHERE Id_Ahorrador = NEW.Id_Ahorrador 
        AND Id_Estado = 2; -- Aprobado
    END IF;
END;
//

-- TRIGGER: auditoría ahorro
CREATE TRIGGER auditar_solicitud_ahorro
AFTER UPDATE ON Solicitud_Ahorro
FOR EACH ROW
BEGIN
    IF OLD.Id_Estado <> NEW.Id_Estado THEN
        INSERT INTO AuditoriaSolicitudes 
        (Id_Solicitud, Tipo_Solicitud, CampoModificado, ValorAnterior, ValorNuevo, UsuarioResponsable)
        VALUES (NEW.Id_SolicitudAhorro, 'Ahorro', 'Estado', OLD.Id_Estado, NEW.Id_Estado, CURRENT_USER());
    END IF;
END;
//

-- TRIGGER: auditoría préstamo
CREATE TRIGGER auditar_solicitud_prestamo
AFTER UPDATE ON Solicitud_Prestamo
FOR EACH ROW
BEGIN
    IF OLD.Id_Estado <> NEW.Id_Estado THEN
        INSERT INTO AuditoriaSolicitudes 
        (Id_Solicitud, Tipo_Solicitud, CampoModificado, ValorAnterior, ValorNuevo, UsuarioResponsable)
        VALUES (NEW.Id_SolicitudPrestamo, 'Prestamo', 'Estado', OLD.Id_Estado, NEW.Id_Estado, CURRENT_USER());
    END IF;
END;
//

DELIMITER ;
