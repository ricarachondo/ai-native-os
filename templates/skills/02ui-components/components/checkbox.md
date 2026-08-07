Fuente: https://02ui.com/components/checkbox/ (consultado 2026-08-05)

# Checkbox

Permite elegir cualquier número de opciones de un conjunto, incluido ninguna. El cambio espera un guardado o submit — esa es la línea que lo separa de un switch. Build difficulty: Easy, pero uno de los componentes más fáciles de usar mal.

## Cuándo usarlo / Cuándo NO

Usar checkbox cuando: se puede elegir varias opciones (o ninguna) de una lista; se necesita confirmar un sí/no antes de enviar un formulario; una opción padre controla un set de hijos y necesita estado mixto; el cambio debe aplicarse al guardar, no al hacer clic.

Cuándo NO — usa otro componente:
- El cambio aplica de inmediato sin paso de guardado → **switch**.
- Debe elegirse exactamente una opción de un set visible → **radio group**.
- Más de ~10 opciones → **multi-select combobox**.
- Marcar ejecuta una acción (filtrar, borrar) → **button**.

Pregunta clave (checkbox vs switch): ¿cuándo aplica el cambio? Si aplica al clic → switch. Si espera un guardado/submit → checkbox. Estar en una pantalla de settings no lo vuelve switch automáticamente, ni estar en un form lo vuelve checkbox automáticamente.

## Variantes

Single (una respuesta sí/no: términos, "recuérdame", "enviarme copia"), con descripción (línea extra para consecuencias que el label no puede cargar), agrupado (varias opciones relacionadas bajo un legend — el caso común), y padre con estado mixto (vale la pena solo si el grupo es lo bastante largo como para que "seleccionar todo" ahorre esfuerzo real; bajo ~5 ítems agrega un control que nadie necesita).

## Estados

Unchecked, Checked, Mixed (estado de display, no de valor — no se puede clicar hacia él, se setea en código con `el.indeterminate = true`, nunca se envía), Focus, Disabled (necesita explicación de por qué está deshabilitado, cerca del control), Disabled+Checked, Error (va en el grupo, no en el checkbox individual — cuando un grupo requiere al menos una selección, ningún checkbox individual es "el culpable"; el mensaje va bajo el legend y el foco se mueve al grupo en submit).

## Comportamiento

El cambio espera — es el componente entero. Si el checkbox guarda al hacer clic, en realidad se construyó un switch con el dibujo equivocado. Clicar el label lo activa también (gratis si el markup está bien — probarlo clicando el texto, no la caja). Sin sorpresas en cascada: marcar uno no debería marcar/desmarcar otro, salvo un padre explícito. Orden estable: nunca reordenar opciones con una seleccionada. Solo opciones independientes: si marcar A hace imposible B, no son checkboxes — son radio group o dos preguntas separadas.

## Accesibilidad

- Grupo relacionado necesita `<fieldset>` + `<legend>` — sin esto, un lector de pantalla escucha cada label sin saber qué pregunta responde. Un checkbox standalone no necesita fieldset (su propio label es toda la pregunta).
- Teclado: Tab mueve al siguiente checkbox (cada uno es su propio tab stop, a diferencia de los radios); Space activa; Enter no hace nada en el checkbox (envía el form si existe) — el error más común al reconstruir desde cero.
- Contraste: borde sin marcar 3:1 contra la página; el tick 3:1 contra la caja rellena.
- Nunca color solo — un estado de error necesita mensaje, no solo caja roja.
- Target size 24×24px (WCAG 2.5.8); envolver caja+label en un solo `<label>` normalmente lo logra sin redibujar nada.
- Espaciado: mínimo 8px entre checkboxes adyacentes.

## Copy

Escribir en positivo ("Enviarme actualizaciones" > "No enviarme actualizaciones" — desmarcar un negativo son dos operaciones mentales). Decir qué hace marcar ("Guardar mi tarjeta para la próxima" es claro; "Guardado de tarjeta" no). Sentence case, sin punto final. Palabra significativa al frente (la gente escanea las primeras dos palabras: "Newsletter semanal" > "Recibir nuestro newsletter semanal"). Consecuencias van en la descripción, no en el label. Nunca pre-marcar consentimiento — pre-marcar consentimiento de marketing es ilegal bajo GDPR, y pre-marcar cualquier cosa con costo es lo que la gente recuerda de un producto.

## Errores comunes

1. Checkbox donde el cambio es inmediato — el más común; sin botón de guardar, es un switch.
2. Labels negativos ("No enviarme emails" hace que marcado signifique "off").
3. Sin fieldset en un grupo.
4. Checkboxes custom hechos con divs — pierden Space, el anillo de foco, submit del form, estado mixto y autofill del navegador.
5. Tap targets del tamaño de la caja (16px se ve bien pero es difícil de tocar).
6. Disparar una acción al marcar (buscar, borrar, filtrar) — eso necesita un button.
7. Cajas pre-marcadas con costo (consentimiento, add-ons, suscripciones) — convierte una vez y cuesta confianza permanentemente.

## Casos borde

Labels largos envuelven — alinear la caja con la primera línea, no centrada verticalmente contra varias líneas. RTL: la caja se mueve a la derecha del label. Un checkbox requerido (términos) necesita su propio mensaje de error y el foco debe moverse a él en submit fallido. Listas muy largas (>~10) se vuelven tediosas de escanear — agregar filtro de búsqueda o migrar a multi-select combobox. Windows High Contrast Mode: ticks dibujados con bordes pueden desaparecer — testear y usar `forced-colors`. Si el checkbox sí guarda inmediatamente (decisión de producto), igual hay que decirlo, mostrar confirmación de guardado y manejar el caso de fallo — un fallo silencioso hace creer que algo cambió cuando no fue así.

## Componentes relacionados

- **Radio group**: muestra todas las opciones a la vez, elige exactamente una.
- **Switch**: enciende/apaga algo y aplica el cambio de inmediato.
- **Select**: elige una opción de una lista oculta hasta abrirse.
- **Text field**: input de una línea para texto libre.
