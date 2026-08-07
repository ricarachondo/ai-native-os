Fuente: https://02ui.com/components/toast/ (consultado 2026-08-05)

# Toast

Mensaje flotante que confirma que algo ya terminó y se retira solo en unos segundos. Todo su contrato es eso: aparece, dice qué terminó, se va sin que nadie tenga que actuar. En el momento en que necesita que alguien decida algo, dejó de ser un toast.

## Cuándo usarlo / Cuándo NO — usa X

Usar toast cuando: algo acaba de terminar y la persona necesita una confirmación breve, no una decisión; el mensaje sigue teniendo sentido aunque la pantalla que lo disparó ya haya cambiado; está bien si alguien no lo alcanza a ver; hay como máximo una acción de deshacer y cabe en un solo botón.

Cuándo NO:
- La condición sigue siendo cierta después de un reload (pago fallido, outage) → usa **banner**.
- El problema es de un campo específico de un formulario → usa **inline field error**.
- Alguien tiene que decidir algo antes de continuar → usa **modal**.
- Es un estado corto, una palabra, no una oración → usa **badge**.

## Variantes

- **Success**: confirma que algo terminó como debía. "File saved."
- **Error**: algo falló; merece duración más larga o sin auto-dismiss, porque la persona todavía necesita leer qué hacer.
- **Promise**: arranca como spinner para una request en curso y cambia su propio ícono/mensaje al resolver, sin mostrar un toast separado por paso.
- **With action**: un botón, normalmente undo, que revierte exactamente lo que el mensaje confirmó.
- **With description**: primera línea en negrita + segunda línea más tenue para detalle que no cabe en una oración (nombre de archivo, tamaño).

## Estados

Entering (slide/fade desde el borde de anclaje, bajo ~300ms) → Visible (corre su timer desde que se renderiza, no desde que alguien lo mira) → Paused (hover o foco detiene el countdown — tiene que funcionar también con foco de teclado, WCAG 2.2.1) → Action pressed (confirmar que la acción realmente terminó antes de que el toast desaparezca) → Stacked (solo importa el más nuevo; los viejos se comprimen o expiran, cap de cuántos renderizan a altura completa) → Exiting (fade/slide reverso, el layout debajo no debe saltar).

## Comportamiento clave

- Se va por timer, no por condición — esa es toda la diferencia con un banner.
- Nunca bloquea la página: sin overlay, sin focus trap.
- Solo importa el más nuevo cuando hay varios apilados.
- Hover o foco de teclado pausa el countdown.
- Se anuncia sin mover el foco: vive en una live region, el foco de teclado queda donde estaba.

## Accesibilidad

- `role="status"` (`aria-live="polite"`) para la mayoría; `role="alert"` (`aria-live="assertive"`) para un error que valga la pena interrumpir.
- No es parte del tab order normal salvo que tenga foco; Tab alcanza la acción o el botón de cerrar; Escape lo descarta.
- Pausar el timer en `:hover` y `:focus-within` (acomodo que pide WCAG 2.2.1).
- Contraste 4.5:1 del texto contra el fondo, chequeado por cada variante de severidad (WCAG 1.4.3).
- Nunca solo color: el ícono y el texto cargan el significado (WCAG 1.4.1).
- Target size 24×24px CSS para el botón de cerrar y de acción (WCAG 2.5.8).

## Copy

- Tiempo pasado: "File saved" / "Invite sent", no "Saving...".
- Nombrar el objeto: "Report.pdf deleted" mejor que "Item deleted".
- Label de la acción literal: "Undo" deshace, "View" navega — nunca algo vago como "Details".
- Omitir el toast si la confirmación ya es visible en otro lado de la pantalla (ej. un checkmark verde ya mostrado).

## Errores comunes

1. Toast para una condición que sigue siendo cierta mañana (pago fallido, trial vencido) — eso es un banner.
2. Sin pausa en hover/foco: leer se vuelve una carrera contra un timer que nadie aceptó.
3. Error que se auto-descarta como si fuera un success — necesita tiempo para leerse.
4. Toasts apilándose sin límite: cinco confirmaciones a la vez y las cuatro más viejas se pierden.
5. Toast que tapa el control que la persona necesita a continuación.
6. Botón de undo cuando ya no hay nada que deshacer.

## Casos borde

- Varios toasts en sucesión rápida: cap de 3 a 5 a altura completa, reemplazar o apilar el resto.
- Tab pierde foco mientras el toast está visible: su timer sigue corriendo en background — decidir si debe seguir ahí al volver.
- Acción duplicada: debounce/disable del trigger que confirmó, para que no se pueda hacer undo dos veces.
- RTL: ícono, acción y botón de cerrar se reflejan al lado opuesto; el toast ancla al borde opuesto.
- `prefers-reduced-motion`: cortar el slide/fade a un cambio de opacidad o sin animación.

## Componentes relacionados

- **Banner**: mensaje que se queda hasta que cambia la condición de fondo — usar en vez de toast si la condición sobrevive un reload.
- **Badge and tag**: estado corto que el sistema setea.
- **Modal**: bloquea la página hasta que la tarea se resuelve o cancela — usar cuando hace falta una decisión.

Distinción clave del sitio: toast vs banner se resuelve con una sola pregunta — ¿el mensaje sigue siendo cierto después de un reload? Si sí, banner. Si confirma algo que ya terminó y no queda nada que trackear, toast.
