# Trivia UTH

Este es el proyecto del juego de trivia de las carreras de la UTH.

Esta guía es para que cualquiera del equipo pueda abrir el proyecto, verlo funcionando y ayudar con cambios, **aunque nunca haya usado estas herramientas**. Sigue los pasos en orden y no te saltes ninguno.

---

## Antes de empezar: ¿qué es cada cosa?

- **GitHub:** es una página web donde está guardado el proyecto en línea. Es como un Google Drive, pero para código.
- **GitHub Desktop:** es un programa con botones para **bajar** el proyecto a tu computadora y **subir** tus cambios a GitHub, sin escribir comandos.
- **Visual Studio Code (VS Code):** es el programa donde se abre y se modifica el código. Es como un Word, pero para programar.
- **Node.js:** es lo que hace funcionar el proyecto en tu computadora. Lo instalas una vez y ya no lo tocas.
- **Next.js y shadcn/ui:** son las herramientas con las que está hecho el juego. No tienes que instalarlas aparte, porque vienen dentro del proyecto.

**Importante:** los cambios **no aparecen solos** en las computadoras de los demás, como en Google Docs. Cada persona **sube** sus cambios y **baja** los de los demás con GitHub Desktop.

---

# PARTE 1: Instalar todo (solo se hace una vez)

## Paso 1: Crear tu cuenta de GitHub y aceptar la invitación

1. Entra a **https://github.com** y dale a **Sign up** para crear tu cuenta.
2. Pásale a Jorge tu **nombre de usuario** de GitHub.
3. Te va a llegar un **correo de invitación**. Ábrelo y dale al botón **Accept invitation**.

> Sin aceptar la invitación no vas a poder ver el proyecto, porque es privado.

## Paso 2: Instalar Node.js

1. Entra a **https://nodejs.org/es/download**
2. Abajo, dale al botón verde **Windows Installer (.msi)**.
3. Abre el archivo que se descargó y dale **Next** en todas las ventanas.
4. Si aparece una casilla que dice **"Automatically install the necessary tools"**, **déjala SIN marcar**.

## Paso 3: Instalar Visual Studio Code

1. Entra a **https://code.visualstudio.com** y dale a **Download for Windows**.
2. Instálalo. Cuando aparezcan casillas, **marca todas**.

## Paso 4: Instalar GitHub Desktop

1. Entra a **https://desktop.github.com** y descárgalo.
2. Instálalo y ábrelo.
3. Dale a **Sign in to GitHub.com** e inicia sesión con tu cuenta.
4. Cuando te pida tu nombre y correo, déjalos como aparecen y dale a **Finish**.

## Paso 5: Darle permiso a Windows para ejecutar el proyecto

Windows bloquea algunos programas por seguridad, y eso impide que el proyecto funcione. Esto se arregla una sola vez:

1. Abre el menú **Inicio**, escribe **PowerShell** y ábrelo.
2. Copia y pega esto, y presiona **Enter**:
   ```
   Set-ExecutionPolicy -Scope CurrentUser RemoteSigned
   ```
3. Cuando te pregunte, escribe **S** y presiona **Enter**.
4. Para revisar que Node.js quedó instalado, escribe esto y presiona **Enter**:
   ```
   npm -v
   ```
   Si te sale un número (por ejemplo, `11.20.0`), está todo bien. Ya puedes cerrar PowerShell.

---

# PARTE 2: Descargar el proyecto (solo se hace una vez)

1. Abre **GitHub Desktop**.
2. Arriba, ve a **File > Clone repository…**
3. En la pestaña **GitHub.com**, busca y selecciona **JDanielHC/proyecto_trivia**.
4. En **Local path**, escribe: **`C:\proyectos\proyecto_trivia`**

   > No lo guardes en Documentos ni en el Escritorio, porque OneDrive puede causar errores.

5. Dale al botón azul **Clone** y espera a que termine.

### Conectar GitHub Desktop con VS Code

1. En GitHub Desktop, ve a **File > Options… > Integrations**.
2. En **External editor**, elige **Visual Studio Code**.
3. En **Shell**, elige **PowerShell**.
4. Dale a **Save**.

---

# PARTE 3: Ver el juego funcionando

## La primera vez

