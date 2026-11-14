import { auditar, ipDe, requerirRol } from "@/lib/auth"
import { conErrores, ErrorApi, leerJson } from "@/lib/errores"
import { generarPregunta } from "@/lib/generador-preguntas"

export const POST = conErrores(async (request) => {
  const usuario = await requerirRol("revisor", "admin")
  const datos = await leerJson(request)

  const idTema = Number(datos.id_tema)
  if (!Number.isInteger(idTema) || idTema <= 0) {
    throw new ErrorApi(400, "Elige un tema")
  }
  const cantidad = Number(datos.cantidad ?? 1)
  if (!Number.isInteger(cantidad) || cantidad < 1 || cantidad > 3) {
    throw new ErrorApi(400, "Se pueden pedir de 1 a 3 preguntas a la vez")
  }
  const dificultad = datos.dificultad || null
  if (dificultad && !["facil", "media", "dificil"].includes(dificultad)) {
    throw new ErrorApi(400, "La dificultad tiene que ser facil, media o dificil")
  }

  const resultados = []
  for (let i = 0; i < cantidad; i++) {
    resultados.push(await generarPregunta({ idTema, idUsuario: usuario.id_usuario, dificultad }))
  }

  const buenas = resultados.filter((r) => r.ok).length
  await auditar({
    idUsuario: usuario.id_usuario,
    tipo: "cambio",
    accion: "generar_preguntas",
    tabla: "preguntas",
    detalle: `Tema ${idTema}: ${buenas} de ${cantidad} preguntas generadas`,
    ip: ipDe(request),
  })

  return Response.json({ resultados })
})
