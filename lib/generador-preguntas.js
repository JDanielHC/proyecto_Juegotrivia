import { randomInt } from "node:crypto"
import { readFile } from "node:fs/promises"
import path from "node:path"

import { consulta, obtenerPool, unaFila } from "@/lib/db"
import { ErrorApi } from "@/lib/errores"
import { ErrorOllama, OLLAMA_MODELO, pedirJson } from "@/lib/ollama"

const LETRAS = ["A", "B", "C", "D"]
const DIFICULTADES = ["facil", "media", "dificil"]

const ESQUEMA = {
  type: "object",
  properties: {
    enunciado: { type: "string" },
    opciones: {
      type: "object",
      properties: { A: { type: "string" }, B: { type: "string" }, C: { type: "string" }, D: { type: "string" } },
      required: LETRAS,
    },
    correcta: { type: "string", enum: LETRAS },
    dificultad: { type: "string", enum: DIFICULTADES },
    pista_conceptual: { type: "string" },
    pista_adicional: { type: "string" },
    explicacion: { type: "string" },
    cita: { type: "string" },
  },
  required: ["enunciado", "opciones", "correcta", "dificultad", "pista_conceptual", "pista_adicional", "explicacion", "cita"],
}

const SECCIONES_DEL_TEMA = {
  "perfil profesional": [1],
  "plan de estudio": [2, 3],
  honduras: [5],
}

const SECCION_DE_MATERIAS = 6

function normalizar(texto) {
  return String(texto ?? "")
    .normalize("NFD")
    .replace(/\p{M}/gu, "")
    .toLowerCase()
    .replace(/\s+/g, " ")
    .trim()
}

function limpio(texto) {
  return String(texto ?? "").replace(/\s+/g, " ").trim()
}

function soloLetras(texto) {
  return normalizar(texto).replace(/[^a-z0-9]+/g, " ").trim()
}

function palabras(texto) {
  return soloLetras(texto)
    .split(" ")
    .filter(Boolean)
    .map((p) => (p.length > 3 && p.endsWith("s") ? p.slice(0, -1) : p))
}

function contiene(texto, buscado) {
  return ` ${palabras(texto).join(" ")} `.includes(` ${palabras(buscado).join(" ")} `)
}

function partirMaterial(material) {
  const secciones = new Map()
  let actual = null
  for (const linea of material.split("\n")) {
    const titulo = /^(\d+)\.\s+\S/.exec(linea)
    if (titulo) {
      actual = Number(titulo[1])
      secciones.set(actual, [])
    }
    if (actual !== null) secciones.get(actual).push(linea)
  }
  return secciones
}

export function materialDelTema(material, nombreTema) {
  const secciones = partirMaterial(material)

  const numeros = SECCIONES_DEL_TEMA[normalizar(nombreTema)] ?? []
  const partes = numeros.filter((n) => secciones.has(n)).map((n) => secciones.get(n).join("\n").trim())
  if (partes.length) return partes.join("\n\n")

  const lineas = (secciones.get(SECCION_DE_MATERIAS) ?? [])
    .map((l) => l.trim())
    .filter((l) => l.startsWith("-") && l.includes(":"))
    .filter((l) => contiene(l.slice(1, l.indexOf(":")), nombreTema))
    .map((l) => l.replace(/^-\s*/, ""))
  if (lineas.length) return lineas.join("\n")

  return material.trim()
}

async function leerMaterial(codigo) {
  try {
    return await readFile(path.join(process.cwd(), "material", `${codigo}.txt`), "utf8")
  } catch {
    throw new ErrorApi(409, `Falta el material de esta carrera (material/${codigo}.txt)`)
  }
}

async function datosDelTema(idTema) {
  const tema = await unaFila(
    `SELECT t.id_tema, t.nombre AS tema, c.id_categoria, c.codigo, c.nombre AS carrera
     FROM temas t JOIN categorias c ON c.id_categoria = t.id_categoria
     WHERE t.id_tema = ? AND t.activo = 1 AND c.activa = 1 AND c.es_mixta = 0`,
    [idTema]
  )
  if (!tema) throw new ErrorApi(404, "Ese tema no existe o no está activo")
  return tema
}

