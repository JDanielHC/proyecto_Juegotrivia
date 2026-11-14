import {
  auditar,
  cerrarSesion,
  crearSesion,
  ipDe,
  usuarioActual,
  verificarContrasena,
} from "@/lib/auth"
import { consulta, unaFila } from "@/lib/db"
import { conErrores, ErrorApi, leerJson } from "@/lib/errores"

export const GET = conErrores(async () => {
  const usuario = await usuarioActual()
  return Response.json({
    usuario: usuario ? { alias: usuario.alias, rol: usuario.rol } : null,
  })
})

export const POST = conErrores(async (request) => {
  const datos = await leerJson(request)
  const correo = String(datos.correo ?? "").trim().toLowerCase()
  const contrasena = String(datos.contrasena ?? "")

  if (!correo || !contrasena) {
    throw new ErrorApi(400, "Escribe el correo y la contraseña")
  }

  const usuario = await unaFila(
    `SELECT u.id_usuario, u.alias, u.contrasena_hash, u.estado, r.codigo AS rol
     FROM usuarios u
     JOIN roles r ON r.id_rol = u.id_rol
     WHERE u.correo = ?`,
    [correo]
  )

  const correcta = await verificarContrasena(contrasena, usuario?.contrasena_hash ?? null)

  if (!usuario || !correcta) {
    await auditar({
      idUsuario: usuario?.id_usuario ?? null,
      tipo: "acceso",
      accion: "inicio_sesion_fallido",
      detalle: "Correo o contraseña incorrectos",
      ip: ipDe(request),
    })
    throw new ErrorApi(401, "Correo o contraseña incorrectos")
  }

  if (usuario.estado !== "activo") {
    throw new ErrorApi(403, "Esta cuenta no está activa")
  }

  await crearSesion(usuario.id_usuario, request)
  await consulta("UPDATE usuarios SET ultimo_acceso = NOW() WHERE id_usuario = ?", [usuario.id_usuario])
  await auditar({
    idUsuario: usuario.id_usuario,
    tipo: "acceso",
    accion: "inicio_sesion",
    tabla: "sesiones",
    ip: ipDe(request),
  })

  return Response.json({ usuario: { alias: usuario.alias, rol: usuario.rol } })
})

export const DELETE = conErrores(async () => {
  await cerrarSesion()
  return Response.json({ mensaje: "Sesión cerrada" })
})
