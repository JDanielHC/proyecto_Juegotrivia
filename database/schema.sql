CREATE DATABASE IF NOT EXISTS retotrivia_uth
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE retotrivia_uth;
SET NAMES utf8mb4;

SET FOREIGN_KEY_CHECKS = 0;

DROP VIEW IF EXISTS v_ultimas_partidas;
DROP VIEW IF EXISTS v_estadisticas_usuario_categoria;
DROP VIEW IF EXISTS v_estadisticas_usuario;
DROP VIEW IF EXISTS v_ranking_reto_diario;
DROP VIEW IF EXISTS v_ranking_mixta;
DROP VIEW IF EXISTS v_ranking_principal;
DROP VIEW IF EXISTS v_ranking_categoria;
DROP VIEW IF EXISTS v_records_categoria;
DROP VIEW IF EXISTS v_opciones_publicas;
DROP VIEW IF EXISTS v_preguntas_publicas;

DROP TABLE IF EXISTS auditoria;
DROP TABLE IF EXISTS configuracion_juego;
DROP TABLE IF EXISTS solicitudes_ia;
DROP TABLE IF EXISTS reportes_pregunta;
DROP TABLE IF EXISTS pistas_usadas;
DROP TABLE IF EXISTS tipos_pista;
DROP TABLE IF EXISTS respuestas;
DROP TABLE IF EXISTS partida_preguntas;
DROP TABLE IF EXISTS partidas;
DROP TABLE IF EXISTS reto_diario_preguntas;
DROP TABLE IF EXISTS retos_diarios;
DROP TABLE IF EXISTS modos_juego;
DROP TABLE IF EXISTS preguntas_revision;
DROP TABLE IF EXISTS opciones;
DROP TABLE IF EXISTS preguntas;
DROP TABLE IF EXISTS temas;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS sesiones;
DROP TABLE IF EXISTS usuarios;
DROP TABLE IF EXISTS roles;

