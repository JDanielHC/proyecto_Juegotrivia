import { hashContrasena } from "@/lib/auth"
import { consulta, unaFila } from "@/lib/db"
import { conErrores, ErrorApi, leerJson } from "@/lib/errores"

export const POST = conErrores(async (request) => {
  const datos = await leerJson(request)
  const alias = String(datos.alias ?? "").trim()
  const correo = String(datos.correo ?? "").trim().toLowerCase()
  const contrasena = String(datos.contrasena ?? "")

  if (!/^[\p{L}\p{N}_.-]{3,30}$/u.test(alias)) {
    throw new ErrorApi(400, "El alias debe tener de 3 a 30 letras o números, sin espacios")
  }
  if (correo.length > 120 || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(correo)) {
    throw new ErrorApi(400, "El correo no es válido")
  }
  if (contrasena.length < 8 || contrasena.length > 128) {
    throw new ErrorApi(400, "La contraseña debe tener entre 8 y 128 caracteres")
  }

  const rol = await unaFila("SELECT id_rol FROM roles WHERE codigo = 'jugador'")
  const hash = await hashContrasena(contrasena)

  const resultado = await consulta(
    "INSERT INTO usuarios (id_rol, alias, correo, contrasena_hash) VALUES (?, ?, ?, ?)",
    [rol.id_rol, alias, correo, hash]
  )

  return Response.json(
    { id_usuario: resultado.insertId, alias, mensaje: "Cuenta creada, ya puedes iniciar sesión" },
    { status: 201 }
  )
})
