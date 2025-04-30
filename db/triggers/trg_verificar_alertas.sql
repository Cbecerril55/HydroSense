USE aquaGuardDB;

DELIMITER $$

CREATE TRIGGER trg_verificar_alerta
AFTER INSERT ON registros
FOR EACH ROW
BEGIN
  CALL verificar_y_generar_alerta(NEW.sensor_id, NEW.valor);
END$$

DELIMITER ;
