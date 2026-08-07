Fuente: https://02ui.com/components/tooltip/ (consultado 2026-08-05)

# Tooltip

Label corto y no-interactivo que aparece al hacer hover o focus sobre un control. Nombra cosas. Cualquier cosa que la persona tenga que leer para terminar la tarea pertenece a la página, no al tooltip.

## Cuándo usarlo / Cuándo NO — usa X

Usar tooltip cuando: un botón solo-ícono necesita un nombre y no hay espacio para un label visible; un label truncado necesita leerse completo; un poco de contexto ayuda pero no es requerido para completar la tarea; vale la pena mostrar un shortcut de teclado o un valor técnico bajo demanda.

Cuándo NO:
- El contenido es necesario para completar la tarea → usa un **hint visible** bajo el campo (no ocultarlo detrás de hover).
- El contenido tiene un link, botón, o cualquier cosa clickeable → usa **popover**.
- El mensaje supera ~12 palabras o tiene más de una oración → usa **popover**.
- El trigger ya tiene un label visible que dice lo mismo → **eliminar el tooltip**, es ruido.
- Se necesita que el mensaje aparezca sin que el usuario lo pida → usa **banner**.

## Variantes

Solo tres valen la pena construir; el resto es decoración:
- **Plain label**: default, una línea corta.
- **Con shortcut de teclado**: pareja nombre + shortcut, genuinamente útil en editores/herramientas de uso diario (ej. Figma).
- **Wrapping**: para labels que no se pueden acortar más, con ancho fijo tope. Tener que usar esta variante es señal de que el copy necesita otra edición.

## Estados

Menos estados que la mayoría de componentes, y los dos que importan son del **trigger**, no del tooltip: resting, hover-after-delay, keyboard-focus, trigger-disabled.

- Hover y keyboard focus deben producir el **mismo** tooltip. Si solo aparece con hover, prácticamente toda la población que usa teclado (incluyendo cualquiera con screen reader) nunca lo ve.
- Disabled es el caso incómodo: un botón disabled no dispara eventos de puntero en ningún browser, así que el tooltip nunca abre — justo cuando más se necesita saber por qué el botón está apagado. Ver solución en "Casos borde / build".

## Comportamiento clave

- Abrir: `mouseenter` con delay (300–500ms es el rango común; Radix usa 700ms por default — el número importa menos que ser consistente en todo el producto); `focus-visible` sin delay (un usuario de teclado ya hizo una elección deliberada al tabear, no hay que castigarlo con espera).
- Saltar el delay dentro de un grupo: una vez visto un tooltip en una toolbar, mostrar los siguientes instantáneamente mientras se sigue recorriendo; resetear el delay tras ~300ms fuera del grupo. Es el cambio que hace sentir rápida una toolbar.
- Cerrar: inmediato en `mouseleave`, `blur`, Esc y scroll — sin delay de salida.
- Escape debe funcionar: WCAG 2.1 SC 1.4.13 (Content on Hover or Focus) exige que el contenido mostrado por hover pueda descartarse sin mover el puntero.
- Debe poder moverse el puntero sobre el tooltip mismo sin que desaparezca (mismo criterio 1.4.13, relevante para magnificación de pantalla) — usar `pointer-events: none` solo si es lo bastante corto como para que nadie necesite acercarse.
- Motion: un fade de 120ms basta; nada de slide/bounce/scale en un componente cuyo trabajo es no llamar la atención.

## Accesibilidad

**Naming vs describing** (la elección depende de si el trigger ya tiene otro nombre):
- Botón solo-ícono, sin texto visible → `aria-labelledby` (el tooltip ES el único nombre del botón; una description no puede sustituir a un name).
- Botón con label visible → `aria-describedby` (el texto visible es el name; el tooltip agrega detalle).
- Texto truncado → `aria-label` en el elemento (el screen reader recibe el string completo sin importar lo que recortó el CSS).
- Usar `aria-describedby` en un botón solo-ícono lo deja sin nombre accesible: el screen reader anuncia "button" y nada más.

Teclado: Tab mueve foco al trigger y el tooltip aparece inmediatamente; Tab de nuevo lo oculta; Esc lo oculta manteniendo el foco en el trigger. El tooltip nunca recibe foco propio, no está en el tab order, no tiene contenido interactivo ni botón de cerrar.

