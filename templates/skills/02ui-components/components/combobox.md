Fuente: https://02ui.com/components/combobox/ (consultado 2026-08-05)

# Combobox

Input de texto que filtra una lista de opciones mientras se escribe, y luego permite elegir una. Hace todo lo que un select hace más búsqueda — por eso es el más difícil de construir bien de los dos (build difficulty: Hard).

## Cuándo usarlo / Cuándo NO

Usar combobox cuando: la lista es larga (~>15-20 opciones) y escanearla plana es más lento que escribir unas letras; es más probable que la persona recuerde un fragmento del valor (primeras letras de un nombre/ciudad) que su posición; debe elegirse exactamente una opción; el conjunto de opciones válidas sigue siendo fijo aunque la búsqueda cambie cómo se navega.

Cuándo NO — usa otro componente:
- Lista corta que se escanea en segundos (<15 opciones) → **select**.
- 2 a 4 opciones que caben en pantalla → **radio group**.
- Texto libre genuino sin lista fija detrás → **text field**.
- Escribir debería disparar una acción inmediata en vez de fijar un valor → **menu**.

Regla combobox vs select: ambos guardan un valor de una lista fija; select es más rápido de construir y usar bajo ~15-20 opciones; sobre ese umbral, o cuando la gente recuerda mejor un fragmento que la posición, la búsqueda del combobox justifica el costo extra.

## Variantes

Agrupado por continente (útil si la lista larga ya tiene categoría natural), con descripciones (segunda línea muda para distinguir opciones parecidas, ej. dos personas con el mismo nombre), y multi-select (valores elegidos se acumulan como chips removibles, ej. tags de un ticket).

## Estados

Empty (placeholder nombra qué buscar), Filled (sigue editable — al reabrir debe permitir buscar de nuevo, no solo re-mostrar la lista), Focus, Error (`aria-invalid="true"`), Disabled, No results (mensaje repitiendo el término de búsqueda — un panel en blanco parece roto, no vacío).

## Comportamiento

Escribir filtra, no envía. Nada se elige hasta seleccionar una opción (clic, flecha+Enter, o coincidencia exacta tipeada donde esté soportado explícitamente). Abrir el panel no borra un valor ya elegido. Solo una opción elegida salvo multi-select explícito. El filtrado debe matchear más allá del inicio de palabra ("United" debe encontrar "United Kingdom" y "United States", no solo la que empieza la lista). Elegir cierra el panel en single-select; en multi-select el panel se mantiene abierto.

## Accesibilidad

- Patrón WAI-ARIA combobox, variante "list autocomplete": input con `role="combobox"`, `aria-expanded`, `aria-controls` apuntando al panel (`role="listbox"` + `role="option"` en ítems).
- Trackear el resaltado con `aria-activedescendant`, no foco real de DOM — el foco permanece en el input todo el tiempo que el panel está abierto.
- Anunciar el conteo de resultados al filtrar (live region oculta o anuncios propios del listbox del lector de pantalla).
- Label explícito `<label for>`, nunca solo placeholder.
- Contraste 3:1 en el borde del trigger (WCAG 1.4.11). Target size 24×24px (WCAG 2.5.8), incluyendo el botón de limpiar en un chip de multi-select.
- Alternativa nativa ligera: `<input list>` + `<datalist>` da filtrado gratis pero no soporta headers agrupados, texto secundario ni estilo de design system propio.

## Copy

Placeholder nombra qué buscar ("Buscar países" > "Seleccionar" o solo una lupa sin label). Mensaje de no-resultados repite la query ("No hay resultados para 'Freldon'" — confirma que la búsqueda corrió). Texto de opción corto. Labels de grupo son sustantivos cortos, igual que en select.

## Errores comunes

1. Combobox para una lista corta que podría solo mostrarse (4 métodos de pago no necesitan buscador — eso es un select o radio group con peso extra).
2. Filtrado que solo matchea las primeras letras ("York" debería encontrar "New York"; anclar al inicio del string rompe silenciosamente la búsqueda).
3. Panel en blanco en no-resultados en vez de mensaje con la query.
4. Perder la query tipeada al hacer blur — clicar afuera y volver debería restaurar lo que había, no resetear a placeholder (salvo que ya se eligió un valor real).
5. Sin ruta de teclado a una opción — un combobox que solo responde a mouse pierde a todo el que navega por teclado.
6. Tratar los chips de un multi-select como la única forma de ver lo elegido — una vez que los chips envuelven más de una línea, hace falta una forma de ver y gestionar el conjunto completo.

## Casos borde

Lista muy larga → cap de altura + scroll interno del panel (misma regla que select). Label de opción más largo que el trigger → truncar con ellipsis, texto completo en el panel. Opciones cargadas async → loading state en el panel, debounce ~200-300ms para no disparar una request por cada tecla. Mobile: teclado táctil cubre pantalla, mantener count visible bajo (3-5 filas), panel debe scrollear independiente de la página detrás del teclado. RTL: chevron, alineación del panel y texto secundario se espejan.

## Componentes relacionados

- **Select**: elige una opción de una lista que permanece oculta hasta abrirse (sin búsqueda).
- **Text field**: input de una línea para texto libre corto.
- **Menu**: lista de acciones revelada por un trigger.
