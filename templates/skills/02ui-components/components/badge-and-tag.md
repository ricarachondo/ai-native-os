Fuente: https://02ui.com/components/badge-and-tag/ (consultado 2026-08-05)

# Badge and tag

Mismo shape (pill redondeado), dos trabajos distintos. Un badge es un estado que setea el sistema (Active, Draft). Un tag es una etiqueta que aplicó una persona (un filtro, un skill). Se confunden constantemente porque muchos productos usan el mismo componente visual para ambos.

## Cuándo usarlo / Cuándo NO — usa X

Usar badge/tag cuando: el sistema necesita reportar un estado de un vistazo (badge: Active, Draft, Failed); una persona aplicó una etiqueta visible y removible (tag: filtro, skill); la información es una o dos palabras, nunca una oración; necesita sentarse inline sin romper el line-height.

Cuándo NO:
- Clickearlo debería disparar una acción (correr un filtro, abrir una página) → usa **button**.
- El mensaje necesita una oración completa de explicación → usa **banner**.
- Alguien está eligiendo de una lista larga de opciones, no viendo las ya aplicadas → usa **checkbox**.
- Existe solo para navegar, sin estado ni label asociado → usa **link**.

## Variantes

- **Neutral badge**: palabra de estado sin codificación de color (Draft, Archived).
- **Semantic badge**: color emparejado con una palabra (success/warning/error/info) — el color refuerza, nunca reemplaza a la palabra.
- **Count badge**: número, redondo en vez de pill (para que se lea rápido en un ícono de nav); pasado 99 muestra "99+" en vez de romper su propio shape.
- **Tag**: pill con outline, label y control de remove, para algo que una persona eligió adjuntar.
- **Icon tag**: tag con una marca líder pequeña (swatch de color, glyph de tipo de archivo) antes del label — agrega un cue, no el significado completo.

## Estados

Badge neutral (fill plano) → Badge semantic (fill/texto toma el color de estado, el color refuerza, nunca es la única señal) → Tag default (outline, label, control de remove visible) → Tag focus (ring alrededor del control de remove únicamente, porque solo el control es tab stop) → Tag hover-on-remove (fondo del control se oscurece, el cuerpo del tag queda inerte) → Tag disabled (control de remove oculto o inerte, necesita razón cercana como cualquier otro control disabled).

## Comportamiento clave

- Un badge nunca responde a nada: sin hover, sin focus ring, sin cursor change — si necesita uno de esos, dejó de ser badge.
- El control de remove de un tag es la única parte interactiva; label y outline son estáticos.
- Un badge se actualiza solo (el sistema cambia el estado subyacente); un tag cambia solo cuando una persona lo agrega o quita.
- Remover un tag no debe reordenar el resto de la fila — igual regla que un grupo de checkboxes: la gente apunta a una posición tanto como a una palabra.

## Accesibilidad

- Tab mueve al control de remove de un tag; un badge nunca está en el tab order porque no es un control.
- Space o Enter activa el control de remove.
- Contraste 4.5:1 texto contra fill del badge (WCAG 1.4.3).
- Nunca solo color: un badge rojo "Error" necesita la palabra "Error" impresa (WCAG 1.4.1) — un screenshot en blanco y negro o un lector daltónico pierde el significado si no.
- Nombrar lo que se remueve: `aria-label="Remove Design tag"`, nunca solo "×" sin contexto.
- Target size 24×24px CSS para el control de remove (WCAG 2.5.8), aunque el tag en sí sea más chico.

## Copy

- Una o dos palabras: "Active", no "This item is currently active".
- Un vocabulario por estado, consistente en todo el producto — si es "Active" en una pantalla, no llamarlo "Live" en otra.
- El tag repite exactamente lo que se aplicó, verbatim; si necesita acortarse, usar ellipsis con el valor completo disponible en hover/foco, nunca un corte silencioso.
- Los conteos tienen tope antes de volverse ilegibles: "99+" en vez de un número de cuatro dígitos estirando el badge.

## Errores comunes

1. Badge con estilo de botón (hover, cursor, shadow) que promete una acción que nunca ejecuta.
2. Tag que nadie puede remover en un producto donde aplicarlo fue un clic.
3. Color como única señal: un punto verde y uno rojo no dicen nada a quien no distingue colores.
4. Control de remove sin nombre accesible: solo un "×" sin nada detrás para un screen reader.
5. Oración completa apretada en el pill: "Your payment could not be processed" pertenece a un banner.
6. La misma palabra cubriendo dos estados distintos ("Active" = encendido y también = viendo actualmente) obliga a adivinar.

## Casos borde

- Fila larga de tags que wrappea: mantener el gap consistente, considerar un badge "+3 more" resumiendo el overflow.
- Tag que alguien no tiene permiso de remover todavía: quitar el control de remove por completo, no mostrar un "×" disabled sin explicación.
- Badge dentro de una celda de tabla: alinear al baseline del texto vecino, no dejar que su alto estire la fila.
- RTL: el control de remove se mueve al borde izquierdo del tag.
- Dark mode: un color semántico que pasa contraste en fondo blanco puede glowear o lavarse en un fondo casi negro — revisar cada uno de nuevo.

## Componentes relacionados

- **Button**: ejecuta una acción sin abandonar la página — usar en vez de badge si el elemento debe ser clickeable.
- **Banner**: mensaje persistente hasta que cambia la condición de fondo.
- **Checkbox**: elegir cualquier número de opciones de un set, incluyendo ninguna.

Pregunta clave del sitio para decidir badge vs tag: ¿quién seteó el valor? Si lo computó el sistema desde datos → badge, nadie lo remueve directo. Si lo aplicó una persona → tag, normalmente viene con forma de sacarlo. "Chip" es el término paraguas que algunos design systems usan para ambos; este sitio los separa porque siguen reglas distintas (uno read-only, el otro removible).
