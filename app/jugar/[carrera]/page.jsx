import { notFound } from "next/navigation"

import { PartidaClient } from "@/components/partida-client"
import { carreras, mixta } from "@/lib/carreras"

const reto = { slug: "mixta", nombre: "Reto del día", modo: "reto_dia" }

export default async function JugarPage({ params }) {
  const { carrera: slug } = await params
  const carrera = slug === "reto" ? reto : [...carreras, mixta].find((c) => c.slug === slug)

  if (!carrera) notFound()

  return <PartidaClient key={slug} carrera={carrera} />
}