async function ejemplos(tema) {
  const preguntas = await consulta(
    `SELECT q.id_pregunta, q.enunciado, q.dificultad, q.pista_conceptual, q.pista_adicional, q.explicacion
     FROM preguntas q JOIN temas t ON t.id_tema = q.id_tema
     WHERE t.id_categoria = ? AND q.estado_revision = 'aprobada'
       AND q.pista_conceptual IS NOT NULL AND q.pista_adicional IS NOT NULL
     ORDER BY t.id_tema = ? DESC, RAND()
     LIMIT 3`,
    [tema.id_categoria, tema.id_tema]
  )
  for (const p of preguntas) {
    const opciones = await consulta("SELECT letra, texto, es_correcta FROM opciones WHERE id_pregunta = ? ORDER BY letra", [p.id_pregunta])
    p.opciones = Object.fromEntries(opciones.map((o) => [o.letra, o.texto]))
    p.correcta = opciones.find((o) => o.es_correcta === 1)?.letra
  }
  return preguntas.map((p) => ({
    enunciado: p.enunciado,
    opciones: p.opciones,
    correcta: p.correcta,
    dificultad: p.dificultad,
    pista_conceptual: p.pista_conceptual,
    pista_adicional: p.pista_adicional,
    explicacion: p.explicacion,
  }))
}

async function enunciadosExistentes(tema) {
  const filas = await consulta(
    `SELECT q.enunciado, q.id_tema FROM preguntas q JOIN temas t ON t.id_tema = q.id_tema
     WHERE t.id_categoria = ? AND q.estado_revision <> 'rechazada'`,
    [tema.id_categoria]
  )
  return {
    todos: new Set(filas.map((f) => normalizar(f.enunciado))),
    delTema: filas.filter((f) => f.id_tema === tema.id_tema).map((f) => f.enunciado).slice(0, 20),
  }
}

function armarInstrucciones({ tema, material, muestras, existentes, dificultad }) {
  const sistema = `Escribes una pregunta de opción múltiple en español para un juego de trivia de la carrera ${tema.carrera} de la UTH (Honduras). El tema de la pregunta es "${tema.tema}".

Reglas:
1. Usa solo datos que estén en el MATERIAL. No inventes datos, fechas ni números.
2. Copia en la cita la frase exacta del MATERIAL en la que se basa la pregunta, sin cambiarle nada.
3. Escribe cuatro opciones cortas y distintas, con una sola correcta. Las incorrectas tienen que ser creíbles. No uses "todas las anteriores" ni "ninguna de las anteriores".
4. La pregunta y las opciones hablan solo del tema. No hablan de estas reglas, de las pistas ni de otras preguntas.
5. La primera pista ayuda a pensar en la idea, sin decir la respuesta.
6. La segunda pista da un dato extra que ayuda a descartar opciones, sin decir la respuesta.
7. La explicación dice en una o dos oraciones por qué la respuesta correcta es la correcta.
8. Puedes usar los mismos datos que las preguntas que ya existen, pero tu pregunta tiene que ser distinta a todas las de esa lista.
9. En las pistas y en la explicación no nombres letras de opciones.

Responde solo con un objeto JSON con estos campos: enunciado, opciones (A, B, C y D), correcta (la letra de la opción correcta), dificultad (facil, media o dificil), pista_conceptual (la primera pista), pista_adicional (la segunda pista), explicacion y cita.`

  const lista = existentes.length ? existentes.map((e) => `- ${e}`).join("\n") : "- (ninguna)"
  const instruccion = `MATERIAL:
<<<
${material.trim()}
>>>

EJEMPLOS DEL FORMATO (preguntas ya revisadas):
${muestras.map((m) => JSON.stringify(m)).join("\n")}

PREGUNTAS QUE YA EXISTEN:
${lista}

Escribe una pregunta nueva sobre ${tema.tema}${dificultad ? ` con dificultad ${dificultad}` : ""}.`

  return { sistema, instruccion }
}

