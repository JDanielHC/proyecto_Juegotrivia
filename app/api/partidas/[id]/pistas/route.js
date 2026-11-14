import { requerirUsuario } from "@/lib/auth"
import { consulta, unaFila } from "@/lib/db"
import { conErrores, ErrorApi, idDeRuta, leerJson } from "@/lib/errores"
import { contenidoPista, partidaDelUsuario, preguntaEnPantalla, resumenPartida } from "@/lib/juego"

export const POST = conErrores(async (request, { params }) => {
  const usuario = await requerirUsuario()
  const idPartida = idDeRuta((await params).id)
  const datos = await leerJson(request)

  const tipo = await unaFila("SELECT id_tipo_pista, codigo FROM tipos_pista WHERE codigo = ?", [String(datos.tipo ?? "")])
  if (!tipo) {
    throw new ErrorApi(400, "El tipo de pista tiene que ser conceptual, eliminar_dos o adicional")
  }

  await partidaDelUsuario(idPartida, usuario.id_usuario)

  const actual = await preguntaEnPantalla(idPartida)
  if (!actual) {
    throw new ErrorApi(409, "Todavía no se ha mostrado ninguna pregunta")
  }
  if (actual.pausada_en) {
    throw new ErrorApi(409, "La pregunta está en pausa, reanúdala primero")
  }

  const pregunta = await unaFila(
    "SELECT id_pregunta, pista_conceptual, pista_adicional FROM preguntas WHERE id_pregunta = ?",
    [actual.id_pregunta]
  )

  if (tipo.codigo === "conceptual" && !pregunta.pista_conceptual) {
    throw new ErrorApi(409, "Esta pregunta no tiene pista conceptual guardada")
  }
  if (tipo.codigo === "adicional" && !pregunta.pista_adicional) {
    throw new ErrorApi(409, "Esta pregunta no tiene pista adicional guardada")
  }

  await consulta(
    "INSERT INTO pistas_usadas (id_partida, orden, id_tipo_pista) VALUES (?, ?, ?)",
    [idPartida, actual.orden, tipo.id_tipo_pista]
  )

  const partida = await partidaDelUsuario(idPartida, usuario.id_usuario)

  return Response.json({
    pista: await contenidoPista(tipo.codigo, pregunta, idPartida),
    partida: resumenPartida(partida),
  })
})
