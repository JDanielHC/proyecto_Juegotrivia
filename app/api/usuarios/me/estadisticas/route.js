import { requerirUsuario } from "@/lib/auth"
import { consulta, unaFila } from "@/lib/db"
import { conErrores } from "@/lib/errores"

export const GET = conErrores(async () => {
  const usuario = await requerirUsuario()
  const id = usuario.id_usuario

  const general = await unaFila(
    `SELECT partidas_jugadas, preguntas_respondidas, aciertos, errores, precision_pct,
            tiempo_medio_seg, pistas_usadas, puntaje_acumulado, ultima_partida
     FROM v_estadisticas_usuario
     WHERE id_usuario = ?`,
    [id]
  )

  const porCarrera = await consulta(
    `SELECT id_categoria, categoria, preguntas_respondidas, aciertos, errores,
            precision_pct, tiempo_medio_seg
     FROM v_estadisticas_usuario_categoria
     WHERE id_usuario = ?
     ORDER BY id_categoria`,
    [id]
  )

  const records = await consulta(
    `SELECT c.codigo AS categoria, c.nombre AS categoria_nombre, rc.puntaje_total,
            rc.tiempo_total_seg, rc.total_pistas, rc.terminada_en
     FROM v_records_categoria rc
     JOIN categorias c ON c.id_categoria = rc.id_categoria
     WHERE rc.id_usuario = ?
     ORDER BY c.orden`,
    [id]
  )

  const ultimas = await consulta(
    `SELECT id_partida, categoria, modo, puntaje_total, aciertos, errores,
            tiempo_total_seg, total_pistas, bono_rapidez, bono_racha, terminada_en
     FROM v_ultimas_partidas
     WHERE id_usuario = ? AND numero <= 10
     ORDER BY numero`,
    [id]
  )

  return Response.json({
    alias: usuario.alias,
    general,
    por_carrera: porCarrera,
    records,
    ultimas_partidas: ultimas,
  })
})