DROP FUNCTION IF EXISTS fn_config;
DROP PROCEDURE IF EXISTS sp_validar_partida;
DROP PROCEDURE IF EXISTS sp_terminar_partida;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE roles (
  id_rol       TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo       VARCHAR(20)  NOT NULL,
  nombre       VARCHAR(50)  NOT NULL,
  descripcion  VARCHAR(255) NULL,
  PRIMARY KEY (id_rol),
  UNIQUE KEY uq_roles_codigo (codigo),
  UNIQUE KEY uq_roles_nombre (nombre)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Tipos de cuenta: jugador, revisor de preguntas y administrador';

CREATE TABLE usuarios (
  id_usuario       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_rol           TINYINT UNSIGNED NOT NULL,
  alias            VARCHAR(30)  NOT NULL COMMENT 'Lo único que se ve en los rankings',
  correo           VARCHAR(120) NOT NULL,
  contrasena_hash  VARCHAR(255) NOT NULL COMMENT 'Nunca la contraseña tal cual',
  estado           ENUM('activo','bloqueado','eliminado') NOT NULL DEFAULT 'activo',
  creado_en        DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ultimo_acceso    DATETIME NULL,
  PRIMARY KEY (id_usuario),
  UNIQUE KEY uq_usuarios_alias (alias),
  UNIQUE KEY uq_usuarios_correo (correo),
  KEY ix_usuarios_rol (id_rol),
  CONSTRAINT fk_usuarios_rol FOREIGN KEY (id_rol)
    REFERENCES roles (id_rol) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_usuarios_alias  CHECK (CHAR_LENGTH(alias) >= 3),
  CONSTRAINT ck_usuarios_correo CHECK (correo LIKE '%_@_%._%')
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Cuentas de los jugadores. No se borran, se cambia el estado';

CREATE TABLE sesiones (
  id_sesion   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario  INT UNSIGNED NOT NULL,
  token_hash  CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL COMMENT 'Hash SHA-256 del token',
  ip          VARCHAR(45)  NULL,
  navegador   VARCHAR(255) NULL,
  creada_en   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  expira_en   DATETIME NOT NULL,
  cerrada_en  DATETIME NULL COMMENT 'Se llena cuando el usuario cierra sesión',
  PRIMARY KEY (id_sesion),
  UNIQUE KEY uq_sesiones_token (token_hash),
  KEY ix_sesiones_usuario (id_usuario, expira_en),
  CONSTRAINT fk_sesiones_usuario FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT ck_sesiones_expira  CHECK (expira_en > creada_en),
  CONSTRAINT ck_sesiones_cerrada CHECK (cerrada_en IS NULL OR cerrada_en >= creada_en)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Sesiones abiertas. Se guarda el hash del token, no el token';

CREATE TABLE categorias (
  id_categoria  TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo        VARCHAR(20)  NOT NULL,
  nombre        VARCHAR(60)  NOT NULL,
  descripcion   VARCHAR(255) NULL,
  es_mixta      TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 solo para la sección Mixta',
  orden         TINYINT UNSIGNED NOT NULL COMMENT 'Orden en la pantalla de inicio',
  activa        TINYINT(1) NOT NULL DEFAULT 1,
  marca_mixta   TINYINT GENERATED ALWAYS AS (IF(es_mixta = 1, 1, NULL)) STORED,
  PRIMARY KEY (id_categoria),
  UNIQUE KEY uq_categorias_codigo (codigo),
  UNIQUE KEY uq_categorias_nombre (nombre),
  UNIQUE KEY uq_categorias_orden (orden),
  UNIQUE KEY uq_categorias_una_mixta (marca_mixta),
  CONSTRAINT ck_categorias_mixta  CHECK (es_mixta IN (0, 1)),
  CONSTRAINT ck_categorias_activa CHECK (activa IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Las cuatro carreras y la sección Mixta';

CREATE TABLE temas (
  id_tema       SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_categoria  TINYINT UNSIGNED NOT NULL,
  nombre        VARCHAR(80) NOT NULL,
  activo        TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id_tema),
  UNIQUE KEY uq_temas_nombre (id_categoria, nombre),
  CONSTRAINT fk_temas_categoria FOREIGN KEY (id_categoria)
    REFERENCES categorias (id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_temas_activo CHECK (activo IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Temas de cada carrera (redes, derecho penal, etc). La Mixta no tiene temas';

CREATE TABLE preguntas (
  id_pregunta       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_tema           SMALLINT UNSIGNED NOT NULL,
  enunciado         VARCHAR(500)  NOT NULL,
  explicacion       VARCHAR(1000) NOT NULL COMMENT 'Se muestra después de contestar',
  pista_conceptual  VARCHAR(300)  NULL COMMENT 'Ya revisada, para no llamar a la IA cada vez',
  pista_adicional   VARCHAR(300)  NULL,
  dificultad        ENUM('facil','media','dificil') NOT NULL DEFAULT 'media',
  fuente            ENUM('manual','ia') NOT NULL COMMENT 'Si la escribió el equipo o la generó la IA',
  referencia        VARCHAR(255) NULL COMMENT 'De dónde sale el dato: plan de estudio, ley, libro',
  estado_revision   ENUM('pendiente','aprobada','rechazada','retirada') NOT NULL DEFAULT 'pendiente',
  creado_por        INT UNSIGNED NULL,
  creada_en         DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  actualizada_en    DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_pregunta),
  UNIQUE KEY uq_preguntas_enunciado (id_tema, enunciado),
  KEY ix_preguntas_juego (estado_revision, id_tema, dificultad),
  KEY ix_preguntas_creador (creado_por),
  CONSTRAINT fk_preguntas_tema FOREIGN KEY (id_tema)
    REFERENCES temas (id_tema) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_preguntas_creador FOREIGN KEY (creado_por)
    REFERENCES usuarios (id_usuario) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT ck_preguntas_enunciado   CHECK (CHAR_LENGTH(enunciado) >= 10),
  CONSTRAINT ck_preguntas_explicacion CHECK (CHAR_LENGTH(explicacion) >= 10)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Banco de preguntas. Solo las aprobadas salen en el juego';

CREATE TABLE opciones (
  id_opcion       INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_pregunta     INT UNSIGNED NOT NULL,
  letra           CHAR(1) NOT NULL,
  texto           VARCHAR(255) NOT NULL,
  es_correcta     TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Nunca se manda al navegador antes de contestar',
  marca_correcta  TINYINT GENERATED ALWAYS AS (IF(es_correcta = 1, 1, NULL)) STORED,
  PRIMARY KEY (id_opcion),
  UNIQUE KEY uq_opciones_letra (id_pregunta, letra),
  UNIQUE KEY uq_opciones_texto (id_pregunta, texto),
  UNIQUE KEY uq_opciones_una_correcta (id_pregunta, marca_correcta),
  UNIQUE KEY uq_opciones_de_pregunta (id_opcion, id_pregunta),
  CONSTRAINT fk_opciones_pregunta FOREIGN KEY (id_pregunta)
    REFERENCES preguntas (id_pregunta) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT ck_opciones_letra    CHECK (letra IN ('A','B','C','D')),
  CONSTRAINT ck_opciones_correcta CHECK (es_correcta IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Las cuatro opciones de cada pregunta y cuál es la correcta';

CREATE TABLE preguntas_revision (
  id_revision   INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_pregunta   INT UNSIGNED NOT NULL,
  id_revisor    INT UNSIGNED NOT NULL,
  decision      ENUM('aprobada','rechazada','cambios','retirada') NOT NULL,
  comentario    VARCHAR(500) NULL,
  revisada_en   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_revision),
  KEY ix_revision_pregunta (id_pregunta, revisada_en),
  KEY ix_revision_revisor (id_revisor),
  CONSTRAINT fk_revision_pregunta FOREIGN KEY (id_pregunta)
    REFERENCES preguntas (id_pregunta) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_revision_revisor FOREIGN KEY (id_revisor)
    REFERENCES usuarios (id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Historial de quién revisó cada pregunta y qué decidió';

CREATE TABLE modos_juego (
  id_modo              TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo               VARCHAR(20)  NOT NULL,
  nombre               VARCHAR(50)  NOT NULL,
  descripcion          VARCHAR(255) NULL,
  cantidad_preguntas   TINYINT UNSIGNED NULL COMMENT 'Vacío = sin límite (muerte súbita)',
  termina_al_fallar    TINYINT(1) NOT NULL DEFAULT 0,
  cuenta_para_ranking  TINYINT(1) NOT NULL DEFAULT 0 COMMENT 'Si cuenta para récords y rankings de carrera y Mixta',
  activo               TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (id_modo),
  UNIQUE KEY uq_modos_codigo (codigo),
  CONSTRAINT ck_modos_cantidad CHECK (cantidad_preguntas IS NULL OR cantidad_preguntas BETWEEN 1 AND 50),
  CONSTRAINT ck_modos_fallar   CHECK (termina_al_fallar IN (0, 1)),
  CONSTRAINT ck_modos_ranking  CHECK (cuenta_para_ranking IN (0, 1)),
  CONSTRAINT ck_modos_activo   CHECK (activo IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Formas de jugar: normal, mixta, reto del día y muerte súbita';

CREATE TABLE retos_diarios (
  id_reto     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  fecha       DATE NOT NULL,
  creado_por  INT UNSIGNED NULL,
  creado_en   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (id_reto),
  UNIQUE KEY uq_retos_fecha (fecha),
  KEY ix_retos_creador (creado_por),
  CONSTRAINT fk_retos_creador FOREIGN KEY (creado_por)
    REFERENCES usuarios (id_usuario) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Un reto por día, igual para todos los jugadores';

CREATE TABLE reto_diario_preguntas (
  id_reto      INT UNSIGNED NOT NULL,
  orden        TINYINT UNSIGNED NOT NULL,
  id_pregunta  INT UNSIGNED NOT NULL,
  PRIMARY KEY (id_reto, orden),
  UNIQUE KEY uq_reto_pregunta (id_reto, id_pregunta),
  KEY ix_reto_preguntas_pregunta (id_pregunta),
  CONSTRAINT fk_reto_preguntas_reto FOREIGN KEY (id_reto)
    REFERENCES retos_diarios (id_reto) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_reto_preguntas_pregunta FOREIGN KEY (id_pregunta)
    REFERENCES preguntas (id_pregunta) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_reto_orden CHECK (orden BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Las cinco preguntas de cada reto del día, en su orden';

CREATE TABLE partidas (
  id_partida         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario         INT UNSIGNED NOT NULL,
  id_categoria       TINYINT UNSIGNED NOT NULL,
  id_modo            TINYINT UNSIGNED NOT NULL,
  id_reto            INT UNSIGNED NULL COMMENT 'Solo en el modo reto del día',
  estado             ENUM('en_curso','terminada','abandonada') NOT NULL DEFAULT 'en_curso',
  iniciada_en        DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  terminada_en       DATETIME(3) NULL,
  aciertos           SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  errores            SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  puntos_respuestas  SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  bono_rapidez       SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '+20 si terminó en menos de la mitad del tiempo',
  bono_racha         SMALLINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '+10 por 5 aciertos seguidos',
  puntaje_total      SMALLINT UNSIGNED GENERATED ALWAYS AS (puntos_respuestas + bono_rapidez + bono_racha) STORED,
  tiempo_total_seg   DECIMAL(8,3) NOT NULL DEFAULT 0 COMMENT 'Suma de los segundos de cada respuesta',
  total_pistas       TINYINT UNSIGNED NOT NULL DEFAULT 0,
  marca_en_curso     TINYINT GENERATED ALWAYS AS (IF(estado = 'en_curso', 1, NULL)) STORED,
  PRIMARY KEY (id_partida),
  UNIQUE KEY uq_partidas_una_en_curso (id_usuario, marca_en_curso),
  UNIQUE KEY uq_partidas_un_intento_reto (id_usuario, id_reto),
  KEY ix_partidas_ranking (estado, id_categoria, id_usuario, puntaje_total, tiempo_total_seg, total_pistas),
  KEY ix_partidas_usuario (id_usuario, estado, terminada_en),
  KEY ix_partidas_reto (id_reto, estado, puntaje_total),
  KEY ix_partidas_categoria (id_categoria),
  KEY ix_partidas_modo (id_modo),
  CONSTRAINT fk_partidas_usuario FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_partidas_categoria FOREIGN KEY (id_categoria)
    REFERENCES categorias (id_categoria) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_partidas_modo FOREIGN KEY (id_modo)
    REFERENCES modos_juego (id_modo) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_partidas_reto FOREIGN KEY (id_reto)
    REFERENCES retos_diarios (id_reto) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_partidas_fin CHECK (
    (estado = 'en_curso' AND terminada_en IS NULL) OR
    (estado <> 'en_curso' AND terminada_en IS NOT NULL)
  ),
  CONSTRAINT ck_partidas_fechas CHECK (terminada_en IS NULL OR terminada_en >= iniciada_en),
  CONSTRAINT ck_partidas_pistas CHECK (total_pistas BETWEEN 0 AND 3),
  CONSTRAINT ck_partidas_tiempo CHECK (tiempo_total_seg >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Cada partida jugada con su puntaje, tiempo, pistas y bonos';

CREATE TABLE partida_preguntas (
  id_partida   INT UNSIGNED NOT NULL,
  orden        SMALLINT UNSIGNED NOT NULL,
  id_pregunta  INT UNSIGNED NOT NULL,
  mostrada_en  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  hora_limite  DATETIME(3) NULL COMMENT 'Si llega vacía, el trigger la calcula con la configuración',
  pausada_en   DATETIME(3) NULL COMMENT 'Lleno mientras la pregunta está en pausa',
  pausas       TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT 'Cuántas veces se pausó',
  segundos_pausa DECIMAL(8,3) NOT NULL DEFAULT 0 COMMENT 'Tiempo total en pausa',
  PRIMARY KEY (id_partida, orden),
  UNIQUE KEY uq_partida_sin_repetir (id_partida, id_pregunta),
  UNIQUE KEY uq_partida_orden_pregunta (id_partida, orden, id_pregunta),
  KEY ix_partida_preguntas_pregunta (id_pregunta),
  CONSTRAINT fk_pp_partida FOREIGN KEY (id_partida)
    REFERENCES partidas (id_partida) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pp_pregunta FOREIGN KEY (id_pregunta)
    REFERENCES preguntas (id_pregunta) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_pp_orden  CHECK (orden >= 1),
  CONSTRAINT ck_pp_limite CHECK (hora_limite IS NOT NULL AND hora_limite > mostrada_en)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Las preguntas que le salieron a cada partida, en orden y con su hora límite';

CREATE TABLE respuestas (
  id_partida     INT UNSIGNED NOT NULL,
  orden          SMALLINT UNSIGNED NOT NULL,
  id_pregunta    INT UNSIGNED NOT NULL,
  id_opcion      INT UNSIGNED NULL COMMENT 'Vacío si se le acabó el tiempo',
  es_correcta    TINYINT(1) NOT NULL DEFAULT 0,
  segundos       DECIMAL(6,3) NOT NULL DEFAULT 0,
  puntos         SMALLINT UNSIGNED NOT NULL DEFAULT 0,
  respondida_en  DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id_partida, orden),
  KEY ix_respuestas_pp (id_partida, orden, id_pregunta),
  KEY ix_respuestas_opcion (id_opcion, id_pregunta),
  KEY ix_respuestas_pregunta (id_pregunta, es_correcta),
  CONSTRAINT fk_respuestas_pp FOREIGN KEY (id_partida, orden, id_pregunta)
    REFERENCES partida_preguntas (id_partida, orden, id_pregunta) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_respuestas_opcion FOREIGN KEY (id_opcion, id_pregunta)
    REFERENCES opciones (id_opcion, id_pregunta) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT ck_respuestas_correcta CHECK (es_correcta IN (0, 1)),
  CONSTRAINT ck_respuestas_sin_opcion CHECK (id_opcion IS NOT NULL OR es_correcta = 0),
  CONSTRAINT ck_respuestas_puntos CHECK (
    (es_correcta = 0 AND puntos = 0) OR (es_correcta = 1 AND puntos > 0)
  ),
  CONSTRAINT ck_respuestas_segundos CHECK (segundos >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='La respuesta a cada pregunta de la partida, con su tiempo y puntos';

CREATE TABLE tipos_pista (
  id_tipo_pista  TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  codigo         VARCHAR(20)  NOT NULL,
  nombre         VARCHAR(50)  NOT NULL,
  descripcion    VARCHAR(255) NULL,
  PRIMARY KEY (id_tipo_pista),
  UNIQUE KEY uq_tipos_pista_codigo (codigo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Tipos de pista: conceptual, eliminar dos opciones y adicional';

CREATE TABLE pistas_usadas (
  id_pista_usada  INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_partida      INT UNSIGNED NOT NULL,
  orden           SMALLINT UNSIGNED NOT NULL COMMENT 'En qué pregunta de la partida se usó',
  id_tipo_pista   TINYINT UNSIGNED NOT NULL,
  numero_uso      TINYINT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Lo pone el trigger: 1, 2 o 3',
  usada_en        DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id_pista_usada),
  UNIQUE KEY uq_pistas_numero (id_partida, numero_uso),
  UNIQUE KEY uq_pistas_tipo_por_pregunta (id_partida, orden, id_tipo_pista),
  KEY ix_pistas_tipo (id_tipo_pista),
  CONSTRAINT fk_pistas_pp FOREIGN KEY (id_partida, orden)
    REFERENCES partida_preguntas (id_partida, orden) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_pistas_tipo FOREIGN KEY (id_tipo_pista)
    REFERENCES tipos_pista (id_tipo_pista) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_pistas_numero CHECK (numero_uso BETWEEN 1 AND 3)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Pistas gastadas en cada partida. Máximo 3 y no se recuperan';

CREATE TABLE reportes_pregunta (
  id_reporte    INT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_pregunta   INT UNSIGNED NOT NULL,
  id_usuario    INT UNSIGNED NOT NULL,
  id_partida    INT UNSIGNED NULL COMMENT 'Partida donde vio el error, si la hay',
  motivo        ENUM('respuesta_incorrecta','texto_confuso','desactualizada','otro') NOT NULL,
  detalle       VARCHAR(500) NULL,
  estado        ENUM('abierto','atendido','descartado') NOT NULL DEFAULT 'abierto',
  atendido_por  INT UNSIGNED NULL,
  creado_en     DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  atendido_en   DATETIME NULL,
  PRIMARY KEY (id_reporte),
  UNIQUE KEY uq_reportes_uno_por_usuario (id_pregunta, id_usuario),
  KEY ix_reportes_estado (estado, creado_en),
  KEY ix_reportes_usuario (id_usuario),
  KEY ix_reportes_partida (id_partida),
  KEY ix_reportes_atendido (atendido_por),
  CONSTRAINT fk_reportes_pregunta FOREIGN KEY (id_pregunta)
    REFERENCES preguntas (id_pregunta) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_reportes_usuario FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id_usuario) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_reportes_partida FOREIGN KEY (id_partida)
    REFERENCES partidas (id_partida) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_reportes_atendido FOREIGN KEY (atendido_por)
    REFERENCES usuarios (id_usuario) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT ck_reportes_atencion CHECK (
    (estado = 'abierto' AND atendido_en IS NULL) OR
    (estado <> 'abierto' AND atendido_en IS NOT NULL)
  )
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Avisos de los jugadores cuando ven un error en una pregunta';

CREATE TABLE solicitudes_ia (
  id_solicitud         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  tipo                 ENUM('pregunta','pista','explicacion') NOT NULL,
  id_tema              SMALLINT UNSIGNED NULL COMMENT 'Tema que se le pidió',
  id_pregunta          INT UNSIGNED NULL COMMENT 'Pregunta que creó o completó, si se guardó',
  id_usuario           INT UNSIGNED NULL COMMENT 'Quién la pidió',
  modelo               VARCHAR(50) NOT NULL DEFAULT 'llama3.2:1b',
  instruccion          TEXT NOT NULL COMMENT 'Lo que se le mandó a Ollama. Sin nombres, correos ni contraseñas',
  respuesta            MEDIUMTEXT NULL COMMENT 'Lo que devolvió el modelo, tal cual',
  estado               ENUM('exitosa','error','tiempo_agotado','formato_invalido') NOT NULL,
  tiempo_respuesta_ms  INT UNSIGNED NULL,
  mensaje_error        VARCHAR(500) NULL,
  uso_respaldo         TINYINT(1) NOT NULL DEFAULT 0 COMMENT '1 si se usó el banco de preguntas porque la IA falló',
  creada_en            DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id_solicitud),
  KEY ix_solicitudes_fecha (creada_en),
  KEY ix_solicitudes_estado (estado, creada_en),
  KEY ix_solicitudes_tema (id_tema),
  KEY ix_solicitudes_pregunta (id_pregunta),
  KEY ix_solicitudes_usuario (id_usuario),
  CONSTRAINT fk_solicitudes_tema FOREIGN KEY (id_tema)
    REFERENCES temas (id_tema) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_solicitudes_pregunta FOREIGN KEY (id_pregunta)
    REFERENCES preguntas (id_pregunta) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT fk_solicitudes_usuario FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id_usuario) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT ck_solicitudes_error CHECK (
    (estado = 'exitosa' AND mensaje_error IS NULL) OR
    (estado <> 'exitosa' AND mensaje_error IS NOT NULL)
  ),
  CONSTRAINT ck_solicitudes_respaldo CHECK (uso_respaldo IN (0, 1))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Cada petición a Ollama, cuánto tardó y si falló. Sirve para el monitoreo';

CREATE TABLE configuracion_juego (
  id_config        TINYINT UNSIGNED NOT NULL AUTO_INCREMENT,
  clave            VARCHAR(40)  NOT NULL,
  valor            DECIMAL(10,2) NOT NULL,
  valor_min        DECIMAL(10,2) NOT NULL,
  valor_max        DECIMAL(10,2) NOT NULL,
  unidad           VARCHAR(20)  NOT NULL COMMENT 'puntos, segundos o aciertos',
  descripcion      VARCHAR(255) NOT NULL,
  actualizado_por  INT UNSIGNED NULL,
  actualizado_en   DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (id_config),
  UNIQUE KEY uq_config_clave (clave),
  KEY ix_config_actualizado (actualizado_por),
  CONSTRAINT fk_config_usuario FOREIGN KEY (actualizado_por)
    REFERENCES usuarios (id_usuario) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT ck_config_rango CHECK (valor_min <= valor_max),
  CONSTRAINT ck_config_valor CHECK (valor BETWEEN valor_min AND valor_max)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Puntos, tiempos y bonos que el administrador puede cambiar sin tocar el código';

CREATE TABLE auditoria (
  id_auditoria   BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
  id_usuario     INT UNSIGNED NULL,
  tipo           ENUM('cambio','acceso','error') NOT NULL,
  accion         VARCHAR(50) NOT NULL COMMENT 'Por ejemplo: inicio_sesion, cambiar_configuracion, error_api',
  metodo         VARCHAR(10) NULL COMMENT 'GET, POST, DELETE...',
  ruta           VARCHAR(255) NULL COMMENT 'Ruta de la API, sin lo que va después de ?',
  codigo_http    SMALLINT UNSIGNED NULL COMMENT 'Código que se le respondió al navegador',
  tabla          VARCHAR(64) NULL,
  id_registro    VARCHAR(64) NULL,
  detalle        VARCHAR(500) NULL,
  datos_antes    JSON NULL,
  datos_despues  JSON NULL,
  ip             VARCHAR(45) NULL,
  creado_en      DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
  PRIMARY KEY (id_auditoria),
  KEY ix_auditoria_fecha (creado_en),
  KEY ix_auditoria_tipo (tipo, creado_en),
  KEY ix_auditoria_registro (tabla, id_registro),
  KEY ix_auditoria_usuario (id_usuario),
  CONSTRAINT fk_auditoria_usuario FOREIGN KEY (id_usuario)
    REFERENCES usuarios (id_usuario) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Registro de cambios importantes, accesos y errores del sistema';

DELIMITER //

CREATE FUNCTION fn_config(p_clave VARCHAR(40))
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
  DECLARE v_valor DECIMAL(10,2);
  DECLARE v_mensaje VARCHAR(128);

  SET v_valor = (SELECT valor FROM configuracion_juego WHERE clave = p_clave);

  IF v_valor IS NULL THEN
    SET v_mensaje = CONCAT('Falta el valor de configuración: ', p_clave);
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = v_mensaje;
  END IF;

  RETURN v_valor;
END//

CREATE PROCEDURE sp_validar_partida(
  IN p_id_categoria TINYINT UNSIGNED,
  IN p_id_modo      TINYINT UNSIGNED,
  IN p_id_reto      INT UNSIGNED,
  IN p_iniciada_en  DATETIME(3)
)
BEGIN
  DECLARE v_es_mixta  TINYINT;
  DECLARE v_cat_activa TINYINT;
  DECLARE v_modo      VARCHAR(20);
  DECLARE v_modo_activo TINYINT;
  DECLARE v_fecha_reto DATE;

  SET v_es_mixta   = (SELECT es_mixta FROM categorias WHERE id_categoria = p_id_categoria);
  SET v_cat_activa = (SELECT activa   FROM categorias WHERE id_categoria = p_id_categoria);
  SET v_modo        = (SELECT codigo FROM modos_juego WHERE id_modo = p_id_modo);
  SET v_modo_activo = (SELECT activo FROM modos_juego WHERE id_modo = p_id_modo);

  IF v_es_mixta IS NULL OR v_modo IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sección o el modo no existen';
  END IF;

  IF v_cat_activa = 0 OR v_modo_activo = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esa sección o ese modo están desactivados';
  END IF;

  IF v_modo = 'normal' AND v_es_mixta = 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El modo normal es para una carrera; la Mixta usa el modo mixta';
  END IF;

  IF v_modo IN ('mixta', 'reto_dia') AND v_es_mixta = 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Este modo solo se juega en la sección Mixta';
  END IF;

  IF v_modo = 'reto_dia' AND p_id_reto IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Falta indicar el reto del día';
  END IF;

  IF v_modo <> 'reto_dia' AND p_id_reto IS NOT NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo el modo reto del día lleva reto';
  END IF;

  IF p_id_reto IS NOT NULL THEN
    SET v_fecha_reto = (SELECT fecha FROM retos_diarios WHERE id_reto = p_id_reto);
    IF v_fecha_reto IS NULL OR v_fecha_reto <> DATE(p_iniciada_en) THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El reto solo se puede jugar el día que le toca';
    END IF;
  END IF;
END//

CREATE PROCEDURE sp_terminar_partida(IN p_id_partida INT UNSIGNED)
BEGIN
  DECLARE v_estado        VARCHAR(20);
  DECLARE v_cantidad      TINYINT UNSIGNED;
  DECLARE v_mostradas     INT;
  DECLARE v_contestadas   INT;
  DECLARE v_tiempo_limite DECIMAL(10,3);
  DECLARE v_tiempo_usado  DECIMAL(10,3);
  DECLARE v_fin           DATETIME(3);
  DECLARE v_racha         INT;
  DECLARE v_bono_rapidez  SMALLINT UNSIGNED DEFAULT 0;
  DECLARE v_bono_racha    SMALLINT UNSIGNED DEFAULT 0;

  SET v_estado = (SELECT estado FROM partidas WHERE id_partida = p_id_partida);

  IF v_estado IS NULL THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esa partida no existe';
  END IF;

  IF v_estado <> 'en_curso' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La partida ya estaba cerrada';
  END IF;

  SET v_cantidad = (
    SELECT m.cantidad_preguntas
    FROM partidas p JOIN modos_juego m ON m.id_modo = p.id_modo
    WHERE p.id_partida = p_id_partida
  );

  SET v_mostradas = (SELECT COUNT(*) FROM partida_preguntas WHERE id_partida = p_id_partida);
  SET v_contestadas = (SELECT COUNT(*) FROM respuestas WHERE id_partida = p_id_partida);

  IF v_mostradas = 0 OR v_contestadas < v_mostradas THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Todavía hay preguntas sin contestar';
  END IF;

  IF v_cantidad IS NOT NULL AND v_mostradas < v_cantidad THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Todavía faltan preguntas en esta partida';
  END IF;

  SET v_tiempo_limite = (
    SELECT SUM(TIMESTAMPDIFF(MICROSECOND, mostrada_en, hora_limite)) / 1000000
    FROM partida_preguntas WHERE id_partida = p_id_partida
  );
  SET v_tiempo_usado = (SELECT SUM(segundos) FROM respuestas WHERE id_partida = p_id_partida);
  SET v_fin = (SELECT MAX(respondida_en) FROM respuestas WHERE id_partida = p_id_partida);

  IF v_tiempo_usado < v_tiempo_limite / 2 THEN
    SET v_bono_rapidez = fn_config('bono_rapidez');
  END IF;

  SET v_racha = (
    SELECT COALESCE(MAX(largo), 0) FROM (
      SELECT COUNT(*) AS largo
      FROM (
        SELECT orden - ROW_NUMBER() OVER (ORDER BY orden) AS grupo
        FROM respuestas
        WHERE id_partida = p_id_partida AND es_correcta = 1
      ) seguidos
      GROUP BY grupo
    ) rachas
  );

  IF v_racha >= fn_config('aciertos_para_racha') THEN
    SET v_bono_racha = fn_config('bono_racha');
  END IF;

  UPDATE partidas
  SET estado = 'terminada',
      terminada_en = v_fin,
      bono_rapidez = v_bono_rapidez,
      bono_racha = v_bono_racha
  WHERE id_partida = p_id_partida;
END//

CREATE TRIGGER trg_temas_antes_insertar
BEFORE INSERT ON temas FOR EACH ROW
BEGIN
  IF (SELECT es_mixta FROM categorias WHERE id_categoria = NEW.id_categoria) = 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sección Mixta no lleva temas, usa los de las cuatro carreras';
  END IF;
END//

CREATE TRIGGER trg_temas_antes_actualizar
BEFORE UPDATE ON temas FOR EACH ROW
BEGIN
  IF (SELECT es_mixta FROM categorias WHERE id_categoria = NEW.id_categoria) = 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La sección Mixta no lleva temas, usa los de las cuatro carreras';
  END IF;
END//

CREATE TRIGGER trg_preguntas_antes_insertar
BEFORE INSERT ON preguntas FOR EACH ROW
BEGIN
  SET NEW.estado_revision = 'pendiente';
END//

CREATE TRIGGER trg_preguntas_antes_actualizar
BEFORE UPDATE ON preguntas FOR EACH ROW
BEGIN
  IF NEW.estado_revision = 'aprobada' AND OLD.estado_revision <> 'aprobada' THEN
    IF (SELECT COUNT(*) FROM opciones WHERE id_pregunta = NEW.id_pregunta) <> 4 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Para aprobarla, la pregunta necesita 4 opciones';
    END IF;
    IF (SELECT COUNT(*) FROM opciones WHERE id_pregunta = NEW.id_pregunta AND es_correcta = 1) <> 1 THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Para aprobarla, la pregunta necesita una sola opción correcta';
    END IF;
  END IF;

  IF OLD.estado_revision = 'aprobada' AND NEW.estado_revision = 'aprobada'
     AND (NEW.enunciado <> OLD.enunciado OR NEW.id_tema <> OLD.id_tema) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Una pregunta aprobada no se edita; primero pásenla a pendiente';
  END IF;
END//

CREATE TRIGGER trg_opciones_antes_insertar
BEFORE INSERT ON opciones FOR EACH ROW
BEGIN
  IF (SELECT estado_revision FROM preguntas WHERE id_pregunta = NEW.id_pregunta) = 'aprobada' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La pregunta ya está aprobada, no se le agregan opciones';
  END IF;
END//

CREATE TRIGGER trg_opciones_antes_actualizar
BEFORE UPDATE ON opciones FOR EACH ROW
BEGIN
  IF (SELECT estado_revision FROM preguntas WHERE id_pregunta = OLD.id_pregunta) = 'aprobada' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La pregunta ya está aprobada, sus opciones no se cambian';
  END IF;
END//

CREATE TRIGGER trg_opciones_antes_borrar
BEFORE DELETE ON opciones FOR EACH ROW
BEGIN
  IF (SELECT estado_revision FROM preguntas WHERE id_pregunta = OLD.id_pregunta) = 'aprobada' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La pregunta ya está aprobada, sus opciones no se borran';
  END IF;
END//

CREATE TRIGGER trg_revision_antes_insertar
BEFORE INSERT ON preguntas_revision FOR EACH ROW
BEGIN
  IF (SELECT r.codigo FROM usuarios u JOIN roles r ON r.id_rol = u.id_rol
      WHERE u.id_usuario = NEW.id_revisor) NOT IN ('revisor', 'admin') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo un revisor o un administrador puede revisar preguntas';
  END IF;
END//

CREATE TRIGGER trg_revision_despues_insertar
AFTER INSERT ON preguntas_revision FOR EACH ROW
BEGIN
  UPDATE preguntas
  SET estado_revision = CASE NEW.decision
                          WHEN 'aprobada'  THEN 'aprobada'
                          WHEN 'rechazada' THEN 'rechazada'
                          WHEN 'retirada'  THEN 'retirada'
                          ELSE 'pendiente'
                        END
  WHERE id_pregunta = NEW.id_pregunta;
END//

CREATE TRIGGER trg_reto_preguntas_antes_insertar
BEFORE INSERT ON reto_diario_preguntas FOR EACH ROW
BEGIN
  IF (SELECT estado_revision FROM preguntas WHERE id_pregunta = NEW.id_pregunta) <> 'aprobada' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El reto del día solo puede usar preguntas aprobadas';
  END IF;
END//

CREATE TRIGGER trg_partidas_antes_insertar
BEFORE INSERT ON partidas FOR EACH ROW
BEGIN
  IF (SELECT estado FROM usuarios WHERE id_usuario = NEW.id_usuario) <> 'activo' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esta cuenta no puede jugar';
  END IF;

  CALL sp_validar_partida(NEW.id_categoria, NEW.id_modo, NEW.id_reto, NEW.iniciada_en);

  SET NEW.estado = 'en_curso',
      NEW.terminada_en = NULL,
      NEW.aciertos = 0,
      NEW.errores = 0,
      NEW.puntos_respuestas = 0,
      NEW.bono_rapidez = 0,
      NEW.bono_racha = 0,
      NEW.tiempo_total_seg = 0,
      NEW.total_pistas = 0;
END//

CREATE TRIGGER trg_partidas_antes_actualizar
BEFORE UPDATE ON partidas FOR EACH ROW
BEGIN
  IF OLD.estado <> 'en_curso' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La partida ya terminó y no se puede modificar';
  END IF;

  IF NEW.id_usuario <> OLD.id_usuario
     OR NEW.id_categoria <> OLD.id_categoria
     OR NEW.id_modo <> OLD.id_modo
     OR NOT (NEW.id_reto <=> OLD.id_reto) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se puede cambiar el jugador, la sección ni el modo de una partida';
  END IF;
END//

CREATE TRIGGER trg_pp_antes_insertar
BEFORE INSERT ON partida_preguntas FOR EACH ROW
BEGIN
  DECLARE v_estado      VARCHAR(20);
  DECLARE v_categoria   TINYINT UNSIGNED;
  DECLARE v_es_mixta    TINYINT;
  DECLARE v_cantidad    TINYINT UNSIGNED;
  DECLARE v_termina     TINYINT;
  DECLARE v_errores     SMALLINT UNSIGNED;
  DECLARE v_reto        INT UNSIGNED;
  DECLARE v_estado_preg VARCHAR(20);
  DECLARE v_cat_preg    TINYINT UNSIGNED;
  DECLARE v_mostradas   INT;
  DECLARE v_contestadas INT;
  DECLARE v_no_hay      TINYINT DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_no_hay = 1;

  SELECT p.estado, p.id_categoria, c.es_mixta, m.cantidad_preguntas, m.termina_al_fallar, p.errores, p.id_reto
    INTO v_estado, v_categoria, v_es_mixta, v_cantidad, v_termina, v_errores, v_reto
  FROM partidas p
  JOIN categorias c ON c.id_categoria = p.id_categoria
  JOIN modos_juego m ON m.id_modo = p.id_modo
  WHERE p.id_partida = NEW.id_partida;

  IF v_no_hay = 1 OR v_estado <> 'en_curso' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La partida ya terminó, no se muestran más preguntas';
  END IF;

  IF v_cantidad IS NOT NULL AND NEW.orden > v_cantidad THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La partida ya tiene todas sus preguntas';
  END IF;

  IF v_termina = 1 AND v_errores > 0 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'En muerte súbita la partida termina con el primer error';
  END IF;

  SET v_mostradas = (SELECT COUNT(*) FROM partida_preguntas WHERE id_partida = NEW.id_partida);
  SET v_contestadas = (SELECT COUNT(*) FROM respuestas WHERE id_partida = NEW.id_partida);

  IF NEW.orden <> v_mostradas + 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Las preguntas tienen que ir en orden';
  END IF;

  IF v_contestadas < v_mostradas THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Falta contestar la pregunta anterior';
  END IF;

  SET v_no_hay = 0;
  SELECT pr.estado_revision, t.id_categoria INTO v_estado_preg, v_cat_preg
  FROM preguntas pr JOIN temas t ON t.id_tema = pr.id_tema
  WHERE pr.id_pregunta = NEW.id_pregunta;

  IF v_no_hay = 1 OR v_estado_preg <> 'aprobada' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Solo se pueden usar preguntas aprobadas';
  END IF;

  IF v_es_mixta = 0 AND v_cat_preg <> v_categoria THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esa pregunta no es de la carrera de esta partida';
  END IF;

  IF v_reto IS NOT NULL AND NOT EXISTS (
       SELECT 1 FROM reto_diario_preguntas
       WHERE id_reto = v_reto AND orden = NEW.orden AND id_pregunta = NEW.id_pregunta) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esa pregunta no le toca en el reto del día';
  END IF;

  IF NEW.hora_limite IS NULL THEN
    SET NEW.hora_limite = NEW.mostrada_en
        + INTERVAL CAST(fn_config('segundos_por_pregunta') AS UNSIGNED) SECOND;
  END IF;
END//

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

CREATE TRIGGER trg_respuestas_antes_insertar
BEFORE INSERT ON respuestas FOR EACH ROW
BEGIN
  DECLARE v_estado     VARCHAR(20);
  DECLARE v_mostrada   DATETIME(3);
  DECLARE v_limite     DATETIME(3);
  DECLARE v_pregunta   INT UNSIGNED;
  DECLARE v_seg_limite DECIMAL(10,3);
  DECLARE v_correcta   TINYINT;
  DECLARE v_min        DECIMAL(10,2);
  DECLARE v_max        DECIMAL(10,2);
  DECLARE v_no_hay     TINYINT DEFAULT 0;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_no_hay = 1;

  SET v_estado = (SELECT estado FROM partidas WHERE id_partida = NEW.id_partida);

  IF v_estado IS NULL OR v_estado <> 'en_curso' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La partida ya terminó, no se aceptan más respuestas';
  END IF;

  SELECT mostrada_en, hora_limite, id_pregunta INTO v_mostrada, v_limite, v_pregunta
  FROM partida_preguntas
  WHERE id_partida = NEW.id_partida AND orden = NEW.orden;

  IF v_no_hay = 1 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esa pregunta no es parte de la partida';
  END IF;

  SET NEW.id_pregunta = v_pregunta;
  SET v_seg_limite = TIMESTAMPDIFF(MICROSECOND, v_mostrada, v_limite) / 1000000;

  IF NEW.respondida_en < v_mostrada THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La hora de la respuesta no puede ser antes de mostrar la pregunta';
  END IF;

  IF NEW.id_opcion IS NULL THEN
    SET NEW.respondida_en = v_limite,
        NEW.segundos = v_seg_limite,
        NEW.es_correcta = 0,
        NEW.puntos = 0;
  ELSE
    IF NEW.respondida_en > v_limite THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Se acabó el tiempo de esta pregunta';
    END IF;

    SET v_correcta = (SELECT es_correcta FROM opciones
                      WHERE id_opcion = NEW.id_opcion AND id_pregunta = v_pregunta);

    IF v_correcta IS NULL THEN
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esa opción no es de esta pregunta';
    END IF;

    SET NEW.segundos = TIMESTAMPDIFF(MICROSECOND, v_mostrada, NEW.respondida_en) / 1000000;
    SET NEW.es_correcta = v_correcta;

    IF v_correcta = 1 THEN
      SET v_min = fn_config('puntos_acierto_min');
      SET v_max = fn_config('puntos_acierto_max');
      SET NEW.puntos = GREATEST(v_min, LEAST(v_max,
                         ROUND(v_max - (v_max - v_min) * NEW.segundos / v_seg_limite)));
    ELSE
      SET NEW.puntos = 0;
    END IF;
  END IF;
END//

CREATE TRIGGER trg_respuestas_despues_insertar
AFTER INSERT ON respuestas FOR EACH ROW
BEGIN
  UPDATE partidas
  SET aciertos = aciertos + NEW.es_correcta,
      errores = errores + (1 - NEW.es_correcta),
      puntos_respuestas = puntos_respuestas + NEW.puntos,
      tiempo_total_seg = tiempo_total_seg + NEW.segundos
  WHERE id_partida = NEW.id_partida;
END//

CREATE TRIGGER trg_respuestas_antes_actualizar
BEFORE UPDATE ON respuestas FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Una respuesta enviada ya no se cambia';
END//

CREATE TRIGGER trg_respuestas_antes_borrar
BEFORE DELETE ON respuestas FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Una respuesta enviada no se borra';
END//

CREATE TRIGGER trg_pistas_antes_insertar
BEFORE INSERT ON pistas_usadas FOR EACH ROW
BEGIN
  DECLARE v_estado  VARCHAR(20);
  DECLARE v_limite  DATETIME(3);
  DECLARE v_usadas  INT;

  SET v_estado = (SELECT estado FROM partidas WHERE id_partida = NEW.id_partida);

  IF v_estado IS NULL OR v_estado <> 'en_curso' THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La partida ya terminó, no se pueden usar pistas';
  END IF;

  IF EXISTS (SELECT 1 FROM respuestas WHERE id_partida = NEW.id_partida AND orden = NEW.orden) THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Esa pregunta ya fue contestada';
  END IF;

  SET v_limite = (SELECT hora_limite FROM partida_preguntas
                  WHERE id_partida = NEW.id_partida AND orden = NEW.orden);

  IF v_limite IS NOT NULL AND NEW.usada_en > v_limite THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Se acabó el tiempo de esta pregunta';
  END IF;

  SET v_usadas = (SELECT COUNT(*) FROM pistas_usadas WHERE id_partida = NEW.id_partida);

  IF v_usadas >= 3 THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya se usaron las 3 pistas de esta partida';
  END IF;

  SET NEW.numero_uso = v_usadas + 1;
END//

CREATE TRIGGER trg_pistas_despues_insertar
AFTER INSERT ON pistas_usadas FOR EACH ROW
BEGIN
  UPDATE partidas SET total_pistas = total_pistas + 1 WHERE id_partida = NEW.id_partida;
END//

CREATE TRIGGER trg_pistas_antes_actualizar
BEFORE UPDATE ON pistas_usadas FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Una pista usada no se cambia';
END//

CREATE TRIGGER trg_config_antes_actualizar
BEFORE UPDATE ON configuracion_juego FOR EACH ROW
BEGIN
  IF NEW.clave = 'puntos_acierto_min'
     AND NEW.valor > (SELECT valor FROM configuracion_juego WHERE clave = 'puntos_acierto_max') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los puntos mínimos no pueden ser mayores que los máximos';
  END IF;

  IF NEW.clave = 'puntos_acierto_max'
     AND NEW.valor < (SELECT valor FROM configuracion_juego WHERE clave = 'puntos_acierto_min') THEN
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Los puntos máximos no pueden ser menores que los mínimos';
  END IF;
END//

CREATE TRIGGER trg_config_despues_actualizar
AFTER UPDATE ON configuracion_juego FOR EACH ROW
BEGIN
  IF NEW.valor <> OLD.valor THEN
    INSERT INTO auditoria (id_usuario, tipo, accion, tabla, id_registro, datos_antes, datos_despues)
    VALUES (NEW.actualizado_por, 'cambio', 'cambiar_configuracion', 'configuracion_juego', NEW.clave,
            JSON_OBJECT('valor', OLD.valor), JSON_OBJECT('valor', NEW.valor));
  END IF;
END//

DELIMITER ;

CREATE VIEW v_preguntas_publicas AS
SELECT p.id_pregunta,
       t.id_categoria,
       c.nombre AS categoria,
       p.id_tema,
       t.nombre AS tema,
       p.enunciado,
       p.dificultad
FROM preguntas p
JOIN temas t      ON t.id_tema = p.id_tema
JOIN categorias c ON c.id_categoria = t.id_categoria
WHERE p.estado_revision = 'aprobada';

CREATE VIEW v_opciones_publicas AS
SELECT o.id_opcion,
       o.id_pregunta,
       o.letra,
       o.texto
FROM opciones o
JOIN preguntas p ON p.id_pregunta = o.id_pregunta
WHERE p.estado_revision = 'aprobada';

CREATE VIEW v_records_categoria AS
SELECT id_usuario, id_categoria, id_partida, puntaje_total, tiempo_total_seg, total_pistas, terminada_en
FROM (
  SELECT p.id_usuario, p.id_categoria, p.id_partida, p.puntaje_total,
         p.tiempo_total_seg, p.total_pistas, p.terminada_en,
         ROW_NUMBER() OVER (
           PARTITION BY p.id_usuario, p.id_categoria
           ORDER BY p.puntaje_total DESC, p.tiempo_total_seg ASC, p.total_pistas ASC, p.terminada_en ASC
         ) AS puesto
  FROM partidas p
  JOIN modos_juego m ON m.id_modo = p.id_modo
  WHERE p.estado = 'terminada' AND m.cuenta_para_ranking = 1
) mejores
WHERE puesto = 1;

CREATE VIEW v_ranking_categoria AS
SELECT r.id_categoria,
       c.nombre AS categoria,
       ROW_NUMBER() OVER (
         PARTITION BY r.id_categoria
         ORDER BY r.puntaje_total DESC, r.tiempo_total_seg ASC, r.total_pistas ASC, r.terminada_en ASC
       ) AS posicion,
       u.alias,
       r.puntaje_total AS puntaje
FROM v_records_categoria r
JOIN categorias c ON c.id_categoria = r.id_categoria AND c.es_mixta = 0
JOIN usuarios u   ON u.id_usuario = r.id_usuario AND u.estado = 'activo';

CREATE VIEW v_ranking_principal AS
SELECT ROW_NUMBER() OVER (
         ORDER BY SUM(r.puntaje_total) DESC, SUM(r.tiempo_total_seg) ASC, SUM(r.total_pistas) ASC
       ) AS posicion,
       u.alias,
       SUM(r.puntaje_total) AS puntaje
FROM v_records_categoria r
JOIN categorias c ON c.id_categoria = r.id_categoria AND c.es_mixta = 0 AND c.activa = 1
JOIN usuarios u   ON u.id_usuario = r.id_usuario AND u.estado = 'activo'
GROUP BY r.id_usuario, u.alias
HAVING COUNT(*) = (SELECT COUNT(*) FROM categorias WHERE es_mixta = 0 AND activa = 1);

CREATE VIEW v_ranking_mixta AS
SELECT ROW_NUMBER() OVER (
         ORDER BY r.puntaje_total DESC, r.tiempo_total_seg ASC, r.total_pistas ASC, r.terminada_en ASC
       ) AS posicion,
       u.alias,
       r.puntaje_total AS puntaje
FROM v_records_categoria r
JOIN categorias c ON c.id_categoria = r.id_categoria AND c.es_mixta = 1
JOIN usuarios u   ON u.id_usuario = r.id_usuario AND u.estado = 'activo';

CREATE VIEW v_ranking_reto_diario AS
SELECT rd.id_reto,
       rd.fecha,
       ROW_NUMBER() OVER (
         PARTITION BY p.id_reto
         ORDER BY p.puntaje_total DESC, p.tiempo_total_seg ASC, p.total_pistas ASC, p.terminada_en ASC
       ) AS posicion,
       u.alias,
       p.puntaje_total AS puntaje
FROM partidas p
JOIN retos_diarios rd ON rd.id_reto = p.id_reto
JOIN usuarios u       ON u.id_usuario = p.id_usuario AND u.estado = 'activo'
WHERE p.estado = 'terminada';

CREATE VIEW v_estadisticas_usuario AS
SELECT u.id_usuario,
       u.alias,
       COALESCE(pa.partidas_jugadas, 0) AS partidas_jugadas,
       COALESCE(re.respondidas, 0) AS preguntas_respondidas,
       COALESCE(re.aciertos, 0) AS aciertos,
       COALESCE(re.respondidas, 0) - COALESCE(re.aciertos, 0) AS errores,
       COALESCE(ROUND(100 * re.aciertos / NULLIF(re.respondidas, 0), 1), 0) AS precision_pct,
       re.tiempo_medio_seg,
       COALESCE(pa.pistas_usadas, 0) AS pistas_usadas,
       COALESCE(pa.puntaje_acumulado, 0) AS puntaje_acumulado,
       pa.ultima_partida
FROM usuarios u
LEFT JOIN (
  SELECT id_usuario,
         COUNT(*) AS partidas_jugadas,
         SUM(total_pistas) AS pistas_usadas,
         SUM(puntaje_total) AS puntaje_acumulado,
         MAX(terminada_en) AS ultima_partida
  FROM partidas
  WHERE estado = 'terminada'
  GROUP BY id_usuario
) pa ON pa.id_usuario = u.id_usuario
LEFT JOIN (
  SELECT p.id_usuario,
         COUNT(*) AS respondidas,
         SUM(r.es_correcta) AS aciertos,
         ROUND(AVG(r.segundos), 2) AS tiempo_medio_seg
  FROM respuestas r
  JOIN partidas p ON p.id_partida = r.id_partida
  WHERE p.estado = 'terminada'
  GROUP BY p.id_usuario
) re ON re.id_usuario = u.id_usuario;

CREATE VIEW v_estadisticas_usuario_categoria AS
SELECT x.id_usuario,
       x.id_categoria,
       c.nombre AS categoria,
       x.respondidas AS preguntas_respondidas,
       x.aciertos,
       x.respondidas - x.aciertos AS errores,
       ROUND(100 * x.aciertos / x.respondidas, 1) AS precision_pct,
       x.tiempo_medio_seg,
       rc.puntaje_total AS record
FROM (
  SELECT p.id_usuario,
         t.id_categoria,
         COUNT(*) AS respondidas,
         SUM(r.es_correcta) AS aciertos,
         ROUND(AVG(r.segundos), 2) AS tiempo_medio_seg
  FROM respuestas r
  JOIN partidas p  ON p.id_partida = r.id_partida
  JOIN preguntas q ON q.id_pregunta = r.id_pregunta
  JOIN temas t     ON t.id_tema = q.id_tema
  WHERE p.estado = 'terminada'
  GROUP BY p.id_usuario, t.id_categoria
) x
JOIN categorias c ON c.id_categoria = x.id_categoria
LEFT JOIN v_records_categoria rc
       ON rc.id_usuario = x.id_usuario AND rc.id_categoria = x.id_categoria;

CREATE VIEW v_ultimas_partidas AS
SELECT p.id_usuario,
       ROW_NUMBER() OVER (PARTITION BY p.id_usuario ORDER BY p.terminada_en DESC) AS numero,
       p.id_partida,
       c.nombre AS categoria,
       m.nombre AS modo,
       p.puntaje_total,
       p.aciertos,
       p.errores,
       p.tiempo_total_seg,
       p.total_pistas,
       p.bono_rapidez,
       p.bono_racha,
       p.terminada_en
FROM partidas p
JOIN categorias c  ON c.id_categoria = p.id_categoria
JOIN modos_juego m ON m.id_modo = p.id_modo
WHERE p.estado = 'terminada';

CREATE USER IF NOT EXISTS 'trivia_app'@'localhost' IDENTIFIED BY 'Cambiar_Clave_App_2026';
GRANT SELECT, INSERT, UPDATE ON retotrivia_uth.* TO 'trivia_app'@'localhost';
GRANT DELETE ON retotrivia_uth.sesiones TO 'trivia_app'@'localhost';
GRANT EXECUTE ON PROCEDURE retotrivia_uth.sp_terminar_partida TO 'trivia_app'@'localhost';

CREATE USER IF NOT EXISTS 'trivia_lectura'@'localhost' IDENTIFIED BY 'Cambiar_Clave_Lectura_2026';
GRANT SELECT ON retotrivia_uth.v_preguntas_publicas  TO 'trivia_lectura'@'localhost';
GRANT SELECT ON retotrivia_uth.v_opciones_publicas   TO 'trivia_lectura'@'localhost';
GRANT SELECT ON retotrivia_uth.v_ranking_categoria   TO 'trivia_lectura'@'localhost';
GRANT SELECT ON retotrivia_uth.v_ranking_principal   TO 'trivia_lectura'@'localhost';
GRANT SELECT ON retotrivia_uth.v_ranking_mixta       TO 'trivia_lectura'@'localhost';
GRANT SELECT ON retotrivia_uth.v_ranking_reto_diario TO 'trivia_lectura'@'localhost';

FLUSH PRIVILEGES;
