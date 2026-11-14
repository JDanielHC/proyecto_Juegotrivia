# Base de datos de RetoTrivia UTH

Funciona en MariaDB 10.5 o más nueva, que es la que trae Rocky Linux 9.6. Todas las tablas usan InnoDB y utf8mb4, así que las tildes y la ñ se guardan bien.

## Archivos

| Archivo | Qué tiene |
|---|---|
| `schema.sql` | Las 20 tablas, las reglas (triggers), las vistas, los índices y los 2 usuarios de MariaDB. No trae datos. |
| `seed.sql` | Datos de prueba: 5 categorías, 18 temas, 40 preguntas, 10 usuarios y 25 partidas. |
| `migracion_pausa.sql` | Agrega la pausa de preguntas a una base que ya tiene datos. No borra nada. |
| `migracion_errores.sql` | Agrega a `auditoria` las columnas para guardar los errores de la API. No borra nada y se puede correr dos veces, también desde DBeaver. |
| `preguntas_computacion.sql` | Carga las 24 preguntas de Ingeniería en Computación del Excel del equipo. Las 15 con fuente quedan aprobadas y las 9 marcadas "revisar" quedan pendientes. No borra nada, se puede correr dos veces y funciona desde DBeaver. |
| `crear_reto_hoy.sql` | Crea el reto del día de hoy con 5 preguntas aprobadas. Se puede correr todos los días, también desde DBeaver. |
| `diagrama.md` | Diagrama de las tablas en Mermaid. |
| `README.md` | Este archivo. |

## Cómo se instala

En el servidor Rocky Linux:

```bash
mysqldump -u root -p retotrivia_uth > respaldo_antes.sql   # solo si ya existía
mariadb -u root -p < schema.sql
mariadb -u root -p < seed.sql
```

`schema.sql` borra las tablas si ya existen, por eso conviene hacer el respaldo antes.

Hay que correrlos desde la terminal y no desde DBeaver, porque los triggers usan `DELIMITER` y DBeaver no siempre lo entiende. Ya cargada la base, DBeaver sirve para verla sin problema.

Todas las cuentas del seed tienen la contraseña `Trivia2026`.

## Usuarios de MariaDB

| Usuario | Para qué | Permisos |
|---|---|---|
| `trivia_app` | El que usa Next.js | Leer, agregar y cambiar en todas las tablas. Solo puede borrar en `sesiones`. Puede correr `sp_terminar_partida`. |
| `trivia_lectura` | Consultas públicas | Solo las vistas públicas y las de ranking. No ve `opciones.es_correcta`, correos ni contraseñas. |

Las contraseñas del schema son de ejemplo y hay que cambiarlas antes de usarlo en serio.

## Tablas

### Usuarios y seguridad

**roles**: los tipos de cuenta. Hay tres: jugador, revisor (aprueba preguntas) y admin.

**usuarios**: las cuentas. Guarda el alias, el correo y la contraseña en hash, nunca tal cual. El alias y el correo no se pueden repetir. A una cuenta no se le borra, se le cambia el estado a `bloqueado` o `eliminado`, porque sus partidas tienen que quedar.

**sesiones**: cada inicio de sesión. Se guarda el hash del token y no el token, para que si alguien ve la tabla no pueda entrar con eso. Si se borra el usuario, sus sesiones se borran con él.

### Contenido

**categorias**: las 4 carreras y la Mixta. La columna `es_mixta` marca la Mixta, y solo puede haber una.

**temas**: los temas de cada carrera, por ejemplo Redes o Derecho penal. La Mixta no lleva temas porque usa los de las cuatro carreras; un trigger no lo deja.

**preguntas**: el banco de preguntas. Guarda el enunciado, la explicación que sale después de contestar, las dos pistas de texto ya revisadas, la dificultad, la `fuente` (manual o ia), la referencia de dónde sale el dato y el estado de revisión. Toda pregunta nueva entra como `pendiente`, y en el juego solo salen las `aprobada`.

**opciones**: las 4 opciones de cada pregunta, de la A a la D. `es_correcta` dice cuál es la buena, y nunca puede haber dos correctas en la misma pregunta. Tampoco se pueden repetir textos. Si la pregunta ya está aprobada, sus opciones no se pueden cambiar.

**preguntas_revision**: el historial de revisiones: quién revisó, qué decidió (aprobada, rechazada, cambios o retirada) y un comentario. Al guardar una revisión, el trigger cambia solo el estado de la pregunta. Para aprobarla, la pregunta tiene que tener 4 opciones y una sola correcta.

**reportes_pregunta**: cuando un jugador avisa que una pregunta tiene un error. Cada jugador puede reportar una misma pregunta una sola vez. Se guarda si el reporte sigue abierto o ya lo atendió alguien.

### Partidas

**modos_juego**: normal, mixta, reto del día y muerte súbita. Cada modo dice cuántas preguntas trae (vacío en muerte súbita, que no tiene límite), si termina al primer error y si cuenta para los rankings. Solo cuentan para los rankings el normal y el mixta. El reto del día tiene su propio ranking, y muerte súbita queda solo en las estadísticas.

