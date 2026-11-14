import { registrarError } from "@/lib/registro-errores"

export class ErrorApi extends Error {
  constructor(estado, mensaje, extra = {}) {
    super(mensaje)
    this.estado = estado
    this.extra = extra
  }
}

const DUPLICADOS = {
  uq_usuarios_alias: "Ese alias ya está en uso",
  uq_usuarios_correo: "Ese correo ya está registrado",
  uq_partidas_una_en_curso: "Ya tienes una partida en curso. Termínala o abandónala primero",
  uq_partidas_un_intento_reto: "Ya jugaste el reto de hoy, solo hay un intento por día",
  uq_pistas_tipo_por_pregunta: "Ya usaste esa pista en esta pregunta",
  uq_pistas_numero: "Ya se usaron las 3 pistas de esta partida",
}

const SIN_BASE = ["ECONNREFUSED", "ETIMEDOUT", "ENOTFOUND", "PROTOCOL_CONNECTION_LOST", "ER_ACCESS_DENIED_ERROR", "ER_BAD_DB_ERROR", "ER_CON_COUNT_ERROR"]

function convertir(error) {
  if (error instanceof ErrorApi) {
    return Response.json({ error: error.message, ...error.extra }, { status: error.estado })
  }

  if (error?.sqlState === "45000") {
    return Response.json({ error: error.sqlMessage }, { status: 409 })
  }

  if (error?.code === "ER_DUP_ENTRY") {
    const llave = /for key '(?:[^']*\.)?([^']+)'/.exec(error.sqlMessage ?? "")?.[1]
    return Response.json({ error: DUPLICADOS[llave] ?? "Eso ya estaba guardado" }, { status: 409 })
  }

  if (error?.code === "ER_CONSTRAINT_FAILED" || error?.errno === 4025) {
    return Response.json({ error: error.sqlMessage }, { status: 400 })
  }

  if (error?.code === "ER_NO_REFERENCED_ROW_2") {
    return Response.json({ error: "Uno de los datos enviados no existe" }, { status: 400 })
  }

  if (SIN_BASE.includes(error?.code)) {
    return Response.json({ error: "No hay conexión con la base de datos" }, { status: 503 })
  }

  return Response.json({ error: "Algo falló en el servidor, intenta de nuevo" }, { status: 500 })
}

export async function responderError(error, request) {
  const respuesta = convertir(error)
  if (respuesta.status >= 500) {
    try {
      registrarError(error, request, respuesta.status)
    } catch (e) {
      console.error("No se pudo registrar el error:", e?.message)
    }
  }
  return respuesta
}

export function conErrores(manejador) {
  return async (request, contexto) => {
    try {
      return await manejador(request, contexto)
    } catch (error) {
      return responderError(error, request)
    }
  }
}

export async function leerJson(request) {
  let datos = null
  try {
    datos = await request.json()
  } catch {
    datos = null
  }
  if (!datos || typeof datos !== "object" || Array.isArray(datos)) {
    throw new ErrorApi(400, "El cuerpo de la petición tiene que ser un objeto JSON")
  }
  return datos
}

export function idDeRuta(valor) {
  const id = Number(valor)
  if (!Number.isInteger(id) || id <= 0) {
    throw new ErrorApi(404, "No se encontró la partida")
  }
  return id
}
