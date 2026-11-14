import mysql from "mysql2/promise"

function crearPool() {
  const faltan = ["DB_HOST", "DB_USER", "DB_PASSWORD", "DB_NAME"].filter((nombre) => !process.env[nombre])
  if (faltan.length > 0) {
    throw new Error(`Faltan estas variables en .env.local: ${faltan.join(", ")}`)
  }

  return mysql.createPool({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT || 3306),
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
    charset: "utf8mb4",
    waitForConnections: true,
    connectionLimit: Number(process.env.DB_POOL || 10),
    decimalNumbers: true,
    dateStrings: ["DATE"],
  })
}

export function obtenerPool() {
  if (!globalThis.poolRetoTrivia) {
    globalThis.poolRetoTrivia = crearPool()
  }
  return globalThis.poolRetoTrivia
}

export async function consulta(sql, valores = []) {
  const [resultado] = await obtenerPool().execute(sql, valores)
  return resultado
}

export async function unaFila(sql, valores = []) {
  const filas = await consulta(sql, valores)
  return filas[0] ?? null
}

export async function llamar(sql, valores = []) {
  const [resultado] = await obtenerPool().query(sql, valores)
  return resultado
}
