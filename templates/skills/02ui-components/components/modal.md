Fuente: https://02ui.com/components/modal/ (consultado 2026-08-05)

# Modal

Ventana que se posiciona sobre la página y bloquea todo lo demás hasta que la tarea dentro se termina o cancela. Es el overlay más disruptivo sin navegar fuera de la página — y por eso el más sobreusado cuando algo más pequeño bastaría.

## Cuándo usarlo / Cuándo NO — usa X

Usar modal cuando: la tarea debe terminarse o cancelarse antes de que pase cualquier otra cosa (ej. confirmar una acción destructiva); perder de vista la página no cuesta nada porque la tarea es corta y autocontenida; la acción es rara (una página dedicada quedaría sin uso la mayor parte del tiempo); la interrupción es deliberada (error que bloquea el progreso, paso de pago, confirmación legal).

Cuándo NO:
- La tarea puede pasar sin bloquear el resto de la pantalla (panel de filtros, vista de detalle que alguien podría querer comparar con la lista de atrás) → usa **drawer**.
- Es información pequeña anclada a un control (selector de color, form corto ligado a un solo campo) → usa **popover**.
- Es confirmar que algo ya pasó, sin nada que decidir → usa **toast**.
- El contenido merece su propia URL, back button o bookmark → eso es una **página**, no un overlay.
- Se abre un modal desde dentro de otro modal → cerrar el primero o repensar por qué la tarea necesita dos capas.

## Variantes

- **Standard**: título, cuerpo, una o dos acciones en el footer. Cubre la mayoría de los casos.
- **Alert dialog**: sin dismissal por backdrop y a menudo sin Escape. Para confirmación destructiva o mensaje que hay que reconocer activamente — un cierre accidental anularía el propósito de preguntar.
- **Full screen**: llena el viewport en vez de flotar al centro, para tareas complejas (form multi-paso) sin el peso de salir a una página nueva.

## Estados

Closed (el trigger mantiene apariencia normal e interactiva) → Opening (bajo 200ms, un open lento se lee como producto lento) → Open (foco dentro, página de atrás inerte — no solo visualmente atenuada, sino inalcanzable por mouse, teclado y screen reader) → Closing (foco vuelve al trigger; perder el rastro de a dónde debe volver el foco es el bug más común aquí).

## Comportamiento clave

- Foco entra al dialog al abrir (primer elemento focuseable o el heading), nunca queda en lo que estaba detrás.
- Foco queda atrapado adentro mientras está abierto — Tab/Shift+Tab ciclan solo dentro del dialog.
- La página de atrás es `inert`, no solo atenuada visualmente: usar el atributo nativo `inert` (o `aria-hidden="true"` + sacar todo del tab order).
- Escape cierra, excepto en alert dialog.
- Foco vuelve al elemento que abrió el modal al cerrar.
- Scroll de la página de atrás queda bloqueado mientras el modal está abierto.
- Solo un modal abierto a la vez — modal dentro de modal significa que la tarea necesita reestructurarse, no una segunda capa.

## Accesibilidad

- `role="dialog"` (o `role="alertdialog"`) con `aria-modal="true"`, o usar `<dialog>` nativo con `showModal()` (lo configura automáticamente).
- Nombrarlo con `aria-labelledby` apuntando al título — sin esto un screen reader anuncia "dialog" sin más contexto.
- Fondo inert es requisito del patrón WAI-ARIA modal dialog.
- Contraste: 4.5:1 texto del título contra fondo del dialog (WCAG 1.4.3); el borde/sombra del dialog debe leerse como superficie distinta del overlay.
- Target size: 24×24px CSS mínimo (WCAG 2.5.8) para botón de cerrar y acciones del footer, con separación clara entre ellos.
- Teclado: Tab/Shift+Tab ciclan solo dentro (wrap en ambos extremos); Escape cierra y devuelve foco al trigger (excepto alert dialog); Enter activa el control con foco.

## Copy

- El título nombra la tarea, no el componente: "Delete project" mejor que "Confirm" o "Are you sure?" — debe sobrevivir siendo leído solo por un screen reader, fuera de contexto.
- Una oración de cuerpo para una confirmación; si necesita tres, el modal está haciendo demasiado.
- Para algo destructivo, nombrar explícitamente qué pasa: "This deletes the project and everything in it. This can't be undone" en vez de un ícono de advertencia genérico + "Are you sure?".
- La acción primaria es un verbo, no "OK" ni "Submit": "Delete project", "Save changes", "Send invite".
- Cancel siempre debe existir como salida — no renombrar la acción primaria a algo que haga desaparecer la vía de escape.

## Errores comunes

1. "Are you sure?" como todo el mensaje — no dice de qué, ni la consecuencia.
2. Sin focus trap — Tab pasa directo a la página de atrás.
3. Click en backdrop descarta trabajo no guardado silenciosamente — confirmar primero o deshabilitar dismissal por backdrop en forms.
4. Modales anidados — dos capas de focus trap y dos overlays apilados; casi siempre indica que la tarea debió ser un solo dialog.
5. Modal para algo que merecía una página — forms largos, flujos multi-paso, cualquier cosa que valga un bookmark/back button.
6. Botón primario deshabilitado sin explicación — mejor mantenerlo habilitado y validar al submit, o decir exactamente qué falta.
7. Sin forma visible de cerrar — depender solo de Escape excluye a quien no conoce el shortcut.

## Casos borde

- Viewports chicos: expandir a full screen bajo un breakpoint en vez de encoger el layout de escritorio (el teclado cubriendo medio celular deja campos inalcanzables).
- Contenido más alto que el viewport: scroll dentro del body del dialog, con header/footer fijos.
- Modal que abre otro modal: cerrar el primero antes, o combinarlos en un dialog con pasos — dos focus traps apilados no es un patrón soportado.
- `prefers-reduced-motion`: bajar la animación de scale/slide a un fade plano o nada.
- Cierre async: si cerrar dispara un guardado, deshabilitar los controles de cierre hasta que resuelva.

## Componentes relacionados

- **Drawer**: desliza desde el borde, mantiene la página visible atenuada de fondo — usar cuando NO se necesita bloquear.
- **Popover**: contenido flotante anclado a un trigger, clickeable adentro — usar para tareas chicas ligadas a un control.
- **Button**: ejecuta una acción sin abandonar la página.
- **Banner**: mensaje persistente en la página hasta que cambia la condición de fondo.

Nota: "Modal" y "Dialog" se usan indistintamente en la práctica — "dialog" es el término más preciso (y el nombre del elemento `<dialog>` y del rol ARIA); "modal" describe el comportamiento (bloquea la página de atrás). Un dialog puede ser no-modal (panel flotante ignorable), pero casi todo lo que se llama "modal" en producto es un modal dialog.
