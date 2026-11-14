"use client"

import { useEffect, useRef, useState } from "react"
import Link from "next/link"
import { useRouter } from "next/navigation"
import { CheckCircle2, Lightbulb, Send, Trophy, XCircle } from "lucide-react"

import { DialogoAbandonar } from "@/components/dialogo-abandonar"
import { Alert, AlertDescription, AlertTitle } from "@/components/ui/alert"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Progress } from "@/components/ui/progress"
import { llamarApi } from "@/lib/api-cliente"
import { numero, puntos, segundos } from "@/lib/formato"
import { cn } from "@/lib/utils"

const TOTAL_PISTAS = 3

const PISTAS = [
  { tipo: "conceptual", numero: 1, titulo: "Pista conceptual" },
  { tipo: "eliminar_dos", numero: 2, titulo: "Eliminar dos opciones" },
  { tipo: "adicional", numero: 3, titulo: "Pista adicional" },
]

function modoDe(carrera) {
  return carrera.modo ?? (carrera.slug === "mixta" ? "mixta" : "normal")
}

function tocaTerminar(partida, pregunta) {
  if (!pregunta?.resultado) return false
  if (partida.total_preguntas != null && pregunta.orden >= partida.total_preguntas) return true
  return partida.modo === "muerte_subita" && !pregunta.resultado.es_correcta
}

