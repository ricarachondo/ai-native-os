Fuente: https://02ui.com/components/banner/ (consultado 2026-08-05)

# Banner

Mensaje que se queda en la página hasta que la condición que lo generó cambia. La regla que lo define: se mantiene exactamente tanto como se mantiene la condición. Si desaparece solo, nunca fue un banner.

## Cuándo usarlo / Cuándo NO — usa X

Usar banner cuando: la condición persiste hasta que algo la cambia (factura impaga, outage, email sin verificar); el mensaje aplica a toda la página o sección, no a un campo; debería seguir ahí tras un reload; descartarlo (cuando se permite) no hace desaparecer el problema real.

Cuándo NO:
- Confirma algo que acaba de pasar y puede desvanecerse solo en segundos → usa **toast**.
- El problema es de un campo específico de un form → usa **inline field error**.
- Es un estado corto, una palabra → usa **badge**.
- Necesita bloquear la página hasta que alguien responda → usa **modal**.

## Variantes

- **Informational**: tono neutro, contexto continuo, no un problema. "You're on the free plan."
- **Warning**: condición que se vuelve un problema real si se ignora demasiado (trial por vencer, storage casi lleno).
- **Critical**: máxima severidad — pago fallido, outage, datos que no se guardan. Usualmente sin control de dismiss mientras la condición se mantiene.
- **With action**: un botón o link que resuelve la condición directamente, no un link genérico a un artículo de ayuda.
- **Dismissible**: control de cierre para una condición real pero no urgente; lo que se recuerda es la condición específica, no "banner descartado" en general.

## Estados

Informational (fill neutro) → Warning (fill/borde ámbar, ícono cambia, la palabra "Warning" tiene que seguir estando aunque haya color) → Critical (fill/borde rojo, sacar el dismiss necesita una razón real) → With action (un botón/link adentro, solo uno) → Dismissing (fade/collapse de un par de cientos de ms, animar también el alto para que el layout no salte) → Dismissed (oculto, condición registrada como reconocida — por condición específica, no en general).

## Comportamiento clave

- Se queda hasta que la condición cambia, no hasta que corre un timer — esa es toda la diferencia con un toast.
- Vive en el orden de lectura, normalmente arriba de la página o sección, nunca flotando sobre el contenido.
- Cuando compiten varias condiciones a la vez, mostrar la más severa y resumir el resto ("+2 more issues") en vez de apilar todas a altura completa.
- El dismiss se recuerda por condición (ej. el ID de la factura), no por sesión — "descartado hoy" que reaparece mañana entrena a la gente a dejar de leer.
- Live region solo si aparece en respuesta a algo (ej. un save fallido); uno que ya está en el markup inicial no necesita rol de live region.

## Accesibilidad

- Tab mueve al botón de acción o al control de dismiss, el cuerpo del banner nunca es tab stop.
- `role="status"` (`aria-live="polite"`) para la mayoría; `role="alert"` (`aria-live="assertive"`) solo para crítico cuando aparece en respuesta a algo.
- Contraste 4.5:1 chequeado por separado en cada color de severidad (WCAG 1.4.3).
- Nunca solo color: ícono + palabra cargan la severidad (WCAG 1.4.1).
- Foco después de dismiss: mover al siguiente elemento lógico, no dejarlo caer al body sin posición clara.
- Target size 24×24px CSS para el control de dismiss (WCAG 2.5.8).

## Copy

- Decir qué es cierto y luego qué hacer: "Your card ending 4242 was declined. Update your payment method." mejor que "There was a payment issue."
- Una oración, una acción — si la explicación necesita un párrafo, linkear a una página, no intentar serlo.
- Nombrar el objeto real: la tarjeta, la factura, el archivo — "Something went wrong" no dice nada accionable.
- No repetir el ícono en palabras: un triángulo de warning + "Warning:" es la misma info dos veces.

## Errores comunes

1. Banner que nunca revisa su propia condición — se renderiza una vez con datos viejos y sobrevive al problema que describía.
2. Apilar tres o cuatro banners a la vez: el que importa se pierde bajo los que no.
3. Sin dismiss en una condición no urgente (plan gratis): castiga a alguien por una elección ya tomada.
4. Dismiss disponible en una condición que activamente está rompiendo algo (outage): permite olvidarla.
5. Copy vago sin próximo paso: "Something went wrong" y nada más.
6. Confirmación puntual viviendo en un banner ("Changes saved" no describe una condición continua) → pertenece a un toast.

## Casos borde

- Varias condiciones califican a la vez: mostrar la de mayor severidad y resumir el resto como conteo.
- Condición se resuelve mientras la página está abierta (tracking en tiempo real): remover con un collapse corto, no un salto de layout.
- El dismiss necesita una key estable: guardar el ID de la condición específica, no un flag genérico de "banner visto".
- RTL: ícono y control de dismiss cambian de lado.
- Banner arriba de un header sticky: contabilizar su alto en el offset que fija el header o queda tapado al hacer scroll.

## Componentes relacionados

- **Toast**: mensaje que confirma algo que ya pasó y se va solo en segundos — usar en vez de banner si la condición no sobrevive un reload.
- **Badge and tag**: estado corto que el sistema setea.
- **Text field**: input de una línea para texto corto — no relacionado directamente, referencia del sitio como "related" genérico.

Convención del sitio: máximo uno o dos banners visibles a la vez por página, apilados por severidad — pasado eso, el que realmente importa se pierde en el montón.
