import { auditar, ipDe, requerirRol } from "@/lib/auth"
import { consulta, unaFila } from "@/lib/db"
import { conErrores, ErrorApi, leerJson } from "@/lib/errores"

export const POST = conErrores(async (request, { params }) => {
  const usuario = await requerirRol("revisor", "admin")
  const idPregunta = Number((await params).id)
  const datos = await leerJson(request)

  if (!["aprobada", "rechazada"].includes(datos.decision)) {
    throw new ErrorApi(400, "La decisión tiene que ser aprobada o rechazada")
  }
  const comentario = datos.comentario ? String(datos.comentario).trim().slice(0, 500) : null

  const pregunta = Number.isInteger(idPregunta) && idPregunta > 0
    ? await unaFila("SELECT id_pregunta, estado_revision FROM preguntas WHERE id_pregunta = ?", [idPregunta])
    : null
  if (!pregunta) {
    throw new ErrorApi(404, "No se encontró la pregunta")
  }
  if (pregunta.estado_revision !== "pendiente") {
    throw new ErrorApi(409, `Esa pregunta ya está ${pregunta.estado_revision}`)
  }

  await consulta(
    "INSERT INTO preguntas_revision (id_pregunta, id_revisor, decision, comentario) VALUES (?, ?, ?, ?)",
    [idPregunta, usuario.id_usuario, datos.decision, comentario]
  )
  await auditar({
    idUsuario: usuario.id_usuario,
    tipo: "cambio",
    accion: "revisar_pregunta",
    tabla: "preguntas",
    idRegistro: String(idPregunta),
    detalle: `Pregunta ${datos.decision}`,
    ip: ipDe(request),
  })

  return Response.json({ id_pregunta: idPregunta, estado: datos.decision })
})
