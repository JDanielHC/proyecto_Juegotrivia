import { requerirUsuario } from "@/lib/auth"
import { consulta } from "@/lib/db"
import { conErrores, idDeRuta } from "@/lib/errores"
import { partidaDelUsuario, resumenPartida } from "@/lib/juego"

export const POST = conErrores(async (request, { params }) => {
  const usuario = await requerirUsuario()
  const idPartida = idDeRuta((await params).id)
  await partidaDelUsuario(idPartida, usuario.id_usuario)

  await consulta(
    "UPDATE partidas SET estado = 'abandonada', terminada_en = NOW(3) WHERE id_partida = ?",
    [idPartida]
  )

  const partida = await partidaDelUsuario(idPartida, usuario.id_usuario)
  return Response.json({ partida: resumenPartida(partida), mensaje: "La partida quedó abandonada" })
})
