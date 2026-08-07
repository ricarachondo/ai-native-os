Fuente: https://02ui.com/components/radio-group/ (consultado 2026-08-05)

# Radio group

Muestra todas las opciones a la vez y permite elegir exactamente una. Es de los pocos controles que insiste en dos propiedades a la vez (todo visible + solo una verdadera), por eso solo funciona cuando hay espacio para él. Build difficulty: Easy.

## Cuándo usarlo / Cuándo NO

Usar radio group cuando: debe elegirse exactamente una opción de un set visible; hay ~2 a 5 opciones y el layout tiene espacio para mostrarlas todas; comparar las opciones lado a lado ayuda a decidir (método de envío, intervalo de facturación).

Cuándo NO — usa otro componente:
- Más de ~7 opciones, o el layout no las contiene todas → **select**.
- Puede ser verdadera más de una opción → **checkbox** (grupo).
- Solo dos opciones y el cambio aplica de inmediato sin guardado → **switch**.
- Hace falta escribir para filtrar una lista larga → **combobox**.

Regla radio group vs select: contar opciones y revisar el layout. ~2-5 que caben en pantalla favorecen radio group (todo visible, sin clic extra). Más opciones o layout apretado favorecen select.

## Variantes

Lista plana (default, opciones apiladas verticalmente con un legend arriba), con descripción (segunda línea para detalle que el label no puede cargar, ej. costo de un envío), y card style (cada opción como card con borde en vez de círculo+label — común en selectores de plan o método de pago; sigue siendo un radio group por debajo, solo cambia la pintura).

## Estados

Unselected (anillo vacío, 3:1 contra el fondo), Selected (punto relleno, contraste contra el relleno del anillo), Focus (solo una opción del grupo sostiene el foco a la vez — detalle mal reconstruido frecuentemente al reemplazar inputs nativos por divs), Disabled (decir por qué, en línea bajo el grupo), Disabled+Selected, Error (mensaje en el grupo, ningún radio individual es "el culpable").

## Comportamiento

Elegir una limpia el resto automáticamente — comportamiento nativo del navegador ligado a un `name` compartido, sin JS. Las flechas mueven y seleccionan a la vez — no hay paso de confirmación separado. Un solo radio button nunca es válido por sí solo (si hay una sola opción, la pregunta no es "sí o no", es "on u off" → checkbox o switch). Orden estable: nunca reordenar con una opción seleccionada. Solo opciones mutuamente excluyentes — si dos podrían ser verdaderas a la vez, nunca fueron un radio group.

## Accesibilidad

- Todo radio group necesita `<fieldset>` + `<legend>`, sin excepción. Un radio input suelto sin grupo alrededor es señal de que debió construirse otra cosa.
- Teclado: Tab entra al grupo una sola vez, aterrizando en la opción marcada o en la primera si ninguna está marcada (el resto del grupo se salta); flecha abajo/derecha mueve y selecciona la siguiente; flecha arriba/izquierda mueve y selecciona la anterior; Space selecciona la opción con foco si no está ya seleccionada.
- Ese primer comportamiento (un solo tab-stop para todo el grupo) es lo que las implementaciones custom más frecuentemente rompen.
- Contraste: anillo sin seleccionar 3:1 contra el fondo; punto seleccionado 3:1 contra el relleno del anillo.
- Nunca color solo — error necesita mensaje bajo el grupo.
- Target size 24×24px (WCAG 2.5.8); envolver círculo+label en un `<label>`. Espaciado mínimo 8px entre opciones.

## Copy

El legend es la pregunta ("Velocidad de envío", no "Opciones" ni nada). Opciones cortas y con lo importante al frente ("Express, al día siguiente" > "Recíbelo al día siguiente por un costo extra"). Sentence case, sin punto final. Cada opción se entiende sola, sin necesitar leer las demás.

## Errores comunes

1. Un solo radio button sin grupo — si hay una sola opción no es una elección, es checkbox o switch.
2. Sin fieldset en el grupo.
3. Pre-seleccionar la opción más cara o más comprometedora — patrón oscuro notado y resentido aunque sea técnicamente cambiable.
4. Reordenar opciones con una seleccionada — rompe la memoria espacial de quien navega con flechas.
5. Opciones que en realidad no son excluyentes — si elegir una no descarta las otras, es un grupo de checkboxes disfrazado.
6. Un select disfrazando 3 opciones que cabrían en pantalla — ocultar una lista corta detrás de un clic cuesta un clic sin razón.
7. Tap targets del tamaño del círculo (16-20px es difícil de tocar).

## Casos borde

Labels largos envuelven — alinear el círculo con la primera línea. RTL: el círculo se mueve a la derecha del label. Sin selección por defecto es válido, y a menudo correcto para cualquier cosa con costo — la validación del form, no el control, decide si es requerido. Más de ~7 opciones: un stack vertical tan largo es scroll, no vistazo — migrar a select. Windows High Contrast Mode: un punto dibujado solo con color de fondo puede desaparecer — testear con `forced-colors`.

## Componentes relacionados

- **Checkbox**: elige cualquier número de opciones, incluido ninguna.
- **Select**: elige una opción de una lista oculta hasta abrirse.
- **Switch**: enciende/apaga algo, aplica de inmediato.
- **Combobox**: input de texto que filtra una lista mientras se escribe.
