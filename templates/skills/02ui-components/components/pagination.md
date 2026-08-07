Fuente: https://02ui.com/components/pagination/ (consultado 2026-08-05)

# Pagination

"Pagination" en realidad son tres componentes distintos bajo un mismo nombre: páginas numeradas, "load more" e infinite scroll. Cada uno responde una pregunta distinta sobre qué pasa cuando alguien vuelve más tarde a la lista.

## Cuándo usarlo / Cuándo NO

Usar paginación cuando: la lista es larga y cargarla completa es lento; los resultados están rankeados (la posición importa); alguien puede querer volver al mismo punto o compartir el link; hay un footer bajo la lista que debe seguir siendo alcanzable.

Cuándo NO — usa otra cosa:
- La lista cabe en una o dos pantallas (bajo ~25 ítems) → usa **una sola lista con scroll**, el pager no esconde nada y solo agrega control.
- La gente busca un registro específico, no navega un set rankeado → usa **búsqueda y filtros**.
- Son unas pocas vistas equivalentes (peer views), no una lista larga del mismo tipo → usa **tabs**.

## Variantes

- **Numerada**: previous, números con el actual marcado, truncamiento, next. La más informativa, la única que permite saltar directo a una página.
- **Previous/Next solo** (sin números): correcta cuando el total es desconocido o costoso de calcular (típico en APIs con cursor) y en pantallas angostas.
- **Load more**: un botón que agrega el siguiente batch abajo de lo ya cargado. Mantiene la posición de lectura y el footer alcanzable.
- **Con rango de resultados** ("Showing 21 to 40 of 312") + control de filas por página: para tablas.

## Comportamiento clave

- La URL debe llevar la página (query param o route segment) — es la decisión que habilita back/forward/bookmark/compartir link.
- Al cambiar de página, el foco se mueve al heading de la lista o al primer resultado (no queda flotando en el botón).
- El cambio de página se anuncia vía live region (ej. "Page 3 of 16, showing 41 to 60").
- Load more **agrega**, no reemplaza — mantiene scroll position; mover foco al primer ítem nuevo o anunciar cuántos llegaron.
- Los filtros resetean a página 1 (nunca dejar "página 7" de una lista que ya no existe).
- El tamaño de página (rows per page) persiste como preferencia; no meterlo en la URL si es personal.
- Previous/Next deshabilitados se dejan **en su lugar** (no se ocultan) — ocultarlos desplaza el resto de los controles y cambia qué botón queda bajo el cursor al pasar de página 1 a 2.

## Accesibilidad

- Envolver en `<nav aria-label="Pagination">`. Si hay pager arriba y abajo de la misma lista, cada `<nav>` necesita un `aria-label` distinto (si no, un screen reader anuncia dos landmarks idénticos).
- `aria-current="page"` en la página actual — el marcador visual es invisible para un screen reader sin esto.
- Cada número necesita nombre: `aria-label="Page 4"` (un "4" pelado se anuncia como "4, link").
- El gap de truncamiento (…) es decorativo: `aria-hidden="true"`.
- Los links de página son `<a href>` reales (funciona middle-click, abrir en nueva pestaña). "Load more" es `<button>` porque cambia la página sin navegar.
- Target size: 24×24px CSS mínimo (WCAG 2.5.8) — los números de página son el elemento que más frecuentemente incumple esto.
- Contraste: 4.5:1 en texto (WCAG 1.4.3); los chevrons de prev/next necesitan 3:1 (WCAG 1.4.11) cuando cargan el significado solos (en pantallas angostas, sin la palabra).
- Teclado: Tab recorre previous → cada página → next; Enter sigue el link; Space activa "load more" (es un `<button>`).

## Copy

- Dar el total cuando se tenga: "Showing 21 to 40 of 312".
- "Load 20 more" es mejor que "Load more" — permite decidir si vale la pena esperar.
- Mantener las palabras "Previous"/"Next" (los chevrons solos son ambiguos en RTL y en pantallas chicas); ocultar la palabra bajo ~480px pero conservar el `aria-label`.
- No inventar un total que no se tiene: "Page 1 of many" o "1 to 20 of 1000+" leen como disculpa. Previous/Next sin conteo es la versión honesta.

## Errores comunes

1. La URL nunca cambia — rompe back, bookmark, refresh y compartir de una vez (el más grave de la lista).
2. Foco no se mueve tras cambiar de página — un usuario de teclado sigue con Tab desde un control que ahora está bajo otra lista.
3. Infinite scroll arriba de un footer — contacto, términos, sitemap se vuelven inalcanzables.
4. Previous/Next que desaparecen en los extremos en vez de deshabilitarse en su lugar.
5. Números de página bajo 24px — se ven bien en el diseño, fallan en el celular.
6. Página actual estilizada igual que las demás — deja de funcionar como orientación.
7. Perder la posición de scroll al volver (back) — hay que restaurar tanto los batches cargados como el offset de scroll.

## Casos borde

- Una sola página de resultados → ocultar el pager.
- Sin resultados → sin pager, y un empty state que aclare si la lista está vacía o si los filtros no matchearon nada.
- Número de página más allá del final (URLs viejas/editadas a mano) → redirigir a la última página o mostrar mensaje claro, nunca una lista en blanco bajo un pager funcional.
- Filas cambiando mientras se lee (offset pagination sobre lista que crece) → puede duplicar o saltarse filas; cursor pagination lo resuelve a costa de perder números de página (por eso muchas herramientas admin usan solo previous/next).
- Páginas muy profundas (ej. página 400) son lentas de consultar y casi nunca deseadas → limitar el rango numerado y apoyarse en búsqueda/filtros.
- Impresión: imprimir la página 3 de una lista imprime solo esas filas; si el documento debe ser completo, ofrecer una vista de impresión/export que ignore la paginación.

## Componentes relacionados

- **Table**: la paginación suele vivir bajo una tabla.
- **Loading/skeleton**: para el estado de carga entre páginas.
- **Empty state**: para cuando no hay resultados.
