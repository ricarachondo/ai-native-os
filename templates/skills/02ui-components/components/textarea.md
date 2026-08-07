Fuente: https://02ui.com/components/textarea/ (consultado 2026-08-05)

## Qué es
Un textarea es un input multi-línea para texto más largo que una línea: un comentario, una dirección, un reporte de bug. Su altura visible funciona como una instrucción implícita sobre cuánto se espera que la persona escriba (dar 5 filas visibles produce respuestas cercanas a 5 líneas). `<textarea>`.

## Cuándo usarlo / Cuándo NO
Usar textarea cuando: la respuesta podría correr a más de una línea (comentario, dirección, descripción de bug), no se puede predecir el largo de antemano, los saltos de línea tienen significado (dirección pegada, mensaje formateado), o el contenido merece más espacio para redactar que una sola línea.

Usar otra cosa cuando:
- La respuesta cabe en una línea (nombre, asunto) → **Text field**.
- La respuesta es una de un set pequeño y conocido → **Select**.
- Se eligen varias opciones de un set conocido, no se redactan oraciones → grupo de **checkboxes**.

## Variantes
Autosizing (crece con el contenido usando `field-sizing: content`, sin JS; requiere `max-height` para que una respuesta extrema haga scroll interno en vez de empujar el submit fuera de vista), Fixed height con resize manual (número fijo de filas + resize handle nativo activo — razonable cuando la mayoría de respuestas caben y la excepción larga se puede arrastrar), Con character count (el conteo va debajo de la caja, se actualiza al escribir, y solo cambia a color de advertencia cerca del límite — es información, no un marcador de puntaje constante).

## Estados
Default (borde/fill 3:1 contra la página, WCAG 1.4.11), Focus (borde accent + ring, nunca sin reemplazo), Filled (valor con más contraste que el placeholder), Near limit (el contador cambia a color de advertencia — el color NO puede ser la única señal, WCAG 1.4.1, el número mismo debe cambiar), Error (borde rojo, mensaje debajo, `aria-invalid="true"`), Disabled (opacidad reducida, no focuseable, no se envía), Read only (fondo plano sin borde, sigue focuseable, se envía, se puede seleccionar).

El estado "near limit" merece construirse deliberadamente: un contador que solo aparece en cero caracteres restantes ya falló como advertencia.

## Comportamiento
Tab mueve el foco fuera de la caja, no inserta un tab dentro (atrapar Tab para insertar un carácter tab es correcto solo en un editor de código, incorrecto en cualquier otro lugar — es un bug de accesibilidad común en campos custom). Enter siempre inserta salto de línea; un textarea nunca envía el formulario con Enter (por eso es la elección incorrecta para una respuesta de una línea que sí espera ese comportamiento). El crecimiento necesita techo: autosizing sin `max-height` crece indefinidamente con un paste largo, arrastrando el resto del formulario — poner límite y dejar scroll interno. Los espacios en blanco sobreviven (saltos de línea y espacios múltiples son parte del valor) — hacer trim solo en los extremos al enviar, no tocar el formato interno. Un paste que excede el límite nunca debe truncarse silenciosamente — aceptarlo completo y mostrar el campo sobre el límite.

## Accesibilidad
- Teclado: Tab mueve al siguiente campo, Shift+Tab al anterior, Enter inserta salto de línea (nunca envía el formulario), flechas mueven el cursor con wrap entre líneas.
- Contraste: borde o fill 3:1 contra la página en reposo (1.4.11).
- Tamaño de texto mínimo 16px (mismo motivo que text field: Safari en iOS hace zoom al enfocar si es menor, y no vuelve a des-zoomear al salir).
- Label igual que un text field: `<label for>` explícito, nunca un placeholder haciendo de label.
- El resize handle no tiene equivalente por teclado en la mayoría de navegadores — esto NO falla WCAG porque el contenido sigue legible vía scroll interno, pero vale la pena saberlo (no asumir que usuarios de teclado pueden arrastrar la esquina).

## Copy
Labels son sustantivos ("Cover letter" mejor que "Write your cover letter here"). Guía de formato va en un hint, no en el placeholder (sobrevive al primer keystroke). Contadores de caracteres se leen como número, no como regaño: "420 characters left" o "128 / 500", nunca "You have used 128 of your 500 characters". Errores nombran el campo y el arreglo: "Message must be under 500 characters, you are 40 over" mejor que "Too long".

## Errores comunes
1. Caja fija y diminuta para una respuesta sin largo natural (bug reports, cartas de presentación, mensajes de soporte no caben en 2 filas).
2. Quitar el resize handle de una caja fija sin autosize (deja a la persona viendo 4 líneas de una respuesta más larga sin forma de ver más).
3. Contador de caracteres desde el primer keystroke ("0 / 500" en un campo vacío es presión sin información).
4. Placeholder haciendo de label (desaparece al primer carácter, justo en el campo al que más se necesita volver a revisar).
5. Autosizing sin altura máxima (un paste largo o de código arrastra el submit button fuera de vista).
6. Truncar un paste que excede el límite (se pierde contenido que la persona nunca vio desaparecer).

## Casos borde
Palabra única más larga que la caja (ej. URL pegada sin espacios): usar `overflow-wrap: break-word`. Zoom 200%: label, caja y hint deben seguir visibles (WCAG 1.4.4). RTL: texto y resize handle se reflejan con propiedades lógicas. Oculto y luego mostrado: un textarea autosizing medido mientras está en `display: none` reporta altura cero — hay que medir de nuevo al volverse visible. Guardado lento (autosave de borrador): mostrar el estado cerca del campo, no encima del texto, para no competir con la escritura.

## Componentes relacionados
- **Text field**: cuando la respuesta cabe en una sola línea.
- **Select**: cuando la respuesta es una de un set pequeño y conocido.
- **Checkbox**: para selección múltiple de opciones conocidas.
- (Distinto de un **rich text editor**: usar textarea cuando el destino guarda texto plano; usar editor rico solo cuando el formato es parte de la respuesta misma — son componentes distintos, con árboles de accesibilidad distintos, no el mismo campo con una toolbar encima).
