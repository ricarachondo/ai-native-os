Fuente: https://02ui.com/components/select/ (consultado 2026-08-05)

# Select

Lista de opciones que permanece oculta hasta que se abre. El trade-off central: se ahorra espacio en pantalla a cambio de un clic extra antes de ver las opciones.

## Cuándo usarlo / Cuándo NO

Usar select cuando: hay una lista pequeña-mediana y conocida (~5 a 15 opciones), debe elegirse exactamente una, no hace falta que la lista completa esté siempre visible, y nadie necesita buscar/filtrar para encontrar la opción.

Cuándo NO — usa otro componente:
- 2 a 4 opciones que caben en pantalla → **radio group** (evita el clic extra).
- Lista larga donde escanear es lento y conviene filtrar escribiendo (>15-20 opciones) → **combobox**.
- Se puede elegir más de una opción → **checkbox** (grupo).
- La respuesta es texto libre impredecible → **text field**.

Regla rápida (FAQ del sitio): <5 opciones visibles → radio group; >15-20 → combobox (agrega búsqueda); en el rango medio, select.

## Variantes

Agrupado por región (útil desde ~8-10 ítems si ya existe una estructura natural), con íconos líder por opción (para valores que se reconocen visualmente más rápido que se leen, ej. método de pago o estado), y compacto (trigger más bajo para toolbar o fila de tabla densa).

## Estados

Placeholder (texto mudo, nada seleccionado — debe distinguirse claramente de un valor real, normalmente con `text-muted-foreground`), Filled, Focus (anillo visible), Error (borde rojo + mensaje + `aria-invalid="true"`), Disabled (opacidad reducida, no focuseable, no se envía), Open (listbox visible, la opción actual lleva check). Solo un select abre a la vez — abrir uno cierra cualquier otro abierto.

## Comportamiento

Un solo valor elegible siempre. Al elegir se cierra el panel automáticamente (nunca queda abierto esperando confirmación). Listas largas hacen scroll dentro del panel, nunca de la página. Type-ahead: escribir una letra salta a la opción que empieza con ella — comportamiento nativo de `<select>`, hay que reconstruirlo deliberadamente en componentes custom.

## Accesibilidad

- Preferir `<select>` nativo: da picker de plataforma en mobile, teclado completo y type-ahead sin JS.
- Custom: seguir el patrón ARIA listbox — `role="combobox"` en el trigger, `role="listbox"` + `role="option"` en cada ítem, conectado vía `aria-activedescendant` o foco real de DOM.
- Teclado: Space/Enter abre; flechas mueven el resaltado (abriendo si está cerrado); Enter elige y cierra; Escape cierra sin cambiar valor; Tab cierra y mueve el foco.
- Anunciar el valor seleccionado al abrir, no solo su posición ("Canadá, seleccionado" > "ítem 3 de 12").
- Contraste del borde del trigger: 3:1 en reposo (WCAG 1.4.11). Target size mínimo 24×24px (WCAG 2.5.8).
- Label conectado con `for`/`id`, nunca solo un placeholder haciendo de label.

## Copy

Labels son sustantivos ("País", no "Por favor selecciona tu país"). Placeholder nombra la elección, no la acción ("Elige un país" > "Seleccionar" o un guion). Texto de opción corto y escaneable. Orden con razón: alfabético para conjuntos abiertos (países), lógico para conjuntos cerrados (tallas). Labels de grupo son sustantivos cortos.

## Errores comunes

1. Pre-seleccionar la primera opción — parece una elección hecha cuando nadie eligió nada; empezar en placeholder vacío salvo default genuinamente correcto.
2. Lista plana larga sin agrupar (ej. 50 códigos de país sin agrupación ni búsqueda).
3. Select para 2 opciones (sí/no) que un radio group o switch mostrarían gratis.
4. Placeholder vago tipo "-- Seleccionar --" que no nombra nada.
5. Listbox hand-rolled con divs — pierde type-ahead, navegación por flechas y Escape.
6. Sin anillo de foco visible en el trigger — la forma más común de volver el select invisible al teclado.

## Casos borde

Texto de opción más largo que el trigger → truncar con ellipsis, texto completo disponible en foco/listbox abierto (nunca solo en `title`). RTL: chevron y alineación del listbox se espejan. Zoom 200%: trigger, label y listbox abierto deben seguir usables dentro del viewport. Mobile: `<select>` nativo dispara el picker del SO (rueda o lista fullscreen), generalmente más rápido que un listbox custom desktop-style escalado.

## Componentes relacionados

- **Radio group**: muestra todas las opciones a la vez, elige exactamente una.
- **Combobox**: input de texto que filtra la lista mientras se escribe.
- **Checkbox**: elige cualquier número de opciones, incluido ninguna.
- **Text field**: texto libre de una línea.
