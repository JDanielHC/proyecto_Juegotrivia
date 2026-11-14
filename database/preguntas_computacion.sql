USE retotrivia_uth;

SET @autor = (SELECT u.id_usuario FROM usuarios u JOIN roles r ON r.id_rol = u.id_rol
              WHERE r.codigo = 'admin' ORDER BY u.id_usuario LIMIT 1);
SET @revisor = (SELECT u.id_usuario FROM usuarios u JOIN roles r ON r.id_rol = u.id_rol
                WHERE r.codigo IN ('revisor', 'admin') ORDER BY r.codigo = 'revisor' DESC, u.id_usuario LIMIT 1);
SET @carrera = (SELECT id_categoria FROM categorias WHERE codigo = 'computacion');

INSERT INTO temas (id_categoria, nombre) SELECT @carrera, 'Algoritmos' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM temas WHERE id_categoria = @carrera AND nombre = 'Algoritmos');
INSERT INTO temas (id_categoria, nombre) SELECT @carrera, 'Bases de datos' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM temas WHERE id_categoria = @carrera AND nombre = 'Bases de datos');
INSERT INTO temas (id_categoria, nombre) SELECT @carrera, 'Estructura de datos' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM temas WHERE id_categoria = @carrera AND nombre = 'Estructura de datos');
INSERT INTO temas (id_categoria, nombre) SELECT @carrera, 'Honduras' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM temas WHERE id_categoria = @carrera AND nombre = 'Honduras');
INSERT INTO temas (id_categoria, nombre) SELECT @carrera, 'Ingeniería de software' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM temas WHERE id_categoria = @carrera AND nombre = 'Ingeniería de software');
INSERT INTO temas (id_categoria, nombre) SELECT @carrera, 'Perfil profesional' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM temas WHERE id_categoria = @carrera AND nombre = 'Perfil profesional');
INSERT INTO temas (id_categoria, nombre) SELECT @carrera, 'Plan de estudio' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM temas WHERE id_categoria = @carrera AND nombre = 'Plan de estudio');
INSERT INTO temas (id_categoria, nombre) SELECT @carrera, 'Redes' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM temas WHERE id_categoria = @carrera AND nombre = 'Redes');
INSERT INTO temas (id_categoria, nombre) SELECT @carrera, 'Sistemas operativos' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM temas WHERE id_categoria = @carrera AND nombre = 'Sistemas operativos');

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Perfil profesional');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Cuál de estos es un campo de trabajo del Ingeniero en Computación según la UTH?',
  'El perfil de la UTH incluye administrador de base de datos, administrador de redes, programador de sistemas y consultor de TIC, entre otros.',
  'Piensa en quién cuida y organiza la información que guardan los sistemas.',
  'Otro campo de trabajo de la lista es administrador de redes.',
  'facil', 'manual', 'Perfil UTH (uth.hn, nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuál de estos es un campo de trabajo del Ingeniero en Computación según la UTH?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuál de estos es un campo de trabajo del Ingeniero en Computación según la UTH?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Técnico en redes eléctricas residenciales' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'Administrador de base de datos', 1
  UNION ALL SELECT 'C', 'Gerente de producción de maquila', 0
  UNION ALL SELECT 'D', 'Diseñador gráfico publicitario', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Perfil profesional');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Qué habilidad desarrolla el ingeniero al finalizar la carrera, según la UTH?',
  'Entre las habilidades de la UTH está evaluar si un proyecto de informática es factible, además de trabajar en equipos multidisciplinarios.',
  'Es algo que se hace antes de empezar un proyecto, para saber si conviene.',
  'La habilidad habla de proyectos de informática.',
  'media', 'manual', 'Perfil UTH (uth.hn, nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué habilidad desarrolla el ingeniero al finalizar la carrera, según la UTH?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué habilidad desarrolla el ingeniero al finalizar la carrera, según la UTH?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Diseñar circuitos integrados para teléfonos' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'Certificar la legalidad de contratos tecnológicos', 0
  UNION ALL SELECT 'C', 'Administrar la contabilidad de empresas de software', 0
  UNION ALL SELECT 'D', 'Evaluar la factibilidad de proyectos de informática', 1
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Perfil profesional');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Cuál de estas es una destreza del Ingeniero en Computación según la UTH?',
  'La UTH incluye entre las destrezas modelar, simular, implementar y optimizar sistemas complejos, además de planificar y analizar sistemas.',
  'Se trata de trabajar con sistemas grandes y mejorarlos.',
  'Tiene cuatro verbos seguidos.',
  'media', 'manual', 'Perfil UTH (uth.hn, nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuál de estas es una destreza del Ingeniero en Computación según la UTH?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuál de estas es una destreza del Ingeniero en Computación según la UTH?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Modelar, simular, implementar y optimizar sistemas complejos' AS texto, 1 AS correcta
  UNION ALL SELECT 'B', 'Ensamblar y reparar equipos de cómputo como única función', 0
  UNION ALL SELECT 'C', 'Redactar manuales de usuario para todo tipo de producto', 0
  UNION ALL SELECT 'D', 'Vender licencias de software a las empresas', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Perfil profesional');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, 'Una destreza del ingeniero es desarrollar estrategias basadas en TIC. ¿Para qué sirven, según la UTH?',
  'Las estrategias basadas en TIC buscan que las empresas logren ventajas competitivas.',
  'Es algo que busca una empresa frente a las demás.',
  'TIC significa tecnologías de información y comunicación.',
  'media', 'manual', 'Perfil UTH (uth.hn, nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = 'Una destreza del ingeniero es desarrollar estrategias basadas en TIC. ¿Para qué sirven, según la UTH?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = 'Una destreza del ingeniero es desarrollar estrategias basadas en TIC. ¿Para qué sirven, según la UTH?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Para que las empresas paguen menos impuestos' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'Para que las empresas cumplan las normas de telecomunicaciones', 0
  UNION ALL SELECT 'C', 'Para que las empresas logren ventajas competitivas', 1
  UNION ALL SELECT 'D', 'Para que las empresas dependan menos de su personal', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Perfil profesional');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Qué tipo de software dice la UTH que desarrollará el ingeniero según sus competencias?',
  'La competencia indica que desarrollará software de sistemas paralelos, concurrentes y distribuidos con un alto grado de dificultad técnica.',
  'Son sistemas donde varias cosas pasan al mismo tiempo, en varias máquinas.',
  'La competencia habla de un alto grado de dificultad técnica.',
  'dificil', 'manual', 'Perfil UTH (uth.hn, nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué tipo de software dice la UTH que desarrollará el ingeniero según sus competencias?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué tipo de software dice la UTH que desarrollará el ingeniero según sus competencias?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Sistemas operativos para teléfonos móviles' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'Software contable para pequeños negocios', 0
  UNION ALL SELECT 'C', 'Sistemas de reservas para hoteles', 0
  UNION ALL SELECT 'D', 'Software de sistemas paralelos, concurrentes y distribuidos', 1
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Plan de estudio');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Cuántos períodos tiene el plan de estudio de Ingeniería en Computación de la UTH?',
  'El plan va del período I al XII, y el XII es la Práctica Profesional Supervisada.',
  'Cuenta también el período de la práctica profesional.',
  'El último período es la Práctica Profesional Supervisada.',
  'facil', 'manual', 'Plan de estudio UTH (nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuántos períodos tiene el plan de estudio de Ingeniería en Computación de la UTH?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuántos períodos tiene el plan de estudio de Ingeniería en Computación de la UTH?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, '8' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', '12', 1
  UNION ALL SELECT 'C', '10', 0
  UNION ALL SELECT 'D', '14', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Plan de estudio');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿En qué período del plan se estudia Inteligencia Artificial?',
  'Inteligencia Artificial está en el período X, igual que Internet de las Cosas (IoT) y Programación para Sistemas Abiertos I.',
  'Está casi al final de la carrera, junto con Internet de las Cosas.',
  'En ese período también se cursa Programación para Sistemas Abiertos I.',
  'media', 'manual', 'Plan de estudio UTH (nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿En qué período del plan se estudia Inteligencia Artificial?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿En qué período del plan se estudia Inteligencia Artificial?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Período X' AS texto, 1 AS correcta
  UNION ALL SELECT 'B', 'Período VIII', 0
  UNION ALL SELECT 'C', 'Período IX', 0
  UNION ALL SELECT 'D', 'Período XI', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Plan de estudio');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Cuántas horas dura cada Pasantía Profesional Supervisada del plan (I y II)?',
  'Cada pasantía dura 80 horas. Las 160 horas son las dos juntas.',
  'Es una cantidad que se repite en las dos pasantías.',
  'Se cursan al terminar Ingeniería de Software II y Redes IV.',
  'media', 'manual', 'Plan de estudio UTH (nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuántas horas dura cada Pasantía Profesional Supervisada del plan (I y II)?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuántas horas dura cada Pasantía Profesional Supervisada del plan (I y II)?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, '40 horas' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', '120 horas', 0
  UNION ALL SELECT 'C', '80 horas', 1
  UNION ALL SELECT 'D', '160 horas', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Plan de estudio');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Cuántas asignaturas de Redes tiene el plan de estudio?',
  'El plan tiene Redes I, II, III y IV, es decir 4 asignaturas de Redes.',
  'Se numeran con números romanos, empezando en Redes I.',
  'Redes I está en el período VI y Redes IV en el IX.',
  'facil', 'manual', 'Plan de estudio UTH (nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuántas asignaturas de Redes tiene el plan de estudio?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuántas asignaturas de Redes tiene el plan de estudio?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, '2' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', '3', 0
  UNION ALL SELECT 'C', '5', 0
  UNION ALL SELECT 'D', '4', 1
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Plan de estudio');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Cuál de estas asignaturas tiene componente de investigación en el plan?',
  'Internet de las Cosas tiene componente de investigación. Programación Móvil II, Programación Web II y Redes IV tienen componente de vinculación.',
  'Las tres incorrectas tienen otro componente, el de vinculación.',
  'Se cursa en el período X.',
  'dificil', 'manual', 'Plan de estudio UTH (nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuál de estas asignaturas tiene componente de investigación en el plan?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuál de estas asignaturas tiene componente de investigación en el plan?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Programación Móvil II' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'Internet de las Cosas (IoT)', 1
  UNION ALL SELECT 'C', 'Programación Web II', 0
  UNION ALL SELECT 'D', 'Redes IV', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Plan de estudio');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿En qué períodos se cursa Programación para Sistemas Abiertos I y II?',
  'Programación para Sistemas Abiertos I se cursa en el período X y la II en el XI.',
  'Son períodos seguidos y están cerca del final de la carrera.',
  'La segunda parte tiene componente de vinculación.',
  'media', 'manual', 'Plan de estudio UTH (nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿En qué períodos se cursa Programación para Sistemas Abiertos I y II?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿En qué períodos se cursa Programación para Sistemas Abiertos I y II?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Períodos VIII y IX' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'Períodos IX y X', 0
  UNION ALL SELECT 'C', 'Períodos X y XI', 1
  UNION ALL SELECT 'D', 'Períodos XI y XII', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Plan de estudio');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Qué área ocupa la mayor parte del plan de estudio, según su distribución?',
  'El área de desarrolladores ocupa el 45% del plan, seguida de habilidades exactas con 24%.',
  'Es el área de programación y desarrollo de software.',
  'Casi la mitad del plan.',
  'media', 'manual', 'Plan de estudio UTH (nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué área ocupa la mayor parte del plan de estudio, según su distribución?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué área ocupa la mayor parte del plan de estudio, según su distribución?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Desarrolladores' AS texto, 1 AS correcta
  UNION ALL SELECT 'B', 'Habilidades exactas', 0
  UNION ALL SELECT 'C', 'Redes y telecomunicaciones', 0
  UNION ALL SELECT 'D', 'Habilidades humanas', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Honduras');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Qué institución regula las telecomunicaciones en Honduras y administra el espectro radioeléctrico?',
  'CONATEL es la Comisión Nacional de Telecomunicaciones, el ente técnico del Estado que regula el sector.',
  'Sus siglas empiezan con CON.',
  'También atiende denuncias y consultas de los usuarios de telecomunicaciones.',
  'media', 'manual', 'CONATEL (conatel.gob.hn, nov 2026)', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué institución regula las telecomunicaciones en Honduras y administra el espectro radioeléctrico?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué institución regula las telecomunicaciones en Honduras y administra el espectro radioeléctrico?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Instituto de Acceso a la Información Pública (IAIP)' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'Banco Central de Honduras (BCH)', 0
  UNION ALL SELECT 'C', 'Instituto de la Propiedad (IP)', 0
  UNION ALL SELECT 'D', 'CONATEL', 1
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Honduras');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Mediante qué decreto aprobó el Congreso Nacional la ley de firma electrónica de Honduras?',
  'La ley de firma electrónica se aprobó con el Decreto 149-2013, el 30 de julio de 2013.',
  'Se aprobó el 30 de julio de un año de la década de 2010.',
  'El número del decreto se parece al año en que se aprobó.',
  'dificil', 'manual', 'La Prensa, 21 mar 2017', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Mediante qué decreto aprobó el Congreso Nacional la ley de firma electrónica de Honduras?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Mediante qué decreto aprobó el Congreso Nacional la ley de firma electrónica de Honduras?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Decreto 149-2003' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'Decreto 149-2013', 1
  UNION ALL SELECT 'C', 'Decreto 194-2013', 0
  UNION ALL SELECT 'D', 'Decreto 94-2013', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Honduras');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Qué institución entregó al Banco Central de Honduras el certificado como prestador de servicios de certificación de firma electrónica?',
  'En 2017, el Instituto de la Propiedad certificó al BCH como la primera prestadora de servicios de certificación de firma electrónica del país.',
  'Es la institución que también maneja registros de propiedad.',
  'El BCH fue la primera institución del país con esa autorización.',
  'dificil', 'manual', 'La Prensa, 21 mar 2017', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué institución entregó al Banco Central de Honduras el certificado como prestador de servicios de certificación de firma electrónica?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué institución entregó al Banco Central de Honduras el certificado como prestador de servicios de certificación de firma electrónica?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'El Instituto de la Propiedad' AS texto, 1 AS correcta
  UNION ALL SELECT 'B', 'CONATEL', 0
  UNION ALL SELECT 'C', 'El Congreso Nacional', 0
  UNION ALL SELECT 'D', 'La Secretaría de Finanzas', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);
