"use client"

import { useEffect, useState } from "react"
import Link from "next/link"
import { Check, X } from "lucide-react"

import { Alert, AlertDescription } from "@/components/ui/alert"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Label } from "@/components/ui/label"
import { llamarApi } from "@/lib/api-cliente"
import { cn } from "@/lib/utils"

const ESTILO_SELECT =
  "h-9 w-full min-w-0 rounded-md border border-input bg-card px-3 py-1 text-base shadow-xs outline-none focus-visible:border-ring focus-visible:ring-[3px] focus-visible:ring-ring/50 disabled:opacity-50 md:text-sm"

const NOMBRE_ESTADO = {
  tiempo_agotado: "Se acabó el tiempo de espera",
  error: "No se pudo conectar",
  formato_invalido: "Respuesta que no sirve",
}

const NOMBRE_DIFICULTAD = { facil: "Fácil", media: "Media", dificil: "Difícil" }

export default function AdminPreguntasPage() {
  const [estado, setEstado] = useState("cargando")
  const [datos, setDatos] = useState(null)
  const [error, setError] = useState(null)
  const [carrera, setCarrera] = useState("")
  const [tema, setTema] = useState("")
  const [dificultad, setDificultad] = useState("")
  const [cantidad, setCantidad] = useState("1")
  const [generando, setGenerando] = useState(false)
  const [resultados, setResultados] = useState(null)
  const [revisando, setRevisando] = useState(null)

  function aplicar(respuesta) {
    setDatos(respuesta)
    setEstado("listo")
    setCarrera((actual) => actual || respuesta.carreras.find((c) => c.tiene_material)?.codigo || respuesta.carreras[0]?.codigo || "")
  }

  useEffect(() => {
    let vigente = true
    llamarApi("/api/admin/preguntas")
      .then((r) => vigente && aplicar(r))
      .catch((e) => {
        if (!vigente) return
        setError(e.message)
        setEstado(e.estado === 401 ? "sin-sesion" : e.estado === 403 ? "sin-permiso" : "error")
      })
    return () => {
      vigente = false
    }
  }, [])

  async function recargar() {
    try {
      aplicar(await llamarApi("/api/admin/preguntas"))
    } catch (e) {
      setError(e.message)
    }
  }

  async function generar(evento) {
    evento.preventDefault()
    setGenerando(true)
    setResultados(null)
    setError(null)
    try {
      const r = await llamarApi("/api/admin/preguntas/generar", {
        metodo: "POST",
        datos: { id_tema: Number(tema), cantidad: Number(cantidad), dificultad: dificultad || null },
      })
      setResultados(r.resultados)
      await recargar()
    } catch (e) {
      setError(e.message)
    } finally {
      setGenerando(false)
    }
  }

  async function revisar(idPregunta, decision) {
    setRevisando(idPregunta)
    setError(null)
    try {
      await llamarApi(`/api/admin/preguntas/${idPregunta}/revision`, { metodo: "POST", datos: { decision } })
      await recargar()
    } catch (e) {
      setError(e.message)
    } finally {
      setRevisando(null)
    }
  }

  if (estado === "cargando") return <p className="text-sm text-muted-foreground">Cargando...</p>

  if (estado === "sin-sesion" || estado === "sin-permiso") {
    return (
      <Card className="mx-auto max-w-md">
        <CardHeader>
          <CardTitle>{estado === "sin-sesion" ? "Inicia sesión" : "No tienes permiso"}</CardTitle>
          <CardDescription>Esta sección es solo para revisores y administradores.</CardDescription>
        </CardHeader>
        <CardContent>
          <Button asChild>
            <Link href={estado === "sin-sesion" ? "/login" : "/"}>{estado === "sin-sesion" ? "Entrar" : "Volver al inicio"}</Link>
          </Button>
        </CardContent>
      </Card>
    )
  }

  if (estado === "error") {
    return (
      <Alert variant="destructive">
        <AlertDescription>{error}</AlertDescription>
      </Alert>
    )
  }

  const carreraElegida = datos.carreras.find((c) => c.codigo === carrera)
  const temas = carreraElegida?.temas ?? []

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-primary">Banco de preguntas</h1>
        <p className="text-sm text-muted-foreground">
          Genera preguntas con Ollama ({datos.modelo}) a partir del material de la carrera. Quedan pendientes
          hasta que un revisor las apruebe.
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Generar preguntas</CardTitle>
        </CardHeader>
        <CardContent>
          <form onSubmit={generar} className="grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-4">
            <div className="space-y-2">
              <Label htmlFor="carrera">Carrera</Label>
              <select
                id="carrera"
                className={ESTILO_SELECT}
                value={carrera}
                onChange={(e) => {
                  setCarrera(e.target.value)
                  setTema("")
                }}
              >
                {datos.carreras.map((c) => (
                  <option key={c.codigo} value={c.codigo}>
                    {c.nombre}
                    {c.tiene_material ? "" : " (sin material)"}
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="tema">Tema</Label>
              <select id="tema" className={ESTILO_SELECT} value={tema} onChange={(e) => setTema(e.target.value)} required>
                <option value="">Elige un tema</option>
                {temas.map((t) => (
                  <option key={t.id_tema} value={t.id_tema}>
                    {t.nombre} ({t.aprobadas} aprobadas, {t.pendientes} pendientes)
                  </option>
                ))}
              </select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="dificultad">Dificultad</Label>
              <select id="dificultad" className={ESTILO_SELECT} value={dificultad} onChange={(e) => setDificultad(e.target.value)}>
                <option value="">La que elija el modelo</option>
                <option value="facil">Fácil</option>
                <option value="media">Media</option>
                <option value="dificil">Difícil</option>
              </select>
            </div>

            <div className="space-y-2">
              <Label htmlFor="cantidad">Cantidad</Label>
              <select id="cantidad" className={ESTILO_SELECT} value={cantidad} onChange={(e) => setCantidad(e.target.value)}>
                <option value="1">1 pregunta</option>
                <option value="2">2 preguntas</option>
                <option value="3">3 preguntas</option>
              </select>
            </div>

            <div className="space-y-2 sm:col-span-2 lg:col-span-4">
              {carreraElegida && !carreraElegida.tiene_material && (
                <p className="text-sm text-destructive">
                  Falta el material de esta carrera: agrega el archivo material/{carreraElegida.codigo}.txt
                </p>
              )}
              <Button type="submit" disabled={generando || !tema || !carreraElegida?.tiene_material}>
                {generando ? "Generando..." : "Generar"}
              </Button>
              {generando && (
                <p role="status" className="text-sm text-muted-foreground">
                  Cada pregunta puede tardar hasta {datos.segundos_espera} segundos.
                </p>
              )}
            </div>
          </form>

          {resultados && (
            <ul className="mt-4 space-y-1 text-sm" role="status">
              {resultados.map((r, i) => (
                <li key={i} className={r.ok ? "text-primary" : "text-destructive"}>
                  {i + 1}. {r.ok ? "Pregunta generada; quedó pendiente abajo." : `${NOMBRE_ESTADO[r.estado] ?? r.estado}: ${r.mensaje}`}
                </li>
              ))}
            </ul>
          )}
        </CardContent>
      </Card>

      {error && (
        <Alert variant="destructive">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      )}

      <section className="space-y-4">
        <h2 className="text-sm font-bold tracking-wide uppercase">Pendientes de revisión ({datos.pendientes.length})</h2>
        {datos.pendientes.length === 0 && <p className="text-sm text-muted-foreground">No hay preguntas pendientes.</p>}
        {datos.pendientes.map((p) => (
          <PreguntaPendiente key={p.id_pregunta} pregunta={p} ocupado={revisando === p.id_pregunta} onRevisar={revisar} />
        ))}
      </section>
    </div>
  )
}

function PreguntaPendiente({ pregunta, ocupado, onRevisar }) {
  return (
    <Card>
      <CardHeader>
        <div className="flex flex-wrap gap-2">
          <Badge variant="outline" className="h-auto max-w-full border-gold text-left whitespace-normal text-gold-foreground">
            {pregunta.carrera} · {pregunta.tema}
          </Badge>
          <Badge variant="secondary">{NOMBRE_DIFICULTAD[pregunta.dificultad]}</Badge>
          <Badge variant="secondary">{pregunta.fuente === "ia" ? "Generada con Ollama" : "Escrita por el equipo"}</Badge>
        </div>
        <CardTitle className="pt-2 text-lg leading-snug">{pregunta.enunciado}</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4 text-sm">
        <ul className="space-y-1">
          {pregunta.opciones.map((o) => (
            <li
              key={o.letra}
              className={cn("flex gap-2 rounded-md border px-3 py-2", o.es_correcta && "border-emerald-600 bg-emerald-50 text-emerald-900")}
            >
              <span className="font-bold">{o.letra}</span>
              <span className="min-w-0 flex-1">{o.texto}</span>
              {o.es_correcta && <span className="font-semibold">Correcta</span>}
            </li>
          ))}
        </ul>
        <dl className="space-y-2">
          <div>
            <dt className="font-semibold">Pista conceptual</dt>
            <dd className="text-muted-foreground">{pregunta.pista_conceptual}</dd>
          </div>
          <div>
            <dt className="font-semibold">Pista adicional</dt>
            <dd className="text-muted-foreground">{pregunta.pista_adicional}</dd>
          </div>
          <div>
            <dt className="font-semibold">Explicación</dt>
            <dd className="text-muted-foreground">{pregunta.explicacion}</dd>
          </div>
          {pregunta.referencia && (
            <div>
              <dt className="font-semibold">Fuente</dt>
              <dd className="text-muted-foreground">{pregunta.referencia}</dd>
            </div>
          )}
        </dl>
        <div className="flex flex-wrap gap-2">
          <Button type="button" onClick={() => onRevisar(pregunta.id_pregunta, "aprobada")} disabled={ocupado}>
            <Check />
            Aprobar
          </Button>
          <Button
            type="button"
            variant="outline"
            onClick={() => onRevisar(pregunta.id_pregunta, "rechazada")}
            disabled={ocupado}
            className="border-red-200 bg-red-50 text-red-700 hover:bg-red-100 hover:text-red-800"
          >
            <X />
            Rechazar
          </Button>
        </div>
      </CardContent>
    </Card>
  )
}
