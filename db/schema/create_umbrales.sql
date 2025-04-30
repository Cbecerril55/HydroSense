CREATE TABLE umbrales (
  tipo_sensor ENUM('pH', 'TDS', 'turbidez', 'temperatura') PRIMARY KEY,
  valor_min DECIMAL(10,3) NOT NULL,
  valor_max DECIMAL(10,3) NOT NULL
);
