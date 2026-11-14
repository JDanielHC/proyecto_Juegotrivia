import { requerirUsuario } from "@/lib/auth"
import { llamar, unaFila } from "@/lib/db"
import { conErrores, idDeRuta } from "@/lib/errores"
import { partidaDelUsuario, resumenPartida } from "@/lib/juego"

export const POST = conErrores(async (request, { params }) => {
  const usuario = await requerirUsuario()
  const idPartida = idDeRuta((await params).id)
  await partidaDelUsuario(idPartida, usuario.id_usuario)

  await llamar("CALL sp_terminar_partida(?)", [idPartida])

  const final = await unaFila(
    `SELECT p.puntos_respuestas, p.bono_rapidez, p.bono_racha, p.puntaje_total,
            p.aciertos, p.errores, p.tiempo_total_seg, p.total_pistas, p.terminada_en,
            EXISTS (SELECT 1 FROM v_records_categoria rc WHERE rc.id_partida = p.id_partida) AS es_record
     FROM partidas p
     WHERE p.id_partida = ?`,
    [idPartida]
  )
  const partida = await partidaDelUsuario(idPartida, usuario.id_usuario)

  return Response.json({
    partida: resumenPartida(partida),
    resumen: {
      puntos_respuestas: final.puntos_respuestas,
      bono_rapidez: final.bono_rapidez,
      bono_racha: final.bono_racha,
      puntaje_total: final.puntaje_total,
      aciertos: final.aciertos,
      errores: final.errores,
      tiempo_total_seg: final.tiempo_total_seg,
      pistas_usadas: final.total_pistas,
      terminada_en: final.terminada_en,
      es_record: final.es_record === 1,
    },
  })
})