Resto:
- Contraste 4.5:1 texto/fondo (WCAG 1.4.3) — gris oscuro sobre negro es la falla típica.
- Target size: 24×24px CSS (AA, 2.5.8), 44×44 (AAA, 2.5.5); guía de Apple es 44×44pt. Los botones-ícono que necesitan tooltip son justo los que suelen quedar chicos.
- Zoom 200%: el tooltip debe quedar dentro del viewport, flipear placement en vez de recortar.
- Nunca poner un tooltip en un elemento no-focuseable: si un `div` necesita tooltip, o se convierte en botón, o se acepta que los usuarios de teclado nunca lo verán.

## Copy

- Bajo 8 palabras — si necesita más, el problema es de la interfaz, no del tooltip.
- Nombrar la acción, no describir el ícono: "Archive" mejor que "Click to move this item to the archive folder."
- Debe calzar con el nombre accesible del botón — si el tooltip dice "Archive" pero el `aria-label` dice "Move to archive", un usuario de control por voz que dice "click archive" puede no acertarle a nada.
- Sin punto final en un label de una línea: "Archive" no "Archive.".
- Sentence case: "Add to favourites" no "Add To Favourites".
- Nunca repetir el texto visible — un botón "Save" con tooltip "Save" es ruido puro; si el tooltip no agrega nada, eliminarlo.

## Errores comunes

1. Hover-only, sin handler de focus — el bug más común por lejos; excluye a usuarios de teclado y screen reader.
2. Contenido interactivo adentro (ej. un link) — inalcanzable, porque el tooltip cierra al mover el puntero hacia él; si tiene algo clickeable, es un popover.
3. Información requerida escondida detrás de hover — reglas de contraseña, aclaraciones de precio, requisitos de formato: todo eso va en la página.
4. Sin dismissal — un tooltip que ignora Esc falla WCAG 1.4.13.
5. Tooltips en touch — no hay hover en celular; o nunca aparece o aparece con long-press que nadie intenta.
6. Clipeado por un contenedor padre con `overflow: hidden` — renderizar en un portal al final del `body`, o usar la CSS anchor positioning API donde el soporte de browser lo permita.

## Casos borde / cómo construirlo

- El atributo `title` nativo es un fallback débil: no aparece con keyboard focus, no se puede estilizar, delay de ~1s controlado por el browser, anunciado de forma inconsistente, nada en touch. Sirve solo para lo que a nadie le importa realmente.
- Un tooltip real son tres piezas conectadas: trigger focuseable + `div role="tooltip"` con id + `aria-labelledby`/`aria-describedby` según el caso.
- Posicionamiento: renderizar en portal al final de `body` para evitar recorte por ancestros con `overflow: hidden`; usar Floating UI para flip/shift automático cerca del borde del viewport.
- Triggers disabled: dos salidas — (a) envolver el botón en un `span` focuseable que porta el tooltip (funciona, agrega un nodo); (b) usar `aria-disabled="true"` con un botón real y focuseable que bloquea la acción en su handler — mejor en casi todos los casos, porque el usuario puede llegar al control y enterarse de por qué está apagado.
- Texto largo sin saltos de línea: tope de ancho ~240px, dejar que wrappee; nunca dejar que ocupe todo el ancho del viewport.
- RTL: placements se reflejan (left↔right); usar logical properties o dejar que Floating UI lo maneje.
- Trigger que se mueve (listas virtualizadas, toolbars animadas): recalcular posición en scroll/resize, o cerrar en scroll (más simple, usualmente correcto).
- Redes lentas: si el contenido del tooltip se fetchea, no mostrar una caja vacía — no mostrar nada hasta que llegue.
- Windows High Contrast Mode: los colores de fondo se eliminan; darle un borde real para que siga leyéndose como superficie distinta.

## Componentes relacionados

- **Popover**: lo que separa a un popover de un tooltip es que adentro se puede clickear algo.
- **Modal**: bloquea toda la página hasta terminar/cancelar.
- **Button**, **Text field**: triggers típicos de tooltip.
