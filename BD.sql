-- Crear la base de datos
CREATE DATABASE IF NOT EXISTS ControlCajaAhorro;
USE ControlCajaAhorro;

-- Tabla: TipoMovimiento
CREATE TABLE TipoMovimiento (
    Id_TipoMovimiento INT AUTO_INCREMENT PRIMARY KEY,
    Movimiento VARCHAR(50) NOT NULL
);

-- Tabla: DatosSistema (corregí el nombre de 'DatosStrema')
CREATE TABLE DatosSistema (
    Id_Datos INT AUTO_INCREMENT PRIMARY KEY,
    NombreDirector VARCHAR(200) NOT NULL,
    Periodo VARCHAR(60) NOT NULL,
    NombreEnc_Personal VARCHAR(200) NOT NULL
);

-- Tabla: Ahorrador (esta tabla es referenciada pero no está en tu esquema, la agregué)
CREATE TABLE Ahorrador (
    Id_Ahorrador INT AUTO_INCREMENT PRIMARY KEY,
    -- Agrega aquí los campos necesarios para Ahorrador
    Nombre VARCHAR(100) NOT NULL,
    Email VARCHAR(100),
    FechaRegistro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: Estado (esta tabla es referenciada pero no está en tu esquema, la agregué)
CREATE TABLE Estado (
    Id_Estado INT AUTO_INCREMENT PRIMARY KEY,
    Descripcion VARCHAR(50) NOT NULL
);

-- Tabla: SolicitudPrestamo
CREATE TABLE SolicitudPrestamo (
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

-- Tabla: AuditoriaSolicitudes (corregí el nombre de 'MultiodisSolicitudes')
CREATE TABLE AuditoriaSolicitudes (
    Id_Auditoria INT AUTO_INCREMENT PRIMARY KEY,
    Id_Solicitud INT NOT NULL,
    Tipo_Solicitud VARCHAR(20) NOT NULL,
    CampoModificado VARCHAR(50) NOT NULL,
    ValorAnterior VARCHAR(255),
    ValorNuevo VARCHAR(255),
    UsuarioResponsable VARCHAR(100) NOT NULL,
    FechaCambio DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: Movimientos
CREATE TABLE Movimientos (
    Id_Movimiento INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Concepto VARCHAR(255) NOT NULL,
    Monto DECIMAL(10, 2) NOT NULL,
    Id_Ahorrador INT NOT NULL,
    Id_TipoMovimiento INT NOT NULL,
    FOREIGN KEY (Id_Ahorrador) REFERENCES Ahorrador(Id_Ahorrador),
    FOREIGN KEY (Id_TipoMovimiento) REFERENCES TipoMovimiento(Id_TipoMovimiento)
);

-- Índices para mejorar el rendimiento
CREATE INDEX idx_solicitud_ahorrador ON SolicitudPrestamo(Id_Ahorrador);
CREATE INDEX idx_solicitud_estado ON SolicitudPrestamo(Id_Estado);
CREATE INDEX idx_movimientos_ahorrador ON Movimientos(Id_Ahorrador);
CREATE INDEX idx_movimientos_tipo ON Movimientos(Id_TipoMovimiento);
CREATE INDEX idx_auditoria_solicitud ON AuditoriaSolicitudes(Id_Solicitud);