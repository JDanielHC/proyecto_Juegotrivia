"use client"

import { useState } from "react"
import Link from "next/link"
import { useRouter } from "next/navigation"

import { Button } from "@/components/ui/button"
import { llamarApi } from "@/lib/api-cliente"

export function BotonReto() {
  const router = useRouter()
  const [ocupado, setOcupado] = useState(false)
  const [mensaje, setMensaje] = useState(null)
  const [pideSesion, setPideSesion] = useState(false)

  async function jugar() {
    setOcupado(true)
    setMensaje(null)
    setPideSesion(false)
    try {
      await llamarApi("/api/partidas", { metodo: "POST", datos: { categoria: "mixta", modo: "reto_dia" } })
      router.push("/jugar/reto")
    } catch (e) {
      if (e.estado === 409 && e.datos?.id_partida_en_curso) return router.push("/jugar/reto")

      if (e.estado === 404) setMensaje("Hoy no hay reto del día")
      else if (e.estado === 401) {
        setMensaje("Inicia sesión para jugar el reto.")
        setPideSesion(true)
      } else setMensaje(e.message)
      setOcupado(false)
    }
  }

  return (
    <div className="space-y-2">
      <Button onClick={jugar} disabled={ocupado}>
        {ocupado ? "Abriendo..." : "Jugar reto"}
      </Button>
      {mensaje && (
        <p role="status" className="text-sm font-semibold text-destructive">
          {mensaje}{" "}
          {pideSesion && (
            <Link href="/login" className="text-primary underline">
              Entrar
            </Link>
          )}
        </p>
      )}
    </div>
  )
}
