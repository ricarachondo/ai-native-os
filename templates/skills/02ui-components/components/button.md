Fuente: https://02ui.com/components/button/ (consultado 2026-08-05)

## Qué es
Un botón ejecuta una acción y la persona se queda en la misma página. Si el clic la lleva a otro lado, es un link, aunque se vea como botón. `<button type="button">` para acción; `type="submit"` (default si no se especifica type) para enviar formulario.

## Cuándo usarlo / Cuándo NO
Usar botón cuando: algo ocurre y la persona permanece en la página, se envía un formulario, se abre un dialog/drawer/panel, o es la acción principal de la pantalla.

Usar otra cosa cuando:
- El clic carga otra página/sitio → **Link**.
- Revela una lista de acciones para elegir → **Menu**.
- Enciende/apaga algo y aplica el cambio de inmediato → **Switch**.
- Marca una elección que un botón "guardar" aplicará después → **Checkbox**.

## Variantes
Primary (relleno, una sola por pantalla), Secondary (misma altura, relleno más suave), Outline/Ghost (para toolbars, filas de tabla, esquinas de card; ghost necesita hover real porque en reposo se lee como texto plano), Destructive (rojo, normalmente sin relleno para que el color funcione como advertencia), Icon-only (necesita `aria-label` + tooltip con el mismo texto). Tamaños: 4 alturas disponibles (24–40px), elegir 2 para el producto y no más.

## Estados
Default, Hover (no existe en touch, nunca debe ser la única señal), Focus (ring visible, quitarlo sin reemplazo viola WCAG 2.4.7), Pressed (shift de 1px o fill más oscuro; omitirlo hace sentir la red lenta como rota), Loading (spinner, deja de aceptar clics; el botón NO debe cambiar de tamaño — reservar el ancho o mantener el label y poner el spinner al lado), Disabled (opacidad reducida, sin pointer-events, fuera del tab order, exento de las reglas de contraste WCAG 1.4.3).

**Sobre disabled**: la práctica de "grisar" el submit hasta que el formulario sea válido se ve bien en un mockup pero funciona mal en uso real — no da razón, no es focuseable, y queda fuera de las reglas de contraste. Mantener el botón activo y mostrar errores junto a los campos. Reservar `disabled` solo para los segundos en que la request está en curso (usar `aria-disabled="true"` + `aria-busy="true"` en loading, no el atributo `disabled` real, para no perder el foco del teclado).

## Comportamiento
Un press, una acción (si hace dos cosas, una debe ir a otro control). Responder dentro de un segundo (bajo 100ms no requiere loading state; sobre 1s sí). No moverse ni cambiar de tamaño en hover/loading. Dentro de un form, sin `type` explícito es `submit` por defecto. Doble clic: guardar también en el handler, no solo deshabilitar el botón (una request en curso puede llegar tarde).

## Accesibilidad
- Icon-only: `aria-label` describiendo la acción + `aria-hidden="true"` y `focusable="false"` en el SVG interno (evita doble nombre).
- El texto del tooltip debe coincidir exactamente con el `aria-label` (WCAG 2.5.3 Label in Name).
- Teclado: Tab (cada botón es su propio tab stop), Enter activa en keydown, Space activa en keyup (de ahí existe el estado pressed).
- Reconstruir un botón con un `<div>` pierde Enter/Space/submit/pressed state; `role="button"` solo repone el nombre en el árbol de accesibilidad, no el comportamiento.
- Contraste: label 4.5:1 contra el fill (1.4.3); si el fill es el único borde visible, 3:1 contra el fondo de página (1.4.11).
- Target size: 24×24px CSS mínimo (WCAG 2.5.8); Apple pide 44×44pt, Android 48dp.
- Nunca color como única señal (~8% de hombres con daltonismo).

## Copy
Empezar con verbo ("Save changes", "Create account"). Nombrar el objeto si hay ambigüedad ("Delete 3 files" mejor que "Delete"). 1–3 palabras. El label debe anticipar lo que pasa después (evitar "Continue" genérico si abre una pantalla de pago — mejor "Go to payment"). Cuidado con "Cancel" en dialogs de confirmación con doble sentido — nombrar ambas acciones ("Keep subscription" / "Cancel subscription"). Sentence case, sin punto final.

## Errores comunes
1. Dos botones primary en una misma pantalla (ninguno destaca realmente).
2. Un link construido como botón (rompe middle-click, right-click, nueva pestaña, historial — si carga página, debe ser `<a href>`).
3. Labels que solo nombran el control ("OK", "Submit", "Yes") sin decir la consecuencia.
4. Submit grisado por formulario incompleto (oculta la razón justo cuando se necesita).
5. Quitar el focus ring (falla WCAG 2.4.7).
6. Botón rojo relleno como respuesta por defecto en un dialog de eliminar (lo más "gritón" de la pantalla no debería ser lo destructivo).
7. Sin loading state (la gente reintenta y genera duplicados).

## Casos borde
Traducción: strings cortos pueden crecer hasta 200% en otros idiomas — dejar que el botón haga wrap, nunca truncar. Botones repetidos en filas de tabla: usar `aria-label="Edit invoice 4482"` para diferenciarlos en lectores de pantalla. Spinner que parpadea: esperar ~300ms antes de mostrarlo y mantenerlo al menos 500ms una vez visible. RTL: ícono leading se mueve a la derecha; flechas de dirección se invierten, íconos de guardar no. Sticky footer en mobile: no debe tapar el campo con foco (WCAG 2.4.11). Windows High Contrast Mode: dar borde transparente a botones ghost para que no desaparezcan.

## Componentes relacionados
- **Link**: cuando el clic navega a otra página/sitio.
- **Menu**: cuando revela una lista de acciones.
- **Modal**: para abrir ventanas que bloquean la página.
- **Tooltip**: para complementar botones icon-only.
