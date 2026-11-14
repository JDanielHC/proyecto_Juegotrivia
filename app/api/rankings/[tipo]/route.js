import { consulta, unaFila } from "@/lib/db"
import { conErrores, ErrorApi } from "@/lib/errores"

export const GET = conErrores(async (request, { params }) => {
  const { tipo } = await params
  const url = new URL(request.url)
  const limite = Math.min(Math.max(Number.parseInt(url.searchParams.get("limite") ?? "50", 10) || 50, 1), 100)

  if (tipo === "principal") {
    const filas = await consulta(
      `SELECT posicion, alias, puntaje FROM v_ranking_principal ORDER BY posicion LIMIT ${limite}`
    )
    return Response.json({ tipo, titulo: "Ranking principal", ranking: filas })
  }

  if (tipo === "mixta") {
    const filas = await consulta(
      `SELECT posicion, alias, puntaje FROM v_ranking_mixta ORDER BY posicion LIMIT ${limite}`
    )
    return Response.json({ tipo, titulo: "Mixta UTH", ranking: filas })
  }

  if (tipo === "reto") {
    const fecha = url.searchParams.get("fecha")
    if (fecha !== null && !/^\d{4}-\d{2}-\d{2}$/.test(fecha)) {
      throw new ErrorApi(400, "La fecha tiene que ir así: 2026-11-07")
    }
    const reto = await unaFila(
      "SELECT id_reto, fecha FROM retos_diarios WHERE fecha = COALESCE(?, CURDATE())",
      [fecha]
    )
    if (!reto) {
      throw new ErrorApi(404, "No hay reto del día para esa fecha")
    }
    const filas = await consulta(
      `SELECT posicion, alias, puntaje FROM v_ranking_reto_diario
       WHERE id_reto = ? ORDER BY posicion LIMIT ${limite}`,
      [reto.id_reto]
    )
    return Response.json({ tipo, titulo: "Reto del día", fecha: reto.fecha, ranking: filas })
  }

  const carrera = await unaFila(
    "SELECT id_categoria, nombre FROM categorias WHERE codigo = ? AND es_mixta = 0",
    [String(tipo)]
  )
  if (!carrera) {
    throw new ErrorApi(404, "Ese ranking no existe. Usa principal, mixta, reto o el código de una carrera")
  }
  const filas = await consulta(
    `SELECT posicion, alias, puntaje FROM v_ranking_categoria
     WHERE id_categoria = ? ORDER BY posicion LIMIT ${limite}`,
    [carrera.id_categoria]
  )
  return Response.json({ tipo, titulo: carrera.nombre, ranking: filas })
})
