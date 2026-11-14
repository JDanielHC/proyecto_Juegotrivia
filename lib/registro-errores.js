import { after } from "next/server"

import { consulta } from "@/lib/db"

export function registrarError(error, request, codigo) {
  const fecha = new Date().toISOString()
  const metodo = request?.method ?? null
  const ruta = request ? new URL(request.url).pathname : null
  const mensaje = String(error?.message ?? error).slice(0, 500)

  console.error(`[${fecha}] Error ${codigo} en ${metodo} ${ruta}: ${mensaje}`)
  if (error?.stack) console.error(error.stack)

  const guardar = () => guardarEnBase({ metodo, ruta, codigo, mensaje, request })
  try {
    after(guardar)
  } catch {
    guardar()
  }
}

async function guardarEnBase({ metodo, ruta, codigo, mensaje, request }) {
  try {
    const { ipDe, usuarioActual } = await import("@/lib/auth")
    const usuario = await usuarioActual().catch(() => null)

    await consulta(
      `INSERT INTO auditoria (id_usuario, tipo, accion, metodo, ruta, codigo_http, detalle, ip)
       VALUES (?, 'error', 'error_api', ?, ?, ?, ?, ?)`,
      [usuario?.id_usuario ?? null, metodo, ruta, codigo, mensaje, request ? ipDe(request) : null]
    )
  } catch (e) {
    console.error(`[${new Date().toISOString()}] No se pudo guardar el error en la base: ${e.message}`)
  }
}
