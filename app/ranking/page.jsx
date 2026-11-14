"use client"

import { useEffect, useRef, useState } from "react"
import Link from "next/link"

import { Alert, AlertDescription } from "@/components/ui/alert"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { llamarApi } from "@/lib/api-cliente"
import { porcentaje, puntos, recordMasAlto, segundos, SIN_DATO } from "@/lib/formato"

const PESTANAS = [
  { valor: "principal", texto: "General" },
  { valor: "computacion", texto: "Computación" },
  { valor: "derecho", texto: "Derecho" },
  { valor: "psicologia", texto: "Psicología" },
  { valor: "electronica", texto: "Electrónica" },
  { valor: "mixta", texto: "Mixta" },
  { valor: "reto", texto: "Reto del día" },
]

async function pedirRanking(tipo) {
  try {
    const respuesta = await llamarApi(`/api/rankings/${tipo}`)
    return { estado: "listo", filas: respuesta.ranking ?? [], fecha: respuesta.fecha ?? null }
  } catch (e) {
    if (tipo === "reto" && e.estado === 404) return { estado: "sin-reto" }
    return { estado: "error", error: e.message }
  }
}

export default function RankingPage() {
  const [tipo, setTipo] = useState("principal")
  const [rankings, setRankings] = useState({})
  const pedidos = useRef(new Set(["principal"]))

  function guardar(t, entrada) {
    setRankings((anteriores) => ({ ...anteriores, [t]: entrada }))
  }

  async function cargar(t) {
    pedidos.current.add(t)
    guardar(t, await pedirRanking(t))
  }

  useEffect(() => {
    let vigente = true
    pedirRanking("principal").then((entrada) => {
      if (vigente) setRankings((anteriores) => ({ ...anteriores, principal: entrada }))
    })
    return () => {
      vigente = false
    }
  }, [])

  function cambiarPestana(t) {
    setTipo(t)
    if (!pedidos.current.has(t)) cargar(t)
  }

  function reintentar(t) {
    guardar(t, undefined)
    cargar(t)
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-primary">Ranking UTH</h1>
        <p className="text-sm text-muted-foreground">
          Un récord es tu mejor resultado; el ranking ordena los resultados de varios jugadores.
        </p>
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-[1fr_320px]">
        <Tabs value={tipo} onValueChange={cambiarPestana} className="min-w-0">
          <TabsList className="h-auto w-full flex-wrap justify-start">
            {PESTANAS.map((p) => (
              <TabsTrigger key={p.valor} value={p.valor} className="h-8 flex-none">
                {p.texto}
              </TabsTrigger>
            ))}
          </TabsList>
          {PESTANAS.map((p) => (
            <TabsContent key={p.valor} value={p.valor}>
              <TablaRanking entrada={rankings[p.valor]} onReintentar={() => reintentar(p.valor)} />
            </TabsContent>
          ))}
        </Tabs>

        <div className="space-y-4">
          <Card>
            <CardHeader>
              <Badge variant="outline" className="w-fit border-gold text-gold-foreground">
                ¿Cómo se calcula?
              </Badge>
              <CardTitle className="pt-2 text-base leading-snug">
                Ranking principal = suma del mejor récord del jugador en Computación, Derecho,
                Psicología y Electrónica.
              </CardTitle>
            </CardHeader>
            <CardContent>
              <p className="text-sm font-semibold text-primary">
                La sección Mixta tiene su ranking propio.
              </p>
            </CardContent>
          </Card>

          <TusEstadisticas />
        </div>
      </div>
    </div>
  )
}

function TablaRanking({ entrada, onReintentar }) {
  if (!entrada) {
    return <Mensaje>Cargando ranking...</Mensaje>
  }

  if (entrada.estado === "error") {
    return (
      <Alert variant="destructive">
        <AlertDescription className="flex flex-wrap items-center justify-between gap-3">
          {entrada.error}
          <Button size="sm" variant="outline" onClick={onReintentar}>
            Reintentar
          </Button>
        </AlertDescription>
      </Alert>
    )
  }

  if (entrada.estado === "sin-reto") {
    return <Mensaje>Hoy no hay reto del día.</Mensaje>
  }

  if (entrada.filas.length === 0) {
    return <Mensaje>Todavía nadie aparece en este ranking. ¡Juega una partida y sé el primero!</Mensaje>
  }

  return (
    <Card className="py-2">
      <CardContent className="px-2">
        {entrada.fecha && (
          <p className="px-2 pt-2 text-xs text-muted-foreground">Reto del {entrada.fecha}</p>
        )}
        <Table>
          <TableHeader>
            <TableRow>
              <TableHead className="w-16">Puesto</TableHead>
              <TableHead>Jugador</TableHead>
              <TableHead className="text-right">Puntaje</TableHead>
            </TableRow>
          </TableHeader>
          <TableBody>
            {entrada.filas.map((fila) => (
              <TableRow key={fila.alias}>
                <TableCell className="font-bold text-primary">{fila.posicion}</TableCell>
                <TableCell className="max-w-0 truncate font-semibold" title={fila.alias}>
                  {fila.alias}
                </TableCell>
                <TableCell className="text-right font-bold">{puntos(fila.puntaje)}</TableCell>
              </TableRow>
            ))}
          </TableBody>
        </Table>
      </CardContent>
    </Card>
  )
}

function Mensaje({ children }) {
  return (
    <Card className="py-6">
      <CardContent>
        <p className="text-sm text-muted-foreground">{children}</p>
      </CardContent>
    </Card>
  )
}

function TusEstadisticas() {
  const [estado, setEstado] = useState("cargando")
  const [datos, setDatos] = useState(null)

  useEffect(() => {
    let vigente = true
    llamarApi("/api/usuarios/me/estadisticas")
      .then((respuesta) => {
        if (!vigente) return
        setDatos(respuesta)
        setEstado("listo")
      })
      .catch((e) => {
        if (vigente) setEstado(e.estado === 401 ? "sin-sesion" : "error")
      })
    return () => {
      vigente = false
    }
  }, [])

  const general = datos?.general ?? {}
  const hayRespuestas = (general.preguntas_respondidas ?? 0) > 0

  const filas = [
    { etiqueta: "Precisión general", valor: hayRespuestas ? porcentaje(general.precision_pct) : SIN_DATO },
    { etiqueta: "Tiempo medio", valor: hayRespuestas ? segundos(general.tiempo_medio_seg) : SIN_DATO },
    { etiqueta: "Récord personal", valor: puntos(recordMasAlto(datos?.records)) },
  ]

  return (
    <Card className="border-primary/30 bg-secondary">
      <CardHeader>
        <CardTitle className="text-sm font-bold text-secondary-foreground">TUS ESTADÍSTICAS</CardTitle>
      </CardHeader>
      <CardContent className="space-y-2 text-sm">
        {estado === "cargando" && <p className="text-muted-foreground">Cargando...</p>}

        {estado === "sin-sesion" && (
          <p>
            <Link href="/login" className="font-semibold text-primary underline">
              Inicia sesión
            </Link>{" "}
            para ver tus datos.
          </p>
        )}

        {estado === "error" && <p className="text-muted-foreground">No se pudieron cargar tus datos.</p>}

        {estado === "listo" &&
          filas.map((f) => (
            <div key={f.etiqueta} className="flex justify-between gap-2">
              <span>{f.etiqueta}</span>
              <span className="font-bold text-primary">{f.valor}</span>
            </div>
          ))}
      </CardContent>
    </Card>
  )
}
