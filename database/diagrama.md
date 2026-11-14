# Diagrama de la base de datos de RetoTrivia UTH

Son 20 tablas. Los rankings, récords y estadísticas no aparecen porque son vistas que se sacan de `partidas` y `respuestas`.

Para verlo: GitHub lo dibuja solo, y en VS Code se ve con la extensión "Markdown Preview Mermaid Support".

```mermaid
erDiagram
    roles ||--o{ usuarios : "tiene"
    usuarios ||--o{ sesiones : "abre"
    usuarios ||--o{ partidas : "juega"
    usuarios ||--o{ preguntas_revision : "revisa"
    usuarios ||--o{ reportes_pregunta : "reporta"
    usuarios |o--o{ preguntas : "crea"
    usuarios |o--o{ solicitudes_ia : "pide"
    usuarios |o--o{ auditoria : "aparece en"
    usuarios |o--o{ configuracion_juego : "cambia"
    usuarios |o--o{ retos_diarios : "arma"

    categorias ||--o{ temas : "tiene"
    temas ||--o{ preguntas : "agrupa"
    temas |o--o{ solicitudes_ia : "se pide"
    preguntas ||--|{ opciones : "tiene 4"
    preguntas ||--o{ preguntas_revision : "se revisa"
    preguntas ||--o{ reportes_pregunta : "recibe"
    preguntas |o--o{ solicitudes_ia : "sale de"

    categorias ||--o{ partidas : "se juega en"
    modos_juego ||--o{ partidas : "define"
    retos_diarios |o--o{ partidas : "se juega en"
    retos_diarios ||--|{ reto_diario_preguntas : "tiene 5"
    preguntas ||--o{ reto_diario_preguntas : "entra en"

    partidas ||--|{ partida_preguntas : "muestra"
    preguntas ||--o{ partida_preguntas : "sale en"
    partida_preguntas ||--o| respuestas : "se contesta"
    opciones |o--o{ respuestas : "elegida en"
    partida_preguntas ||--o{ pistas_usadas : "gasta"
    tipos_pista ||--o{ pistas_usadas : "es de tipo"
    partidas |o--o{ reportes_pregunta : "origen"

    roles {
        tinyint id_rol PK
        varchar codigo UK
        varchar nombre UK
    }
    usuarios {
        int id_usuario PK
        tinyint id_rol FK
        varchar alias UK
        varchar correo UK
        varchar contrasena_hash
        enum estado
        datetime ultimo_acceso
    }
    sesiones {
        int id_sesion PK
        int id_usuario FK
        char token_hash UK
        datetime expira_en
        datetime cerrada_en
    }
    categorias {
        tinyint id_categoria PK
        varchar codigo UK
        varchar nombre UK
        tinyint es_mixta "solo una puede ser 1"
        tinyint orden UK
    }
    temas {
        smallint id_tema PK
        tinyint id_categoria FK
        varchar nombre
    }
    preguntas {
        int id_pregunta PK
        smallint id_tema FK
        varchar enunciado
        varchar explicacion
        varchar pista_conceptual
        varchar pista_adicional
        enum dificultad
        enum fuente "manual o ia"
        enum estado_revision
        int creado_por FK
    }
    opciones {
        int id_opcion PK
        int id_pregunta FK
        char letra "A a D"
        varchar texto
        tinyint es_correcta "solo una por pregunta"
    }
    preguntas_revision {
        int id_revision PK
        int id_pregunta FK
        int id_revisor FK
        enum decision
        varchar comentario
    }
    reportes_pregunta {
        int id_reporte PK
        int id_pregunta FK
        int id_usuario FK
        int id_partida FK
        enum motivo
        enum estado
        int atendido_por FK
    }
    modos_juego {
        tinyint id_modo PK
        varchar codigo UK
        tinyint cantidad_preguntas
        tinyint termina_al_fallar
        tinyint cuenta_para_ranking
    }
    partidas {
        int id_partida PK
        int id_usuario FK
        tinyint id_categoria FK
        tinyint id_modo FK
        int id_reto FK
        enum estado
        smallint aciertos
        smallint puntos_respuestas
        smallint bono_rapidez
        smallint bono_racha
        smallint puntaje_total "se calcula solo"
        decimal tiempo_total_seg
        tinyint total_pistas "0 a 3"
    }
    partida_preguntas {
        int id_partida PK, FK
        smallint orden PK
        int id_pregunta FK
        datetime mostrada_en
        datetime hora_limite
        datetime pausada_en "vacío si no está en pausa"
        tinyint pausas
        decimal segundos_pausa
    }
    respuestas {
        int id_partida PK, FK
        smallint orden PK, FK
        int id_pregunta FK
        int id_opcion FK "vacía si se acabó el tiempo"
        tinyint es_correcta
        decimal segundos
        smallint puntos
    }
    tipos_pista {
        tinyint id_tipo_pista PK
        varchar codigo UK
    }
    pistas_usadas {
        int id_pista_usada PK
        int id_partida FK
        smallint orden FK
        tinyint id_tipo_pista FK
        tinyint numero_uso "1 a 3"
    }
    retos_diarios {
        int id_reto PK
        date fecha UK
        int creado_por FK
    }
    reto_diario_preguntas {
        int id_reto PK, FK
        tinyint orden PK "1 a 5"
        int id_pregunta FK
    }
    solicitudes_ia {
        int id_solicitud PK
        enum tipo
        smallint id_tema FK
        int id_pregunta FK
        int id_usuario FK
        enum estado
        int tiempo_respuesta_ms
        varchar mensaje_error
        tinyint uso_respaldo
    }
    configuracion_juego {
        tinyint id_config PK
        varchar clave UK
        decimal valor
        decimal valor_min
        decimal valor_max
        int actualizado_por FK
    }
    auditoria {
        bigint id_auditoria PK
        int id_usuario FK
        enum tipo
        varchar accion
        varchar metodo
        varchar ruta
        smallint codigo_http
        json datos_antes
        json datos_despues
    }
```

## Vistas

| Vista | Sale de |
|---|---|
| `v_preguntas_publicas` | preguntas, temas, categorias |
| `v_opciones_publicas` | opciones, preguntas |
| `v_records_categoria` | partidas, modos_juego |
| `v_ranking_categoria` | v_records_categoria, categorias, usuarios |
| `v_ranking_principal` | v_records_categoria, categorias, usuarios |
| `v_ranking_mixta` | v_records_categoria, categorias, usuarios |
| `v_ranking_reto_diario` | partidas, retos_diarios, usuarios |
| `v_estadisticas_usuario` | usuarios, partidas, respuestas |
| `v_estadisticas_usuario_categoria` | respuestas, partidas, preguntas, temas, v_records_categoria |
| `v_ultimas_partidas` | partidas, categorias, modos_juego |