export function validarPregunta(datos, existentes, dificultadPedida, material) {
  const errores = []
  const p = {
    enunciado: limpio(datos?.enunciado),
    opciones: Object.fromEntries(LETRAS.map((l) => [l, limpio(datos?.opciones?.[l])])),
    correcta: limpio(datos?.correcta).toUpperCase(),
    dificultad: normalizar(datos?.dificultad),
    pista_conceptual: limpio(datos?.pista_conceptual),
    pista_adicional: limpio(datos?.pista_adicional),
    explicacion: limpio(datos?.explicacion),
    cita: limpio(datos?.cita),
  }

  if (p.enunciado.length < 10 || p.enunciado.length > 500) errores.push("el enunciado debe tener de 10 a 500 letras")
  if (existentes.has(normalizar(p.enunciado))) errores.push("la pregunta ya existe")

  const textos = LETRAS.map((l) => p.opciones[l])
  if (textos.some((t) => t.length < 1 || t.length > 255)) errores.push("cada opción debe tener de 1 a 255 letras")
  if (new Set(textos.map(normalizar)).size < 4) errores.push("hay opciones repetidas")
  if (textos.some((t) => /(todas|ninguna) de las anteriores/i.test(t))) errores.push('usa "todas/ninguna de las anteriores"')
  if (!LETRAS.includes(p.correcta)) errores.push("la respuesta correcta no es A, B, C ni D")

  if ([p.enunciado, ...textos].some((t) => /\bpistas?\b|\bpregunta 1\b/.test(normalizar(t)))) {
    errores.push('el enunciado o las opciones dicen "pista" o "pregunta 1"')
  }

  if (!p.cita || !soloLetras(material).includes(soloLetras(p.cita))) errores.push("la cita no está en el material")
  else if (soloLetras(p.cita).length < 15) errores.push("la cita es muy corta")
  else if (p.cita.length > 200) errores.push("la cita es muy larga (máximo 200 letras)")

  if (dificultadPedida) p.dificultad = dificultadPedida
  else if (!DIFICULTADES.includes(p.dificultad)) p.dificultad = "media"

  for (const [campo, nombre] of [["pista_conceptual", "la pista conceptual"], ["pista_adicional", "la pista adicional"]]) {
    if (p[campo].length < 5 || p[campo].length > 300) errores.push(`${nombre} debe tener de 5 a 300 letras`)
  }
  if (p.explicacion.length < 10 || p.explicacion.length > 1000) errores.push("la explicación debe tener de 10 a 1000 letras")

  const correcta = normalizar(p.opciones[p.correcta])
  if (correcta.length >= 4) {
    if (normalizar(p.pista_conceptual).includes(correcta)) errores.push("la pista conceptual dice la respuesta")
    if (normalizar(p.pista_adicional).includes(correcta)) errores.push("la pista adicional dice la respuesta")
  }

  const nombraLetra = /\b(opci[oó]n|letra|inciso|respuesta)\s+[ABCD]\b|\(\s*[ABCD]\s*\)/i
  if ([p.pista_conceptual, p.pista_adicional, p.explicacion].some((t) => nombraLetra.test(t))) {
    errores.push("las pistas o la explicación nombran una letra")
  }

  return { pregunta: p, errores }
}

function mezclar(p) {
  const lista = LETRAS.map((l) => ({ texto: p.opciones[l], correcta: l === p.correcta }))
  for (let i = lista.length - 1; i > 0; i--) {
    const j = randomInt(i + 1)
    ;[lista[i], lista[j]] = [lista[j], lista[i]]
  }
  return {
    ...p,
    opciones: Object.fromEntries(lista.map((o, i) => [LETRAS[i], o.texto])),
    correcta: LETRAS[lista.findIndex((o) => o.correcta)],
  }
}

