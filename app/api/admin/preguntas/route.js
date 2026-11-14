import { access } from "node:fs/promises"
import path from "node:path"

import { requerirRol } from "@/lib/auth"
import { consulta } from "@/lib/db"
import { conErrores } from "@/lib/errores"
import { OLLAMA_MODELO } from "@/lib/ollama"

async function hayMaterial(codigo) {
  try {
    await access(path.join(process.cwd(), "material", `${codigo}.txt`))
    return true
  } catch {
    return false
  }
}

export const GET = conErrores(async () => {
  await requerirRol("revisor", "admin")

  const temas = await consulta(
    `SELECT c.codigo, c.nombre AS carrera, t.id_tema, t.nombre AS tema,
            SUM(q.estado_revision = 'aprobada') AS aprobadas,
            SUM(q.estado_revision = 'pendiente') AS pendientes
     FROM categorias c
     JOIN temas t ON t.id_categoria = c.id_categoria AND t.activo = 1
     LEFT JOIN preguntas q ON q.id_tema = t.id_tema
     WHERE c.es_mixta = 0 AND c.activa = 1
     GROUP BY c.id_categoria, t.id_tema
     ORDER BY c.orden, t.nombre`
  )

  const carreras = []
  for (const fila of temas) {
    let carrera = carreras.find((c) => c.codigo === fila.codigo)
    if (!carrera) {
      carrera = { codigo: fila.codigo, nombre: fila.carrera, tiene_material: await hayMaterial(fila.codigo), temas: [] }
      carreras.push(carrera)
    }
    carrera.temas.push({
      id_tema: fila.id_tema,
      nombre: fila.tema,
      aprobadas: Number(fila.aprobadas ?? 0),
      pendientes: Number(fila.pendientes ?? 0),
    })
  }

  const pendientes = await consulta(
    `SELECT q.id_pregunta, q.enunciado, q.dificultad, q.fuente, q.referencia, q.pista_conceptual,
            q.pista_adicional, q.explicacion, q.creada_en, t.nombre AS tema, c.nombre AS carrera
     FROM preguntas q
     JOIN temas t      ON t.id_tema = q.id_tema
     JOIN categorias c ON c.id_categoria = t.id_categoria
     WHERE q.estado_revision = 'pendiente'
     ORDER BY q.creada_en DESC, q.id_pregunta DESC
     LIMIT 50`
  )
  for (const p of pendientes) {
    p.opciones = await consulta(
      "SELECT letra, texto, es_correcta = 1 AS es_correcta FROM opciones WHERE id_pregunta = ? ORDER BY letra",
      [p.id_pregunta]
    )
    p.opciones.forEach((o) => (o.es_correcta = o.es_correcta === 1))
  }

  const espera = await consulta("SELECT valor FROM configuracion_juego WHERE clave = 'segundos_espera_ia'")
  return Response.json({ carreras, pendientes, modelo: OLLAMA_MODELO, segundos_espera: Number(espera[0]?.valor) || 20 })
})
