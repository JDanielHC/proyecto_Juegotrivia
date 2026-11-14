import { consulta, unaFila } from "@/lib/db"
import { ErrorApi } from "@/lib/errores"

const PISTAS_POR_PARTIDA = 3

export async function partidaDelUsuario(idPartida, idUsuario) {
  const partida = await unaFila(
    `SELECT p.id_partida, p.id_categoria, p.id_reto, p.estado,
            p.aciertos, p.errores, p.puntos_respuestas, p.total_pistas,
            c.codigo AS categoria, c.nombre AS categoria_nombre, c.es_mixta,
            m.codigo AS modo, m.nombre AS modo_nombre, m.cantidad_preguntas, m.termina_al_fallar
     FROM partidas p
     JOIN categorias c  ON c.id_categoria = p.id_categoria
     JOIN modos_juego m ON m.id_modo = p.id_modo
     WHERE p.id_partida = ? AND p.id_usuario = ?`,
    [idPartida, idUsuario]
  )
  if (!partida) {
    throw new ErrorApi(404, "No se encontró la partida")
  }
  return partida
}

export function resumenPartida(partida) {
  return {
    id_partida: partida.id_partida,
    estado: partida.estado,
    categoria: partida.categoria,
    categoria_nombre: partida.categoria_nombre,
    modo: partida.modo,
    modo_nombre: partida.modo_nombre,
    total_preguntas: partida.cantidad_preguntas,
    aciertos: partida.aciertos,
    errores: partida.errores,
    puntos: partida.puntos_respuestas,
    pistas_restantes: PISTAS_POR_PARTIDA - partida.total_pistas,
  }
}

export async function preguntaEnPantalla(idPartida) {
  return unaFila(
    `SELECT orden, id_pregunta, pausada_en
     FROM partida_preguntas
     WHERE id_partida = ?
     ORDER BY orden DESC
     LIMIT 1`,
    [idPartida]
  )
}

export async function elegirPregunta(partida, orden) {
  if (partida.id_reto) {
    const fila = await unaFila(
      "SELECT id_pregunta FROM reto_diario_preguntas WHERE id_reto = ? AND orden = ?",
      [partida.id_reto, orden]
    )
    return fila?.id_pregunta ?? null
  }

  const soloSuCarrera = partida.es_mixta ? "" : "AND t.id_categoria = ?"
  const valores = partida.es_mixta ? [partida.id_partida] : [partida.id_partida, partida.id_categoria]

  const fila = await unaFila(
    `SELECT q.id_pregunta
     FROM preguntas q
     JOIN temas t      ON t.id_tema = q.id_tema
     JOIN categorias c ON c.id_categoria = t.id_categoria
     WHERE q.estado_revision = 'aprobada'
       AND t.activo = 1
       AND c.activa = 1
       AND NOT EXISTS (
         SELECT 1 FROM partida_preguntas pp
         WHERE pp.id_partida = ? AND pp.id_pregunta = q.id_pregunta
       )
       ${soloSuCarrera}
     ORDER BY RAND()
     LIMIT 1`,
    valores
  )
  return fila?.id_pregunta ?? null
}

async function opcionesEliminadas(idPartida, idPregunta) {
  const filas = await consulta(
    `SELECT id_opcion
     FROM opciones
     WHERE id_pregunta = ? AND es_correcta = 0
     ORDER BY SHA2(CONCAT(?, '-', id_opcion), 256)
     LIMIT 2`,
    [idPregunta, String(idPartida)]
  )
  return filas.map((fila) => fila.id_opcion)
}

export async function contenidoPista(tipo, pregunta, idPartida) {
  if (tipo === "eliminar_dos") {
    return { tipo, opciones_eliminadas: await opcionesEliminadas(idPartida, pregunta.id_pregunta) }
  }
  const texto = tipo === "conceptual" ? pregunta.pista_conceptual : pregunta.pista_adicional
  return { tipo, texto }
}

