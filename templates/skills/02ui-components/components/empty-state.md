Fuente: https://02ui.com/components/empty-state/ (consultado 2026-08-05)

# Empty state

La pantalla cuando no hay nada que mostrar. Cuatro situaciones distintas usan el mismo nombre y cada una necesita mensaje y acción (o ninguna) diferentes. Solo tres de las cuatro son realmente este componente — la cuarta es un error disfrazado de vacío, y es la versión que más daño causa.

## Cuándo usarlo / Cuándo NO — usa X

Usar empty state cuando: una lista, inbox o dashboard genuinamente no tiene nada todavía o ya no tiene nada; una búsqueda o filtro legítimamente no devolvió matches; alguien limpió todos los items a propósito y no queda nada por hacer.

Cuándo NO:
- Los datos fallaron al cargar por error de red o servidor → usa **mensaje de error** (con retry), NUNCA un empty state disfrazado — es el error más común y más dañino del componente.
- La pantalla sigue esperando una request que no terminó → usa **loading state**.
- Es una confirmación breve de que algo acaba de pasar, no una pantalla estable → usa **toast**.

## Variantes

- **First use**: nada se ha creado todavía. Necesita la acción más clara de las cuatro, porque la persona nunca hizo esto antes: "Create your first project."
- **No results**: una búsqueda o filtro no encontró nada. Necesita una salida, no solo la descripción del hecho: "Clear filters" o "Clear search."
- **All done**: cada item se resolvió a propósito (inbox en cero, checklist completa). Sin acción requerida — el único lugar de la página donde se permite algo de calidez.
- (Cuarta situación, NO es empty state real): **error wearing empty clothes** — request falló, se muestra como si estuviera vacío. Siempre tratar como error con retry, no como empty state.

## Estados

Default (ícono, heading, body y acción llenan el espacio que ocuparía el contenido, matchear ancho/alto para que nada salte al llegar datos reales) → Live update (reemplaza resultados existentes tras correr una búsqueda/filtro, necesita `aria-live="polite"` para que se anuncie el cambio de conteo) → Momentary (mostraría por un instante antes de que la request realmente termine — el bug más común de la lista: hay que esperar a que resuelva antes de decidir que la lista está vacía) → Focused action (el botón/link adentro hereda su propio focus ring, sin reglas propias del componente).

## Comportamiento clave

- Llena el espacio del contenido, no la página entera — un dashboard con un widget vacío muestra el empty state en ese widget, el resto del layout intacto.
- Espera la respuesta real: no renderizarlo hasta que la request que poblaría la lista haya resuelto — renderizarlo primero y hacer swap con datos es lo que produce el flash momentáneo.
- Un cambio en vivo se anuncia; una primera carga no — nada cambió para quien recién abrió la página, así que no hay nada que interrumpir.
- La acción hace lo mínimo útil: crear el item, limpiar el filtro, reintentar la request — un link a un artículo de ayuda genérico no sustituye ninguna de las tres.

## Accesibilidad

- `role="status"` + `aria-live="polite"` en el contenedor de resultados anuncia la actualización tras una búsqueda/filtro sin mover el foco ni interrumpir. Un empty state estático que ya es parte de la página en la primera carga no necesita esto — no hay cambio que anunciar a alguien que no vio nada antes.
- Tab mueve a la acción si existe; Enter/Space la activa (hereda comportamiento de button/link, sin nada propio del componente).
- Nivel de heading correcto según la posición en el outline de la página.
- Ícono siempre decorativo: `aria-hidden="true"`, no debe agregar ruido al nombre accesible.
- Contraste 4.5:1 para el body text incluso en tono atenuado (WCAG 1.4.3).

## Copy

- Nombrar específicamente qué falta: "No projects yet" mejor que "Nothing here."
- Matchear el tono a la variante: first use puede invitar a la acción, no results puede sugerir un fix, all done puede tener calidez breve.
- Nunca culpar a la persona: "Create your first project to get started" describe el hecho sin apuntar el dedo, en vez de "You haven't created anything yet."
- Nombrar la acción en el botón: "Create your first project", no "Get started" (que podría significar cualquier cosa fuera de contexto).

## Errores comunes

1. Renderizar una request fallida como empty state — "No results" y "el servidor no respondió" se ven idénticos al lector y necesitan fixes completamente distintos (el segundo necesita retry).
2. Heading genérico sin próximo paso: "No data" no dice qué hacer.
3. Sin acción en una pantalla de first use: deja a alguien nuevo sin dónde ir.
4. Acción en una pantalla "all done" que nadie pidió: sugerir otra tarea justo al terminar la lista se lee como fastidio.
5. Ilustración tan grande que empuja la acción fuera del viewport — la imagen es decoración, el botón es el punto.
6. Flash de empty state antes de que los datos reales carguen — renderizar solo después de que la request resuelva.
7. Lenguaje que culpa a la persona por la ausencia en vez de describir el estado.

## Casos borde

- Usuario que vuelve vs. usuario nuevo: alguien que borró su único proyecto ve la misma pantalla "no projects yet" que alguien nuevo — sigue siendo preciso, no vale la pena reescribir según historial de cuenta.
- Widget chico en vez de página completa: sacar el ícono por completo si el espacio es reducido; una línea corta de texto + una acción si hay lugar.
- Acceso restringido disfrazado de vacío: una lista vacía porque el viewer no tiene permiso es un mensaje distinto, más cerca de un error — decir explícitamente que el acceso está restringido, no que no hay nada.
- Borrar el último item en una página profunda de paginación: redirigir a una página válida o mostrar su propio empty state, no renderizar un número de página sin contenido.

## Componentes relacionados

- **Banner**: mensaje persistente hasta que cambia la condición de fondo.
- **Loading and skeleton**: imita el shape del contenido que todavía no llegó — el paso previo antes de decidir que algo está vacío.
- **Button**: ejecuta la acción del empty state.
- **Table**: layout de filas/columnas que suele preceder al empty state cuando no hay registros.

Pregunta clave del sitio: ¿es lo mismo un empty state que un error state? No — es el error más frecuente del componente. Empty significa que la request funcionó y genuinamente no hay nada que mostrar. Error significa que la request falló. Mostrar un mensaje amable de "vacío" cuando en realidad una llamada al servidor falló esconde el problema y elimina lo único que lo arreglaría: un botón de retry.
