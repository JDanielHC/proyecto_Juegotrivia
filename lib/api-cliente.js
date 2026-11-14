export async function llamarApi(ruta, { metodo = "GET", datos } = {}) {
  const opciones = { method: metodo, headers: {} }

  if (datos !== undefined) {
    opciones.headers["Content-Type"] = "application/json"
    opciones.body = JSON.stringify(datos)
  }

  let respuesta
  try {
    respuesta = await fetch(ruta, opciones)
  } catch {
    throw crearError("No hay conexión con el servidor", 0, {})
  }

  const json = await respuesta.json().catch(() => ({}))

  if (!respuesta.ok) {
    throw crearError(json.error ?? "Algo falló, intenta de nuevo", respuesta.status, json)
  }
  return json
}

function crearError(mensaje, estado, datos) {
  const error = new Error(mensaje)
  error.estado = estado
  error.datos = datos
  return error
}
