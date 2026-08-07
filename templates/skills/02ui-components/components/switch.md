Fuente: https://02ui.com/components/switch/ (consultado 2026-08-05)

# Switch

Enciende o apaga algo y aplica el cambio de inmediato. Esa inmediatez es todo el componente y es la línea que lo separa de un checkbox. Build difficulty: Easy.

## Cuándo usarlo / Cuándo NO

Usar switch cuando: el cambio debe aplicarse al momento de tocarlo, sin paso de guardado; hay exactamente dos estados (on/off), nada intermedio; el setting es independiente de los demás alrededor; se puede revertir instantáneamente si el guardado falla.

Cuándo NO — usa otro componente:
- El cambio debe esperar un botón de guardar/submit → **checkbox**.
- El control necesita estado mixto/indeterminado → **checkbox**.
- Debe elegirse exactamente una opción entre varias visibles → **radio group**.
- Activarlo debería disparar una acción puntual en vez de sostener un estado → **button**.

Pregunta clave (checkbox vs switch): ¿cuándo aplica el cambio? Al clic → switch. Espera guardado/submit → checkbox. Una pantalla de settings no implica switch automáticamente, ni un form implica checkbox automáticamente.

## Variantes

Single (un setting on/off solo: feature flags, notificaciones, dark mode), con descripción (segunda línea para una consecuencia que el label no carga, ej. "Aplica solo a archivos nuevos"), compacto (tamaño pequeño para listas densas), y lista agrupada (varios switches independientes apilados con dividers — "independiente" es la palabra clave: activar uno nunca debería mover otro, salvo relación declarada explícitamente, como Modo Avión nombrando qué va a desactivar).

## Estados

Off, On (el color de relleno no es la única señal — la posición del thumb es lo que carga el estado; "reduced motion" debe ralentizar el slide, nunca eliminarlo), Focus, Saving (el thumb muestra un spinner chico, control inerte — existe porque el cambio ya se aplicó antes de que alguien confirmara que funcionó; saltarse este estado hace que un guardado fallido parezca que no pasó nada), Disabled (necesita razón cercana, igual que un checkbox deshabilitado), Disabled+On (caso común: un setting bloqueado en "on" por un admin o plan).

## Comportamiento

El cambio aplica ahora — es todo el componente. Si el switch espera un botón de guardar, en realidad se construyó un checkbox con el dibujo equivocado. Clicar el label también lo mueve, gratis, si label y control están bien asociados. Un switch activado confirma o revierte: tratar la request detrás como cualquier acción asíncrona (mostrar aplicando, luego éxito o revertir con mensaje). Sin sorpresas en cascada, con una excepción nombrada: activar un switch no debería mover otro, salvo que la dependencia sea visible y nombrada (Modo Avión desactivando wifi/bluetooth visiblemente). Siempre binario: sin estado mixto, sin tercera opción.

## Accesibilidad

- Teclado: Tab mueve al siguiente switch; Space activa; Enter también activa (a diferencia del checkbox, que reserva Enter para submit — un switch construido como `<button>` real da ambas teclas gratis).
- Contraste: el track necesita 3:1 contra la página en ambos rellenos (on y off).
- Nunca color solo — la posición del thumb ya satisface esto en un switch nativo; un build custom que solo recolorea el track sin mover nada falla.
- Anunciar el estado como "on"/"off", no "checked" — `role="switch"` + `aria-checked` hace que el lector de pantalla diga "activado"/"desactivado", que es como la gente ya habla de un switch.
- Target size 24×24px (WCAG 2.5.8) — el track solo suele ser más chico, extender el área de toque en vez de redibujarlo más grande.
- Patrón de build recomendado: `<button type="button" role="switch" aria-checked="false" aria-labelledby="...">`. Safari agregó `switch` nativo en `<input type="checkbox">` en 2024, pero el soporte en otros navegadores aún no está — el patrón de botón con `role="switch"` sigue siendo el default seguro.

## Copy

Nombrar el setting, no su estado ("Modo oscuro" > "Modo oscuro: activado" — el switch ya muestra el estado). Sentence case, sin punto final, sin signo de pregunta (es un label de setting, no una pregunta pidiendo permiso). Una sola oración en la línea de descripción, solo para la consecuencia. Sin captions "Off"/"On" en los extremos del track — un solo label nombrando el setting alcanza.

## Errores comunes

1. Switch dentro de un form que necesita guardarse — si el resto de la página espera submit, ese control también debería, o hay que sacarlo y marcarlo como diferente.
2. Sin revertir en un guardado fallido — el switch queda activado, la request falló silenciosamente, la persona cree que algo cambió y no cambió.
3. Labels en ambos extremos del track ("Off"/"On" impresos junto a un switch que ya se mueve para mostrar su estado).
4. Switches custom hechos con dos divs — pierden `role="switch"`, el manejo de Space/Enter, y el anuncio "on"/"off".
5. Switch disfrazando 3+ opciones ("Público", "Privado", "No listado" forzadas en un on/off pierde la opción del medio) → radio group o select.
6. Tap targets del tamaño del track (20px de alto sin padding es un miss común en mobile).

## Casos borde

Switch mezclado en un form que también necesita paso de guardado → darle tratamiento visual propio (divider o card) para que se lea como un tipo de control distinto. Cambio destructivo o difícil de revertir (ej. hacer público un workspace privado) → agregar confirmación antes de aplicar; esto rompe la regla de "nunca espera" y está bien, la regla protege preferencias ordinarias, no fuerza una acción irreversible con un clic. Guardado lento en backend → mostrar el estado Saving y deshabilitar el control mientras la request está en vuelo para que un segundo flip no compita con el primero. RTL: la posición "on" se espeja, el thumb se mueve a la izquierda cuando está activado. Switches dependientes: construir la cascada solo si es visible, nombrar qué afecta, y permitir override después.

## Componentes relacionados

- **Checkbox**: elige cualquier número de opciones, incluido ninguna; el cambio espera guardado.
- **Radio group**: muestra todas las opciones a la vez, elige exactamente una.
- **Banner**: mensaje que permanece en la página hasta que cambia la condición detrás.
