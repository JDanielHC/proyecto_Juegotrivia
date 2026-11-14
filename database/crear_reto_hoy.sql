USE retotrivia_uth;

INSERT INTO retos_diarios (fecha, creado_por)
SELECT CURDATE(),
       (SELECT u.id_usuario
        FROM usuarios u
        JOIN roles r ON r.id_rol = u.id_rol
        WHERE r.codigo = 'admin'
        ORDER BY u.id_usuario
        LIMIT 1)
FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM retos_diarios WHERE fecha = CURDATE());

SET @id_reto = (SELECT id_reto FROM retos_diarios WHERE fecha = CURDATE());

INSERT INTO reto_diario_preguntas (id_reto, orden, id_pregunta)
SELECT @id_reto,
       ROW_NUMBER() OVER (ORDER BY RAND()) AS orden, 
       elegidas.id_pregunta
FROM (
  SELECT id_pregunta
  FROM (
    SELECT q.id_pregunta,
           ROW_NUMBER() OVER (PARTITION BY t.id_categoria ORDER BY RAND()) AS turno
    FROM preguntas q
    JOIN temas t      ON t.id_tema = q.id_tema
    JOIN categorias c ON c.id_categoria = t.id_categoria
    WHERE q.estado_revision = 'aprobada'
      AND t.activo = 1
      AND c.activa = 1
      AND c.es_mixta = 0
  ) sorteo
  ORDER BY turno, RAND()
  LIMIT 5
) elegidas
WHERE NOT EXISTS (SELECT 1 FROM reto_diario_preguntas WHERE id_reto = @id_reto);

SELECT rd.fecha, rp.orden, c.nombre AS carrera, q.enunciado
FROM reto_diario_preguntas rp
JOIN retos_diarios rd ON rd.id_reto = rp.id_reto
JOIN preguntas q      ON q.id_pregunta = rp.id_pregunta
JOIN temas t          ON t.id_tema = q.id_tema
JOIN categorias c     ON c.id_categoria = t.id_categoria
WHERE rp.id_reto = @id_reto
ORDER BY rp.orden;
