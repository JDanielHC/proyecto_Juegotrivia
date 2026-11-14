export const SIN_DATO = "—"

export function numero(valor) {
  return valor == null ? SIN_DATO : Number(valor).toLocaleString("es-HN")
}

export function porcentaje(valor) {
  return valor == null ? SIN_DATO : `${Number(valor).toLocaleString("es-HN", { maximumFractionDigits: 1 })}%`
}

export function segundos(valor) {
  return valor == null ? SIN_DATO : `${Number(valor).toLocaleString("es-HN", { maximumFractionDigits: 1 })} s`
}

export function puntos(valor) {
  return valor == null ? SIN_DATO : `${numero(valor)} pts`
}

export function recordMasAlto(records = []) {
  return records.length > 0 ? Math.max(...records.map((r) => r.puntaje_total)) : null
}
