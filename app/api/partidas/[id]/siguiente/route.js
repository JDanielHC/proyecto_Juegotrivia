import { requerirUsuario } from "@/lib/auth"
import { consulta } from "@/lib/db"
import { conErrores, ErrorApi, idDeRuta } from "@/lib/errores"
import {
  elegirPregunta,
  partidaDelUsuario,
  preguntaEnPantalla,
  preguntaPublica,
  resumenPartida,
} from "@/lib/juego"

export const POST = conErrores(async (request, { params }) => {
  const usuario = await requerirUsuario()
  const idPartida = idDeRuta((await params).id)
  const partida = await partidaDelUsuario(idPartida, usuario.id_usuario)

  const actual = await preguntaEnPantalla(idPartida)
  const orden = (actual?.orden ?? 0) + 1

  const idPregunta = await elegirPregunta(partida, orden)
  if (!idPregunta) {
    const llena = partida.cantidad_preguntas !== null && orden > partida.cantidad_preguntas
    throw new ErrorApi(
      409,
      llena ? "La partida ya tiene todas sus preguntas" : "Ya no quedan preguntas disponibles en esta sección"
    )
  }

  try {
    await consulta(
      "INSERT INTO partida_preguntas (id_partida, orden, id_pregunta) VALUES (?, ?, ?)",
      [idPartida, orden, idPregunta]
    )
  } catch (error) {
    if (error.code === "ER_DUP_ENTRY") {
      throw new ErrorApi(409, "Esa pregunta ya se mostró, pide la pregunta actual")
    }
    throw error
  }

  return Response.json(
    { partida: resumenPartida(partida), pregunta: await preguntaPublica(idPartida, orden) },
    { status: 201 }
  )
})
