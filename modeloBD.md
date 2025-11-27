# Diccionario de Datos del Sistema SETDITSX

Este diccionario detalla las seis entidades principales que componen el modelo de base de datos del Sindicato ITSX, especificando atributos, tipos de datos y restricciones clave.

## 1. Usuario

| Atributo | Descripción | Tipo de Dato | Longitud | Restricciones |
| :--- | :--- | :--- | :--- | :--- |
| **`ID_Usuario`** | Clave primaria. Identificador único del usuario. | `VARCHAR` | 10 | **PK**, NOT NULL |
| `Nombres` | Nombre(s) del usuario. | `VARCHAR` | 100 | NOT NULL |
| `Apellido_Paterno` | Primer apellido del usuario. | `VARCHAR` | 100 | NOT NULL |
| `Apellido_Materno` | Segundo apellido del usuario. | `VARCHAR` | 100 | Opcional |
| `Correo_Personal` | Correo electrónico personal. | `VARCHAR` | 255 | UNIQUE |
| `Correo_Institucional` | Correo electrónico laboral. | `VARCHAR` | 255 | Opcional |
| `Número_Telefónico` | Número de contacto. | `VARCHAR` | 20 | Opcional |
| `CURP` | Clave Única de Registro de Población. | `VARCHAR` | 18 | NOT NULL, UNIQUE |
| `RFC` | Registro Federal de Contribuyentes. | `VARCHAR` | 13 | NOT NULL, UNIQUE |
| `Contraseña` | Contraseña del usuario (almacenada en hash). | `VARCHAR` | 255 | NOT NULL |
| `Rol` | Rol del usuario en el sistema. | `ENUM` | | ('Ahorrador', 'Administrador', 'SuperUsuario') |
| `Estado_Usuario` | Estado de la cuenta del usuario. | `ENUM` | | ('Activo', 'Inactivo') |
| `Número_Tarjeta` | Número de tarjeta para depósitos. | `VARCHAR` | 16 | Opcional |
| `CLABE_Interbancaria` | CLABE interbancaria para transferencias. | `VARCHAR` | 18 | Opcional |

***

## 2. Ahorro

| Atributo | Descripción | Tipo de Dato | Longitud | Restricciones |
| :--- | :--- | :--- | :--- | :--- |
| **`ID_Ahorro`** | Clave primaria. Identificador de la cuenta de ahorro. | `INT` | | **PK**, NOT NULL |
| **`ID_Usuario`** | Clave foránea que enlaza con `Usuario`. | `VARCHAR` | 10 | **FK** (`Usuario`), UNIQUE, NOT NULL |
| `Saldo_Total_Ahorrado` | Monto total disponible en la caja de ahorro. | `DECIMAL` | 12, 2 | NOT NULL |

***

## 3. Préstamo

| Atributo | Descripción | Tipo de Dato | Longitud | Restricciones |
| :--- | :--- | :--- | :--- | :--- |
| **`ID_Préstamo`** | Clave primaria. Identificador de la solicitud. | `VARCHAR` | 10 | **PK**, NOT NULL |
| **`ID_Usuario`** | Clave foránea que enlaza al solicitante (`Usuario`). | `VARCHAR` | 10 | **FK** (`Usuario`), NOT NULL |
| `Monto_Solicitado` | Cantidad de dinero solicitada. | `DECIMAL` | 10, 2 | NOT NULL |
| `Plazo_Quincenas` | Número total de quincenas para la liquidación. | `INT` | | NOT NULL |
| `Tasa_Interes_Aplicada`| Tasa de interés vigente al solicitar. | `DECIMAL` | 5, 2 | NOT NULL |
| `Fecha_Solicitud` | Fecha y hora en que se registró la solicitud. | `DATETIME` | | NOT NULL |
| `Fecha_Aprobación` | Fecha en que el préstamo fue aprobado. | `DATE` | | Opcional |
| `Capacidad_Pago` | Clasificación de la capacidad de pago. | `ENUM` | | ('Suficiente', 'Límite', 'Insuficiente') |
| `Pago_Quincenal_Estimado`| Monto de cada pago quincenal calculado. | `DECIMAL` | 8, 2 | NOT NULL |
| `Saldo_Pendiente` | Monto restante por liquidar. | `DECIMAL` | 10, 2 | Opcional |
| `Estado_Préstamo` | Estado actual de la solicitud/préstamo. | `ENUM` | | ('Pendiente', 'Aprobado', 'Rechazado') |

***

## 4. Movimiento

| Atributo | Descripción | Tipo de Dato | Longitud | Restricciones |
| :--- | :--- | :--- | :--- | :--- |
| **`ID_Movimiento`** | Clave primaria. Identificador único del movimiento. | `INT` | | **PK**, NOT NULL |
| **`ID_Ahorro`** | Clave foránea que enlaza a la cuenta de ahorro. | `INT` | | **FK** (`Ahorro`), NOT NULL |
| `Fecha_Hora` | Fecha y hora exacta en que ocurrió el movimiento. | `DATETIME` | | NOT NULL |
| `Concepto` | Razón o descripción de la transacción. | `VARCHAR` | 255 | NOT NULL |
| `Monto` | Cantidad de dinero involucrada. | `DECIMAL` | 8, 2 | NOT NULL |
| `Tipo_Movimiento` | Define si es entrada o salida de dinero. | `ENUM` | | ('Depósito', 'Retiro', 'Pago') |
| `Saldo_Resultante` | Saldo de la cuenta después del movimiento. | `DECIMAL` | 12, 2 | NOT NULL |
| `Comprobante_URL` | Enlace o referencia al archivo PDF de soporte. | `VARCHAR` | 255 | Opcional |

***

## 5. Configuración_Sistema

| Atributo | Descripción | Tipo de Dato | Longitud | Restricciones |
| :--- | :--- | :--- | :--- | :--- |
| **`Nombre_Parámetro`** | Clave primaria. Nombre técnico del parámetro. | `VARCHAR` | 50 | **PK**, NOT NULL |
| `Valor` | Valor actual del parámetro. | `VARCHAR` | 255 | NOT NULL |
| `Tipo_Dato` | Tipo de dato que almacena el valor (para validación). | `ENUM` | | ('Porcentaje', 'Moneda', 'Entero', 'Texto') |
| `Descripción` | Descripción completa del parámetro. | `TEXT` | | Opcional |
| `Unidad` | Unidad de medida del valor (ej. %, MXM, Quincenas). | `VARCHAR` | 20 | Opcional |

***

## 6. Historial_Actividad (Auditoría)

| Atributo | Descripción | Tipo de Dato | Longitud | Restricciones |
| :--- | :--- | :--- | :--- | :--- |
| **`ID_Registro`** | Clave primaria. Identificador único del registro de auditoría. | `BIGINT` | | **PK**, NOT NULL |
| `Fecha_Hora` | Momento exacto en que se realizó la acción. | `DATETIME` | | NOT NULL |
| **`ID_Usuario_Acción`**| Clave foránea que identifica al usuario que ejecutó la acción. | `VARCHAR` | 10 | **FK** (`Usuario`), NOT NULL |
| `Acción` | Tipo de operación realizada (ej. 'APROBACIÓN', 'MODIFICACIÓN'). | `VARCHAR` | 50 | NOT NULL |
| `Entidad_Afectada` | Nombre de la tabla sobre la que se actuó. | `VARCHAR` | 50 | NOT NULL |
| `ID_Registro_Afectado`| Clave primaria del registro afectado. | `VARCHAR` | 50 | NOT NULL |
| `Detalle` | Descripción legible de la acción y los cambios. | `TEXT` | | Opcional |