1. En GitHub Desktop, ve a **Repository > Open in Visual Studio Code**.
2. Si VS Code te pregunta si confías en la carpeta, dale a **Yes, I trust the authors**.
3. Abre la terminal de VS Code: arriba, ve a **Terminal > New Terminal**. Abajo se abre un cuadro negro.
4. Escribe esto y presiona **Enter**:
   ```
   npm install
   ```
   Esto descarga todo lo que necesita el proyecto. Puede tardar unos minutos. **Espera a que termine.**
5. Ahora escribe esto y presiona **Enter**:
   ```
   npm run dev
   ```
6. Abre tu navegador (Chrome, Edge, etc.) y entra a: **http://localhost:3000**

¡Ya estás viendo el juego!

## Las siguientes veces

Solo repites los pasos **1, 3, 5 y 6**. El paso 4 (`npm install`) solo se vuelve a hacer si alguien avisa que agregó algo nuevo al proyecto, o si te sale un error.

**Mientras `npm run dev` está corriendo:**
- Cada vez que guardes un archivo con **Ctrl + S**, el navegador se actualiza solo.
- Para apagarlo, haz clic en la terminal y presiona **Ctrl + C**.

---

# PARTE 4: Cómo trabajar todos los días

Sigue siempre estos 5 pasos, en este orden:

### 1. Baja los cambios de los demás (siempre ANTES de empezar)
En GitHub Desktop, arriba, dale a **Fetch origin**.
Si el botón cambia a **Pull origin**, dale clic otra vez.

### 2. Abre el proyecto
**Repository > Open in Visual Studio Code**.

### 3. Haz tus cambios
Modifica lo que necesites en VS Code y guarda con **Ctrl + S**.

### 4. Guarda tus cambios en GitHub Desktop (Commit)
1. Vuelve a GitHub Desktop. A la izquierda vas a ver los archivos que cambiaste.
   - En **rojo** está lo que borraste.
   - En **verde** está lo que agregaste.
2. Abajo a la izquierda, en el cuadro **Summary**, escribe en pocas palabras qué hiciste. Por ejemplo:
   - *Agregar preguntas de Derecho*
   - *Cambiar color del botón de inicio*
3. Dale al botón azul **Commit to main**.

### 5. Sube tus cambios (Push)
Arriba, dale a **Push origin**.

¡Listo! Ahora tus compañeros pueden bajar tus cambios con el paso 1.

---

## ¿Dónde está cada cosa en el proyecto?

| Carpeta o archivo | ¿Qué es? |
|---|---|
| `app/page.jsx` | La **página principal** del juego. Es lo que ves en http://localhost:3000 |
| `app/layout.jsx` | El **título de la pestaña** del navegador y la estructura general. |
| `app/globals.css` | Los **colores** y estilos generales, incluidos los colores de la UTH. |
| `components/ui/` | Los **botones, tarjetas y otros diseños** listos para usar. |
| `public/` | Las **imágenes**, como el logo. |
| `material/` | El **material de cada carrera** que se usa para generar preguntas. Un archivo por carrera, por ejemplo `computacion.txt`. |
| `app/admin/preguntas/` | La pantalla para **generar y revisar preguntas** (solo revisores y administradores). |
| `node_modules/` | Archivos internos. **No los toques.** |

---

## Generar preguntas con Ollama

Los revisores y administradores pueden pedirle preguntas nuevas a Ollama desde **http://localhost:3000/admin/preguntas**. Las preguntas salen del material de la carrera (`material/<carrera>.txt`) y siguen el formato de las preguntas ya aprobadas. Quedan **pendientes** hasta que un revisor las aprueba en esa misma pantalla; mientras tanto no salen en el juego.

