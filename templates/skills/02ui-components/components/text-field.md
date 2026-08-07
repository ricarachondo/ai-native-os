Fuente: https://02ui.com/components/text-field/ (consultado 2026-08-05)

## Qué es
Un text field es un input de una sola línea para texto libre y corto. Es el componente más denso de la UI: las decisiones pequeñas sobre labels, hints y el momento de validar deciden si la gente termina el formulario. `<input type="text">`.

## Cuándo usarlo / Cuándo NO
Usar text field cuando: la respuesta es texto libre corto e impredecible (nombre, email, número de referencia), la respuesta cabe en una línea sin formato, y se quiere permitir pegar/autofill/password manager.

Usar otra cosa cuando:
- La respuesta es una de un set pequeño y conocido de opciones → **Radio group** o **Select**.
- La respuesta corre a varias líneas o un párrafo → **Textarea**.
- La respuesta es sí/no → **Checkbox**.
- La respuesta es una opción de una lista larga buscable → **Combobox**.

## Dónde va el label
Siempre arriba del campo. Labels al costado cuestan espacio horizontal y se rompen en pantallas angostas; labels flotantes dentro del borde ("floating labels") quitan el lugar del hint y perjudican a quien usa magnificación de pantalla (el label se sale de vista mientras se llena el campo).

## Variantes
Con ícono leading (ayuda a identificar el tipo de campo, ej. search), Numeric (usar `type="text"` + `inputmode="numeric"` + `pattern="[0-9]*"`, NO `type="number"` — este agrega flechas spinner no deseadas, rechaza silenciosamente valores pegados con espacios, y permite que el scroll del mouse cambie un número de tarjeta por accidente), Read only (valor visible, seleccionable, copiable, NO editable, pero SÍ se envía con el formulario — distinto de disabled), Password (siempre con toggle de mostrar/ocultar; ocultar la contraseña dejó de ser una medida de seguridad real y es la mayor causa individual de fallos de login).

## Estados
Default (borde 3:1 contra la página, WCAG 1.4.11), Hover (borde se oscurece, señal sutil), Focus (borde accent + ring visible, nunca quitar el outline sin reemplazo), Filled (el valor debe tener más contraste que el placeholder), Error (borde rojo, mensaje debajo, `aria-invalid="true"`, el color solo no basta — WCAG 1.4.1), Disabled (opacidad reducida, no focuseable, no se envía), Read only (fondo plano sin borde, sigue siendo focuseable y se envía).

## Comportamiento
**El timing de la validación es todo el juego**: no decir nada mientras escriben la primera vez → validar en blur (al salir del campo) → una vez que aparece un error, revalidar en cada keystroke para que se limpie apenas se corrige → validar todo de nuevo al submit y mover el foco al primer error. Validar mientras la persona escribe su email dice "murat@ es inválido" a medio escribir — correcto pero inútil y hostil.

Nunca bloquear caracteres en silencio (si rechaza un keystroke sin explicación, la gente cree que el teclado está roto). Aceptar input "sucio" y reformatearlo (quitar espacios de números de tarjeta, guiones de teléfonos, mayúsculas de códigos postales) en vez de exigir que la persona lo formatee. Setear `autocomplete` en todo campo que mapee a un valor conocido (email, given-name, postal-code, cc-number, one-time-code) — WCAG 1.3.5 (AA) lo pide. Hacer trim en el submit (un espacio inicial de un paste nunca debería impedir un login).

## Accesibilidad
- Label programático obligatorio, en orden de preferencia: (1) `<label for>` + `id` explícito (mejor, hace el label clickeable), (2) label envolvente, (3) `aria-label` como último recurso.
- Placeholder NO es label (desaparece al primer keystroke; quien es interrumpido a medio formulario vuelve a ver campos llenos sin saber qué son).
- Hints y errores se conectan con `aria-describedby` (ambos ids pueden ir en el mismo atributo). `role="alert"` en el mensaje de error para que se anuncie al aparecer (no usarlo en un hint que ya estaba ahí desde el inicio).
- Teclado: Tab entra al campo; Esc limpia el valor solo en campos de búsqueda; Enter envía el formulario si el campo está dentro de uno (crítico para formularios de un solo campo).
- Mobile: fuente mínima 16px (Safari hace zoom si es menor y no vuelve a des-zoomear — el bug móvil de formularios más común), nunca desactivar zoom (`user-scalable=no` falla WCAG 1.4.4), altura mínima 44px, setear `inputmode` correcto (numeric, tel, email, decimal, url).

## Copy
Labels son sustantivos, no preguntas ("Work email" mejor que "What is your work email?"). Sentence case. Decir qué se quiere, no qué es ("Name as it appears on your card" mejor que "Cardholder"). Errores necesitan 3 cosas: qué falló, por qué, y qué hacer ("Enter an email address in the format name@example.com" cumple las 3; "Invalid input" no cumple ninguna). Nunca culpar a la persona. Marcar lo que sea más raro: si 10 de 12 campos son requeridos, marcar los 2 opcionales con "(optional)"; si es al revés, marcar los requeridos.

## Errores comunes
1. Placeholder como label (el más común de la industria; GOV.UK Design System ahora recomienda no usar placeholder en absoluto).
2. Validar demasiado temprano (borde rojo a media palabra).
3. Quitar el focus outline sin reemplazo (inutiliza el formulario por teclado).
4. `type="number"` para cosas que no son números matemáticos (tarjetas, teléfonos, códigos postales, PINs son strings que contienen dígitos).
5. Campo dimensionado mal respecto a la respuesta esperada (un campo de 2 dígitos que ocupa todo el ancho sugiere una respuesta más larga).
6. Perder el input al fallar la validación (limpiar el formulario por un solo campo fallido pierde a la persona).
7. Deshabilitar paste, especialmente en password/tarjeta (rompe password managers, sin valor de seguridad real).

## Casos borde
Valores muy largos: deben hacer scroll dentro del campo, no estirar el layout. RTL: usar propiedades lógicas (`padding-inline-start`) para que el campo, label y hint se reflejen sin hoja de estilos aparte. Zoom 200%: label, campo y hint deben seguir visibles (WCAG 1.4.4). Autofill de Chrome aplica su propio color de fondo — verificar que el texto siga legible. Validación lenta (chequeo de username contra servidor): mostrar estado pending, el silencio se lee como fallo. Password managers inyectan valores sin disparar los eventos que el framework espera — probar con uno real. Dictado por voz: la puntuación llega como palabras ("comma", "full stop") — no rechazar sin explicar.

## Componentes relacionados
- **Textarea**: cuando la respuesta corre a más de una línea.
- **Select**: cuando la respuesta es una de un set pequeño y conocido.
- **Combobox**: cuando la lista de opciones es larga y buscable.
- **Checkbox**: para respuestas sí/no o selección múltiple.
- **Banner**: para mensajes persistentes de estado, ej. email sin verificar.
