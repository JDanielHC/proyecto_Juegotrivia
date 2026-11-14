import "./globals.css"

import { SiteHeader } from "@/components/site-header"

export const metadata = {
  title: "RetoTrivia UTH",
  description: "Trivia de carreras de la UTH con IA sobre Rocky Linux",
}

export default function RootLayout({ children }) {
  return (
    <html lang="es">
      <body className="min-h-screen bg-background font-sans text-foreground antialiased">
        <SiteHeader />
        <main className="mx-auto w-full max-w-6xl px-4 py-8">{children}</main>
        <footer className="border-t py-6 text-center text-xs text-muted-foreground">
          RetoTrivia UTH · Programación para Sistemas Abiertos II
        </footer>
      </body>
    </html>
  )
}