1. Instala Ollama (https://ollama.com) y descarga el modelo una vez: `ollama pull llama3.2:1b`
2. En `.env.local` pon `OLLAMA_URL` y `OLLAMA_MODELO` (vienen de ejemplo en `.env.example`).
3. Carga las preguntas del equipo: `mariadb -u root -p < database/preguntas_computacion.sql`. Sirven de ejemplo para el modelo.
4. Entra con una cuenta de revisor (por ejemplo `revisor@retotrivia.test`, contraseña `Trivia2026`) y abre `/admin/preguntas`.

### Qué se le manda al modelo

Para que el modelo pequeño no se confunda, solo recibe la parte del material que corresponde al tema:

| Tema | Parte del material |
|---|---|
| Perfil profesional | Sección 1 |
| Plan de estudio | Secciones 2 y 3 |
| Honduras | Sección 5 |
| Temas técnicos (Redes, Bases de datos, Algoritmos...) | Solo su línea de la sección 6 |
| Cualquier otro tema | Todo el material |

Además recibe tres preguntas aprobadas del mismo tema como ejemplo del formato y la lista de preguntas que ya existen. Puede usar los mismos datos, pero la pregunta tiene que ser distinta. La temperatura es 0.2 para que invente menos.

### Cuándo se rechaza una respuesta

El modelo tiene que devolver una **cita**: la frase exacta del material en la que se basa la pregunta. La respuesta se rechaza si:

- la cita no está en la parte del material que se le mandó ("la cita no está en el material"), o es muy corta;
- el enunciado o las opciones dicen "pista" o "pregunta 1" (señal de que habla de las instrucciones);
- hay opciones repetidas, "todas/ninguna de las anteriores", una pista que dice la respuesta o una explicación que nombra una letra;
- la pregunta ya existe o el JSON viene roto.

En el panel de revisión, la cita aparece en el campo **Fuente**, para comprobar rápido de dónde salió la pregunta.

Cada petición queda guardada en la tabla `solicitudes_ia`: cuánto tardó, lo que respondió el modelo y, si falló, por qué. Para agregar otra carrera, crea su archivo en `material/` con el mismo estilo que `computacion.txt` (secciones numeradas y, en la sección 6, una línea por materia que empiece con `- Materia:`).

---

## Reglas del equipo

1. **Siempre** dale a **Fetch origin / Pull origin** antes de empezar a trabajar.
2. **Sube tus cambios seguido.** No esperes varios días.
3. **Avisen en el grupo qué archivo van a modificar**, para que dos personas no cambien el mismo archivo al mismo tiempo.
4. En **Summary** escribe algo claro y serio. Todo queda guardado en el historial del proyecto, y el ingeniero lo puede ver.
5. Si cambiaste algo por error y **todavía no le diste a Commit**, haz clic derecho sobre el archivo en GitHub Desktop y elige **Discard changes…** Así vuelve a quedar como estaba.

---

## Si algo sale mal

| Lo que ves | Qué hacer |
|---|---|
| `No se puede cargar el archivo ... npm.ps1 porque la ejecución de scripts está deshabilitada` | Haz el **Paso 5** de la Parte 1. |
| `El término 'npm' (o 'npx') no se reconoce` | Cierra VS Code por completo y ábrelo de nuevo. Si sigue igual, reinicia la computadora. |
| `Could not read package.json` o `ENOENT` | No estás en la carpeta del proyecto. Abre VS Code desde GitHub Desktop con **Repository > Open in Visual Studio Code**. |
| `ECONNRESET` o `network` | Se cortó el internet. Vuelve a escribir el mismo comando. Si sigue fallando, prueba con otra red. |
| `Port 3000 is in use` | El juego ya está abierto en otra terminal. Ciérrala, o entra a la dirección que te indica (por ejemplo, http://localhost:3001). |
| Mensajes que dicen `warn`, `notice` o `vulnerabilities` | Son **avisos**, no errores. Ignóralos. **No escribas** `npm audit fix --force`. |
| Aviso amarillo en GitHub Desktop sobre **LF** y **CRLF** | No es un error. Ignóralo. |
| Triángulo amarillo junto a "powershell" en VS Code | No es un error. Ignóralo. |
| GitHub Desktop dice que hay un **conflict** (conflicto) | Dos personas cambiaron la misma parte del mismo archivo. **No borres nada**: avisa en el grupo para resolverlo juntos. |

Si te sale algo que no está en esta lista, toma una **captura de pantalla** y mándala al grupo.

---

## Resumen rápido

**Para ver el juego:**
GitHub Desktop → **Repository > Open in Visual Studio Code** → **Terminal > New Terminal** → `npm run dev` → entra a **http://localhost:3000**

**Para trabajar:**
**Fetch / Pull origin** → cambias y guardas en VS Code → escribes en **Summary** → **Commit to main** → **Push origin**