SET @estado = (SELECT estado_revision FROM preguntas WHERE id_pregunta = @p);
INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario)
SELECT @p, @revisor, 'aprobada', 'Cargada desde el Excel del equipo' FROM DUAL
WHERE @revisor IS NOT NULL AND @estado = 'pendiente'
  AND NOT EXISTS (SELECT 1 FROM preguntas_revision WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Bases de datos');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Qué cláusula de SQL combina filas de dos tablas según una columna relacionada?',
  'JOIN relaciona las filas de dos tablas por una columna en común. UNION junta los resultados de dos consultas, uno debajo del otro.',
  'Une las tablas por una columna que tienen en común.',
  'UNION también junta datos, pero de otra forma.',
  'media', 'manual', 'Conocimiento general, revisar', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué cláusula de SQL combina filas de dos tablas según una columna relacionada?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué cláusula de SQL combina filas de dos tablas según una columna relacionada?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'UNION' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'JOIN', 1
  UNION ALL SELECT 'C', 'GROUP BY', 0
  UNION ALL SELECT 'D', 'WHERE', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Redes');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Cuántos bits tiene una dirección IPv4?',
  'IPv4 tiene 32 bits. La MAC tiene 48 y IPv6 tiene 128.',
  'Se escribe como cuatro números separados por puntos.',
  'Cada uno de esos cuatro números ocupa 8 bits.',
  'media', 'manual', 'Conocimiento general, revisar', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuántos bits tiene una dirección IPv4?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuántos bits tiene una dirección IPv4?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, '32' AS texto, 1 AS correcta
  UNION ALL SELECT 'B', '16', 0
  UNION ALL SELECT 'C', '48', 0
  UNION ALL SELECT 'D', '128', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Redes');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Qué protocolo de transporte es más rápido pero no garantiza que los datos lleguen completos ni en orden?',
  'UDP no confirma la entrega, por eso es más rápido. TCP sí garantiza que los datos lleguen completos y en orden.',
  'Se usa mucho en videollamadas y juegos en línea.',
  'Sus siglas empiezan con U.',
  'dificil', 'manual', 'Conocimiento general, revisar', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué protocolo de transporte es más rápido pero no garantiza que los datos lleguen completos ni en orden?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué protocolo de transporte es más rápido pero no garantiza que los datos lleguen completos ni en orden?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'TCP' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'ARP', 0
  UNION ALL SELECT 'C', 'UDP', 1
  UNION ALL SELECT 'D', 'ICMP', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Redes');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, 'En el modelo OSI, ¿qué capa se encarga del direccionamiento IP y del enrutamiento de los paquetes?',
  'La capa de red usa las direcciones IP para llevar los paquetes de una red a otra. La de transporte se ocupa de TCP y UDP.',
  'Es la capa 3 del modelo.',
  'Aquí trabajan los routers.',
  'dificil', 'manual', 'Conocimiento general, revisar', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = 'En el modelo OSI, ¿qué capa se encarga del direccionamiento IP y del enrutamiento de los paquetes?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = 'En el modelo OSI, ¿qué capa se encarga del direccionamiento IP y del enrutamiento de los paquetes?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Capa de enlace de datos' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'Capa de transporte', 0
  UNION ALL SELECT 'C', 'Capa de sesión', 0
  UNION ALL SELECT 'D', 'Capa de red', 1
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Sistemas operativos');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, 'En un sistema operativo, ¿qué es un proceso?',
  'Un programa guardado en disco es solo un archivo. Cuando se ejecuta, se convierte en un proceso con su propia memoria.',
  'Piensa en un programa que ya se abrió y está corriendo.',
  'Un mismo programa puede tener varios procesos a la vez.',
  'media', 'manual', 'Conocimiento general, revisar', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = 'En un sistema operativo, ¿qué es un proceso?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = 'En un sistema operativo, ¿qué es un proceso?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Un archivo ejecutable guardado en el disco' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'Un programa en ejecución con su propia memoria', 1
  UNION ALL SELECT 'C', 'Un hilo dentro de un programa', 0
  UNION ALL SELECT 'D', 'Un controlador de un dispositivo', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Ingeniería de software');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Qué hace el comando git commit?',
  'commit guarda los cambios en el historial local. Para subirlos se usa push, y para traer los del remoto, pull o fetch.',
  'Es como tomar una foto de tu trabajo en ese momento.',
  'Para subir los cambios a GitHub se usa otro comando.',
  'media', 'manual', 'Conocimiento general, revisar', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué hace el comando git commit?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Qué hace el comando git commit?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Sube los cambios al repositorio remoto' AS texto, 0 AS correcta
  UNION ALL SELECT 'B', 'Trae los cambios del repositorio remoto', 0
  UNION ALL SELECT 'C', 'Guarda los cambios preparados en el historial local', 1
  UNION ALL SELECT 'D', 'Crea una rama nueva', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);