async function pistasDePregunta(idPartida, orden) {
  const filas = await consulta(
    `SELECT tp.codigo AS tipo, q.id_pregunta, q.pista_conceptual, q.pista_adicional
     FROM pistas_usadas pu
     JOIN tipos_pista tp      ON tp.id_tipo_pista = pu.id_tipo_pista
     JOIN partida_preguntas pp ON pp.id_partida = pu.id_partida AND pp.orden = pu.orden
     JOIN preguntas q         ON q.id_pregunta = pp.id_pregunta
     WHERE pu.id_partida = ? AND pu.orden = ?
     ORDER BY pu.numero_uso`,
    [idPartida, orden]
  )
  return Promise.all(filas.map((fila) => contenidoPista(fila.tipo, fila, idPartida)))
}

export async function resultadoRespuesta(idPartida, orden) {
  const fila = await unaFila(
    `SELECT r.es_correcta, r.puntos, r.segundos, r.id_opcion AS opcion_elegida,
            o.id_opcion AS opcion_correcta, o.letra AS letra_correcta, q.explicacion
     FROM respuestas r
     JOIN preguntas q ON q.id_pregunta = r.id_pregunta
     JOIN opciones o  ON o.id_pregunta = r.id_pregunta AND o.es_correcta = 1
     WHERE r.id_partida = ? AND r.orden = ?`,
    [idPartida, orden]
  )
  if (!fila) return null
  return {
    es_correcta: fila.es_correcta === 1,
    se_acabo_el_tiempo: fila.opcion_elegida === null,
    puntos: fila.puntos,
    segundos: fila.segundos,
    opcion_elegida: fila.opcion_elegida,
    opcion_correcta: fila.opcion_correcta,
    letra_correcta: fila.letra_correcta,
    explicacion: fila.explicacion,
  }
}

export async function preguntaPublica(idPartida, orden) {
  const fila = await unaFila(
    `SELECT pp.orden, pp.id_pregunta, pp.mostrada_en, pp.hora_limite,
            TIMESTAMPDIFF(SECOND, pp.mostrada_en, pp.hora_limite) AS segundos_totales,
            GREATEST(0, TIMESTAMPDIFF(MICROSECOND, COALESCE(pp.pausada_en, NOW(3)), pp.hora_limite) / 1000000) AS segundos_restantes,
            pp.pausada_en IS NOT NULL AS en_pausa,
            q.enunciado, q.dificultad, t.nombre AS tema, c.nombre AS carrera,
            r.orden IS NOT NULL AS contestada
     FROM partida_preguntas pp
     JOIN preguntas q  ON q.id_pregunta = pp.id_pregunta
     JOIN temas t      ON t.id_tema = q.id_tema
     JOIN categorias c ON c.id_categoria = t.id_categoria
     LEFT JOIN respuestas r ON r.id_partida = pp.id_partida AND r.orden = pp.orden
     WHERE pp.id_partida = ? AND pp.orden = ?`,
    [idPartida, orden]
  )
  if (!fila) return null

  const opciones = await consulta(
    "SELECT id_opcion, letra, texto FROM opciones WHERE id_pregunta = ? ORDER BY letra",
    [fila.id_pregunta]
  )
  const contestada = fila.contestada === 1

  return {
    orden: fila.orden,
    enunciado: fila.enunciado,
    carrera: fila.carrera,
    tema: fila.tema,
    dificultad: fila.dificultad,
    opciones,
    mostrada_en: fila.mostrada_en,
    hora_limite: fila.hora_limite,
    segundos_totales: fila.segundos_totales,
    segundos_restantes: contestada ? 0 : Number(fila.segundos_restantes),
    en_pausa: fila.en_pausa === 1,
    pistas_usadas: await pistasDePregunta(idPartida, orden),
    contestada,
    resultado: contestada ? await resultadoRespuesta(idPartida, orden) : null,
  }
}
