Fuente: https://02ui.com/components/table/ (consultado 2026-08-05)

# Table

Ordena registros en filas y columnas para que los valores de una misma columna se comparen mirando derecho hacia abajo. Si nadie escanea una columna, el dato no necesita tabla. Casi todo lo que una tabla hace bien viene de una sola propiedad: los valores de una columna se alinean, así el ojo los rankea sin leerlos.

## Cuándo usarlo / cuándo NO

Usar cuando:
- Se compara el mismo atributo entre registros (monto, fecha, estado).
- Cada registro lleva el mismo set de atributos.
- Ordenar o filtrar por columna es parte del trabajo.
- Las filas se accionan: seleccionar, exportar, editar in place.

Usar otra cosa cuando:
- Hay un solo registro en pantalla, no hay columna que escanear — usar una **card**.
- Cada fila es una elección de la que se toma una, no un valor a comparar — usar un **radio group**.
- Las filas son destinos y las columnas no cargan nada que escanear — usar una **lista de links**.
- Filas y columnas se usan para posicionar contenido de página, no para presentar datos — usar **CSS grid layout**.

## Variantes

- **Default**: una línea fina entre filas, sin relleno. Funciona hasta 4-5 columnas.
- **Zebra**: filas con fondo alternado. Gana su lugar en tablas anchas (~5+ columnas), donde el ojo puede saltarse una línea entre la primera y la última columna.
- **Selectable**: columna de checkbox al inicio + select-all en el header. Al agregarla, se debe mostrar un count de lo seleccionado y una forma de limpiarlo.
- **Compact**: filas más bajas para quien vive en la tabla todo el día. Rango típico: default 40-56px, compact 32-36px (no estandarizado).

## Estados

Default, Hover (solo vale pintarlo si la fila es clickeable o tiene acciones), Selected (debe distinguirse de hover y de una franja zebra — dar una señal distinta, como borde izquierdo o checkbox marcado, no solo un fondo un poco más oscuro), Sorted (flecha en el header, `aria-sort` actualizado), Loading (skeleton rows a la altura real de fila, header visible para que no salte el layout), Empty (mensaje reemplazando las filas).

Los dos empty states son problemas distintos y piden palabras distintas: sin datos en absoluto invita a una primera acción ("Add your first invoice"); sin resultados para el filtro actual invita a un camino de vuelta ("No invoices match these filters. Clear filters"). Ofrecer "crea tu primera factura" a alguien con 400 detrás de un filtro es un pequeño insulto.

## Comportamiento

- Ordenar es por columna y visible: un click ordena ascendente, un segundo invierte. El header muestra qué columna está ordenada y en qué dirección, porque tras un scroll la flecha es lo único que sigue diciéndolo.
- Ordenar no cambia lo que hay en la tabla; filtrar sí — mantener ambos conceptos separados en la interfaz.
- Los anchos de columna se mantienen fijos entre páginas (si se calculan por contenido, la página 2 relayoutea toda la tabla por tener strings distintos de largo).
- Una tabla ancha hace scroll dentro de su propio contenedor, no empuja la página entero — ese contenedor necesita `tabindex="0"` y nombre accesible (WCAG 2.1.1).
- Las acciones de fila viven en una columna consistente (última, alineada a la derecha, misma posición en cada fila). Acciones que solo aparecen en hover son invisibles a touch y teclado — mantenerlas presentes y solo subir contraste en hover.

## Accesibilidad

- Usar markup real de tabla: `<table>`, `<thead>`, `<tbody>`, `<th>`, `<td>` — un grid de divs no anuncia nada.
- `<caption>` nombrando qué son las filas (puede estar visualmente oculto).
- `scope="col"` en headers de columna, `scope="row"` donde una fila tenga uno — necesario con celdas merged o más de una fila de headers.
- Headers ordenables llevan `aria-sort` (ascending/descending/none) en el `<th>`, con un `<button>` real adentro haciendo el sort — el glyph de flecha solo no dice nada a un screen reader.
- Cada checkbox de fila necesita nombre propio: "Select invoice INV-2043", no "Select row" repetido 40 veces.
- No depender solo del color para el estado (un punto verde en Status necesita su palabra al lado).
- Contraste 3:1 en flechas de sort y status dots (WCAG 1.4.11); líneas separadoras de fila son decorativas y están exentas.
- Target size 24×24 CSS px en sort buttons, checkboxes y triggers de acción de fila (WCAG 2.5.8) — punto donde las filas compact empiezan a pelear con el spec.

### Teclado

Tab mueve por los elementos interactivos internos (botones de sort, checkboxes, links de fila, menús de acción — una tabla plana no tiene stops propios); Enter/Espacio activa el control con foco; flechas solo mueven entre celdas en un grid completo (`role="grid"`, implementación propia) — en una tabla plana el navegador reserva las flechas para scroll; Tab hacia el contenedor de scroll horizontal (con `tabindex="0"`) permite luego scrollear con flechas.

## Copy

- Headers de columna son sustantivos cortos: "Amount", "Status", "Last active" — uno que hace wrap a dos líneas fija la altura de todo el header row.
- Formatear cada celda de una columna igual: un formato de fecha, un formato de moneda, un decimal count — una columna con 1,240 arriba de 1240.00 no se puede escanear aunque el alineado esté bien.
- Celdas vacías necesitan una marca (en dash o "None") — una celda en blanco lee como bug.
- Truncar solo la columna menos importante, y solo esa; truncar identificadores en el medio si los extremos son lo que distingue ("INV-2043…8871").
- Decir en qué unidad están los números: "Amount (USD)" en el header gana sobre repetir el símbolo de moneda 40 veces.

## Errores comunes

1. Divs en vez de markup de tabla — pierde toda asociación fila/columna, caption, relación de headers.
2. Números alineados a la izquierda — el cambio más barato que más mejora una tabla; a la izquierda, 40 strings separados en vez de una columna rankeable.
3. Cifras proporcionales en columna numérica — el alineado a la derecha no sirve si los dígitos tienen ancho distinto; `font-variant-numeric: tabular-nums` lo arregla en una línea.
4. Acciones de fila que solo aparecen en hover — invisibles en touch, no descubribles para el resto.
5. Flecha de sort sin `aria-sort` — la única pista que un screen reader no puede ver.
6. Selección que se ve como hover — dos fills similares para dos estados distintos, las filas parecen seleccionarse solas al pasar el mouse.
7. Doce columnas porque la API devolvió doce campos — cada columna agregada hace más difícil escanear las demás; empezar por lo que la gente compara y poner el resto detrás de un row expander o column picker.

## Casos borde

- Tabla muy ancha: scroll dentro de contenedor focuseable y nombrado, primera columna pineada (`position: sticky` + fondo propio).
- Miles de filas: virtualizar o paginar — el DOM con 5000 filas dropea frames en scroll y cada sort las toca todas.
- Celdas merged: `colspan`/`rowspan` rompen la inferencia simple de headers, agregar `scope`/`headers` explícito; si hace falta ambos, a veces son en realidad dos tablas.
- Celdas editables: el momento en que una celda tiene un input, se debe un modelo de guardado, validación y undo — más cerca de un form que de una tabla.
- Una sola fila de resultados: mantener la tabla en vez de cambiar de layout — cambiar a card a cierto row count enseña dos layouts para una misma cosa.

## Componentes relacionados

- **Pagination**: divide una lista larga en páginas.
- **Card**: agrupa contenido en una unidad visible para comparar varias a la vez — alternativa cuando el contenido no se compara por columna.
- **Empty state**: pantalla cuando no hay nada que mostrar.
