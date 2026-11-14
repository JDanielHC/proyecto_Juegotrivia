"use client"

import { useEffect, useState } from "react"
import Link from "next/link"
import Image from "next/image"
import { usePathname, useRouter } from "next/navigation"

import { Button } from "@/components/ui/button"
import { llamarApi } from "@/lib/api-cliente"

const enlaces = [
  { href: "/", texto: "Inicio" },
  { href: "/ranking", texto: "Ranking" },
  { href: "/estadisticas", texto: "Estadísticas" },
]

export function SiteHeader() {
  const pathname = usePathname()
  const router = useRouter()
  const [usuario, setUsuario] = useState(undefined)
  const [saliendo, setSaliendo] = useState(false)

  useEffect(() => {
    let vigente = true
    llamarApi("/api/sesion")
      .then((datos) => vigente && setUsuario(datos.usuario))
      .catch(() => vigente && setUsuario(null))
    return () => {
      vigente = false
    }
  }, [pathname])

  async function salir() {
    setSaliendo(true)
    try {
      await llamarApi("/api/sesion", { metodo: "DELETE" })
      setUsuario(null)
      router.push("/")
      router.refresh()
    } catch {
    } finally {
      setSaliendo(false)
    }
  }

  return (
    <header className="border-b-4 border-gold bg-card">
      <div className="mx-auto hidden h-16 w-full max-w-6xl items-center justify-between px-4 min-[481px]:flex">
        <Link href="/" className="flex items-center gap-3 rounded-md focus-visible:ring-[3px] focus-visible:ring-ring/50 focus-visible:outline-none">
          <Image
            src="/logo-uth.png"
            alt="Universidad Tecnológica de Honduras"
            width={96}
            height={33}
            priority
          />
          <span className="hidden text-sm font-bold tracking-wide sm:inline">
            TRIVIA DE CARRERAS
          </span>
        </Link>

        <nav className="flex items-center gap-1" aria-label="Navegación principal">
          {enlaces.map(({ href, texto }) => (
            <Button
              key={href}
              asChild
              size="sm"
              variant={pathname === href ? "secondary" : "ghost"}
            >
              <Link href={href} aria-current={pathname === href ? "page" : undefined}>
                {texto}
              </Link>
            </Button>
          ))}

          {usuario === undefined && <span className="ml-2 w-20" aria-hidden="true" />}

          {usuario === null && (
            <Button asChild size="sm" variant="outline" className="ml-2">
              <Link href="/login">Entrar</Link>
            </Button>
          )}

          {usuario && (
            <div className="ml-2 flex items-center gap-2">
              <span
                className="hidden max-w-32 truncate text-sm font-semibold text-primary md:inline"
                title={usuario.alias}
              >
                {usuario.alias}
              </span>
              <Button size="sm" variant="outline" onClick={salir} disabled={saliendo}>
                {saliendo ? "Saliendo..." : "Salir"}
              </Button>
            </div>
          )}
        </nav>
      </div>

      <div className="space-y-2 px-4 py-2 min-[481px]:hidden">
        <div className="flex min-h-8 items-center justify-between gap-2">
          <Link
            href="/"
            className="shrink-0 rounded-md text-sm font-bold tracking-wide focus-visible:ring-[3px] focus-visible:ring-ring/50 focus-visible:outline-none"
          >
            TRIVIA DE CARRERAS
          </Link>

          {usuario === null && (
            <Button asChild size="sm" variant="outline">
              <Link href="/login">Entrar</Link>
            </Button>
          )}

          {usuario && (
            <span className="min-w-0 truncate text-sm font-semibold text-primary" title={usuario.alias}>
              {usuario.alias}
            </span>
          )}
        </div>

        <nav className="flex items-center justify-between gap-1" aria-label="Navegación principal">
          {enlaces.map(({ href, texto }) => (
            <Button
              key={href}
              asChild
              size="sm"
              variant={pathname === href ? "secondary" : "ghost"}
              className="px-2"
            >
              <Link href={href} aria-current={pathname === href ? "page" : undefined}>
                {texto}
              </Link>
            </Button>
          ))}

          {usuario && (
            <Button size="sm" variant="outline" className="px-2" onClick={salir} disabled={saliendo}>
              {saliendo ? "Saliendo..." : "Salir"}
            </Button>
          )}
        </nav>
      </div>
    </header>
  )
}
