DROP DATABASE aquaGuardDB;
CREATE DATABASE IF NOT EXISTS aquaGuardDB;
USE aquaGuardDB;

CREATE TABLE estaciones (
  estacion_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  ubicacion VARCHAR(255),
  tipo ENUM('cenote', 'playa') NOT NULL,
  fecha_instalacion DATE
);

CREATE TABLE sensores (
  sensor_id INT AUTO_INCREMENT PRIMARY KEY,
  tipo_sensor ENUM('pH', 'TDS', 'turbidez', 'temperatura') NOT NULL,
  unidad_medida VARCHAR(20),
  estacion_id INT,
  FOREIGN KEY (estacion_id) REFERENCES estaciones(estacion_id)
);

CREATE TABLE registros (
  registro_id INT AUTO_INCREMENT PRIMARY KEY,
  sensor_id INT,
  valor DECIMAL(10,3) NOT NULL,
  fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (sensor_id) REFERENCES sensores(sensor_id)
);

CREATE TABLE alertas (
  alerta_id INT AUTO_INCREMENT PRIMARY KEY,
  sensor_id INT,
  valor_detectado DECIMAL(10,3),
  limite_superado VARCHAR(50),
  fecha_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
  resuelta BOOLEAN DEFAULT FALSE,
  mensaje TEXT,
  FOREIGN KEY (sensor_id) REFERENCES sensores(sensor_id)
);

CREATE TABLE usuarios (
  usuario_id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  email VARCHAR(100) UNIQUE,
  rol ENUM('admin', 'tecnico', 'visualizador') DEFAULT 'visualizador',
  password_hash VARCHAR(255)
);

CREATE TABLE reportes (
  reporte_id INT AUTO_INCREMENT PRIMARY KEY,
  estacion_id INT,
  fecha_inicio DATE,
  fecha_fin DATE,
  descripcion TEXT,
  archivo_url VARCHAR(255),
  FOREIGN KEY (estacion_id) REFERENCES estaciones(estacion_id)
);