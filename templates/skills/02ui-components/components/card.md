Fuente: https://02ui.com/components/card/ (consultado 2026-08-05)

# Card

Agrupa contenido relacionado en una unidad visible para que alguien pueda escanear varias a la vez y compararlas. Esa comparación es la única razón para dibujar el borde en primer lugar — una card sola en la página es una caja alrededor de algo que no necesitaba caja.

## Cuándo usarlo / cuándo NO

Usar cuando:
- Un grupo de contenido forma una unidad que tiene sentido sacada y puesta en otro lado (producto, preview de post, contacto).
- Varias de esas unidades se repiten en grid o lista, y un borde visible ayuda a compararlas de un vistazo.
- Cada unidad lleva su propio destino/acción, separado del vecino.

Usar otra cosa cuando:
- El contenido son filas del mismo atributo, para escanear hacia abajo por columna y comparar — usar una **tabla**.
- Hay un solo destino y nada más en la página necesita compararse contra él — usar un **link plano**.
- Hay que elegir exactamente una opción de un set chico, aunque se dibuje como bloque con borde — usar un **radio group**.
- Es un label o count corto adosado a otra cosa, no una unidad standalone — usar un **badge**.

## Variantes

- **Media card**: imagen arriba, título y descripción abajo. Default para productos, posts, listings.
- **List row**: sin imagen, título y metadata en una línea. Para sidebar o columna angosta.
- **Con acciones de footer**: un destino primario más uno o dos controles secundarios (guardar, overflow menu) fuera del link estirado de la card.
- **Selectable card**: opción con forma de card dentro de un radio group o checkbox group (planes, métodos de pago). El pintado es de card; el control real es un radio/checkbox, no un click handler en un div.

## Estados

Default (borde y opcionalmente shadow, contraste 3:1 contra la página), Hover (solo tiene sentido si la card es clickeable), Focus (anillo cae en el link estirado, no en todo el rectángulo como stop separado), Loading (skeleton que respeta las proporciones reales para que no haya reflow al llegar el contenido), Disabled (atenuada, sin hover/focus, explicar el motivo).

## Comportamiento

- Un solo destino: toda la card lleva al mismo lugar. Una segunda acción genuinamente distinta (guardar, eliminar) va visiblemente aparte del link estirado, normalmente en una esquina, con su propio stop de foco.
- El título es el nombre accesible: lo que envuelve el anchor es lo que un lector de pantalla anuncia por toda la card — envolver el título, no la descripción ni la imagen.
- Nada anida dentro del link estirado: un botón dentro del anchor estirado falla a renderizar (elementos interactivos no pueden anidarse) o captura el click y rompe el estiramiento. Acciones secundarias viven fuera del anchor, posicionadas encima con `position: relative` + z-index mayor.
- Altura igual en un grid: cards de altura muy distinta en la misma fila rompen el escaneo izquierda-derecha. Fijar con aspect ratio de imagen + descripción con line-clamp, no esperando que los textos calcen.

## Accesibilidad

- El título usa el heading level correcto según la posición en el outline de la página (h2/h3 normalmente), no un div con tamaño de heading.
- Teclado: Tab mueve al link estirado de la card y por separado a cualquier acción secundaria dentro de ella; Enter activa lo que tenga foco. La card no es un control propio — su comportamiento de teclado se hereda enteramente de los elementos interactivos reales que contiene.
- Contraste 3:1 en el borde (WCAG 1.4.11); foco visible en el link estirado dimensionado a toda la card, no un outline fino sobre el texto pequeño; target size del tamaño de toda la card (bien sobre el mínimo 24×24 WCAG 2.5.8).
- Alt text vacío para imágenes decorativas, descriptivo cuando la imagen agrega información que el título no cubre.

## Copy

- Adelantar el título: "Wireless keyboard, backlit" gana sobre "A backlit keyboard that connects wirelessly" — alguien escaneando un grid lee las primeras 2-3 palabras y decide si sigue.
- Nunca repetir el mismo CTA en todo un grid: una docena de cards diciendo "Learn more" pasa WCAG 2.4.4 pero falla 2.4.9 (el link debe tener sentido fuera de contexto, como en la lista de links de un screen reader). Nombrar la cosa: "See the wireless keyboard".
- Metadata corta: fecha, precio, count. Si necesita una oración, va en la descripción, no como label junto al título.

## Errores comunes

1. Toda la card envuelta en un solo anchor — todo el texto se vuelve no-seleccionable y el nombre accesible es la card entera leída como una sola frase. Estirar el link desde el título en cambio.
2. Un botón anidado dentro del anchor estirado — rompe en todo browser que prohíbe interactivos anidados (todos).
3. Card alrededor de un ítem único sin nada al lado — el borde compara contra un vecino que no existe.
4. Mismo texto de CTA en cada card de un grid — pasa la letra de WCAG 2.4.4 pero falla lo que un screen reader realmente necesita.
5. Shadow sin borde, probado solo en modo claro — invisible en dark mode o sobre fondos no calibrados.
6. Alturas desparejas rompiendo la línea de escaneo del grid.
7. Click handler en un div en vez de un link/botón real — pierde foco, Enter/Espacio y "abrir en nueva pestaña".

## Casos borde

- Card dentro de card: bordes anidados leen como una sola unidad confusa; si de verdad hace falta, al menos uno de los dos no es realmente una card.
- Títulos largos: clamp con `-webkit-line-clamp` y número fijo de líneas (el título completo sigue en el DOM/nombre accesible).
- Sin imagen: usar la variante list-row en vez de un placeholder box (que lee como imagen rota).
- RTL: la técnica de link estirado y el posicionamiento de la acción secundaria usan propiedades lógicas sin cambios (inset y z-index no son direccionales).
- Grid que nunca termina: paginar o "load more" pasado unas pocas docenas de cards.

## Componentes relacionados

- **Link**: alternativa cuando hay un solo destino y nada más que comparar.
- **Button**: para acciones que dejan a la persona en la misma página.
- **Table**: alternativa cuando el contenido son filas del mismo atributo para comparar por columna.
- **Menu**: lista de acciones revelada por un trigger.