export function PartidaClient({ carrera }) {
  const router = useRouter()

  const [fase, setFase] = useState("cargando")
  const [partida, setPartida] = useState(null)
  const [pregunta, setPregunta] = useState(null)
  const [seleccion, setSeleccion] = useState(null)
  const [debeTerminar, setDebeTerminar] = useState(false)
  const [restante, setRestante] = useState(0)
  const [ocupado, setOcupado] = useState(false)
  const [aviso, setAviso] = useState(null)
  const [error, setError] = useState(null)
  const [otra, setOtra] = useState(null)
  const [resumen, setResumen] = useState(null)
  const [dialogo, setDialogo] = useState(false)
  const [errorDialogo, setErrorDialogo] = useState(null)

  const limite = useRef(0)
  const enCamino = useRef(false)
  const arrancada = useRef(false)
  const alArrancar = useRef(null)
  const alAgotarse = useRef(null)
  const agotadoEn = useRef(null)

  function ponerReloj(q) {
    limite.current = Date.now() + (q?.segundos_restantes ?? 0) * 1000
    setRestante(q?.segundos_restantes ?? 0)
  }

  function mostrar(p, q) {
    setPartida(p)
    setPregunta(q)
    setSeleccion(null)
    setDebeTerminar(q?.contestada ? tocaTerminar(p, q) : false)
    ponerReloj(q)
    setFase("jugando")
    if (q?.en_pausa) setDialogo(true)
  }

  function fallo(mensaje) {
    setError(mensaje)
    setFase("error")
  }

  async function paso(accion) {
    if (enCamino.current) return
    enCamino.current = true
    setOcupado(true)
    try {
      await accion()
    } finally {
      enCamino.current = false
      setOcupado(false)
    }
  }

  async function pedirSiguiente(p) {
    try {
      const r = await llamarApi(`/api/partidas/${p.id_partida}/siguiente`, { metodo: "POST" })
      mostrar(r.partida, r.pregunta)
    } catch (e) {
      setPartida(p)
      fallo(e.message)
    }
  }

  async function retomar({ partida: p, pregunta: q }) {
    if (!q) return pedirSiguiente(p)
    mostrar(p, q)
  }

  async function resincronizar(p, mensaje) {
    try {
      const r = await llamarApi(`/api/partidas/${p.id_partida}/pregunta-actual`)
      await retomar(r)
      setAviso(mensaje)
    } catch (e) {
      fallo(e.message)
    }
  }

  async function iniciar() {
    try {
      const r = await llamarApi("/api/partidas", {
        metodo: "POST",
        datos: { categoria: carrera.slug, modo: modoDe(carrera) },
      })
      await pedirSiguiente(r.partida)
    } catch (e) {
      if (e.estado === 401) return setFase("sin-sesion")
      if (e.estado === 404 && carrera.modo === "reto_dia") return setFase("sin-reto")

      const idAbierta = e.datos?.id_partida_en_curso
      if (e.estado === 409 && idAbierta) {
        try {
          const abierta = await llamarApi(`/api/partidas/${idAbierta}/pregunta-actual`)
          const esLaMisma =
            abierta.partida.categoria === carrera.slug && abierta.partida.modo === modoDe(carrera)
          if (esLaMisma) return retomar(abierta)
          setOtra(abierta)
          return setFase("conflicto")
        } catch (e2) {
          return fallo(e2.message)
        }
      }
      fallo(e.message)
    }
  }

  function empezarDeNuevo() {
    setFase("cargando")
    setError(null)
    setAviso(null)
    setResumen(null)
    paso(iniciar)
  }

  function responder(idOpcion) {
    return paso(async () => {
      setAviso(null)
      try {
        const r = await llamarApi(`/api/partidas/${partida.id_partida}/respuestas`, {
          metodo: "POST",
          datos: { id_opcion: idOpcion },
        })
        setPartida(r.partida)
        setPregunta((q) => ({ ...q, contestada: true, resultado: r.resultado }))
        setDebeTerminar(r.debe_terminar)
      } catch (e) {
        await resincronizar(partida, e.message)
      }
    })
  }

  function usarPista(tipo) {
    return paso(async () => {
      setAviso(null)
      try {
        const r = await llamarApi(`/api/partidas/${partida.id_partida}/pistas`, {
          metodo: "POST",
          datos: { tipo },
        })
        setPartida(r.partida)
        setPregunta((q) => ({ ...q, pistas_usadas: [...q.pistas_usadas, r.pista] }))
        if (r.pista.opciones_eliminadas?.includes(seleccion)) setSeleccion(null)
      } catch (e) {
        setAviso(e.message)
      }
    })
  }

  function avanzar() {
    return paso(async () => {
      if (!debeTerminar) return pedirSiguiente(partida)
      try {
        const r = await llamarApi(`/api/partidas/${partida.id_partida}/terminar`, { metodo: "POST" })
        setPartida(r.partida)
        setResumen(r.resumen)
        setFase("fin")
      } catch (e) {
        setAviso(e.message)
      }
    })
  }

  function pedirAbandonar() {
    setErrorDialogo(null)
    setDialogo(true)
    const corriendo = fase === "jugando" && pregunta && !pregunta.contestada && !pregunta.en_pausa
    if (!corriendo) return
    return paso(async () => {
      try {
        const r = await llamarApi(`/api/partidas/${partida.id_partida}/pausa`, { metodo: "POST" })
        setPartida(r.partida)
        setPregunta(r.pregunta)
        ponerReloj(r.pregunta)
      } catch (e) {
        setErrorDialogo(e.message)
      }
    })
  }

  function seguirJugando() {
    const pendiente = fase === "jugando" && pregunta && !pregunta.contestada
    if (!pendiente) return setDialogo(false)
    return paso(async () => {
      try {
        const r = await llamarApi(`/api/partidas/${partida.id_partida}/pausa`, { metodo: "DELETE" })
        setPartida(r.partida)
        setPregunta(r.pregunta)
        ponerReloj(r.pregunta)
        setDialogo(false)
      } catch (e) {
        setDialogo(false)
        await resincronizar(partida, e.message)
      }
    })
  }

  function confirmarAbandono() {
    return paso(async () => {
      try {
        await llamarApi(`/api/partidas/${partida.id_partida}/abandonar`, { metodo: "POST" })
        router.push("/")
      } catch (e) {
        setErrorDialogo(e.message)
      }
    })
  }

  function abandonarOtraYEmpezar() {
    return paso(async () => {
      try {
        await llamarApi(`/api/partidas/${otra.partida.id_partida}/abandonar`, { metodo: "POST" })
        setOtra(null)
        setFase("cargando")
        await iniciar()
      } catch (e) {
        fallo(e.message)
      }
    })
  }

  useEffect(() => {
    alArrancar.current = () => paso(iniciar)
  })

  useEffect(() => {
    if (arrancada.current) return
    arrancada.current = true
    alArrancar.current()
  }, [])

  useEffect(() => {
    alAgotarse.current = () => {
      if (enCamino.current || agotadoEn.current === limite.current) return
      agotadoEn.current = limite.current
      responder(null)
    }
  })

  const esperandoRespuesta =
    fase === "jugando" && pregunta && !pregunta.contestada && !pregunta.en_pausa && !dialogo
  useEffect(() => {
    if (!esperandoRespuesta) return
    const reloj = setInterval(() => {
      const quedan = Math.max(0, (limite.current - Date.now()) / 1000)
      setRestante(quedan)
      if (quedan === 0) alAgotarse.current?.()
    }, 200)
    return () => clearInterval(reloj)
  }, [esperandoRespuesta, pregunta?.orden])

  const titulo = partida
    ? partida.modo === "reto_dia"
      ? "Reto del día"
      : partida.categoria_nombre
    : carrera.nombre

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <h1 className="text-2xl font-bold text-primary">Partida: {titulo}</h1>
        {partida && <Badge variant="secondary">{partida.modo_nombre}</Badge>}
      </div>

      {fase === "cargando" && <p className="text-sm text-muted-foreground">Preparando la partida...</p>}

      {fase === "sin-sesion" && (
        <Aviso titulo="Inicia sesión para jugar" texto="Las partidas se guardan en tu cuenta.">
          <Button asChild>
            <Link href="/login">Entrar</Link>
          </Button>
        </Aviso>
      )}

      {fase === "sin-reto" && (
        <Aviso titulo="Hoy no hay reto del día" texto="Vuelve más tarde o juega una carrera.">
          <Button asChild>
            <Link href="/">Volver al inicio</Link>
          </Button>
        </Aviso>
      )}

      {fase === "error" && (
        <Aviso titulo="No se pudo seguir" texto={error}>
          <Button onClick={partida ? () => paso(() => resincronizar(partida, null)) : empezarDeNuevo}>
            Reintentar
          </Button>
          {partida && (
            <Button variant="outline" onClick={pedirAbandonar}>
              Abandonar partida
            </Button>
          )}
          <Button asChild variant="ghost">
            <Link href="/">Volver al inicio</Link>
          </Button>
        </Aviso>
      )}

      {fase === "conflicto" && otra && (
        <Aviso
          titulo="Ya tienes una partida en curso"
          texto={`Es de ${otra.partida.modo === "reto_dia" ? "Reto del día" : otra.partida.categoria_nombre} (${otra.partida.modo_nombre}). Solo se puede tener una abierta a la vez.`}
        >
          <Button onClick={() => retomar(otra)} disabled={ocupado}>
            Continuar esa partida
          </Button>
          <Button variant="outline" onClick={abandonarOtraYEmpezar} disabled={ocupado}>
            Abandonarla y empezar esta
          </Button>
        </Aviso>
      )}

      {fase === "fin" && resumen && (
        <Final resumen={resumen} partida={partida} onOtraVez={empezarDeNuevo} />
      )}

      {fase === "jugando" && pregunta && (
        <Juego
          partida={partida}
          pregunta={pregunta}
          seleccion={seleccion}
          onSeleccion={setSeleccion}
          restante={restante}
          ocupado={ocupado}
          aviso={aviso}
          debeTerminar={debeTerminar}
          onResponder={() => responder(seleccion)}
          onPista={usarPista}
          onAvanzar={avanzar}
          pausado={dialogo || pregunta.en_pausa}
          onAbandonar={pedirAbandonar}
        />
      )}

      {partida && (
        <DialogoAbandonar
          abierto={dialogo}
          enPausa={Boolean(pregunta?.en_pausa)}
          ocupado={ocupado}
          error={errorDialogo}
          onSeguir={seguirJugando}
          onAbandonar={confirmarAbandono}
        />
      )}
    </div>
  )
}