**partidas**: cada partida jugada. Guarda el jugador, la sección, el modo, el estado y estos totales:

- `aciertos`, `errores`, `puntos_respuestas` y `tiempo_total_seg` los suma el trigger con cada respuesta.
- `total_pistas` lo suma el trigger con cada pista.
- `bono_rapidez` (+20) y `bono_racha` (+10) los calcula `sp_terminar_partida` al final.
- `puntaje_total` se calcula solo: puntos de las respuestas más los dos bonos.

Un jugador no puede tener dos partidas en curso al mismo tiempo, y en el reto del día solo tiene un intento. Una partida que ya terminó no se puede modificar.

Estos totales también se podrían sacar sumando las respuestas, pero se guardan aquí para que los rankings salgan rápido. Como los llenan los triggers y no la app, no se desordenan.

**partida_preguntas**: las preguntas que le salieron a cada partida, en orden, con la hora en que se mostró y la hora límite. Si la app no manda la hora límite, el trigger la calcula con `segundos_por_pregunta`. Antes de guardar, el trigger revisa:

- que la partida siga en curso,
- que la pregunta esté aprobada y sea de la carrera de la partida (en la Mixta puede ser de cualquiera),
- que vayan en orden y que la anterior ya esté contestada,
- que no pase de 10 preguntas (o 5 en el reto),
- que en muerte súbita no siga después del primer error,
- que en el reto del día sean las mismas preguntas del reto y en el mismo orden.

Una pregunta ya mostrada solo se puede pausar y reanudar. La app manda `pausada_en = NOW(3)` para pausar y `pausada_en = NULL` para reanudar; el resto lo hace el trigger. No deja pausar si ya se contestó o si se acabó el tiempo. Al reanudar, `mostrada_en` y `hora_limite` se corren lo que duró la pausa, así el jugador sigue con los segundos que tenía y los puntos no cuentan el rato en pausa. `pausas` y `segundos_pausa` guardan cuántas veces se pausó y cuánto tiempo en total. Mientras está en pausa, la app no acepta respuestas ni pistas.

**respuestas**: la respuesta a cada pregunta. La app solo manda la partida, el orden, la pregunta y la opción elegida. Lo demás lo hace el trigger: decide si es correcta, calcula los segundos y los puntos, y no acepta nada si la partida ya terminó o si se pasó la hora límite. Si se acabó el tiempo, se guarda sin opción y cuenta como error con 0 puntos. Una respuesta enviada ya no se cambia ni se borra.

Los puntos van de 100 a 70 según la rapidez:

```
puntos = 100 - 30 × (segundos que tardó / segundos que tenía)
```

Contestar al instante da 100, justo al final da 70, y un error da 0. Los valores 70 y 100 salen de `configuracion_juego`.

**tipos_pista**: conceptual, eliminar dos opciones y adicional.

**pistas_usadas**: cada pista gastada. El trigger le pone el número de uso (1, 2 o 3) y no deja pasar de 3 por partida, aunque se gasten todas en una sola pregunta. Tampoco deja usar pistas en una pregunta ya contestada ni con la partida terminada. Usar una pista no resta puntos, pero queda registrado y sirve para el desempate.

**retos_diarios**: un reto por fecha, igual para todos.

**reto_diario_preguntas**: las 5 preguntas de cada reto, en orden. Solo se pueden usar preguntas aprobadas.

### IA y sistema

**solicitudes_ia**: cada petición a Ollama. Guarda qué se pidió (pregunta, pista o explicación), lo que se le mandó, lo que respondió, cuánto tardó en milisegundos, si falló y por qué, y si se usó el banco de preguntas como respaldo. Sirve para el monitoreo del tiempo de respuesta del modelo. Lo que se le mande al modelo nunca debe llevar nombres, correos ni contraseñas.

La pantalla `/admin/preguntas` llena esta tabla cada vez que pide una pregunta: guarda las instrucciones (con la parte del material que corresponde al tema y tres preguntas aprobadas como ejemplo), la respuesta tal cual, el tiempo en milisegundos y el estado: `exitosa`, `tiempo_agotado` (pasó `segundos_espera_ia`), `error` (Ollama apagado o sin el modelo) o `formato_invalido` (la respuesta no sirve: JSON roto, una cita que no está en el material, opciones repetidas, una pista que dice la respuesta o una pregunta que ya existe). Las preguntas que sí sirven se guardan con `fuente = 'ia'`, con la cita en `referencia`, y quedan pendientes hasta que un revisor las aprueba.

Para ver cómo le va al modelo:

```sql
SELECT estado, COUNT(*) AS peticiones, ROUND(AVG(tiempo_respuesta_ms)) AS ms_promedio
FROM solicitudes_ia
WHERE tipo = 'pregunta'
GROUP BY estado;
```

**configuracion_juego**: los valores que el administrador puede cambiar sin tocar el código: puntos mínimos y máximos por acierto, segundos por pregunta, los dos bonos, los aciertos que necesita la racha y el tiempo de espera de la IA. Cada valor tiene un mínimo y un máximo permitidos. Cada cambio queda anotado solo en la auditoría.

