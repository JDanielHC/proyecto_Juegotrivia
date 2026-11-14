import Link from "next/link"

import { BotonReto } from "@/components/boton-reto"
import { CarreraCard } from "@/components/carrera-card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import { carreras, mixta } from "@/lib/carreras"

export default function InicioPage() {
  return (
    <div className="space-y-8">
      <section className="rounded-2xl bg-primary p-6 text-primary-foreground sm:p-8">
        <h1 className="text-2xl font-bold sm:text-3xl">¡Bienvenido a RetoTrivia UTH!</h1>
        <p className="mt-1 text-primary-foreground/80">
          Pon a prueba lo que sabes de las carreras de la universidad.
        </p>
      </section>

      <div className="grid gap-6 lg:grid-cols-[320px_1fr]">
        <Card className="h-fit">
          <CardHeader>
            <Badge variant="outline" className="w-fit border-gold text-gold-foreground">
              Reto del día
            </Badge>
            <CardTitle className="pt-2 text-xl text-primary">Trivia Mixta</CardTitle>
            <CardDescription>
              5 preguntas de las cuatro carreras. El reto es igual para todos hoy.
            </CardDescription>
          </CardHeader>
          <CardFooter>
            <BotonReto />
          </CardFooter>
        </Card>

        <section className="space-y-4">
          <h2 className="text-sm font-bold tracking-wide uppercase">Elige una carrera</h2>
          <div className="grid gap-4 sm:grid-cols-2">
            {carreras.map((carrera) => (
              <CarreraCard key={carrera.slug} carrera={carrera} />
            ))}
          </div>

          <Card className="border-primary/30 bg-secondary py-5">
            <CardContent className="flex flex-wrap items-center justify-between gap-4">
              <div className="flex items-center gap-4">
                <span className="flex size-11 shrink-0 items-center justify-center rounded-lg bg-gold text-sm font-bold text-gold-foreground">
                  {mixta.numero}
                </span>
                <div>
                  <h3 className="font-semibold text-secondary-foreground">{mixta.nombre}</h3>
                  <p className="text-sm text-secondary-foreground/80">{mixta.descripcion}</p>
                </div>
              </div>
              <Button asChild>
                <Link href="/jugar/mixta">Jugar mixta</Link>
              </Button>
            </CardContent>
          </Card>
        </section>
      </div>
    </div>
  )
}