async function guardar(p, tema, idUsuario) {
  const conexion = await obtenerPool().getConnection()
  try {
    await conexion.beginTransaction()
    const [res] = await conexion.execute(
      `INSERT INTO preguntas (id_tema, enunciado, explicacion, pista_conceptual, pista_adicional, dificultad, fuente, referencia, creado_por)
       VALUES (?, ?, ?, ?, ?, ?, 'ia', ?, ?)`,
      [tema.id_tema, p.enunciado, p.explicacion, p.pista_conceptual, p.pista_adicional, p.dificultad,
        `«${p.cita}» (material/${tema.codigo}.txt)`.slice(0, 255), idUsuario]
    )
    for (const letra of LETRAS) {
      await conexion.execute(
        "INSERT INTO opciones (id_pregunta, letra, texto, es_correcta) VALUES (?, ?, ?, ?)",
        [res.insertId, letra, p.opciones[letra], letra === p.correcta ? 1 : 0]
      )
    }
    await conexion.commit()
    return res.insertId
  } catch (error) {
    await conexion.rollback()
    throw error
  } finally {
    conexion.release()
  }
}

async function registrarSolicitud(datos) {
  try {
    const r = await consulta(
      `INSERT INTO solicitudes_ia (tipo, id_tema, id_pregunta, id_usuario, modelo, instruccion, respuesta,
                                   estado, tiempo_respuesta_ms, mensaje_error)
       VALUES ('pregunta', ?, ?, ?, ?, ?, ?, ?, ?, ?)`,
      [datos.idTema, datos.idPregunta ?? null, datos.idUsuario, OLLAMA_MODELO, datos.instruccion.slice(0, 60000),
        datos.respuesta?.slice(0, 1_000_000) ?? null, datos.estado, datos.ms, datos.mensaje?.slice(0, 500) ?? null]
    )
    return r.insertId
  } catch (error) {
    console.error(`[${new Date().toISOString()}] No se pudo guardar en solicitudes_ia: ${error.message}`)
    return null
  }
}

async function segundosDeEspera() {
  const fila = await unaFila("SELECT valor FROM configuracion_juego WHERE clave = 'segundos_espera_ia'")
  return Number(fila?.valor) || 20
}

export async function generarPregunta({ idTema, idUsuario, dificultad = null }) {
  const tema = await datosDelTema(idTema)
  const material = materialDelTema(await leerMaterial(tema.codigo), tema.tema)
  const [muestras, existentes, segundos] = await Promise.all([ejemplos(tema), enunciadosExistentes(tema), segundosDeEspera()])
  const { sistema, instruccion } = armarInstrucciones({ tema, material, muestras, existentes: existentes.delTema, dificultad })

  const inicio = Date.now()
  const base = { idTema, idUsuario, instruccion: `${sistema}\n\n${instruccion}` }
  let texto = null

  try {
    const r = await pedirJson({ sistema, instruccion, esquema: ESQUEMA, segundos })
    texto = r.texto
    const ms = Date.now() - inicio

    const { pregunta, errores } = validarPregunta(r.datos, existentes.todos, dificultad, material)
    if (errores.length) {
      const mensaje = `La pregunta no sirve: ${errores.join("; ")}`
      await registrarSolicitud({ ...base, respuesta: texto, estado: "formato_invalido", ms, mensaje })
      return { ok: false, estado: "formato_invalido", mensaje }
    }

    let idPregunta
    try {
      idPregunta = await guardar(mezclar(pregunta), tema, idUsuario)
    } catch (error) {
      const mensaje = error.code === "ER_DUP_ENTRY" ? "La pregunta ya existe" : `No se pudo guardar: ${error.message}`
      await registrarSolicitud({ ...base, respuesta: texto, estado: "formato_invalido", ms, mensaje })
      return { ok: false, estado: "formato_invalido", mensaje }
    }

    await registrarSolicitud({ ...base, idPregunta, respuesta: texto, estado: "exitosa", ms })
    return { ok: true, estado: "exitosa", id_pregunta: idPregunta }
  } catch (error) {
    if (!(error instanceof ErrorOllama)) throw error
    await registrarSolicitud({ ...base, respuesta: error.respuesta ?? texto, estado: error.estado, ms: Date.now() - inicio, mensaje: error.message })
    return { ok: false, estado: error.estado, mensaje: error.message }
  }
}
