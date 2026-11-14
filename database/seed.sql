USE retotrivia_uth;
SET NAMES utf8mb4;

INSERT INTO roles (id_rol, codigo, nombre, descripcion) VALUES
(1, 'jugador', 'Jugador', 'Juega partidas y ve su ranking y sus estadísticas'),
(2, 'revisor', 'Revisor', 'Revisa y aprueba las preguntas antes de que salgan en el juego'),
(3, 'admin', 'Administrador', 'Maneja la configuración, los retos y los reportes');

INSERT INTO usuarios (id_usuario, id_rol, alias, correo, contrasena_hash, estado, creado_en, ultimo_acceso) VALUES
(1, 3, 'admin_trivia', 'admin@retotrivia.test', 'scrypt$16384$8$1$7b2f8acd0a90b4e25260feb20db21af0$29459d7dabafebce6736d2a792454aa7695b0495ff25ad9d1c50d9b9e73ae5f4cadffc073811d42a7e8f4547ffc4c176a431a1050a4404bb1673b1f3fa6d4cd4', 'activo', '2026-10-20 08:00:00', '2026-11-07 09:00:00'),
(2, 2, 'revisor_uth', 'revisor@retotrivia.test', 'scrypt$16384$8$1$2fcaf50bbdb2ce266b77ec9b4a2d3996$f5f3ad824aec6fdf6f7fbfc2b35dba532c39de7ce19a8f20f50dd5566e624cb5387793ac6abb950beb515c6a56372391590066106e7edd5daf00026f6669bdfa', 'activo', '2026-10-20 08:10:00', '2026-11-07 09:00:00'),
(3, 1, 'dani_uth', 'dani@correo.test', 'scrypt$16384$8$1$5f9434d468847679fcd0299bb48ae2a4$43b2623d1654c43aee17e977d3ee47d9c46986bb02b845e8cb4319326312bf01495cc102cb293bc04fb875962c014a82623d341a1a1d8d6936476f420e500daf', 'activo', '2026-10-25 14:00:00', '2026-11-07 09:00:00'),
(4, 1, 'sofi23', 'sofi@correo.test', 'scrypt$16384$8$1$f895e61c05ffb9d77a79c5c2531d9761$9cfddf5a606b0cfe85a1e08154ccbce9a1ce88830633d23a7f96600ec81205465771f7ef95b66bcc414ed0a3f18aa289ed16b8a85f0f666d15e6809e5c0e290d', 'activo', '2026-10-25 15:30:00', '2026-11-07 09:00:00'),
(5, 1, 'kevin_hn', 'kevin@correo.test', 'scrypt$16384$8$1$34f7efc5d65c99cc68c082857f89ea10$d4f1f4c917e05dd07b934a153bcf3ca402d5497583924a5bb2a688fc71d64a95ae7089d396e8bfcd3462caebfcc318c76975d4ce0069114c200f4ba36cbaeb14', 'activo', '2026-10-26 09:00:00', '2026-11-07 09:00:00'),
(6, 1, 'luis_tec', 'luis@correo.test', 'scrypt$16384$8$1$b1d9e0e147a7a2b2804e42f56b7f4dc1$78c8510945c9bb6d14841866fed23053a81d6a2cc301d4d42eb7cb1e988a3d190e5d20cee7c11d52176c8119a0a673d641e318912979119f28836037cacf3c7c', 'activo', '2026-10-26 10:20:00', '2026-11-07 09:00:00'),
(7, 1, 'andrea_m', 'andrea@correo.test', 'scrypt$16384$8$1$89b69dcb5ca323cdf78f6a554ee96fe9$89fad63df3eeccf9954942b2f60049c422ff2cc295b907516835437167c1ce6e573bd50c3d75601c813df9dab62d890b433441a75cbf63735da93531a4eed894', 'activo', '2026-10-27 16:45:00', '2026-11-07 09:00:00'),
(8, 1, 'carlos_ce', 'carlos@correo.test', 'scrypt$16384$8$1$85e64117a04bbcfba734b8e7e115c400$99cfba9be2bd71f78dae81c256b8188713c9f132a8237ec3830797387c56bc7aa43803f0f146ef6f7fa68179271c0f49b2b60ee248347f7d4f8e6bfe838cb507', 'activo', '2026-10-28 11:00:00', '2026-11-07 09:00:00'),
(9, 1, 'jugador_nuevo', 'nuevo@correo.test', 'scrypt$16384$8$1$cd4c94d686dc69399536f7605affe027$af27b001ec5f765bdee1a008bd9555c3aee40df755216b64726f85c890fafeee24af8700ee47306d642e7929585006a60ef5d4b93405d90661bba5b64766ee63', 'activo', '2026-11-06 18:00:00', NULL),
(10, 1, 'cuenta_bloqueada', 'bloqueada@correo.test', 'scrypt$16384$8$1$0c26b6690743df7f900d23e8ca35bbfe$447dbeeca6cddc975a0f579e63197146672f6323a85aab2203fa08ea0755e6d5066f84189fb35664b2bbd234e874c452ed2d3193742407215139aa5751280e42', 'bloqueado', '2026-10-29 12:00:00', '2026-11-07 09:00:00');

INSERT INTO sesiones (id_sesion, id_usuario, token_hash, ip, navegador, creada_en, expira_en, cerrada_en) VALUES
(1, 1, '2aca97da60a32c4d6f4dbcdf54f53b5f6641acbb28ee1696353a9f4181970221', '192.168.56.1', 'Mozilla/5.0 (Windows NT 10.0)', '2026-11-07 08:55:00', '2026-11-14 08:55:00', NULL),
(2, 3, '8c2df70d14d9bcd31dc268501d3831f3d56cb332cee590923f38697ea1154a90', '192.168.56.1', 'Mozilla/5.0 (Windows NT 10.0)', '2026-11-06 19:00:00', '2026-11-13 19:00:00', '2026-11-06 21:10:00'),
(3, 3, 'ab81ea390b23011159593b0bac3fed303013d5a8ff5f398fd641f5be30aff9d1', '192.168.56.1', 'Mozilla/5.0 (Windows NT 10.0)', '2026-11-07 09:00:00', '2026-11-14 09:00:00', NULL),
(4, 6, 'eb395f9f52337e2330f9a11dfd600b62daf9bb2ef0864125e1437850e29e82eb', '192.168.56.1', 'Mozilla/5.0 (Windows NT 10.0)', '2026-11-07 09:25:00', '2026-11-14 09:25:00', NULL);

INSERT INTO categorias (id_categoria, codigo, nombre, descripcion, es_mixta, orden) VALUES
(1, 'computacion', 'Ingeniería en Computación', 'Programación, bases de datos, redes, sistemas operativos y algoritmos', 0, 1),
(2, 'derecho', 'Derecho', 'Conceptos jurídicos, áreas del Derecho, derechos humanos y nociones constitucionales', 0, 2),
(3, 'psicologia', 'Psicología', 'Aprendizaje, desarrollo humano, psicología social y métodos de evaluación', 0, 3),
(4, 'electronica', 'Ingeniería en Electrónica', 'Circuitos, electrónica analógica y digital, medición, control y automatización', 0, 4),
(5, 'mixta', 'Mixta UTH', 'Preguntas al azar de las cuatro carreras', 1, 5);

INSERT INTO temas (id_tema, id_categoria, nombre) VALUES
(1, 1, 'Programación'),
(2, 1, 'Bases de datos'),
(3, 1, 'Redes'),
(4, 1, 'Sistemas operativos'),
(5, 1, 'Algoritmos'),
(6, 2, 'Conceptos jurídicos'),
(7, 2, 'Áreas del Derecho'),
(8, 2, 'Derechos humanos'),
(9, 2, 'Nociones constitucionales'),
(10, 3, 'Aprendizaje'),
(11, 3, 'Desarrollo humano'),
(12, 3, 'Psicología social'),
(13, 3, 'Métodos de evaluación'),
(14, 4, 'Circuitos'),
(15, 4, 'Electrónica analógica'),
(16, 4, 'Electrónica digital'),
(17, 4, 'Medición'),
(18, 4, 'Control y automatización');

INSERT INTO configuracion_juego (id_config, clave, valor, valor_min, valor_max, unidad, descripcion, actualizado_por) VALUES
(1, 'puntos_acierto_min', 70, 1, 100, 'puntos', 'Puntos de un acierto contestado justo al final del tiempo', 1),
(2, 'puntos_acierto_max', 100, 1, 500, 'puntos', 'Puntos de un acierto contestado al instante', 1),
(3, 'segundos_por_pregunta', 20, 5, 120, 'segundos', 'Tiempo para contestar cada pregunta', 1),
(4, 'bono_rapidez', 20, 0, 200, 'puntos', 'Bono por terminar en menos de la mitad del tiempo total', 1),
(5, 'bono_racha', 10, 0, 200, 'puntos', 'Bono por lograr la racha de aciertos seguidos', 1),
(6, 'aciertos_para_racha', 5, 2, 10, 'aciertos', 'Aciertos seguidos que se necesitan para el bono de racha', 1),
(7, 'segundos_espera_ia', 15, 5, 120, 'segundos', 'Cuánto se espera a Ollama antes de usar el banco de preguntas', 1);

INSERT INTO modos_juego (id_modo, codigo, nombre, descripcion, cantidad_preguntas, termina_al_fallar, cuenta_para_ranking) VALUES
(1, 'normal', 'Normal', '10 preguntas de una carrera', 10, 0, 1),
(2, 'mixta', 'Mixta', '10 preguntas al azar de las cuatro carreras', 10, 0, 1),
(3, 'reto_dia', 'Reto del día', '5 preguntas mixtas iguales para todos, un intento por día', 5, 0, 0),
(4, 'muerte_subita', 'Muerte súbita', 'Sigue hasta el primer error', NULL, 1, 0);

