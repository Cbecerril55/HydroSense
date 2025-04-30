USE aquaGuardDB;

INSERT INTO umbrales (tipo_sensor, valor_min, valor_max) VALUES
('pH', 6.5, 8.5),
('TDS', 0, 500),
('turbidez', 0, 5),
('temperatura', 20, 35);

DELIMITER $$

CREATE PROCEDURE verificar_y_generar_alerta (
  IN p_sensor_id INT,
  IN p_valor DECIMAL(10,3)
)
BEGIN
  DECLARE v_tipo_sensor ENUM('pH', 'TDS', 'turbidez', 'temperatura');
  DECLARE v_min DECIMAL(10,3);
  DECLARE v_max DECIMAL(10,3);
  DECLARE v_superado VARCHAR(50);

  -- Obtener tipo de sensor
  SELECT tipo_sensor INTO v_tipo_sensor
  FROM sensores
  WHERE sensor_id = p_sensor_id;

  -- Obtener umbrales
  SELECT valor_min, valor_max INTO v_min, v_max
  FROM umbrales
  WHERE tipo_sensor = v_tipo_sensor;

  -- Comparar el valor
  IF p_valor < v_min THEN
    SET v_superado = CONCAT('Menor al mínimo (', v_min, ')');
  ELSEIF p_valor > v_max THEN
    SET v_superado = CONCAT('Mayor al máximo (', v_max, ')');
  ELSE
    SET v_superado = NULL;
  END IF;

  -- Si el valor está fuera de los límites, registrar alerta
  IF v_superado IS NOT NULL THEN
    INSERT INTO alertas (sensor_id, valor_detectado, limite_superado, mensaje)
    VALUES (p_sensor_id, p_valor, v_superado, CONCAT('Valor fuera de rango: ', p_valor));
  END IF;
END$$

DELIMITER ;
