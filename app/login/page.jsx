"use client"

import { useState } from "react"
import { useRouter } from "next/navigation"

import { Alert, AlertDescription } from "@/components/ui/alert"
import { Button } from "@/components/ui/button"
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import { llamarApi } from "@/lib/api-cliente"

export default function LoginPage() {
  const router = useRouter()
  const [pestana, setPestana] = useState("entrar")
  const [cargando, setCargando] = useState(false)
  const [error, setError] = useState(null)
  const [aviso, setAviso] = useState(null)
  const [correoEntrar, setCorreoEntrar] = useState("")

  function cambiarPestana(valor) {
    setPestana(valor)
    setError(null)
    setAviso(null)
  }

  async function entrar(evento) {
    evento.preventDefault()
    const form = new FormData(evento.currentTarget)
    setCargando(true)
    setError(null)
    setAviso(null)

    try {
      await llamarApi("/api/sesion", {
        metodo: "POST",
        datos: { correo: correoEntrar, contrasena: form.get("contrasena") },
      })
      router.push("/")
      router.refresh()
    } catch (e) {
      setError(e.message)
      setCargando(false)
    }
  }

  async function registrar(evento) {
    evento.preventDefault()
    const form = new FormData(evento.currentTarget)
    const correo = String(form.get("correo"))
    setCargando(true)
    setError(null)

    try {
      const respuesta = await llamarApi("/api/usuarios", {
        metodo: "POST",
        datos: { alias: form.get("alias"), correo, contrasena: form.get("contrasena") },
      })
      setCorreoEntrar(correo)
      setPestana("entrar")
      setAviso(respuesta.mensaje)
    } catch (e) {
      setError(e.message)
    } finally {
      setCargando(false)
    }
  }

  return (
    <div className="mx-auto w-full max-w-md space-y-4">
      <Tabs value={pestana} onValueChange={cambiarPestana}>
        <TabsList className="grid w-full grid-cols-2">
          <TabsTrigger value="entrar">Iniciar sesión</TabsTrigger>
          <TabsTrigger value="registro">Registrarse</TabsTrigger>
        </TabsList>

        <TabsContent value="entrar">
          <Card>
            <CardHeader>
              <CardTitle>Iniciar sesión</CardTitle>
              <CardDescription>Entra con tu cuenta para guardar tus récords.</CardDescription>
            </CardHeader>
            <CardContent>
              <form onSubmit={entrar} className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="correo-entrar">Correo</Label>
                  <Input
                    id="correo-entrar"
                    type="email"
                    autoComplete="email"
                    placeholder="tucorreo@ejemplo.com"
                    value={correoEntrar}
                    onChange={(e) => setCorreoEntrar(e.target.value)}
                    required
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="clave-entrar">Contraseña</Label>
                  <Input
                    id="clave-entrar"
                    name="contrasena"
                    type="password"
                    autoComplete="current-password"
                    required
                  />
                </div>
                <Button type="submit" className="w-full" disabled={cargando}>
                  {cargando ? "Entrando..." : "Entrar"}
                </Button>
              </form>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="registro">
          <Card>
            <CardHeader>
              <CardTitle>Crear cuenta</CardTitle>
              <CardDescription>El alias es lo único que verán los demás en el ranking.</CardDescription>
            </CardHeader>
            <CardContent>
              <form onSubmit={registrar} className="space-y-4">
                <div className="space-y-2">
                  <Label htmlFor="alias">Alias</Label>
                  <Input
                    id="alias"
                    name="alias"
                    autoComplete="username"
                    placeholder="Estudiante42"
                    minLength={3}
                    maxLength={30}
                    required
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="correo-registro">Correo</Label>
                  <Input
                    id="correo-registro"
                    name="correo"
                    type="email"
                    autoComplete="email"
                    placeholder="tucorreo@ejemplo.com"
                    maxLength={120}
                    required
                  />
                </div>
                <div className="space-y-2">
                  <Label htmlFor="clave-registro">Contraseña</Label>
                  <Input
                    id="clave-registro"
                    name="contrasena"
                    type="password"
                    autoComplete="new-password"
                    minLength={8}
                    maxLength={128}
                    required
                  />
                  <p className="text-xs text-muted-foreground">Mínimo 8 caracteres.</p>
                </div>
                <Button type="submit" className="w-full" disabled={cargando}>
                  {cargando ? "Creando..." : "Crear cuenta"}
                </Button>
              </form>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>

      {error && (
        <Alert variant="destructive" role="alert">
          <AlertDescription>{error}</AlertDescription>
        </Alert>
      )}
      {aviso && (
        <Alert className="border-primary/30 bg-secondary">
          <AlertDescription className="text-secondary-foreground">{aviso}</AlertDescription>
        </Alert>
      )}
    </div>
  )
}
