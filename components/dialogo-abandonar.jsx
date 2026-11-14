"use client"

import { useEffect, useRef } from "react"
import { PauseCircle } from "lucide-react"

import { Button } from "@/components/ui/button"

export function DialogoAbandonar({ abierto, enPausa, ocupado, error, onSeguir, onAbandonar }) {
  const ref = useRef(null)
  const botonSeguir = useRef(null)

  useEffect(() => {
    const dialogo = ref.current
    if (!dialogo) return
    if (abierto && !dialogo.open) dialogo.showModal()
    if (!abierto && dialogo.open) dialogo.close()
  }, [abierto])

  useEffect(() => {
    if (abierto && !ocupado) botonSeguir.current?.focus()
  }, [abierto, ocupado])

  function alCancelar(evento) {
    evento.preventDefault()
    if (!ocupado) onSeguir()
  }

  return (
    <dialog
      ref={ref}
      onCancel={alCancelar}
      aria-labelledby="titulo-abandonar"
      className="m-auto w-[calc(100%-2rem)] max-w-md rounded-xl border-t-4 border-gold bg-card p-0 text-card-foreground shadow-xl backdrop:bg-black/60 backdrop:backdrop-blur-md"
    >
      <div className="space-y-4 p-6">
        <h2 id="titulo-abandonar" className="text-xl font-bold text-primary">
          ¿Abandonar la partida?
        </h2>
        <p className="text-sm text-muted-foreground">
          Si la abandonas no contará para el ranking ni para tus estadísticas.
        </p>

        {enPausa && (
          <p className="flex items-center gap-2 rounded-lg bg-secondary px-3 py-2 text-sm font-semibold text-secondary-foreground">
            <PauseCircle className="size-4 shrink-0 text-gold" />
            El tiempo está detenido mientras decides.
          </p>
        )}

        {error && <p className="text-sm font-semibold text-destructive">{error}</p>}

        <div className="flex flex-col-reverse gap-2 pt-2 sm:flex-row sm:justify-end">
          <Button
            type="button"
            variant="outline"
            disabled={ocupado}
            onClick={onAbandonar}
            className="border-red-200 bg-red-50 text-red-700 hover:bg-red-100 hover:text-red-800"
          >
            Abandonar
          </Button>
          <Button ref={botonSeguir} type="button" disabled={ocupado} onClick={onSeguir}>
            Seguir jugando
          </Button>
        </div>
      </div>
    </dialog>
  )
}
