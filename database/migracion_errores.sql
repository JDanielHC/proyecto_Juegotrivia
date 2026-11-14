
USE retotrivia_uth;

ALTER TABLE auditoria
  ADD COLUMN IF NOT EXISTS metodo VARCHAR(10) NULL COMMENT 'GET, POST, DELETE...' AFTER accion,
  ADD COLUMN IF NOT EXISTS ruta VARCHAR(255) NULL COMMENT 'Ruta de la API, sin lo que va después de ?' AFTER metodo,
  ADD COLUMN IF NOT EXISTS codigo_http SMALLINT UNSIGNED NULL COMMENT 'Código que se le respondió al navegador' AFTER ruta;
