import { requerirUsuario } from "@/lib/auth"
import { consulta } from "@/lib/db"
import { conErrores, ErrorApi, idDeRuta, leerJson } from "@/lib/errores"
import { partidaDelUsuario, preguntaEnPantalla, resultadoRespuesta, resumenPartida } from "@/lib/juego"

export const POST = conErrores(async (request, { params }) => {
  const usuario = await requerirUsuario()
  const idPartida = idDeRuta((await params).id)
  const datos = await leerJson(request)

  if (!("id_opcion" in datos)) {
    throw new ErrorApi(400, "Falta id_opcion (manda null si se acabó el tiempo)")
  }
  const idOpcion = datos.id_opcion
  if (idOpcion !== null && !(Number.isInteger(idOpcion) && idOpcion > 0)) {
    throw new ErrorApi(400, "La opción no es válida")
  }

  await partidaDelUsuario(idPartida, usuario.id_usuario)

  const actual = await preguntaEnPantalla(idPartida)
  if (!actual) {
    throw new ErrorApi(409, "Todavía no se ha mostrado ninguna pregunta")
  }
  if (actual.pausada_en) {
    throw new ErrorApi(409, "La pregunta está en pausa, reanúdala primero")
  }

  try {
    await consulta(
      "INSERT INTO respuestas (id_partida, orden, id_pregunta, id_opcion) VALUES (?, ?, ?, ?)",
      [idPartida, actual.orden, actual.id_pregunta, idOpcion]
    )
  } catch (error) {
    if (error.code === "ER_DUP_ENTRY") {
      throw new ErrorApi(409, "Esa pregunta ya fue contestada")
    }
    throw error
  }

  const resultado = await resultadoRespuesta(idPartida, actual.orden)
  const partida = await partidaDelUsuario(idPartida, usuario.id_usuario)

  const eraLaUltima = partida.cantidad_preguntas !== null && actual.orden >= partida.cantidad_preguntas
  const falloEnMuerteSubita = partida.termina_al_fallar === 1 && !resultado.es_correcta

  return Response.json({
    resultado,
    partida: resumenPartida(partida),
    debe_terminar: eraLaUltima || falloEnMuerteSubita,
  })
})
