import Link from "next/link"

import { Card, CardContent } from "@/components/ui/card"
import { cn } from "@/lib/utils"

export function CarreraCard({ carrera }) {
  return (
    <Link
      href={`/jugar/${carrera.slug}`}
      className="group block h-full rounded-xl focus-visible:ring-[3px] focus-visible:ring-ring/50 focus-visible:outline-none"
    >
      <Card className="h-full py-5 transition-shadow group-hover:shadow-md">
        <CardContent className="flex items-start gap-4">
          <span
            className={cn(
              "flex size-11 shrink-0 items-center justify-center rounded-lg text-sm font-bold",
              carrera.color
            )}
          >
            {carrera.numero}
          </span>
          <div className="space-y-1">
            <h3 className="font-semibold">{carrera.nombre}</h3>
            <p className="text-sm text-muted-foreground">{carrera.descripcion}</p>
            <p className="pt-2 text-xs font-semibold text-primary">10 preguntas · 3 pistas</p>
          </div>
        </CardContent>
      </Card>
    </Link>
  )
}