SET @tema = (SELECT id_tema FROM temas WHERE id_categoria = @carrera AND nombre = 'Ingeniería de software');
INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
SELECT @tema, '¿Cuál de estos es un modelo de ciclo de vida del desarrollo de software?',
  'El modelo en cascada hace requisitos, diseño, implementación, pruebas y mantenimiento en ese orden. Los otros modelos son de otras áreas.',
  'Las etapas se hacen una después de otra, como un agua que baja.',
  'Los otros tres modelos son de redes, de bases de datos y de arquitectura de computadoras.',
  'dificil', 'manual', 'Conocimiento general, revisar', @autor FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
                  WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuál de estos es un modelo de ciclo de vida del desarrollo de software?');
SET @p = (SELECT p.id_pregunta FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
          WHERE t.id_categoria = @carrera AND p.enunciado = '¿Cuál de estos es un modelo de ciclo de vida del desarrollo de software?');
INSERT INTO opciones (id_pregunta, letra, texto, es_correcta)
SELECT @p, letra, texto, correcta FROM (
  SELECT 'A' AS letra, 'Modelo en cascada' AS texto, 1 AS correcta
  UNION ALL SELECT 'B', 'Modelo OSI', 0
  UNION ALL SELECT 'C', 'Modelo entidad-relación', 0
  UNION ALL SELECT 'D', 'Modelo de von Neumann', 0
) AS o
WHERE NOT EXISTS (SELECT 1 FROM opciones WHERE id_pregunta = @p);

SELECT t.nombre AS tema, p.estado_revision AS estado, COUNT(*) AS preguntas
FROM preguntas p JOIN temas t ON t.id_tema = p.id_tema
WHERE t.id_categoria = @carrera
GROUP BY t.nombre, p.estado_revision
ORDER BY t.nombre, p.estado_revision;
