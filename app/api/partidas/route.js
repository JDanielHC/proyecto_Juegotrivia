import { requerirUsuario } from "@/lib/auth"
import { consulta, unaFila } from "@/lib/db"
import { conErrores, ErrorApi, leerJson } from "@/lib/errores"
import { partidaDelUsuario, resumenPartida } from "@/lib/juego"

export const POST = conErrores(async (request) => {
  const usuario = await requerirUsuario()
  const datos = await leerJson(request)

  const codigoModo = datos.modo ?? (datos.categoria === "mixta" ? "mixta" : "normal")
  const codigoCategoria = datos.categoria ?? (codigoModo === "reto_dia" ? "mixta" : null)

  if (!codigoCategoria) {
    throw new ErrorApi(400, "Falta la categoría")
  }

  const categoria = await unaFila("SELECT id_categoria FROM categorias WHERE codigo = ?", [String(codigoCategoria)])
  if (!categoria) {
    throw new ErrorApi(400, "Esa categoría no existe")
  }

  const modo = await unaFila("SELECT id_modo FROM modos_juego WHERE codigo = ?", [String(codigoModo)])
  if (!modo) {
    throw new ErrorApi(400, "Ese modo de juego no existe")
  }

  let idReto = null
  if (codigoModo === "reto_dia") {
    const reto = await unaFila("SELECT id_reto FROM retos_diarios WHERE fecha = CURDATE()")
    if (!reto) {
      throw new ErrorApi(404, "Hoy no hay reto del día")
    }
    idReto = reto.id_reto
  }

  let resultado
  try {
    resultado = await consulta(
      "INSERT INTO partidas (id_usuario, id_categoria, id_modo, id_reto) VALUES (?, ?, ?, ?)",
      [usuario.id_usuario, categoria.id_categoria, modo.id_modo, idReto]
    )
  } catch (error) {
    if (error.code === "ER_DUP_ENTRY" && /uq_partidas_una_en_curso/.test(error.sqlMessage ?? "")) {
      const abierta = await unaFila(
        "SELECT id_partida FROM partidas WHERE id_usuario = ? AND estado = 'en_curso'",
        [usuario.id_usuario]
      )
      throw new ErrorApi(409, "Ya tienes una partida en curso. Termínala o abandónala primero", {
        id_partida_en_curso: abierta?.id_partida ?? null,
      })
    }
    throw error
  }

  const partida = await partidaDelUsuario(resultado.insertId, usuario.id_usuario)
  return Response.json({ partida: resumenPartida(partida) }, { status: 201 })
})