function Juego({
  partida,
  pregunta,
  seleccion,
  onSeleccion,
  restante,
  ocupado,
  aviso,
  debeTerminar,
  onResponder,
  onPista,
  onAvanzar,
  pausado,
  onAbandonar,
}) {
  const resultado = pregunta.resultado
  const contestada = pregunta.contestada
  const usadas = pregunta.pistas_usadas ?? []
  const eliminadas = usadas.find((p) => p.tipo === "eliminar_dos")?.opciones_eliminadas ?? []
  const total = partida.total_preguntas
  const segundosVisibles = contestada ? 0 : Math.ceil(restante)

  return (
    <>
      <Card className="py-4">
        <CardContent className="space-y-3">
          <div className="flex flex-wrap items-center justify-between gap-2 text-sm font-semibold">
            <span className="text-primary">
              PREGUNTA {pregunta.orden}
              {total ? ` DE ${total}` : ""}
            </span>
            <span>Puntos: {numero(partida.puntos)}</span>
            <span className={cn(!contestada && !pausado && segundosVisibles <= 5 && "text-destructive")}>
              Tiempo restante: {contestada ? "—" : `${segundosVisibles} s`}
              {!contestada && pausado && " (en pausa)"}
            </span>
          </div>
          <Progress value={total ? (pregunta.orden / total) * 100 : 0} aria-label="Avance de la partida" />
        </CardContent>
      </Card>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-[1fr_320px]">
        <Card className="min-w-0">
          <CardHeader>
            <Badge
              variant="outline"
              className="h-auto max-w-full justify-start border-gold text-left break-words whitespace-normal text-gold-foreground"
            >
              {pregunta.carrera} · {pregunta.tema}
            </Badge>
            <CardTitle className="pt-2 text-xl leading-snug">{pregunta.enunciado}</CardTitle>
          </CardHeader>
          <CardContent className="space-y-3">
            {pregunta.opciones.map((opcion) => {
              const quitada = eliminadas.includes(opcion.id_opcion)
              const activa = seleccion === opcion.id_opcion
              const esCorrecta = contestada && resultado?.opcion_correcta === opcion.id_opcion
              const fueMal = contestada && resultado?.opcion_elegida === opcion.id_opcion && !esCorrecta
              return (
                <Button
                  key={opcion.id_opcion}
                  type="button"
                  variant={activa && !contestada ? "default" : "outline"}
                  disabled={quitada || contestada || ocupado}
                  aria-pressed={activa}
                  onClick={() => onSeleccion(opcion.id_opcion)}
                  className={cn(
                    "h-auto w-full justify-start gap-3 py-3 text-left whitespace-normal",
                    quitada && "line-through opacity-40",
                    esCorrecta && "border-emerald-600 bg-emerald-50 text-emerald-900 disabled:opacity-100",
                    fueMal && "border-destructive bg-red-50 text-destructive disabled:opacity-100"
                  )}
                >
                  <span className="flex size-6 shrink-0 items-center justify-center rounded bg-secondary text-xs font-bold text-secondary-foreground">
                    {opcion.letra}
                  </span>
                  {opcion.texto}
                </Button>
              )
            })}

            {!contestada && (
              <div className="flex justify-end pt-2">
                <Button type="button" disabled={!seleccion || ocupado} onClick={onResponder}>
                  <Send />
                  Enviar respuesta
                </Button>
              </div>
            )}

            {contestada && resultado && (
              <>
                <Alert
                  className={cn(
                    resultado.es_correcta ? "border-emerald-600/40 bg-emerald-50" : "border-destructive/40 bg-red-50"
                  )}
                >
                  {resultado.es_correcta ? <CheckCircle2 /> : <XCircle />}
                  <AlertTitle>
                    {resultado.es_correcta
                      ? `¡Correcto! +${resultado.puntos} puntos`
                      : resultado.se_acabo_el_tiempo
                        ? "Se acabó el tiempo"
                        : "Incorrecto"}
                  </AlertTitle>
                  <AlertDescription>
                    {!resultado.es_correcta && <p>La respuesta correcta era la {resultado.letra_correcta}.</p>}
                    <p>{resultado.explicacion}</p>
                  </AlertDescription>
                </Alert>
                <div className="flex justify-end">
                  <Button type="button" onClick={onAvanzar} disabled={ocupado}>
                    {debeTerminar ? "Ver resultado final" : "Siguiente pregunta"}
                  </Button>
                </div>
              </>
            )}

            {aviso && (
              <Alert variant="destructive">
                <AlertDescription>{aviso}</AlertDescription>
              </Alert>
            )}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle className="text-sm font-bold tracking-wide text-primary">PISTAS DISPONIBLES</CardTitle>
            <p className="text-3xl font-bold text-primary">
              {partida.pistas_restantes} de {TOTAL_PISTAS}
            </p>
            <p className="text-xs text-muted-foreground">Cada pista consume un uso.</p>
          </CardHeader>
          <CardContent className="space-y-2">
            {PISTAS.map((pista) => {
              const usada = usadas.some((u) => u.tipo === pista.tipo)
              return (
                <Button
                  key={pista.tipo}
                  type="button"
                  variant="secondary"
                  className="w-full justify-start"
                  disabled={usada || partida.pistas_restantes === 0 || contestada || ocupado}
                  onClick={() => onPista(pista.tipo)}
                >
                  <span className="flex size-5 items-center justify-center rounded-full bg-gold text-xs font-bold text-gold-foreground">
                    {pista.numero}
                  </span>
                  {pista.titulo}
                </Button>
              )
            })}

            {usadas.map((u) => (
              <Alert key={u.tipo} className="mt-3">
                <Lightbulb />
                <AlertTitle>{PISTAS.find((p) => p.tipo === u.tipo)?.titulo}</AlertTitle>
                <AlertDescription>
                  {u.tipo === "eliminar_dos" ? "Se quitaron dos opciones incorrectas." : u.texto}
                </AlertDescription>
              </Alert>
            ))}
          </CardContent>
        </Card>
      </div>

      <Alert className="border-gold/50 bg-amber-50">
        <AlertTitle className="text-amber-900">Regla de las pistas</AlertTitle>
        <AlertDescription className="text-amber-900/90">
          La partida empieza con 3 pistas. Cada pista usada descuenta una y no se recupera hasta
          terminar la partida.
        </AlertDescription>
      </Alert>

      <div className="flex justify-end">
        <Button type="button" variant="ghost" size="sm" onClick={onAbandonar} disabled={ocupado}>
          Abandonar partida
        </Button>
      </div>
    </>
  )
}