INSERT INTO tipos_pista (id_tipo_pista, codigo, nombre, descripcion) VALUES
(1, 'conceptual', 'Pista conceptual', 'Recuerda el concepto sin decir la respuesta'),
(2, 'eliminar_dos', 'Eliminar dos opciones', 'Quita dos opciones incorrectas'),
(3, 'adicional', 'Pista adicional', 'Da un dato corto que ayuda a razonar');

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(1, 1, '¿Qué estructura repite un bloque de código mientras una condición sea verdadera?', 'El ciclo while revisa la condición antes de cada vuelta y sigue repitiendo mientras sea verdadera.', 'Piensa en una instrucción que se queda dando vueltas.', 'En español su nombre se traduce como ''mientras''.', 'facil', 'manual', 'Plan de estudio de Ingeniería en Computación, UTH', 2, '2026-10-21 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(1, 1, 'A', 'if', 0),
(2, 1, 'B', 'while', 1),
(3, 1, 'C', 'switch', 0),
(4, 1, 'D', 'return', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(2, 1, 'En JavaScript, ¿qué devuelve typeof null?', 'Es un error viejo del lenguaje que se dejó así para no romper programas que ya existían.', 'El resultado no es el que uno esperaría a simple vista.', 'Es el mismo resultado que da typeof con un arreglo o con {}.', 'media', 'ia', 'Documentación de JavaScript en MDN Web Docs', 1, '2026-10-21 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(5, 2, 'A', '"null"', 0),
(6, 2, 'B', '"undefined"', 0),
(7, 2, 'C', '"object"', 1),
(8, 2, 'D', '"number"', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(3, 2, '¿Qué comando de SQL se usa para consultar datos de una tabla?', 'SELECT lee los datos sin cambiarlos; los otros tres agregan, cambian o borran filas.', 'Busca el comando que solo lee y no modifica nada.', 'Casi siempre va acompañado de FROM.', 'facil', 'manual', 'Plan de estudio de Ingeniería en Computación, UTH', 2, '2026-10-21 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(9, 3, 'A', 'SELECT', 1),
(10, 3, 'B', 'INSERT', 0),
(11, 3, 'C', 'UPDATE', 0),
(12, 3, 'D', 'DELETE', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(4, 2, '¿Cómo se llama la llave que relaciona una tabla con la llave primaria de otra tabla?', 'La llave foránea guarda el valor de la llave primaria de otra tabla y así une las dos.', 'Es la llave que ''viene de afuera'' de la tabla.', 'Con ella se definen reglas como ON DELETE CASCADE.', 'media', 'manual', 'Plan de estudio de Ingeniería en Computación, UTH', 2, '2026-10-21 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(13, 4, 'A', 'Llave primaria', 0),
(14, 4, 'B', 'Llave candidata', 0),
(15, 4, 'C', 'Índice único', 0),
(16, 4, 'D', 'Llave foránea', 1);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(5, 3, '¿Cuál es el puerto que usa HTTPS por defecto?', 'HTTPS usa el puerto 443; el 80 es para HTTP sin cifrar, el 21 para FTP y el 22 para SSH.', 'Es el puerto de las páginas con candadito en el navegador.', 'No es el mismo que usa HTTP normal.', 'facil', 'manual', 'Plan de estudio de Ingeniería en Computación, UTH', 2, '2026-10-21 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(17, 5, 'A', '80', 0),
(18, 5, 'B', '443', 1),
(19, 5, 'C', '21', 0),
(20, 5, 'D', '22', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(6, 3, '¿Qué servicio convierte un nombre de dominio, como uth.hn, en una dirección IP?', 'El DNS funciona como una agenda: busca el nombre del sitio y devuelve la IP del servidor.', 'Piensa en una agenda de contactos de internet.', 'Si este servicio falla, las páginas no abren por nombre pero sí por IP.', 'media', 'ia', 'Plan de estudio de Ingeniería en Computación, UTH', 1, '2026-10-21 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(21, 6, 'A', 'DHCP', 0),
(22, 6, 'B', 'SMTP', 0),
(23, 6, 'C', 'DNS', 1),
(24, 6, 'D', 'FTP', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(7, 4, '¿Qué comando de Linux muestra la carpeta en la que estás trabajando?', 'pwd significa ''print working directory'' y muestra la ruta completa de la carpeta actual.', 'No lista archivos ni cambia de carpeta, solo te dice dónde estás.', 'Sus tres letras vienen de una frase en inglés.', 'facil', 'manual', 'Plan de estudio de Ingeniería en Computación, UTH', 2, '2026-10-21 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(25, 7, 'A', 'ls', 0),
(26, 7, 'B', 'cd', 0),
(27, 7, 'C', 'mkdir', 0),
(28, 7, 'D', 'pwd', 1);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(8, 4, 'En Rocky Linux, ¿qué se usa para que un servicio arranque solo al encender el servidor?', 'Con systemctl enable, systemd deja el servicio listo para arrancar con el sistema.', 'Es el mismo que se usa con systemctl start y stop.', 'Es el primer proceso que arranca en el sistema.', 'media', 'manual', 'Documentación de Rocky Linux', 2, '2026-10-21 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(29, 8, 'A', 'systemd', 1),
(30, 8, 'B', 'cron', 0),
(31, 8, 'C', 'firewalld', 0),
(32, 8, 'D', 'logrotate', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(9, 5, '¿Cuántos pasos necesita, más o menos, la búsqueda binaria en un arreglo ordenado de n elementos?', 'En cada paso descarta la mitad de los elementos, por eso tarda del orden de log n.', 'Cada vez que compara, la lista se parte a la mitad.', 'Con 1024 elementos le bastan unos 10 pasos.', 'media', 'manual', 'Plan de estudio de Ingeniería en Computación, UTH', 2, '2026-10-21 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(33, 9, 'A', 'n', 0),
(34, 9, 'B', 'log n', 1),
(35, 9, 'C', 'n²', 0),
(36, 9, 'D', '1', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(10, 5, '¿Qué estructura de datos funciona con la regla ''el último que entra es el primero que sale''?', 'En una pila se agrega y se saca siempre por arriba, como una pila de platos.', 'Piensa en una pila de platos para lavar.', 'Sus operaciones se llaman push y pop.', 'dificil', 'manual', 'Plan de estudio de Ingeniería en Computación, UTH', 2, '2026-10-21 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(37, 10, 'A', 'Cola', 0),
(38, 10, 'B', 'Árbol', 0),
(39, 10, 'C', 'Pila', 1),
(40, 10, 'D', 'Grafo', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(11, 9, '¿Cuál es la norma de mayor jerarquía dentro de un país?', 'La Constitución está por encima de las demás normas; ninguna ley puede contradecirla.', 'Todas las demás normas tienen que respetarla.', 'En Honduras la actual es de 1982.', 'facil', 'manual', 'Constitución de la República de Honduras', 2, '2026-10-22 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(41, 11, 'A', 'La ley ordinaria', 0),
(42, 11, 'B', 'La Constitución', 1),
(43, 11, 'C', 'El reglamento', 0),
(44, 11, 'D', 'El decreto ejecutivo', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(12, 7, '¿Qué rama del Derecho se encarga de los delitos y sus penas?', 'El Derecho penal define qué conductas son delitos y qué castigo le corresponde a cada una.', 'Piensa en la rama que se aplica en un juicio por robo.', 'Su código principal es el Código Penal.', 'facil', 'manual', 'Plan de estudio de la Licenciatura en Derecho, UTH', 2, '2026-10-22 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(45, 12, 'A', 'Derecho civil', 0),
(46, 12, 'B', 'Derecho mercantil', 0),
(47, 12, 'C', 'Derecho laboral', 0),
(48, 12, 'D', 'Derecho penal', 1);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(13, 7, '¿Qué rama del Derecho regula la relación entre trabajadores y patronos?', 'El Derecho laboral trata temas como el salario, la jornada, las vacaciones y los despidos.', 'Tiene que ver con el empleo y los contratos de trabajo.', 'En Honduras su norma principal es el Código del Trabajo.', 'facil', 'ia', 'Plan de estudio de la Licenciatura en Derecho, UTH', 1, '2026-10-22 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(49, 13, 'A', 'Derecho laboral', 1),
(50, 13, 'B', 'Derecho penal', 0),
(51, 13, 'C', 'Derecho internacional', 0),
(52, 13, 'D', 'Derecho notarial', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(14, 8, '¿En qué año se aprobó la Declaración Universal de los Derechos Humanos?', 'La aprobó la Asamblea General de la ONU el 10 de diciembre de 1948.', 'Fue pocos años después de terminar la Segunda Guerra Mundial.', 'Por eso el 10 de diciembre es el Día de los Derechos Humanos.', 'media', 'manual', 'Declaración Universal de los Derechos Humanos, ONU', 2, '2026-10-22 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(53, 14, 'A', '1945', 0),
(54, 14, 'B', '1966', 0),
(55, 14, 'C', '1948', 1),
(56, 14, 'D', '1989', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(15, 6, '¿Qué principio dice que una persona es inocente mientras no se demuestre que es culpable?', 'Por la presunción de inocencia, es la acusación la que tiene que probar la culpa.', 'Tiene que ver con quién debe probar en un juicio.', 'También aparece en la Declaración Universal de los Derechos Humanos.', 'facil', 'manual', 'Plan de estudio de la Licenciatura en Derecho, UTH', 2, '2026-10-22 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(57, 15, 'A', 'Presunción de inocencia', 1),
(58, 15, 'B', 'Principio de legalidad', 0),
(59, 15, 'C', 'Cosa juzgada', 0),
(60, 15, 'D', 'Irretroactividad', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(16, 9, 'Según la Constitución de Honduras, ¿cuáles son los tres poderes del Estado?', 'El artículo 4 de la Constitución dice que son el Legislativo, el Ejecutivo y el Judicial, independientes entre sí.', 'Uno hace las leyes, otro las ejecuta y otro juzga.', 'El Congreso Nacional es uno de ellos.', 'media', 'manual', 'Constitución de la República de Honduras, art. 4', 2, '2026-10-22 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(61, 16, 'A', 'Electoral, Militar y Municipal', 0),
(62, 16, 'B', 'Legislativo, Ejecutivo y Judicial', 1),
(63, 16, 'C', 'Ejecutivo, Electoral y Judicial', 0),
(64, 16, 'D', 'Legislativo, Municipal y Ejecutivo', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(17, 9, '¿En qué año entró en vigencia la Constitución actual de Honduras?', 'La Constitución vigente se aprobó en enero de 1982, cuando el país volvió al orden constitucional.', 'Fue a inicios de la década de los ochenta.', 'Se aprobó en el mes de enero.', 'media', 'manual', 'Constitución de la República de Honduras', 2, '2026-10-22 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(65, 17, 'A', '1957', 0),
(66, 17, 'B', '1965', 0),
(67, 17, 'C', '1999', 0),
(68, 17, 'D', '1982', 1);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(18, 6, '¿Qué es la capacidad jurídica de una persona?', 'Toda persona tiene capacidad jurídica: puede ser dueña de derechos y responder por obligaciones.', 'No depende de la profesión ni del dinero.', 'Se tiene desde el nacimiento.', 'media', 'ia', 'Plan de estudio de la Licenciatura en Derecho, UTH', 1, '2026-10-22 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(69, 18, 'A', 'La aptitud para tener derechos y obligaciones', 1),
(70, 18, 'B', 'El dinero que tiene a su nombre', 0),
(71, 18, 'C', 'El título de abogado', 0),
(72, 18, 'D', 'El permiso para votar', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(19, 9, '¿Qué recurso protege a una persona cuando un acto viola sus derechos constitucionales?', 'El amparo sirve para que se restituya un derecho de la Constitución que fue violado o amenazado.', 'Su nombre significa proteger o resguardar.', 'Lo conoce la Sala de lo Constitucional.', 'dificil', 'manual', 'Constitución de la República de Honduras', 2, '2026-10-22 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(73, 19, 'A', 'Apelación', 0),
(74, 19, 'B', 'Casación', 0),
(75, 19, 'C', 'Amparo', 1),
(76, 19, 'D', 'Desahucio', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(20, 8, '¿Qué garantía se usa cuando una persona está detenida de forma ilegal?', 'El hábeas corpus, o exhibición personal, obliga a presentar al detenido ante un juez para revisar su detención.', 'Protege la libertad personal.', 'Su nombre viene del latín y habla del cuerpo de la persona.', 'dificil', 'manual', 'Constitución de la República de Honduras', 2, '2026-10-22 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(77, 20, 'A', 'Inconstitucionalidad', 0),
(78, 20, 'B', 'Revisión', 0),
(79, 20, 'C', 'Hábeas data', 0),
(80, 20, 'D', 'Hábeas corpus', 1);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(21, 10, '¿Quién es conocido por sus experimentos de condicionamiento clásico con perros?', 'Pávlov logró que los perros salivaran al oír un sonido que antes acompañaba a la comida.', 'El experimento usaba comida y un sonido.', 'Era un fisiólogo ruso.', 'facil', 'manual', 'Plan de estudio de la Licenciatura en Psicología, UTH', 2, '2026-10-23 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(81, 21, 'A', 'Iván Pávlov', 1),
(82, 21, 'B', 'B. F. Skinner', 0),
(83, 21, 'C', 'Sigmund Freud', 0),
(84, 21, 'D', 'Jean Piaget', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(22, 10, 'En el condicionamiento operante, ¿qué hace que una conducta tenga más probabilidad de repetirse?', 'El refuerzo, positivo o negativo, aumenta la conducta; el castigo la disminuye.', 'Piensa en lo que pasa después de la conducta.', 'Skinner lo estudió con palomas y ratas.', 'media', 'manual', 'Plan de estudio de la Licenciatura en Psicología, UTH', 2, '2026-10-23 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(85, 22, 'A', 'El castigo', 0),
(86, 22, 'B', 'El refuerzo', 1),
(87, 22, 'C', 'La extinción', 0),
(88, 22, 'D', 'La habituación', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(23, 11, '¿Qué autor propuso las etapas del desarrollo cognitivo del niño?', 'Piaget describió cuatro etapas: sensoriomotora, preoperacional, operaciones concretas y operaciones formales.', 'Estudió cómo piensan los niños a distintas edades.', 'Era suizo.', 'facil', 'manual', 'Plan de estudio de la Licenciatura en Psicología, UTH', 2, '2026-10-23 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(89, 23, 'A', 'Erik Erikson', 0),
(90, 23, 'B', 'Albert Bandura', 0),
(91, 23, 'C', 'Jean Piaget', 1),
(92, 23, 'D', 'Abraham Maslow', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(24, 11, 'Según Piaget, ¿en qué etapa el bebé entiende que un objeto sigue existiendo aunque no lo vea?', 'La permanencia del objeto aparece en la etapa sensoriomotora, durante los dos primeros años.', 'Es la primera etapa.', 'Se nota cuando el bebé busca un juguete que se escondió.', 'media', 'ia', 'Plan de estudio de la Licenciatura en Psicología, UTH', 1, '2026-10-23 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(93, 24, 'A', 'Operaciones formales', 0),
(94, 24, 'B', 'Operaciones concretas', 0),
(95, 24, 'C', 'Preoperacional', 0),
(96, 24, 'D', 'Sensoriomotora', 1);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(25, 11, 'Según Erikson, ¿cuál es la crisis principal de la adolescencia?', 'En la adolescencia la persona busca saber quién es y qué lugar ocupa.', 'Tiene que ver con la pregunta ''¿quién soy yo?''.', 'Las otras opciones son de la infancia o de la adultez.', 'media', 'manual', 'Plan de estudio de la Licenciatura en Psicología, UTH', 2, '2026-10-23 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(97, 25, 'A', 'Identidad frente a confusión de roles', 1),
(98, 25, 'B', 'Confianza frente a desconfianza', 0),
(99, 25, 'C', 'Intimidad frente a aislamiento', 0),
(100, 25, 'D', 'Integridad frente a desesperación', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(26, 12, '¿Cómo se llama cambiar la opinión o la conducta para coincidir con lo que hace el grupo?', 'La conformidad es ajustarse al grupo aunque nadie lo ordene; Asch la estudió con líneas de distinto largo.', 'Nadie da una orden, pero la persona igual se ajusta.', 'Se relaciona con la presión de grupo.', 'facil', 'manual', 'Plan de estudio de la Licenciatura en Psicología, UTH', 2, '2026-10-23 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(101, 26, 'A', 'Obediencia', 0),
(102, 26, 'B', 'Disonancia', 0),
(103, 26, 'C', 'Conformidad', 1),
(104, 26, 'D', 'Reactancia', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(27, 12, '¿Quién hizo los experimentos de obediencia a la autoridad con supuestas descargas eléctricas?', 'Milgram mostró que muchas personas seguían órdenes aunque creían que estaban lastimando a alguien.', 'Los participantes creían que castigaban a otra persona.', 'Los hizo en la Universidad de Yale en los años sesenta.', 'media', 'manual', 'Plan de estudio de la Licenciatura en Psicología, UTH', 2, '2026-10-23 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(105, 27, 'A', 'Stanley Milgram', 1),
(106, 27, 'B', 'Solomon Asch', 0),
(107, 27, 'C', 'Philip Zimbardo', 0),
(108, 27, 'D', 'Albert Bandura', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(28, 12, '¿Qué es la disonancia cognitiva?', 'Festinger explicó que ese malestar lleva a la persona a cambiar lo que piensa o lo que hace.', 'Es una incomodidad interna.', 'La propuso Leon Festinger.', 'dificil', 'ia', 'Plan de estudio de la Licenciatura en Psicología, UTH', 1, '2026-10-23 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(109, 28, 'A', 'Olvidar algo por estrés', 0),
(110, 28, 'B', 'El malestar de tener ideas o conductas que se contradicen', 1),
(111, 28, 'C', 'Aprender viendo a otros', 0),
(112, 28, 'D', 'Una falla en la memoria de corto plazo', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(29, 13, '¿Qué significa que una prueba psicológica sea confiable?', 'La confiabilidad es la consistencia del resultado; medir lo que dice medir es la validez.', 'No es lo mismo que la validez.', 'Piensa en una balanza que siempre marca el mismo peso.', 'media', 'manual', 'Plan de estudio de la Licenciatura en Psicología, UTH', 2, '2026-10-23 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(113, 29, 'A', 'Que mide lo que dice medir', 0),
(114, 29, 'B', 'Que es fácil de contestar', 0),
(115, 29, 'C', 'Que da resultados parecidos al repetirse', 1),
(116, 29, 'D', 'Que la hizo un psicólogo', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(30, 13, 'En las escalas de inteligencia de Wechsler, ¿cuál es el puntaje promedio de CI?', 'Las escalas Wechsler ponen el promedio en 100, con una desviación estándar de 15.', 'Es un número redondo.', 'Las demás opciones quedan lejos del centro.', 'dificil', 'manual', 'Plan de estudio de la Licenciatura en Psicología, UTH', 2, '2026-10-23 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(117, 30, 'A', '85', 0),
(118, 30, 'B', '50', 0),
(119, 30, 'C', '130', 0),
(120, 30, 'D', '100', 1);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(31, 14, 'Por una resistencia de 100 Ω pasan 0.2 A. ¿Qué voltaje hay en ella?', 'Por la ley de Ohm, V = I × R = 0.2 A × 100 Ω = 20 V.', 'Usa la ley de Ohm.', 'Multiplica la corriente por la resistencia.', 'facil', 'manual', 'Plan de estudio de Ingeniería en Electrónica, UTH', 2, '2026-10-24 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(121, 31, 'A', '2 V', 0),
(122, 31, 'B', '20 V', 1),
(123, 31, 'C', '200 V', 0),
(124, 31, 'D', '500 V', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(32, 14, '¿Cuál es la resistencia total de dos resistencias de 10 Ω conectadas en paralelo?', 'Dos resistencias iguales en paralelo dan la mitad de una de ellas: 10 / 2 = 5 Ω.', 'En paralelo el total es menor que la resistencia más pequeña.', 'Con resistencias iguales, se divide entre cuántas hay.', 'media', 'manual', 'Plan de estudio de Ingeniería en Electrónica, UTH', 2, '2026-10-24 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(125, 32, 'A', '20 Ω', 0),
(126, 32, 'B', '10 Ω', 0),
(127, 32, 'C', '5 Ω', 1),
(128, 32, 'D', '2.5 Ω', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(33, 15, '¿Qué componente deja pasar la corriente en un solo sentido?', 'El diodo conduce cuando está polarizado en directa y bloquea en inversa.', 'Funciona como una válvula de un solo sentido.', 'Sus terminales se llaman ánodo y cátodo.', 'facil', 'manual', 'Plan de estudio de Ingeniería en Electrónica, UTH', 2, '2026-10-24 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(129, 33, 'A', 'Diodo', 1),
(130, 33, 'B', 'Capacitor', 0),
(131, 33, 'C', 'Inductor', 0),
(132, 33, 'D', 'Resistencia', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(34, 15, '¿Cómo se llaman las tres terminales de un transistor bipolar (BJT)?', 'El BJT tiene emisor, base y colector; fuente, compuerta y drenador son del transistor de efecto de campo.', 'No confundir con el transistor de efecto de campo.', 'Una de las terminales controla la corriente entre las otras dos.', 'media', 'ia', 'Plan de estudio de Ingeniería en Electrónica, UTH', 1, '2026-10-24 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(133, 34, 'A', 'Fuente, compuerta y drenador', 0),
(134, 34, 'B', 'Ánodo, cátodo y rejilla', 0),
(135, 34, 'C', 'Entrada, salida y tierra', 0),
(136, 34, 'D', 'Emisor, base y colector', 1);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(35, 16, '¿Qué compuerta lógica da 1 solo cuando todas sus entradas son 1?', 'La compuerta AND solo da 1 si todas las entradas valen 1; con un solo 0 la salida es 0.', 'Se parece a la palabra ''y''.', 'Funciona como dos interruptores en serie.', 'facil', 'manual', 'Plan de estudio de Ingeniería en Electrónica, UTH', 2, '2026-10-24 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(137, 35, 'A', 'OR', 0),
(138, 35, 'B', 'AND', 1),
(139, 35, 'C', 'XOR', 0),
(140, 35, 'D', 'NOT', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(36, 16, '¿Cuánto vale el número binario 1010 en decimal?', '1010 = 1×8 + 0×4 + 1×2 + 0×1 = 10.', 'Cada posición vale el doble que la de su derecha.', 'Los valores de las posiciones son 8, 4, 2 y 1.', 'media', 'manual', 'Plan de estudio de Ingeniería en Electrónica, UTH', 2, '2026-10-24 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(141, 36, 'A', '8', 0),
(142, 36, 'B', '12', 0),
(143, 36, 'C', '10', 1),
(144, 36, 'D', '5', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(37, 17, '¿Cómo se conecta un amperímetro para medir la corriente de un circuito?', 'El amperímetro va en serie para que toda la corriente pase por él; el voltímetro va en paralelo.', 'La corriente tiene que pasar por adentro del aparato.', 'Es al revés de como se conecta el voltímetro.', 'facil', 'manual', 'Plan de estudio de Ingeniería en Electrónica, UTH', 2, '2026-10-24 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(145, 37, 'A', 'En paralelo con la carga', 0),
(146, 37, 'B', 'Directo a la fuente sin carga', 0),
(147, 37, 'C', 'En serie con la carga', 1),
(148, 37, 'D', 'Entre tierra y chasis', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(38, 17, '¿Qué instrumento muestra la forma de onda de una señal eléctrica?', 'El osciloscopio dibuja el voltaje contra el tiempo en su pantalla.', 'Tiene una pantalla con cuadrícula.', 'Se usa para ver la frecuencia y la amplitud.', 'media', 'manual', 'Plan de estudio de Ingeniería en Electrónica, UTH', 2, '2026-10-24 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(149, 38, 'A', 'Osciloscopio', 1),
(150, 38, 'B', 'Óhmetro', 0),
(151, 38, 'C', 'Amperímetro', 0),
(152, 38, 'D', 'Fuente de poder', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(39, 18, '¿Qué significan las letras de un controlador PID?', 'El PID combina tres acciones: proporcional al error, integral del error y derivada del error.', 'Las tres palabras vienen del cálculo.', 'Se usa mucho para controlar temperatura y velocidad.', 'media', 'ia', 'Plan de estudio de Ingeniería en Electrónica, UTH', 1, '2026-10-24 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(153, 39, 'A', 'Potencia, intensidad y dirección', 0),
(154, 39, 'B', 'Proporcional, integral y derivativo', 1),
(155, 39, 'C', 'Pulso, inicio y detención', 0),
(156, 39, 'D', 'Programa, interfaz y datos', 0);

INSERT INTO preguntas (id_pregunta, id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por, creada_en) VALUES
(40, 18, '¿Qué equipo se usa en la industria para automatizar procesos con programas en lenguaje escalera?', 'El PLC o controlador lógico programable lee sensores, ejecuta el programa y activa motores y válvulas.', 'Es una computadora hecha para trabajar en fábricas.', 'El lenguaje escalera también se llama Ladder.', 'dificil', 'manual', 'Plan de estudio de Ingeniería en Electrónica, UTH', 2, '2026-10-24 10:00:00');
INSERT INTO opciones (id_opcion, id_pregunta, letra, texto, es_correcta) VALUES
(157, 40, 'A', 'Variador de frecuencia', 0),
(158, 40, 'B', 'Multímetro', 0),
(159, 40, 'C', 'Transformador', 0),
(160, 40, 'D', 'PLC', 1);

INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES
(2, 2, 'cambios', 'Las comillas de las opciones no se ven bien, revisar', '2026-10-24 15:00:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (1, 2, 'aprobada', NULL, '2026-10-25 08:07:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (2, 2, 'aprobada', 'Se corrigió y queda bien', '2026-10-25 08:14:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (3, 2, 'aprobada', NULL, '2026-10-25 08:21:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (4, 2, 'aprobada', NULL, '2026-10-25 08:28:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (5, 2, 'aprobada', NULL, '2026-10-25 08:35:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (6, 2, 'aprobada', NULL, '2026-10-25 08:42:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (7, 2, 'aprobada', NULL, '2026-10-25 08:49:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (8, 2, 'aprobada', NULL, '2026-10-25 08:56:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (9, 2, 'aprobada', NULL, '2026-10-25 08:03:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (10, 2, 'aprobada', NULL, '2026-10-25 09:10:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (11, 2, 'aprobada', NULL, '2026-10-25 09:17:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (12, 2, 'aprobada', NULL, '2026-10-25 09:24:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (13, 2, 'aprobada', NULL, '2026-10-25 09:31:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (14, 2, 'aprobada', NULL, '2026-10-25 09:38:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (15, 2, 'aprobada', NULL, '2026-10-25 09:45:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (16, 2, 'aprobada', NULL, '2026-10-25 09:52:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (17, 2, 'aprobada', NULL, '2026-10-25 09:59:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (18, 2, 'aprobada', NULL, '2026-10-25 09:06:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (19, 2, 'aprobada', NULL, '2026-10-25 09:13:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (20, 2, 'aprobada', NULL, '2026-10-25 10:20:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (21, 2, 'aprobada', NULL, '2026-10-25 10:27:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (22, 2, 'aprobada', NULL, '2026-10-25 10:34:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (23, 2, 'aprobada', NULL, '2026-10-25 10:41:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (24, 2, 'aprobada', NULL, '2026-10-25 10:48:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (25, 2, 'aprobada', NULL, '2026-10-25 10:55:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (26, 2, 'aprobada', NULL, '2026-10-25 10:02:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (27, 2, 'aprobada', NULL, '2026-10-25 10:09:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (28, 2, 'aprobada', NULL, '2026-10-25 10:16:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (29, 2, 'aprobada', NULL, '2026-10-25 10:23:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (30, 2, 'aprobada', NULL, '2026-10-25 11:30:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (31, 2, 'aprobada', NULL, '2026-10-25 11:37:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (32, 2, 'aprobada', NULL, '2026-10-25 11:44:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (33, 2, 'aprobada', NULL, '2026-10-25 11:51:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (34, 2, 'aprobada', NULL, '2026-10-25 11:58:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (35, 2, 'aprobada', NULL, '2026-10-25 11:05:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (36, 2, 'aprobada', NULL, '2026-10-25 11:12:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (37, 2, 'aprobada', NULL, '2026-10-25 11:19:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (38, 2, 'aprobada', NULL, '2026-10-25 11:26:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (39, 2, 'aprobada', NULL, '2026-10-25 11:33:00');
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario, revisada_en) VALUES (40, 2, 'aprobada', NULL, '2026-10-25 12:40:00');

INSERT INTO solicitudes_ia (id_solicitud, tipo, id_tema, id_pregunta, id_usuario, modelo, instruccion, respuesta, estado, tiempo_respuesta_ms, mensaje_error, uso_respaldo, creada_en) VALUES
(1, 'pregunta', 1, 2, 1, 'llama3.2:1b', 'Genera una pregunta de opción múltiple del tema indicado con 4 opciones, una correcta, explicación y dificultad. Responde en JSON.', '{"enunciado": "En JavaScript, ¿qué devuelve typeof null?", "opciones": 4, "correcta": "C"}', 'exitosa', 3775, NULL, 0, '2026-10-21 09:05:00.000'),
(2, 'pregunta', 3, 6, 1, 'llama3.2:1b', 'Genera una pregunta de opción múltiple del tema indicado con 4 opciones, una correcta, explicación y dificultad. Responde en JSON.', '{"enunciado": "¿Qué servicio convierte un nombre de dominio, como uth.hn, en una dirección IP?", "opciones": 4, "correcta": "C"}', 'exitosa', 5417, NULL, 0, '2026-10-21 09:10:00.000'),
(3, 'pregunta', 7, 13, 1, 'llama3.2:1b', 'Genera una pregunta de opción múltiple del tema indicado con 4 opciones, una correcta, explicación y dificultad. Responde en JSON.', '{"enunciado": "¿Qué rama del Derecho regula la relación entre trabajadores y patronos?", "opciones": 4, "correcta": "A"}', 'exitosa', 6916, NULL, 0, '2026-10-22 09:15:00.000'),
(4, 'pregunta', 6, 18, 1, 'llama3.2:1b', 'Genera una pregunta de opción múltiple del tema indicado con 4 opciones, una correcta, explicación y dificultad. Responde en JSON.', '{"enunciado": "¿Qué es la capacidad jurídica de una persona?", "opciones": 4, "correcta": "A"}', 'exitosa', 6992, NULL, 0, '2026-10-22 09:20:00.000'),
(5, 'pregunta', 11, 24, 1, 'llama3.2:1b', 'Genera una pregunta de opción múltiple del tema indicado con 4 opciones, una correcta, explicación y dificultad. Responde en JSON.', '{"enunciado": "Según Piaget, ¿en qué etapa el bebé entiende que un objeto sigue existiendo aunque no lo vea?", "opciones": 4, "correcta": "D"}', 'exitosa', 8101, NULL, 0, '2026-10-23 09:25:00.000'),
(6, 'pregunta', 12, 28, 1, 'llama3.2:1b', 'Genera una pregunta de opción múltiple del tema indicado con 4 opciones, una correcta, explicación y dificultad. Responde en JSON.', '{"enunciado": "¿Qué es la disonancia cognitiva?", "opciones": 4, "correcta": "B"}', 'exitosa', 3640, NULL, 0, '2026-10-23 09:30:00.000'),
(7, 'pregunta', 15, 34, 1, 'llama3.2:1b', 'Genera una pregunta de opción múltiple del tema indicado con 4 opciones, una correcta, explicación y dificultad. Responde en JSON.', '{"enunciado": "¿Cómo se llaman las tres terminales de un transistor bipolar (BJT)?", "opciones": 4, "correcta": "D"}', 'exitosa', 4629, NULL, 0, '2026-10-24 09:35:00.000'),
(8, 'pregunta', 18, 39, 1, 'llama3.2:1b', 'Genera una pregunta de opción múltiple del tema indicado con 4 opciones, una correcta, explicación y dificultad. Responde en JSON.', '{"enunciado": "¿Qué significan las letras de un controlador PID?", "opciones": 4, "correcta": "B"}', 'exitosa', 7723, NULL, 0, '2026-10-24 09:40:00.000'),
(9, 'pista', 10, 21, 1, 'llama3.2:1b', 'Escribe una pista corta para la pregunta indicada sin decir la respuesta.', '{"texto": "respuesta del modelo"}', 'exitosa', 1900, NULL, 0, '2026-10-26 10:00:00.000'),
(10, 'explicacion', 15, 33, 1, 'llama3.2:1b', 'Escribe una explicacion corta para la pregunta indicada sin decir la respuesta.', '{"texto": "respuesta del modelo"}', 'exitosa', 3400, NULL, 0, '2026-10-26 10:05:00.000'),
(11, 'pregunta', 3, NULL, 1, 'llama3.2:1b', 'Genera una pregunta de opción múltiple del tema indicado con 4 opciones. Responde en JSON.', NULL, 'tiempo_agotado', 15000, 'Ollama no respondió en 15 segundos', 1, '2026-10-27 11:00:00.000'),
(12, 'pregunta', 3, NULL, 1, 'llama3.2:1b', 'Genera una pregunta de opción múltiple del tema indicado con 4 opciones. Responde en JSON.', '{"texto": "respuesta del modelo"}', 'formato_invalido', 7200, 'Llegaron 3 opciones en vez de 4', 1, '2026-10-27 11:02:00.000'),
(13, 'pista', 13, 30, 6, 'llama3.2:1b', 'Escribe una pista corta para la pregunta indicada sin decir la respuesta.', NULL, 'error', NULL, 'No se pudo conectar con el servidor de Ollama', 1, '2026-11-07 09:30:04.000');

INSERT INTO retos_diarios (id_reto, fecha, creado_por, creado_en) VALUES
(1, '2026-11-06', 1, '2026-11-05 22:00:00'),
(2, '2026-11-07', 1, '2026-11-06 22:00:00');
INSERT INTO reto_diario_preguntas (id_reto, orden, id_pregunta) VALUES
(1, 1, 3),
(1, 2, 14),
(1, 3, 25),
(1, 4, 36),
(1, 5, 7),
(2, 1, 12),
(2, 2, 22),
(2, 3, 33),
(2, 4, 5),
(2, 5, 18);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (1, 3, 1, 1, NULL, '2026-10-28 19:15:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (1, 1, 1, '2026-10-28 19:15:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (1, 1, 1, 2, '2026-10-28 19:15:04.518');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (1, 2, 2, '2026-10-28 19:15:06.018');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (1, 2, 2, 7, '2026-10-28 19:15:09.598');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (1, 3, 3, '2026-10-28 19:15:11.098');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (1, 3, 3, 9, '2026-10-28 19:15:17.379');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (1, 4, 4, '2026-10-28 19:15:18.879');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (1, 4, 4, 16, '2026-10-28 19:15:25.013');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (1, 5, 6, '2026-10-28 19:15:26.513');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (1, 5, 6, 23, '2026-10-28 19:15:30.641');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (1, 6, 5, '2026-10-28 19:15:32.141');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (1, 6, 5, 18, '2026-10-28 19:15:40.155');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (1, 7, 8, '2026-10-28 19:15:41.655');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (1, 7, 3, '2026-10-28 19:15:44.087');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (1, 7, 8, 29, '2026-10-28 19:15:47.737');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (1, 8, 7, '2026-10-28 19:15:49.237');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (1, 8, 7, 28, '2026-10-28 19:15:53.552');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (1, 9, 9, '2026-10-28 19:15:55.052');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (1, 9, 9, 34, '2026-10-28 19:16:01.989');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (1, 10, 10, '2026-10-28 19:16:03.489');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (1, 10, 10, 39, '2026-10-28 19:16:13.473');
CALL sp_terminar_partida(1);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (2, 3, 2, 1, NULL, '2026-10-29 19:30:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (2, 1, 19, '2026-10-29 19:30:01.000');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (2, 1, 3, '2026-10-29 19:30:04.876');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (2, 1, 19, 75, '2026-10-29 19:30:10.690');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (2, 2, 17, '2026-10-29 19:30:12.190');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (2, 2, 17, 68, '2026-10-29 19:30:22.196');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (2, 3, 12, '2026-10-29 19:30:23.696');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (2, 3, 12, 48, '2026-10-29 19:30:31.884');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (2, 4, 20, '2026-10-29 19:30:33.384');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (2, 4, 20, 80, '2026-10-29 19:30:40.236');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (2, 5, 18, '2026-10-29 19:30:41.736');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (2, 5, 18, NULL, '2026-10-29 19:31:02.736');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (2, 6, 15, '2026-10-29 19:31:03.236');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (2, 6, 15, 59, '2026-10-29 19:31:09.944');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (2, 7, 16, '2026-10-29 19:31:11.444');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (2, 7, 16, 62, '2026-10-29 19:31:19.793');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (2, 8, 11, '2026-10-29 19:31:21.293');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (2, 8, 2, '2026-10-29 19:31:23.909');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (2, 8, 11, 41, '2026-10-29 19:31:27.833');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (2, 9, 13, '2026-10-29 19:31:29.333');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (2, 9, 13, 49, '2026-10-29 19:31:35.902');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (2, 10, 14, '2026-10-29 19:31:37.402');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (2, 10, 14, 55, '2026-10-29 19:31:47.356');
CALL sp_terminar_partida(2);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (3, 3, 3, 1, NULL, '2026-10-30 19:00:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (3, 1, 27, '2026-10-30 19:00:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (3, 1, 27, 105, '2026-10-30 19:00:05.145');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (3, 2, 29, '2026-10-30 19:00:06.645');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (3, 2, 3, '2026-10-30 19:00:09.753');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (3, 2, 2, '2026-10-30 19:00:09.753');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (3, 2, 29, 115, '2026-10-30 19:00:14.416');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (3, 3, 26, '2026-10-30 19:00:15.916');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (3, 3, 26, 103, '2026-10-30 19:00:23.864');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (3, 4, 24, '2026-10-30 19:00:25.364');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (3, 4, 24, 96, '2026-10-30 19:00:34.251');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (3, 5, 30, '2026-10-30 19:00:35.751');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (3, 5, 30, 119, '2026-10-30 19:00:40.195');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (3, 6, 21, '2026-10-30 19:00:41.695');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (3, 6, 21, 84, '2026-10-30 19:00:48.728');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (3, 7, 23, '2026-10-30 19:00:50.228');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (3, 7, 23, 91, '2026-10-30 19:00:55.870');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (3, 8, 28, '2026-10-30 19:00:57.370');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (3, 8, 1, '2026-10-30 19:01:00.370');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (3, 8, 28, NULL, '2026-10-30 19:01:18.370');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (3, 9, 25, '2026-10-30 19:01:18.870');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (3, 9, 25, 97, '2026-10-30 19:01:24.799');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (3, 10, 22, '2026-10-30 19:01:26.299');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (3, 10, 22, 86, '2026-10-30 19:01:29.980');
CALL sp_terminar_partida(3);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (4, 3, 4, 1, NULL, '2026-10-31 19:27:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (4, 1, 40, '2026-10-31 19:27:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (4, 1, 40, 160, '2026-10-31 19:27:08.863');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (4, 2, 33, '2026-10-31 19:27:10.363');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (4, 2, 33, NULL, '2026-10-31 19:27:31.363');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (4, 3, 37, '2026-10-31 19:27:31.863');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (4, 3, 3, '2026-10-31 19:27:35.078');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (4, 3, 37, 147, '2026-10-31 19:27:39.901');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (4, 4, 32, '2026-10-31 19:27:41.401');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (4, 4, 3, '2026-10-31 19:27:44.791');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (4, 4, 32, 125, '2026-10-31 19:27:49.878');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (4, 5, 39, '2026-10-31 19:27:51.378');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (4, 5, 39, 154, '2026-10-31 19:27:56.001');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (4, 6, 34, '2026-10-31 19:27:57.501');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (4, 6, 34, 136, '2026-10-31 19:28:03.900');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (4, 7, 31, '2026-10-31 19:28:05.400');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (4, 7, 31, 122, '2026-10-31 19:28:10.744');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (4, 8, 36, '2026-10-31 19:28:12.244');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (4, 8, 36, 143, '2026-10-31 19:28:19.018');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (4, 9, 38, '2026-10-31 19:28:20.518');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (4, 9, 38, 149, '2026-10-31 19:28:29.594');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (4, 10, 35, '2026-10-31 19:28:31.094');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (4, 10, 35, 138, '2026-10-31 19:28:36.213');
CALL sp_terminar_partida(4);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (5, 3, 1, 1, NULL, '2026-11-01 19:07:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (5, 1, 5, '2026-11-01 19:07:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (5, 1, 5, 18, '2026-11-01 19:07:08.845');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (5, 2, 10, '2026-11-01 19:07:10.345');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (5, 2, 10, 39, '2026-11-01 19:07:17.834');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (5, 3, 4, '2026-11-01 19:07:19.334');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (5, 3, 4, 16, '2026-11-01 19:07:28.305');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (5, 4, 6, '2026-11-01 19:07:29.805');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (5, 4, 6, 23, '2026-11-01 19:07:33.728');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (5, 5, 2, '2026-11-01 19:07:35.228');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (5, 5, 2, 7, '2026-11-01 19:07:39.472');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (5, 6, 8, '2026-11-01 19:07:40.972');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (5, 6, 8, 29, '2026-11-01 19:07:50.995');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (5, 7, 1, '2026-11-01 19:07:52.495');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (5, 7, 1, 1, '2026-11-01 19:08:02.060');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (5, 8, 3, '2026-11-01 19:08:03.560');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (5, 8, 3, '2026-11-01 19:08:06.560');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (5, 8, 3, NULL, '2026-11-01 19:08:24.560');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (5, 9, 9, '2026-11-01 19:08:25.060');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (5, 9, 9, 34, '2026-11-01 19:08:34.562');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (5, 10, 7, '2026-11-01 19:08:36.062');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (5, 10, 7, NULL, '2026-11-01 19:08:57.062');
CALL sp_terminar_partida(5);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (6, 4, 1, 1, NULL, '2026-10-28 20:22:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (6, 1, 9, '2026-10-28 20:22:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (6, 1, 9, 34, '2026-10-28 20:22:05.519');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (6, 2, 4, '2026-10-28 20:22:07.019');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (6, 2, 4, 14, '2026-10-28 20:22:13.994');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (6, 3, 2, '2026-10-28 20:22:15.494');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (6, 3, 2, 7, '2026-10-28 20:22:26.405');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (6, 4, 5, '2026-10-28 20:22:27.905');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (6, 4, 5, 18, '2026-10-28 20:22:34.987');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (6, 5, 3, '2026-10-28 20:22:36.487');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (6, 5, 3, '2026-10-28 20:22:40.315');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (6, 5, 3, 11, '2026-10-28 20:22:46.058');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (6, 6, 1, '2026-10-28 20:22:47.558');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (6, 6, 1, 2, '2026-10-28 20:22:51.817');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (6, 7, 6, '2026-10-28 20:22:53.317');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (6, 7, 6, 23, '2026-10-28 20:22:59.471');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (6, 8, 7, '2026-10-28 20:23:00.971');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (6, 8, 7, 28, '2026-10-28 20:23:09.857');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (6, 9, 8, '2026-10-28 20:23:11.357');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (6, 9, 2, '2026-10-28 20:23:14.385');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (6, 9, 3, '2026-10-28 20:23:14.385');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (6, 9, 8, 29, '2026-10-28 20:23:18.929');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (6, 10, 10, '2026-10-28 20:23:20.429');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (6, 10, 10, 39, '2026-10-28 20:23:33.055');
CALL sp_terminar_partida(6);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (7, 4, 2, 1, NULL, '2026-10-29 20:03:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (7, 1, 18, '2026-10-29 20:03:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (7, 1, 18, NULL, '2026-10-29 20:03:22.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (7, 2, 20, '2026-10-29 20:03:22.500');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (7, 2, 20, 78, '2026-10-29 20:03:35.232');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (7, 3, 14, '2026-10-29 20:03:36.732');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (7, 3, 14, 55, '2026-10-29 20:03:47.097');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (7, 4, 17, '2026-10-29 20:03:48.597');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (7, 4, 17, 68, '2026-10-29 20:03:55.079');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (7, 5, 19, '2026-10-29 20:03:56.579');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (7, 5, 19, 75, '2026-10-29 20:04:04.697');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (7, 6, 15, '2026-10-29 20:04:06.197');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (7, 6, 15, 57, '2026-10-29 20:04:13.007');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (7, 7, 16, '2026-10-29 20:04:14.507');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (7, 7, 16, 62, '2026-10-29 20:04:18.555');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (7, 8, 11, '2026-10-29 20:04:20.055');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (7, 8, 3, '2026-10-29 20:04:23.055');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (7, 8, 11, NULL, '2026-10-29 20:04:41.055');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (7, 9, 13, '2026-10-29 20:04:41.555');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (7, 9, 13, 49, '2026-10-29 20:04:46.797');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (7, 10, 12, '2026-10-29 20:04:48.297');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (7, 10, 12, 48, '2026-10-29 20:04:54.251');
CALL sp_terminar_partida(7);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (8, 4, 3, 1, NULL, '2026-10-30 20:21:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (8, 1, 29, '2026-10-30 20:21:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (8, 1, 29, 115, '2026-10-30 20:21:09.927');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (8, 2, 24, '2026-10-30 20:21:11.427');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (8, 2, 24, 96, '2026-10-30 20:21:17.135');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (8, 3, 28, '2026-10-30 20:21:18.635');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (8, 3, 28, 110, '2026-10-30 20:21:23.841');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (8, 4, 22, '2026-10-30 20:21:25.341');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (8, 4, 22, 86, '2026-10-30 20:21:36.967');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (8, 5, 26, '2026-10-30 20:21:38.467');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (8, 5, 26, 103, '2026-10-30 20:21:49.418');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (8, 6, 21, '2026-10-30 20:21:50.918');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (8, 6, 21, NULL, '2026-10-30 20:22:11.918');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (8, 7, 25, '2026-10-30 20:22:12.418');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (8, 7, 25, 97, '2026-10-30 20:22:16.674');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (8, 8, 23, '2026-10-30 20:22:18.174');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (8, 8, 3, '2026-10-30 20:22:22.534');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (8, 8, 23, 91, '2026-10-30 20:22:29.075');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (8, 9, 30, '2026-10-30 20:22:30.575');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (8, 9, 30, 120, '2026-10-30 20:22:40.065');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (8, 10, 27, '2026-10-30 20:22:41.565');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (8, 10, 27, 105, '2026-10-30 20:22:53.431');
CALL sp_terminar_partida(8);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (9, 4, 4, 1, NULL, '2026-10-31 20:37:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (9, 1, 39, '2026-10-31 20:37:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (9, 1, 39, 154, '2026-10-31 20:37:08.106');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (9, 2, 33, '2026-10-31 20:37:09.606');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (9, 2, 33, 129, '2026-10-31 20:37:20.608');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (9, 3, 37, '2026-10-31 20:37:22.108');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (9, 3, 37, 148, '2026-10-31 20:37:30.001');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (9, 4, 40, '2026-10-31 20:37:31.501');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (9, 4, 1, '2026-10-31 20:37:36.187');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (9, 4, 40, 158, '2026-10-31 20:37:43.216');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (9, 5, 35, '2026-10-31 20:37:44.716');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (9, 5, 35, 138, '2026-10-31 20:37:55.545');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (9, 6, 31, '2026-10-31 20:37:57.045');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (9, 6, 31, 122, '2026-10-31 20:38:02.961');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (9, 7, 34, '2026-10-31 20:38:04.461');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (9, 7, 2, '2026-10-31 20:38:07.613');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (9, 7, 34, 136, '2026-10-31 20:38:12.343');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (9, 8, 38, '2026-10-31 20:38:13.843');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (9, 8, 38, 149, '2026-10-31 20:38:22.749');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (9, 9, 36, '2026-10-31 20:38:24.249');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (9, 9, 36, 143, '2026-10-31 20:38:35.201');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (9, 10, 32, '2026-10-31 20:38:36.701');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (9, 10, 32, 127, '2026-10-31 20:38:44.296');
CALL sp_terminar_partida(9);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (10, 5, 1, 1, NULL, '2026-10-29 21:00:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (10, 1, 5, '2026-10-29 21:00:01.000');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (10, 1, 3, '2026-10-29 21:00:04.175');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (10, 1, 5, 18, '2026-10-29 21:00:08.938');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (10, 2, 7, '2026-10-29 21:00:10.438');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (10, 2, 7, 28, '2026-10-29 21:00:23.998');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (10, 3, 10, '2026-10-29 21:00:25.498');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (10, 3, 2, '2026-10-29 21:00:27.662');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (10, 3, 10, 39, '2026-10-29 21:00:30.910');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (10, 4, 1, '2026-10-29 21:00:32.410');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (10, 4, 1, 2, '2026-10-29 21:00:45.987');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (10, 5, 6, '2026-10-29 21:00:47.487');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (10, 5, 6, 21, '2026-10-29 21:00:56.551');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (10, 6, 3, '2026-10-29 21:00:58.051');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (10, 6, 3, 9, '2026-10-29 21:01:04.765');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (10, 7, 9, '2026-10-29 21:01:06.265');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (10, 7, 2, '2026-10-29 21:01:11.227');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (10, 7, 9, 34, '2026-10-29 21:01:18.670');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (10, 8, 4, '2026-10-29 21:01:20.170');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (10, 8, 4, 16, '2026-10-29 21:01:32.663');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (10, 9, 8, '2026-10-29 21:01:34.163');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (10, 9, 8, 29, '2026-10-29 21:01:42.143');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (10, 10, 2, '2026-10-29 21:01:43.643');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (10, 10, 2, 6, '2026-10-29 21:01:56.720');
CALL sp_terminar_partida(10);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (11, 5, 2, 1, NULL, '2026-10-30 21:16:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (11, 1, 11, '2026-10-30 21:16:01.000');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (11, 1, 2, '2026-10-30 21:16:03.161');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (11, 1, 11, 43, '2026-10-30 21:16:06.404');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (11, 2, 18, '2026-10-30 21:16:07.904');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (11, 2, 18, 69, '2026-10-30 21:16:15.090');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (11, 3, 12, '2026-10-30 21:16:16.590');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (11, 3, 12, 48, '2026-10-30 21:16:23.991');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (11, 4, 17, '2026-10-30 21:16:25.491');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (11, 4, 17, 66, '2026-10-30 21:16:38.434');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (11, 5, 14, '2026-10-30 21:16:39.934');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (11, 5, 14, 56, '2026-10-30 21:16:55.725');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (11, 6, 15, '2026-10-30 21:16:57.225');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (11, 6, 15, 57, '2026-10-30 21:17:05.801');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (11, 7, 13, '2026-10-30 21:17:07.301');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (11, 7, 3, '2026-10-30 21:17:13.651');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (11, 7, 13, 49, '2026-10-30 21:17:23.178');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (11, 8, 19, '2026-10-30 21:17:24.678');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (11, 8, 19, 75, '2026-10-30 21:17:33.889');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (11, 9, 20, '2026-10-30 21:17:35.389');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (11, 9, 20, 80, '2026-10-30 21:17:45.491');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (11, 10, 16, '2026-10-30 21:17:46.991');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (11, 10, 16, 63, '2026-10-30 21:17:57.641');
CALL sp_terminar_partida(11);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (12, 5, 3, 1, NULL, '2026-10-31 21:09:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (12, 1, 25, '2026-10-31 21:09:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (12, 1, 25, 97, '2026-10-31 21:09:07.444');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (12, 2, 27, '2026-10-31 21:09:08.944');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (12, 2, 27, NULL, '2026-10-31 21:09:29.944');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (12, 3, 21, '2026-10-31 21:09:30.444');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (12, 3, 21, 81, '2026-10-31 21:09:37.413');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (12, 4, 22, '2026-10-31 21:09:38.913');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (12, 4, 1, '2026-10-31 21:09:42.925');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (12, 4, 2, '2026-10-31 21:09:42.925');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (12, 4, 22, 86, '2026-10-31 21:09:48.943');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (12, 5, 24, '2026-10-31 21:09:50.443');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (12, 5, 1, '2026-10-31 21:09:54.597');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (12, 5, 24, 96, '2026-10-31 21:10:00.830');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (12, 6, 28, '2026-10-31 21:10:02.330');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (12, 6, 28, 110, '2026-10-31 21:10:17.098');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (12, 7, 30, '2026-10-31 21:10:18.598');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (12, 7, 30, 120, '2026-10-31 21:10:28.073');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (12, 8, 26, '2026-10-31 21:10:29.573');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (12, 8, 26, 103, '2026-10-31 21:10:40.164');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (12, 9, 29, '2026-10-31 21:10:41.664');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (12, 9, 29, 115, '2026-10-31 21:10:50.547');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (12, 10, 23, '2026-10-31 21:10:52.047');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (12, 10, 23, 91, '2026-10-31 21:11:06.033');
CALL sp_terminar_partida(12);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (13, 5, 4, 1, NULL, '2026-11-01 21:14:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (13, 1, 35, '2026-11-01 21:14:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (13, 1, 35, 138, '2026-11-01 21:14:13.278');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (13, 2, 33, '2026-11-01 21:14:14.778');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (13, 2, 33, 129, '2026-11-01 21:14:29.352');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (13, 3, 31, '2026-11-01 21:14:30.852');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (13, 3, 31, 124, '2026-11-01 21:14:38.153');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (13, 4, 38, '2026-11-01 21:14:39.653');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (13, 4, 38, 150, '2026-11-01 21:14:51.326');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (13, 5, 37, '2026-11-01 21:14:52.826');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (13, 5, 37, 147, '2026-11-01 21:15:06.143');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (13, 6, 36, '2026-11-01 21:15:07.643');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (13, 6, 36, 142, '2026-11-01 21:15:13.910');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (13, 7, 40, '2026-11-01 21:15:15.410');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (13, 7, 40, 158, '2026-11-01 21:15:20.746');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (13, 8, 32, '2026-11-01 21:15:22.246');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (13, 8, 2, '2026-11-01 21:15:25.509');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (13, 8, 32, 126, '2026-11-01 21:15:30.404');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (13, 9, 34, '2026-11-01 21:15:31.904');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (13, 9, 2, '2026-11-01 21:15:38.236');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (13, 9, 3, '2026-11-01 21:15:38.236');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (13, 9, 34, 136, '2026-11-01 21:15:47.736');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (13, 10, 39, '2026-11-01 21:15:49.236');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (13, 10, 39, 154, '2026-11-01 21:16:01.199');
CALL sp_terminar_partida(13);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (14, 6, 1, 1, NULL, '2026-10-30 22:17:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (14, 1, 3, '2026-10-30 22:17:01.000');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (14, 1, 2, '2026-10-30 22:17:05.105');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (14, 1, 3, 9, '2026-10-30 22:17:11.264');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (14, 2, 7, '2026-10-30 22:17:12.764');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (14, 2, 7, 28, '2026-10-30 22:17:24.013');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (14, 3, 2, '2026-10-30 22:17:25.513');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (14, 3, 2, NULL, '2026-10-30 22:17:46.513');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (14, 4, 8, '2026-10-30 22:17:47.013');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (14, 4, 8, 29, '2026-10-30 22:17:55.170');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (14, 5, 4, '2026-10-30 22:17:56.670');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (14, 5, 1, '2026-10-30 22:18:03.746');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (14, 5, 4, 14, '2026-10-30 22:18:14.361');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (14, 6, 1, '2026-10-30 22:18:15.861');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (14, 6, 1, 2, '2026-10-30 22:18:30.751');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (14, 7, 10, '2026-10-30 22:18:32.251');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (14, 7, 10, 39, '2026-10-30 22:18:49.114');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (14, 8, 5, '2026-10-30 22:18:50.614');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (14, 8, 5, 18, '2026-10-30 22:19:06.947');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (14, 9, 6, '2026-10-30 22:19:08.447');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (14, 9, 6, 23, '2026-10-30 22:19:20.271');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (14, 10, 9, '2026-10-30 22:19:21.771');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (14, 10, 9, NULL, '2026-10-30 22:19:42.771');
CALL sp_terminar_partida(14);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (15, 6, 4, 1, NULL, '2026-11-01 22:17:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (15, 1, 40, '2026-11-01 22:17:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (15, 1, 40, 160, '2026-11-01 22:17:16.437');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (15, 2, 34, '2026-11-01 22:17:17.937');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (15, 2, 34, 136, '2026-11-01 22:17:34.502');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (15, 3, 35, '2026-11-01 22:17:36.002');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (15, 3, 35, 138, '2026-11-01 22:17:51.866');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (15, 4, 36, '2026-11-01 22:17:53.366');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (15, 4, 36, 143, '2026-11-01 22:18:09.251');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (15, 5, 33, '2026-11-01 22:18:10.751');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (15, 5, 1, '2026-11-01 22:18:17.847');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (15, 5, 33, 129, '2026-11-01 22:18:28.492');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (15, 6, 32, '2026-11-01 22:18:29.992');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (15, 6, 1, '2026-11-01 22:18:36.805');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (15, 6, 32, 128, '2026-11-01 22:18:47.026');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (15, 7, 37, '2026-11-01 22:18:48.526');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (15, 7, 37, 147, '2026-11-01 22:19:04.360');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (15, 8, 38, '2026-11-01 22:19:05.860');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (15, 8, 38, 152, '2026-11-01 22:19:13.251');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (15, 9, 39, '2026-11-01 22:19:14.751');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (15, 9, 39, NULL, '2026-11-01 22:19:35.751');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (15, 10, 31, '2026-11-01 22:19:36.251');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (15, 10, 31, 122, '2026-11-01 22:19:45.341');
CALL sp_terminar_partida(15);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (16, 3, 5, 2, NULL, '2026-11-02 19:34:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (16, 1, 11, '2026-11-02 19:34:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (16, 1, 11, 42, '2026-11-02 19:34:05.673');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (16, 2, 5, '2026-11-02 19:34:07.173');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (16, 2, 5, 18, '2026-11-02 19:34:16.414');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (16, 3, 18, '2026-11-02 19:34:17.914');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (16, 3, 18, NULL, '2026-11-02 19:34:38.914');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (16, 4, 14, '2026-11-02 19:34:39.414');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (16, 4, 1, '2026-11-02 19:34:42.049');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (16, 4, 2, '2026-11-02 19:34:42.049');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (16, 4, 14, 55, '2026-11-02 19:34:46.002');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (16, 5, 1, '2026-11-02 19:34:47.502');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (16, 5, 1, 2, '2026-11-02 19:34:57.887');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (16, 6, 19, '2026-11-02 19:34:59.387');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (16, 6, 19, 75, '2026-11-02 19:35:03.407');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (16, 7, 3, '2026-11-02 19:35:04.907');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (16, 7, 3, 9, '2026-11-02 19:35:12.025');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (16, 8, 31, '2026-11-02 19:35:13.525');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (16, 8, 3, '2026-11-02 19:35:15.342');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (16, 8, 31, 122, '2026-11-02 19:35:18.068');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (16, 9, 17, '2026-11-02 19:35:19.568');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (16, 9, 17, 66, '2026-11-02 19:35:23.079');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (16, 10, 34, '2026-11-02 19:35:24.579');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (16, 10, 34, 136, '2026-11-02 19:35:32.484');
CALL sp_terminar_partida(16);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (17, 4, 5, 2, NULL, '2026-11-02 20:19:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (17, 1, 23, '2026-11-02 20:19:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (17, 1, 23, 91, '2026-11-02 20:19:10.352');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (17, 2, 6, '2026-11-02 20:19:11.852');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (17, 2, 1, '2026-11-02 20:19:14.852');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (17, 2, 6, NULL, '2026-11-02 20:19:32.852');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (17, 3, 38, '2026-11-02 20:19:33.352');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (17, 3, 38, 152, '2026-11-02 20:19:42.661');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (17, 4, 2, '2026-11-02 20:19:44.161');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (17, 4, 2, 7, '2026-11-02 20:19:56.752');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (17, 5, 17, '2026-11-02 20:19:58.252');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (17, 5, 1, '2026-11-02 20:19:59.866');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (17, 5, 17, 68, '2026-11-02 20:20:02.288');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (17, 6, 16, '2026-11-02 20:20:03.788');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (17, 6, 16, 62, '2026-11-02 20:20:10.447');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (17, 7, 8, '2026-11-02 20:20:11.947');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (17, 7, 8, 29, '2026-11-02 20:20:21.232');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (17, 8, 25, '2026-11-02 20:20:22.732');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (17, 8, 25, 97, '2026-11-02 20:20:27.346');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (17, 9, 35, '2026-11-02 20:20:28.846');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (17, 9, 35, 138, '2026-11-02 20:20:39.397');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (17, 10, 31, '2026-11-02 20:20:40.897');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (17, 10, 31, 122, '2026-11-02 20:20:48.591');
CALL sp_terminar_partida(17);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (18, 7, 5, 2, NULL, '2026-11-02 21:06:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (18, 1, 40, '2026-11-02 21:06:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (18, 1, 40, 160, '2026-11-02 21:06:08.069');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (18, 2, 36, '2026-11-02 21:06:09.569');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (18, 2, 36, 143, '2026-11-02 21:06:16.438');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (18, 3, 2, '2026-11-02 21:06:17.938');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (18, 3, 2, 7, '2026-11-02 21:06:26.340');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (18, 4, 14, '2026-11-02 21:06:27.840');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (18, 4, 14, 54, '2026-11-02 21:06:34.421');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (18, 5, 37, '2026-11-02 21:06:35.921');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (18, 5, 37, 147, '2026-11-02 21:06:42.450');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (18, 6, 19, '2026-11-02 21:06:43.950');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (18, 6, 1, '2026-11-02 21:06:47.300');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (18, 6, 19, 76, '2026-11-02 21:06:52.326');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (18, 7, 26, '2026-11-02 21:06:53.826');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (18, 7, 26, 104, '2026-11-02 21:07:01.863');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (18, 8, 15, '2026-11-02 21:07:03.363');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (18, 8, 15, 57, '2026-11-02 21:07:16.300');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (18, 9, 21, '2026-11-02 21:07:17.800');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (18, 9, 21, 81, '2026-11-02 21:07:30.010');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (18, 10, 6, '2026-11-02 21:07:31.510');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (18, 10, 6, 23, '2026-11-02 21:07:45.420');
CALL sp_terminar_partida(18);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (19, 3, 5, 3, 1, '2026-11-06 08:33:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (19, 1, 3, '2026-11-06 08:33:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (19, 1, 3, 9, '2026-11-06 08:33:07.505');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (19, 2, 14, '2026-11-06 08:33:09.005');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (19, 2, 14, 55, '2026-11-06 08:33:18.107');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (19, 3, 25, '2026-11-06 08:33:19.607');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (19, 3, 25, NULL, '2026-11-06 08:33:40.607');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (19, 4, 36, '2026-11-06 08:33:41.107');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (19, 4, 36, 143, '2026-11-06 08:33:48.931');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (19, 5, 7, '2026-11-06 08:33:50.431');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (19, 5, 1, '2026-11-06 08:33:53.431');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (19, 5, 2, '2026-11-06 08:33:53.431');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (19, 5, 7, NULL, '2026-11-06 08:34:11.431');
CALL sp_terminar_partida(19);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (20, 4, 5, 3, 1, '2026-11-06 10:38:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (20, 1, 3, '2026-11-06 10:38:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (20, 1, 3, 9, '2026-11-06 10:38:08.123');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (20, 2, 14, '2026-11-06 10:38:09.623');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (20, 2, 2, '2026-11-06 10:38:12.069');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (20, 2, 14, 55, '2026-11-06 10:38:15.738');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (20, 3, 25, '2026-11-06 10:38:17.238');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (20, 3, 25, 98, '2026-11-06 10:38:25.386');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (20, 4, 36, '2026-11-06 10:38:26.886');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (20, 4, 36, 143, '2026-11-06 10:38:38.754');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (20, 5, 7, '2026-11-06 10:38:40.254');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (20, 5, 1, '2026-11-06 10:38:42.302');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (20, 5, 7, 27, '2026-11-06 10:38:45.376');
CALL sp_terminar_partida(20);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (21, 7, 5, 3, 1, '2026-11-06 13:50:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (21, 1, 3, '2026-11-06 13:50:01.000');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (21, 1, 2, '2026-11-06 13:50:06.533');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (21, 1, 3, '2026-11-06 13:50:06.533');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (21, 1, 3, 10, '2026-11-06 13:50:14.834');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (21, 2, 14, '2026-11-06 13:50:16.334');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (21, 2, 14, 55, '2026-11-06 13:50:25.310');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (21, 3, 25, '2026-11-06 13:50:26.810');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (21, 3, 25, 97, '2026-11-06 13:50:40.789');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (21, 4, 36, '2026-11-06 13:50:42.289');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (21, 4, 36, 143, '2026-11-06 13:50:53.705');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (21, 5, 7, '2026-11-06 13:50:55.205');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (21, 5, 7, 26, '2026-11-06 13:51:01.725');
CALL sp_terminar_partida(21);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (22, 8, 5, 3, 1, '2026-11-06 17:49:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (22, 1, 3, '2026-11-06 17:49:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (22, 1, 3, 9, '2026-11-06 17:49:15.817');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (22, 2, 14, '2026-11-06 17:49:17.317');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (22, 2, 14, 55, '2026-11-06 17:49:31.594');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (22, 3, 25, '2026-11-06 17:49:33.094');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (22, 3, 25, 99, '2026-11-06 17:49:45.890');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (22, 4, 36, '2026-11-06 17:49:47.390');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (22, 4, 36, 143, '2026-11-06 17:49:55.963');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (22, 5, 7, '2026-11-06 17:49:57.463');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (22, 5, 7, 28, '2026-11-06 17:50:06.247');
CALL sp_terminar_partida(22);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (23, 8, 3, 4, NULL, '2026-11-06 20:15:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (23, 1, 23, '2026-11-06 20:15:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (23, 1, 23, 91, '2026-11-06 20:15:15.962');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (23, 2, 22, '2026-11-06 20:15:17.462');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (23, 2, 22, 86, '2026-11-06 20:15:30.133');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (23, 3, 21, '2026-11-06 20:15:31.633');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (23, 3, 21, 81, '2026-11-06 20:15:45.302');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (23, 4, 28, '2026-11-06 20:15:46.802');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (23, 4, 28, 112, '2026-11-06 20:15:56.503');
CALL sp_terminar_partida(23);

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (24, 7, 2, 1, NULL, '2026-11-06 21:00:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (24, 1, 11, '2026-11-06 21:00:01.000');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (24, 1, 11, 42, '2026-11-06 21:00:09.224');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (24, 2, 20, '2026-11-06 21:00:10.724');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (24, 2, 20, 80, '2026-11-06 21:00:17.984');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (24, 3, 15, '2026-11-06 21:00:19.484');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (24, 3, 15, 58, '2026-11-06 21:00:29.913');
UPDATE partidas SET estado = 'abandonada', terminada_en = '2026-11-06 21:01:01.413' WHERE id_partida = 24;

INSERT INTO partidas (id_partida, id_usuario, id_categoria, id_modo, id_reto, iniciada_en) VALUES (25, 6, 3, 1, NULL, '2026-11-07 09:30:00.000');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (25, 1, 30, '2026-11-07 09:30:01.000');
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista, usada_en) VALUES (25, 1, 3, '2026-11-07 09:30:04.760');
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion, respondida_en) VALUES (25, 1, 30, 120, '2026-11-07 09:30:10.401');
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta, mostrada_en) VALUES (25, 2, 29, '2026-11-07 09:30:11.901');

INSERT INTO reportes_pregunta (id_pregunta, id_usuario, id_partida, motivo, detalle, estado, atendido_por, creado_en, atendido_en) VALUES
(17, 5, 11, 'desactualizada', 'La explicación habla de cuándo se aprobó, pero la pregunta dice cuándo entró en vigencia', 'atendido', 2, '2026-10-30 21:00:00', '2026-10-31 09:00:00'),
(2, 6, 14, 'texto_confuso', 'No se entiende por qué las opciones llevan comillas', 'abierto', NULL, '2026-10-30 22:10:00', NULL);

UPDATE configuracion_juego SET valor = 20, actualizado_por = 1 WHERE clave = 'segundos_espera_ia';

INSERT INTO auditoria (id_usuario, tipo, accion, tabla, id_registro, detalle, ip, creado_en) VALUES
(1, 'acceso', 'inicio_sesion', 'sesiones', '1', 'Entró el administrador', '192.168.56.1', '2026-11-07 08:55:00.000'),
(NULL, 'acceso', 'inicio_sesion_fallido', NULL, NULL, 'Contraseña incorrecta para el correo bloqueada@correo.test', '192.168.56.1', '2026-11-07 08:58:00.000'),
(6, 'error', 'error_api', 'solicitudes_ia', '13', 'POST /api/partidas/25/pistas: no se pudo conectar con Ollama, se usó la pista guardada', '192.168.56.1', '2026-11-07 09:30:04.000');

