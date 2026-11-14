export const OLLAMA_URL = process.env.OLLAMA_URL || "http://127.0.0.1:11434"
export const OLLAMA_MODELO = process.env.OLLAMA_MODELO || "llama3.2:1b"

export class ErrorOllama extends Error {
  constructor(estado, mensaje, respuesta = null) {
    super(mensaje)
    this.estado = estado
    this.respuesta = respuesta
  }
}

export async function pedirJson({ sistema, instruccion, esquema, segundos }) {
  let respuesta
  try {
    respuesta = await fetch(`${OLLAMA_URL}/api/generate`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        model: OLLAMA_MODELO,
        system: sistema,
        prompt: instruccion,
        format: esquema,
        stream: false,
        options: { temperature: 0.2, num_ctx: 8192 },
      }),
      signal: AbortSignal.timeout(segundos * 1000),
    })
  } catch (error) {
    if (error.name === "TimeoutError" || error.name === "AbortError") {
      throw new ErrorOllama("tiempo_agotado", `Ollama no respondió en ${segundos} segundos`)
    }
    throw new ErrorOllama("error", `No se pudo conectar con Ollama en ${OLLAMA_URL}`)
  }

  const cuerpo = await respuesta.text()
  if (!respuesta.ok) {
    throw new ErrorOllama("error", `Ollama respondió ${respuesta.status}: ${cuerpo.slice(0, 200)}`, cuerpo)
  }

  let texto
  try {
    texto = JSON.parse(cuerpo).response ?? ""
  } catch {
    throw new ErrorOllama("formato_invalido", "La respuesta de Ollama no es JSON", cuerpo)
  }

  try {
    return { texto, datos: JSON.parse(texto) }
  } catch {
    throw new ErrorOllama("formato_invalido", "El modelo no devolvió un JSON válido", texto)
  }
}
