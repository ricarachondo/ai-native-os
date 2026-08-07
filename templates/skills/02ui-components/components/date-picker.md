Fuente: https://02ui.com/components/date-picker/ (consultado 2026-08-05)

# Date picker

Abre un calendario para elegir una fecha tocándola, en vez de tecleándola. Ese cambio (seis-ocho caracteres tecleados vs. abrir calendario + tocar día) solo vale la pena cuando ver los días aporta algo que escribir no puede dar.

## Cuándo usarlo / cuándo NO

Usar cuando:
- La fecha está lo bastante lejos o es lo bastante desconocida como para que verla junto al día de la semana ayude a ubicarla.
- Se elige un rango (check-in/check-out) donde ver ambos extremos en un calendario es mejor que dos campos separados.
- Hay que descartar visualmente ciertas fechas (días agotados, cierres del negocio).

Usar otra cosa cuando:
- La fecha es cercana o memorizada (fecha de nacimiento, aniversario) — usar un **text field** con hint de formato visible.
- La elección real es un puñado de opciones con nombre (Hoy, Mañana, Próxima semana) — usar un **select de presets**.
- El valor necesita hora además de fecha — usar text field + control de hora aparte.

## Variantes

- **Range**: dos fechas de un mismo calendario, días intermedios sombreados en cuanto se eligen ambos extremos.
- **Con fechas deshabilitadas**: días específicos no clickeables (reservados, cerrados).
- **Inline**: calendario sin trigger ni popover, cuando la fecha es la decisión principal del flujo (ej. reservas).

## Estados

Empty, Filled, Focus, Error (`aria-invalid="true"`, borde rojo, mensaje debajo), Disabled, Open. El error más común: que "hoy" y "seleccionado" compartan el mismo color/relleno — hoy necesita un marcador (outline/punto) distinto del relleno de seleccionado; si coinciden, deben combinarse visualmente, no elegir uno solo.

## Comportamiento

- Abrir el calendario no compromete nada; la fecha solo se fija al hacer click/confirmar un día.
- El calendario abre en el mes relevante (si se edita una fecha existente, abre en su mes, no en el mes actual).
- Días fuera de rango (antes de min/después de max) se ven distintos de días puntualmente bloqueados (feriados) — no deben confundirse visualmente.
- Un picker de fecha única cierra al seleccionar; un picker de rango permanece abierto tras el primer click.

## Accesibilidad

- Teclado: flechas mueven foco día a día; Page Up/Down mueve mes; Home/End saltan a inicio/fin de semana; Enter/Espacio elige; Escape cierra sin cambiar valor.
- Seguir el patrón WAI-ARIA de grid: `role="grid"` en el cuerpo del calendario, cada semana una fila, cada día un `gridcell`.
- Nombre accesible inequívoco por día: "Wednesday, July 29, 2026", nunca solo "29".
- Anunciar el cambio de mes en navegación (live region o heading actualizado, no solo repintar).
- Contraste 3:1 en el borde del trigger (WCAG 1.4.11) y en el relleno del día seleccionado contra el fondo del grid.
- Target size mínimo 24×24 CSS px por celda (WCAG 2.5.8).

## Copy

- Trigger muestra fecha completa y no ambigua una vez elegida: "29 Jul 2026", nunca "29/07/26".
- Placeholder nombra formato o acción: "Choose a date", nunca un "Select" desnudo.
- Mensajes en fechas deshabilitadas explican el motivo cuando importa: "Fully booked" al hover/focus.
- Labels de rango nombran ambos extremos: "Check-in" / "Check-out", no un "Dates" ambiguo.

## Errores comunes

1. Date picker para una fecha bien conocida (fecha de nacimiento) — obliga a retroceder décadas de meses.
2. Formato numérico ambiguo en el trigger ("03/04/26" — día-primero vs. mes-primero).
3. Sin salto rápido de mes/año — solo flechas de mes a mes es lentísimo para fechas lejanas.
4. "Hoy" y "seleccionado" con el mismo tratamiento visual.
5. Días deshabilitados sin explicación (agotado vs. fuera de rango vs. pasado).
6. Sin fallback de entrada tecleada — castiga a quien ya sabe la fecha exacta.

## Casos borde

- Fecha tecleada fuera de rango: validar en blur/submit con mensaje específico ("Check-out must be after July 29"), no "Invalid date" genérico.
- Años bisiestos y meses de distinta duración: calcular días reales, no asumir 30/31.
- Zonas horarias: una fecha-momento (cita) necesita zona explícita; una fecha-calendario sin componente de hora (deadline) no debe desplazarse por el reloj del navegador.
- RTL: el grid se espeja, incluyendo hacia qué lado apunta "next month".
- Usuario de teclado con rango largo: dropdowns de mes/año en el header, no solo Page Up/Down.

## Componentes relacionados

- **Text field**: alternativa cuando la fecha se sabe de memoria.
- **Select**: alternativa cuando la elección real son presets con nombre.
