import crypto from "node:crypto"
import { promisify } from "node:util"
import { cookies } from "next/headers"

import { consulta, unaFila } from "@/lib/db"
import { ErrorApi } from "@/lib/errores"

const scrypt = promisify(crypto.scrypt)

const N = 16384
const R = 8
const P = 1
const LARGO_HASH = 64

const COOKIE_SESION = "rt_sesion"
const HORAS_SESION = Number(process.env.SESION_HORAS || 168)

const HASH_FALSO = `scrypt$${N}$${R}$${P}$${"0".repeat(32)}$${"0".repeat(128)}`

export async function hashContrasena(contrasena) {
  const sal = crypto.randomBytes(16)
  const hash = await scrypt(contrasena, sal, LARGO_HASH, { N, r: R, p: P })
  return `scrypt$${N}$${R}$${P}$${sal.toString("hex")}$${hash.toString("hex")}`
}

export async function verificarContrasena(contrasena, guardado) {
  const partes = String(guardado ?? HASH_FALSO).split("$")
  if (partes.length !== 6 || partes[0] !== "scrypt") return false

  const [, n, r, p, salHex, hashHex] = partes
  const esperado = Buffer.from(hashHex, "hex")
  const calculado = await scrypt(contrasena, Buffer.from(salHex, "hex"), esperado.length, {
    N: Number(n),
    r: Number(r),
    p: Number(p),
  })
  return guardado != null && crypto.timingSafeEqual(esperado, calculado)
}

function hashToken(token) {
  return crypto.createHash("sha256").update(token).digest("hex")
}

export function ipDe(request) {
  const ip = request.headers.get("x-real-ip") || request.headers.get("x-forwarded-for")?.split(",")[0]
  return ip ? ip.trim().slice(0, 45) : null
}

export async function crearSesion(idUsuario, request) {
  const token = crypto.randomBytes(32).toString("base64url")
  const navegador = (request.headers.get("user-agent") || "").slice(0, 255) || null

  await consulta(
    `INSERT INTO sesiones (id_usuario, token_hash, ip, navegador, expira_en)
     VALUES (?, ?, ?, ?, NOW() + INTERVAL ? HOUR)`,
    [idUsuario, hashToken(token), ipDe(request), navegador, HORAS_SESION]
  )

  const almacen = await cookies()
  almacen.set(COOKIE_SESION, token, {
    httpOnly: true,
    sameSite: "lax",
    secure: process.env.COOKIE_SEGURA === "true",
    path: "/",
    maxAge: HORAS_SESION * 3600,
  })
}

export async function usuarioActual() {
  const almacen = await cookies()
  const token = almacen.get(COOKIE_SESION)?.value
  if (!token) return null

  return unaFila(
    `SELECT u.id_usuario, u.alias, r.codigo AS rol
     FROM sesiones s
     JOIN usuarios u ON u.id_usuario = s.id_usuario
     JOIN roles r    ON r.id_rol = u.id_rol
     WHERE s.token_hash = ?
       AND s.cerrada_en IS NULL
       AND s.expira_en > NOW()
       AND u.estado = 'activo'`,
    [hashToken(token)]
  )
}

export async function requerirUsuario() {
  const usuario = await usuarioActual()
  if (!usuario) {
    throw new ErrorApi(401, "Tienes que iniciar sesión")
  }
  return usuario
}

export async function requerirRol(...roles) {
  const usuario = await requerirUsuario()
  if (!roles.includes(usuario.rol)) {
    throw new ErrorApi(403, "No tienes permiso para entrar aquí")
  }
  return usuario
}

export async function cerrarSesion() {
  const almacen = await cookies()
  const token = almacen.get(COOKIE_SESION)?.value
  if (token) {
    await consulta(
      "UPDATE sesiones SET cerrada_en = NOW() WHERE token_hash = ? AND cerrada_en IS NULL",
      [hashToken(token)]
    )
  }
  almacen.delete(COOKIE_SESION)
}

export async function auditar({ idUsuario = null, tipo, accion, tabla = null, idRegistro = null, detalle = null, ip = null }) {
  try {
    await consulta(
      `INSERT INTO auditoria (id_usuario, tipo, accion, tabla, id_registro, detalle, ip)
       VALUES (?, ?, ?, ?, ?, ?, ?)`,
      [idUsuario, tipo, accion, tabla, idRegistro, detalle, ip]
    )
  } catch (error) {
    console.error("No se pudo guardar en la auditoría:", error.message)
  }
}