function Final({ resumen, partida, onOtraVez }) {
  const filas = [
    { etiqueta: "Puntos por respuestas", valor: puntos(resumen.puntos_respuestas) },
    { etiqueta: "Bono de rapidez", valor: puntos(resumen.bono_rapidez) },
    { etiqueta: "Bono de racha", valor: puntos(resumen.bono_racha) },
    { etiqueta: "Aciertos", valor: `${resumen.aciertos}/${resumen.aciertos + resumen.errores}` },
    { etiqueta: "Tiempo total", valor: segundos(resumen.tiempo_total_seg) },
    { etiqueta: "Pistas usadas", valor: numero(resumen.pistas_usadas) },
  ]
  const esReto = partida.modo === "reto_dia"

  return (
    <Card className="mx-auto w-full max-w-lg">
      <CardHeader className="text-center">
        {resumen.es_record && (
          <Badge className="mx-auto bg-gold text-gold-foreground">
            <Trophy />
            ¡Nuevo récord!
          </Badge>
        )}
        <CardDescription>Partida terminada</CardDescription>
        <CardTitle className="text-4xl text-primary">{puntos(resumen.puntaje_total)}</CardTitle>
      </CardHeader>
      <CardContent className="space-y-4">
        <div className="space-y-2 text-sm">
          {filas.map((f) => (
            <div key={f.etiqueta} className="flex justify-between gap-2 border-b pb-2 last:border-0">
              <span>{f.etiqueta}</span>
              <span className="font-bold text-primary">{f.valor}</span>
            </div>
          ))}
        </div>
        <div className="flex flex-wrap justify-center gap-2">
          {!esReto && <Button onClick={onOtraVez}>Jugar otra vez</Button>}
          <Button asChild variant="outline">
            <Link href="/ranking">Ver ranking</Link>
          </Button>
          <Button asChild variant="ghost">
            <Link href="/">Inicio</Link>
          </Button>
        </div>
      </CardContent>
    </Card>
  )
}

function Aviso({ titulo, texto, children }) {
  return (
    <Card>
      <CardHeader>
        <CardTitle>{titulo}</CardTitle>
        {texto && <CardDescription>{texto}</CardDescription>}
      </CardHeader>
      <CardContent className="flex flex-wrap gap-2">{children}</CardContent>
    </Card>
  )
}
