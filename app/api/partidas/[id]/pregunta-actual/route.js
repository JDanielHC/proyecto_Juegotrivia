import { requerirUsuario } from "@/lib/auth"
import { conErrores, idDeRuta } from "@/lib/errores"
import { partidaDelUsuario, preguntaEnPantalla, preguntaPublica, resumenPartida } from "@/lib/juego"

export const GET = conErrores(async (request, { params }) => {
  const usuario = await requerirUsuario()
  const idPartida = idDeRuta((await params).id)
  const partida = await partidaDelUsuario(idPartida, usuario.id_usuario)

  const actual = await preguntaEnPantalla(idPartida)

  return Response.json({
    partida: resumenPartida(partida),
    pregunta: actual ? await preguntaPublica(idPartida, actual.orden) : null,
  })
})
