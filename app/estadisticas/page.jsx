"use client"

import { useEffect, useState } from "react"
import Link from "next/link"

import { Alert, AlertDescription } from "@/components/ui/alert"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Progress } from "@/components/ui/progress"
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from "@/components/ui/table"
import { llamarApi } from "@/lib/api-cliente"
import { numero, porcentaje, puntos, recordMasAlto, segundos, SIN_DATO } from "@/lib/formato"

export default function EstadisticasPage() {
  const [estado, setEstado] = useState("cargando")
  const [datos, setDatos] = useState(null)
  const [error, setError] = useState(null)
  const [intento, setIntento] = useState(0)

  useEffect(() => {
    let vigente = true
    llamarApi("/api/usuarios/me/estadisticas")
      .then((respuesta) => {
        if (!vigente) return
        setDatos(respuesta)
        setEstado("listo")
      })
      .catch((e) => {
        if (!vigente) return
        setError(e.message)
        setEstado(e.estado === 401 ? "sin-sesion" : "error")
      })
    return () => {
      vigente = false
    }
  }, [intento])

  function reintentar() {
    setEstado("cargando")
    setIntento(intento + 1)
  }

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-primary">Estadísticas personales</h1>
        <p className="text-sm text-muted-foreground">
          Tus datos ayudan a identificar en qué áreas tienes más práctica.
        </p>
      </div>

      {estado === "cargando" && <p className="text-sm text-muted-foreground">Cargando estadísticas...</p>}

      {estado === "sin-sesion" && (
        <Card>
          <CardHeader>
            <CardTitle>Inicia sesión para ver tus estadísticas</CardTitle>
            <CardDescription>Solo se guardan las partidas de jugadores con cuenta.</CardDescription>
          </CardHeader>
          <CardContent>
            <Button asChild>
              <Link href="/login">Entrar</Link>
            </Button>
          </CardContent>
        </Card>
      )}

      {estado === "error" && (
        <Alert variant="destructive">
          <AlertDescription className="flex flex-wrap items-center justify-between gap-3">
            {error}
            <Button size="sm" variant="outline" onClick={reintentar}>
              Reintentar
            </Button>
          </AlertDescription>
        </Alert>
      )}

      {estado === "listo" && <Resumen datos={datos} />}
    </div>
  )
}

function Resumen({ datos }) {
  const general = datos.general ?? {}
  const respondidas = general.preguntas_respondidas ?? 0
  const porCarrera = datos.por_carrera ?? []
  const ultimas = datos.ultimas_partidas ?? []
  const record = recordMasAlto(datos.records)
  const hayRespuestas = respondidas > 0

  const tarjetas = [
    { etiqueta: "Preguntas respondidas", valor: numero(respondidas) },
    { etiqueta: "Aciertos", valor: numero(general.aciertos ?? 0) },
    { etiqueta: "Errores", valor: numero(general.errores ?? 0) },
    { etiqueta: "Precisión", valor: hayRespuestas ? porcentaje(general.precision_pct) : SIN_DATO },
    { etiqueta: "Tiempo medio por respuesta", valor: hayRespuestas ? segundos(general.tiempo_medio_seg) : SIN_DATO },
    { etiqueta: "Partidas jugadas", valor: numero(general.partidas_jugadas ?? 0) },
    { etiqueta: "Pistas usadas", valor: numero(general.pistas_usadas ?? 0) },
    { etiqueta: "Puntaje total", valor: puntos(general.puntaje_acumulado ?? 0) },
    { etiqueta: "Récord", valor: puntos(record) },
  ]

  return (
    <>
      {(general.partidas_jugadas ?? 0) === 0 && (
        <Alert className="border-primary/30 bg-secondary">
          <AlertDescription className="flex flex-wrap items-center justify-between gap-3 text-secondary-foreground">
            Todavía no has terminado ninguna partida. Juega una para ver tus estadísticas.
            <Button asChild size="sm">
              <Link href="/">Elegir carrera</Link>
            </Button>
          </AlertDescription>
        </Alert>
      )}

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
        {tarjetas.map((t) => (
          <Card key={t.etiqueta} className="gap-2 py-4">
            <CardHeader className="pb-0">
              <CardDescription>{t.etiqueta}</CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-2xl font-bold text-primary">{t.valor}</p>
            </CardContent>
          </Card>
        ))}
      </div>

      <div className="grid grid-cols-1 gap-6 lg:grid-cols-[1fr_380px]">
        <Card>
          <CardHeader>
            <CardTitle>Precisión por carrera</CardTitle>
          </CardHeader>
          <CardContent className="space-y-4">
            {porCarrera.length === 0 && (
              <p className="text-sm text-muted-foreground">Sin datos todavía.</p>
            )}
            {porCarrera.map((c) => (
              <div
                key={c.id_categoria}
                className="grid grid-cols-[minmax(0,200px)_1fr_52px] items-center gap-3 text-sm"
              >
                <span className="truncate font-semibold" title={c.categoria}>
                  {c.categoria}
                </span>
                <Progress value={Number(c.precision_pct)} aria-label={`Precisión en ${c.categoria}`} />
                <span className="text-right font-bold text-primary">{porcentaje(c.precision_pct)}</span>
              </div>
            ))}
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Últimas partidas</CardTitle>
          </CardHeader>
          <CardContent>
            {ultimas.length === 0 ? (
              <p className="text-sm text-muted-foreground">Sin partidas terminadas.</p>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>Carrera</TableHead>
                    <TableHead className="text-right">Puntos</TableHead>
                    <TableHead className="text-right">Aciertos</TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {ultimas.map((u) => (
                    <TableRow key={u.id_partida}>
                      <TableCell className="whitespace-normal">
                        <span className="block font-semibold">{u.categoria}</span>
                        <span className="text-xs text-muted-foreground">{u.modo}</span>
                      </TableCell>
                      <TableCell className="text-right font-bold text-primary">{puntos(u.puntaje_total)}</TableCell>
                      <TableCell className="text-right text-muted-foreground">
                        {u.aciertos}/{u.aciertos + u.errores}
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </CardContent>
        </Card>
      </div>
    </>
  )
}
