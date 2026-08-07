Fuente: https://02ui.com/components/popover/ (consultado 2026-08-05)

# Popover

Contenido flotante anclado a un trigger. La distinción central con un tooltip: si algo adentro es clickeable, es popover; si no, es tooltip disfrazado de caja más grande.

## Cuándo usarlo / Cuándo NO — usa X

Usar popover cuando: el contenido incluye algo clickeable (link, botón, campo de form, swatch de color); es una tarea corta y autocontenida ligada a un control específico (editar una fecha, elegir un label); perder de vista la página de fondo está bien porque el popover solo necesita un momento de atención; el contexto del trigger importa (anclar cerca de él, a diferencia de un modal, mantiene la conexión visible).

Cuándo NO:
- El contenido es un label corto no-interactivo, sin nada que clickear → usa **tooltip** (más simple y barato).
- La tarea es lo bastante importante como para justificar bloquear toda la página (confirmación destructiva) → usa **modal**.
- Es una lista de acciones que cada una ejecuta algo inmediatamente (Rename, Delete) → usa **menu**.
- El contenido necesita espacio real (más que un form corto o lista breve) o se beneficia de quedar abierto mientras se escanea la página de atrás → usa **drawer**.

## Variantes

- **Info panel**: versión más rica de un tooltip, para contenido de más de una oración o con link adentro (ej. explicación + "Learn more").
- **Form**: input corto autocontenido ligado al trigger (ej. renombrar un ítem, editar un campo sin salir de la página).
- **Date picker**: calendario anclado a un campo, cierra al elegir fecha.

## Estados

Closed (solo el trigger visible, necesita su propia affordance clara) → Open (panel anclado, foco al primer campo/elemento; solo un popover abierto a la vez, misma regla que un menu) → Focus inside (Tab mueve entre los controles del panel; al llegar al último y presionar Tab de nuevo, el foco debe **salir** del panel, no volver en loop al primero) → Repositioned (el panel flipea de lado si se saldría del viewport, sin perder el anclaje al trigger).

El estado "focus inside" es donde más se construye mal: copiando el focus trap de un modal sin más. Un popover no es un modal en miniatura — Tab puede salir de él.

## Comportamiento clave

- Se ancla al trigger y reposiciona si el trigger se mueve o el viewport es chico para su placement actual (flipea de lado en vez de salirse de la pantalla).
- Abre con **click**, no con hover (hover es trabajo de tooltip; usarlo para contenido clickeable lo vuelve inalcanzable para quien no puede mantener el hover con precisión).
- **No atrapa foco**: Tab recorre los controles del panel y luego continúa hacia el resto de la página, cerrando el popover al salir — la diferencia más grande respecto a un modal.
- Cierra con click afuera, con Escape, y a menudo tras confirmar una elección (fecha elegida, color seleccionado) — igual que un menu cierra al elegir un ítem.
- Solo un popover abierto a la vez — abrir otro, o abrir un menu/select, cierra el popover previo.
- Reposiciona en scroll y resize.

## Accesibilidad

- El trigger necesita `aria-haspopup="dialog"` (o el rol más específico que aplique) y `aria-expanded`.
- El panel suele llevar `role="dialog"` **sin** `aria-modal` — ese detalle le indica a la tecnología asistiva que no bloquea la página.
- Sin focus trap: dejar que el foco salga hacia la página es correcto acá, no un bug a corregir.
- Contraste: 4.5:1 texto contra fondo del panel (WCAG 1.4.3).
- Target size: 24×24px CSS mínimo (WCAG 2.5.8) en cada elemento clickeable adentro.
- Zoom: a 200% el panel debe quedar dentro del viewport — flipear el placement en vez de dejar que se recorte.
- Teclado: Enter/Space abren desde el trigger; Tab mueve por los controles del panel y luego sale a la página cerrando el popover; Shift+Tab desde el primer control vuelve al trigger y cierra; Escape cierra y devuelve foco al trigger.

## Copy

- Título solo si el contenido lo necesita para tener sentido solo (un campo de form único raramente lo necesita; un form multi-paso o explicación larga usualmente sí).
- Mantenerlo a una sola tarea — un popover con dos forms no relacionados es señal de que el trigger hace dos trabajos y necesita dividirse en dos triggers.
- Acción primaria visible para todo lo que necesite confirmarse (ej. "Save" en un campo de rename), no depender solo del click-afuera para implicar que el valor se guardó.

## Errores comunes

1. Abre con hover — cualquier cosa clickeable adentro se vuelve inalcanzable (al moverse hacia el contenido, se cierra antes).
2. Focus trap copiado de un modal — Tab debería poder salir del panel y cerrarlo, no ciclar por siempre en un form que nunca debió bloquear la página.
3. Sin affordance visible del trigger — un botón de apariencia plana que abre un panel no avisa nada.
4. Popover apilado desde dentro de otro popover — dos paneles flotantes compitiendo por el mismo click-afuera/Escape.
5. Contenido que necesitaba una página completa — un form de cinco campos con validación propia y flujo multi-paso ya superó al componente; mover a página o drawer.
6. Sin reposicionamiento cerca del borde del viewport — un popover que abre parcialmente fuera de pantalla es ilegible para quien no puede hacer scroll de vuelta.

## Casos borde

- Cerca del borde del viewport: flipear placement en vez de recortar (misma regla que tooltip y menu).
- El trigger se mueve o desmonta mientras el popover está abierto (lista virtualizada, layout animado): recalcular posición en scroll, o cerrar en scroll (más simple y usualmente correcto).
- Contenido más alto que el espacio restante del viewport: scroll dentro del panel.
- Anidado dentro de un modal: está bien, porque el popover no atrapa foco propio — el trap del modal sigue aplicando a la página completa, y el popover solo agrega una segunda capa flotante dentro de ese contexto.
- RTL: placement y dirección de la flecha se reflejan, igual que en tooltip.

## Componentes relacionados

- **Tooltip**: label corto no-interactivo que aparece con hover o focus — usar cuando nada adentro es clickeable.
- **Modal**: bloquea toda la página hasta terminar/cancelar.
- **Menu**: lista de acciones donde elegir una cierra el panel y ejecuta la acción — si solo se puede elegir un ítem de una lista y nada más, es un menu disfrazado de popover.
- **Drawer**: desliza desde el borde, mantiene la página visible atenuada de fondo.

Nota clave: la prueba real popover vs tooltip es "¿se puede clickear algo adentro?". Y popover nunca necesita focus trap tipo modal — ese es el error de implementación más común.
