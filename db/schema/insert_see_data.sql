-- Insertar estación de prueba
INSERT INTO estaciones (nombre, ubicacion, tipo, fecha_instalacion)
VALUES ('Cenote Azul', 'Quintana Roo', 'cenote', CURDATE());

-- Insertar sensor asociado a la estación (ID 1 asumido)
INSERT INTO sensores (tipo_sensor, unidad_medida, estacion_id)
VALUES ('pH', 'pH', 1);

-- Insertar umbrales para todos los tipos de sensor
INSERT INTO umbrales (tipo_sensor, valor_min, valor_max) VALUES
('pH', 6.5, 8.5),
('TDS', 0, 500),
('turbidez', 0, 5),
('temperatura', 20, 35);

-- Insertar una lectura dentro del umbral (no debe generar alerta)
INSERT INTO registros (sensor_id, valor) VALUES (1, 7.0);

-- Insertar una lectura fuera del umbral (debe generar alerta)
INSERT INTO registros (sensor_id, valor) VALUES (1, 9.5);

