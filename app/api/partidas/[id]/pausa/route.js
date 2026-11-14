import { requerirUsuario } from "@/lib/auth"
import { consulta } from "@/lib/db"
import { conErrores, ErrorApi, idDeRuta } from "@/lib/errores"
import { partidaDelUsuario, preguntaEnPantalla, preguntaPublica, resumenPartida } from "@/lib/juego"

async function preguntaActual(request, params) {
  const usuario = await requerirUsuario()
  const idPartida = idDeRuta((await params).id)
  await partidaDelUsuario(idPartida, usuario.id_usuario)

  const actual = await preguntaEnPantalla(idPartida)
  if (!actual) {
    throw new ErrorApi(409, "Todavía no se ha mostrado ninguna pregunta")
  }
  return { usuario, idPartida, actual }
}

async function responder(idPartida, idUsuario, orden) {
  const partida = await partidaDelUsuario(idPartida, idUsuario)
  return Response.json({
    partida: resumenPartida(partida),
    pregunta: await preguntaPublica(idPartida, orden),
  })
}

export const POST = conErrores(async (request, { params }) => {
  const { usuario, idPartida, actual } = await preguntaActual(request, params)

  if (!actual.pausada_en) {
    await consulta(
      "UPDATE partida_preguntas SET pausada_en = NOW(3) WHERE id_partida = ? AND orden = ?",
      [idPartida, actual.orden]
    )
  }
  return responder(idPartida, usuario.id_usuario, actual.orden)
})

export const DELETE = conErrores(async (request, { params }) => {
  const { usuario, idPartida, actual } = await preguntaActual(request, params)

  if (actual.pausada_en) {
    await consulta(
      "UPDATE partida_preguntas SET pausada_en = NULL WHERE id_partida = ? AND orden = ?",
      [idPartida, actual.orden]
    )
  }
  return responder(idPartida, usuario.id_usuario, actual.orden)
})
