
USE retotrivia_uth;

ALTER TABLE partida_preguntas
  ADD COLUMN IF NOT EXISTS pausada_en DATETIME(3) NULL COMMENT 'Lleno mientras la pregunta está en pausa' AFTER hora_limite,
  ADD COLUMN IF NOT EXISTS pausas TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Cuántas veces se pausó' AFTER pausada_en,
  ADD COLUMN IF NOT EXISTS segundos_pausa DECIMAL(8,3) NOT NULL DEFAULT 0 COMMENT 'Tiempo total en pausa' AFTER pausas;

DROP TRIGGER IF EXISTS trg_pp_antes_actualizar;

DELIMITER //
CREATE TRIGGER trg_pp_antes_actualizar
BEFORE UPDATE ON partida_preguntas FOR EACH ROW
BEGIN
  DECLARE v_pausa BIGINT;

  IF NEW.id_partida <> OLD.id_partida OR NEW.orden <> OLD.orden OR NEW.id_pregunta <> OLD.id_pregunta THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Las preguntas de una partida no se cambian';
  END IF;

  IF (SELECT estado FROM partidas WHERE id_partida = OLD.id_partida) <> 'en_curso' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La partida ya terminó';
  END IF;

  IF EXISTS (SELECT 1 FROM respuestas WHERE id_partida = OLD.id_partida AND orden = OLD.orden) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esa pregunta ya fue contestada';
  END IF;

  IF OLD.pausada_en IS NULL AND NEW.pausada_en IS NOT NULL THEN
    IF NOW(3) >= OLD.hora_limite THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Se acabó el tiempo de esta pregunta';
    END IF;
    SET NEW.pausada_en = NOW(3),
        NEW.pausas = OLD.pausas + 1,
        NEW.mostrada_en = OLD.mostrada_en,
        NEW.hora_limite = OLD.hora_limite,
        NEW.segundos_pausa = OLD.segundos_pausa;
  ELSEIF OLD.pausada_en IS NOT NULL AND NEW.pausada_en IS NULL THEN
    SET v_pausa = TIMESTAMPDIFF(MICROSECOND, OLD.pausada_en, NOW(3));
    SET NEW.mostrada_en = OLD.mostrada_en + INTERVAL v_pausa MICROSECOND,
        NEW.hora_limite = OLD.hora_limite + INTERVAL v_pausa MICROSECOND,
        NEW.segundos_pausa = OLD.segundos_pausa + v_pausa / 1000000,
        NEW.pausas = OLD.pausas;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se puede pausar o reanudar la pregunta';
  END IF;
END//

DELIMITER ;
