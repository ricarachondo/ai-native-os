Fuente: https://02ui.com/components/drawer/ (consultado 2026-08-05)

# Drawer

Panel que desliza desde el borde de la pantalla y mantiene la página de atrás visible, atenuada pero presente. Esa es toda la diferencia con un modal: un drawer permite mirar hacia atrás sin cerrarlo.

## Cuándo usarlo / Cuándo NO — usa X

Usar drawer cuando: alguien se beneficia de comparar el contenido del drawer contra la página de atrás (ej. panel de filtros junto a la lista que filtra); el contenido es naturalmente una lista, un form o un set de opciones, no una decisión única a forzar; en viewport angosto y el contenido necesita más espacio que un popover sin salir de la pantalla actual (bottom sheet); descartarlo no cuesta nada (swipe o tap afuera nunca debería perder algo importante).

Cuándo NO:
- La acción es destructiva o la tarea realmente necesita bloquear la página → usa **modal**.
- El contenido es un detalle corto y contextual ligado a un control específico (rango de fechas, swatch de color) → usa **popover**.
- El contenido merece su propia URL/back button/bookmark → eso es una **página**.
- Se abre un drawer desde dentro de otro drawer o de un modal → cerrar la primera capa, o combinar las dos tareas en una.

## Variantes

- **Right** (default): panel de detalle o form ligado a una fila/card. En idiomas LTR se lee como una adición a lo que ya se estaba mirando.
- **Left**: reservado para navegación, el mismo lugar donde viviría un sidebar fijo.
- **Bottom** (bottom sheet): patrón mobile — abre/cierra con gesto de swipe hacia abajo, queda al alcance del pulgar, no recorre todo el ancho de la pantalla.

## Estados

Closed → Open (panel desliza, backdrop atenúa; foco entra inmediatamente, no queda en el trigger detrás del backdrop) → Dragging (solo bottom sheet táctil: sigue el dedo/puntero; snap-back si se suelta antes de cruzar el umbral de dismiss, cierra si se suelta después — el umbral es aprox. un tercio de la altura del panel) → Closing (foco vuelve al trigger al terminar la animación).

## Comportamiento clave

- Desliza desde un borde de pantalla (no escala desde el centro como un modal) — la dirección del movimiento indica de dónde vino y hacia dónde vuelve al cerrar.
- La página de atrás permanece visible, atenuada por backdrop pero no reemplazada.
- Foco entra al abrir (misma regla que modal): primer elemento focuseable o el heading.
- Foco queda atrapado mientras está abierto **cuando tiene backdrop y bloquea la página** (caso común); un drawer no-modal que deja la página interactiva no necesita trap, pero entonces nada detrás debe asumir que el drawer está "fuera del camino".
- Escape y click en backdrop cierran, salvo cambios sin guardar (misma excepción que modal).
- Dragging de un bottom sheet sigue el gesto en tiempo real.
- Solo un drawer abierto a la vez — abrir uno segundo cierra el que estaba abierto.

## Accesibilidad

- `role="dialog"` con `aria-modal="true"` cuando bloquea la página (mismo patrón que modal). Un drawer no-modal debe omitir `aria-modal` completamente (no ponerlo en `false` — algunas tecnologías asistivas ignoran el valor `false`).
- Nombrarlo con `aria-labelledby` apuntando al heading propio.
- Fondo inert mientras es modal (mismo tratamiento que modal).
- Contraste: 4.5:1 texto contra fondo del panel (WCAG 1.4.3), el panel debe leerse como superficie distinta de la página atenuada.
- Target size: 24×24px CSS mínimo (WCAG 2.5.8) para handle y botón de cerrar; en bottom sheet táctil, 44×44 es el target más seguro.
- Teclado: Tab/Shift+Tab ciclan solo dentro del panel (wrap en extremos); Escape cierra y devuelve foco al trigger; Enter/Space activan el control con foco.

## Copy

- El título nombra lo que hay adentro, no el mecanismo: "Filter results" mejor que "Filters panel".
- En bottom sheet, mantener la acción primaria alcanzable sin scroll (alguien arrastrando el sheet hacia arriba en un celular chico no debería tener que buscar el botón que cierra la tarea).
- Empty states dentro de un drawer necesitan un próximo paso: un drawer de filtros sin matches debe decirlo y sugerir limpiar un filtro, no solo renderizar una lista en blanco debajo.

## Errores comunes

1. Sin forma visible de cerrar — depender solo de click en backdrop o swipe excluye a quien no descubre ninguno de los dos.
2. Click en backdrop descarta un form silenciosamente — misma regla que modal: confirmar primero, o no permitir dismissal por backdrop con input sin guardar.
3. Sin focus trap en un drawer modal — Tab entra a la página de atrás mientras el drawer sigue bloqueando clicks (peor que en modal porque la página está visiblemente ahí, invitando a intentarlo).
4. Side drawer usado para confirmación destructiva — mantener la página visible resta seriedad a la acción; usar modal en su lugar.
5. Bottom sheet que ignora el gesto de drag — se siente roto la primera vez que alguien intenta el swipe obvio y no pasa nada.
6. Contenido más alto que el panel sin scroll interno — pierde todo lo que queda bajo el fold.

## Casos borde

- Drawer más alto que el viewport: scroll dentro del panel, header/footer fijos (mismo patrón que modal).
- Resize mientras está abierto (rotar el celular): recalcular la altura del panel en vez de dejarlo con el tamaño de la orientación en que abrió.
- Drawer abierto desde dentro de un modal: cerrar el modal primero — dos overlays con dos focus traps compitiendo por el mismo Tab no es una combinación soportada.
- `prefers-reduced-motion`: bajar el slide a fade plano o quitar la transición.
- Regiones scrolleables anidadas: un bottom sheet con su propia lista scrolleable necesita que el gesto de drag y el scroll de la lista no compitan — normalmente se resuelve iniciando el drag solo cuando la lista ya está scrolleada hasta arriba.

## Componentes relacionados

- **Modal**: bloquea la página completa hasta terminar/cancelar la tarea — usar cuando la tarea necesita un hard stop.
- **Popover**: contenido flotante anclado a un trigger, clickeable adentro.
- **Menu**: lista de acciones revelada por un trigger.

Nota clave del sitio (drawer vs modal): si la tarea necesita un hard stop, es modal. Si se beneficia de quedar visible mientras se interactúa con el resto, es drawer. Para mobile, bottom sheet es casi siempre la opción sobre side drawer (gesto natural, alcance del pulgar); reservar side drawer en mobile solo para navegación con posición fija ya aprendida (ej. menú principal).