Las 3 pistas y las 10 preguntas no están aquí porque son reglas fijas del juego: van en la tabla `modos_juego` y en los CHECK.

**auditoria**: registro de cambios importantes, accesos (como un inicio de sesión fallido) y errores del sistema. Guarda cómo estaba el dato antes y después, en JSON.

Cuando una ruta de la API falla con un error del servidor (código 500 o 503), la app guarda una fila con `tipo = 'error'` y `accion = 'error_api'`: la fecha y hora (`creado_en`), el `metodo`, la `ruta`, el `codigo_http`, el mensaje en `detalle`, el usuario si tenía sesión y la IP. Nunca se guardan el cuerpo de la petición, las contraseñas ni las cookies. El error también sale siempre en la consola del servidor, porque si la base no responde no se puede guardar ahí. Si guardarlo falla, el usuario igual recibe su respuesta. Los errores 4xx (datos mal escritos, sin sesión, alias repetido) no se guardan porque no son fallas del sistema.

Para ver los últimos errores:

```sql
SELECT creado_en, codigo_http, metodo, ruta, detalle, id_usuario
FROM auditoria
WHERE tipo = 'error'
ORDER BY creado_en DESC
LIMIT 50;
```

## Vistas

| Vista | Qué muestra | Quién la ve |
|---|---|---|
| `v_preguntas_publicas` | Preguntas aprobadas, sin la explicación ni las pistas | Público |
| `v_opciones_publicas` | Las opciones sin decir cuál es la correcta | Público |
| `v_records_categoria` | La mejor partida de cada jugador en cada carrera y en la Mixta | Interna |
| `v_ranking_categoria` | Ranking de cada carrera | Público |
| `v_ranking_principal` | Suma del récord en las 4 carreras, solo de quienes jugaron las 4 | Público |
| `v_ranking_mixta` | Ranking de la Mixta, aparte del principal | Público |
| `v_ranking_reto_diario` | Ranking de cada reto. La app filtra con `WHERE fecha = CURDATE()` | Público |
| `v_estadisticas_usuario` | Partidas, aciertos, errores, precisión, tiempo medio, pistas y puntaje acumulado | Solo el dueño |
| `v_estadisticas_usuario_categoria` | Lo mismo pero por carrera, más su récord | Solo el dueño |
| `v_ultimas_partidas` | Las partidas de cada jugador de la más nueva a la más vieja | Solo el dueño |

En los rankings públicos solo salen la posición, el alias y el puntaje. Las vistas privadas traen `id_usuario`, y la app las filtra con el id de quien inició sesión.

**Desempate:** gana quien tenga más puntos. Si empatan, quien tardó menos; si siguen empatados, quien usó menos pistas; y si aún así siguen iguales, quien lo logró primero.

En `v_estadisticas_usuario_categoria` las respuestas se cuentan por la carrera de la pregunta. Así, lo que contesta en la Mixta y en el reto también suma a la precisión de cada carrera.

## Cómo no se filtra la respuesta correcta

1. Las vistas públicas no tienen la columna `es_correcta`.
2. `trivia_lectura` solo puede leer esas vistas, no las tablas.
3. La app nunca necesita mandar `es_correcta` al navegador para calificar, porque el trigger de `respuestas` ya decide si acertó. La correcta se muestra solo después de contestar.

## Flujo de una partida desde la app

```sql
-- 1. Crear la partida
INSERT INTO partidas (id_usuario, id_categoria, id_modo) VALUES (3, 1, 1);

-- 2. Mostrar la pregunta (la hora límite la pone el trigger)
INSERT INTO partida_preguntas (id_partida, orden, id_pregunta) VALUES (26, 1, 4);

-- 3. Si abre el diálogo de abandonar, se pausa y al cancelar se reanuda
UPDATE partida_preguntas SET pausada_en = NOW(3) WHERE id_partida = 26 AND orden = 1;
UPDATE partida_preguntas SET pausada_en = NULL WHERE id_partida = 26 AND orden = 1;

-- 4. Si pide pista
INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista) VALUES (26, 1, 2);

-- 5. Guardar lo que eligió (los puntos los pone el trigger)
INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion) VALUES (26, 1, 4, 16);

-- ... se repiten 2 a 5 hasta la décima pregunta ...

-- 6. Cerrar la partida y calcular los bonos
CALL sp_terminar_partida(26);
```

Si ya existía la base antes de la pausa, se agrega desde la terminal con `mariadb -u root -p < migracion_pausa.sql`.

Si el jugador se va a mitad de partida, la app la cierra así: `UPDATE partidas SET estado = 'abandonada', terminada_en = NOW(3) WHERE id_partida = ...`.

Cuando una regla no se cumple, MariaDB devuelve un error con un mensaje en español, por ejemplo "La partida ya terminó, no se aceptan más respuestas". La app puede mostrarlo tal cual o cambiarlo por uno propio.

## Para comprobar el seed

Al final de `seed.sql` está anotado lo que tienen que dar los rankings y tres INSERT que deben fallar. Si dan igual, los triggers y las vistas están funcionando.
