# ADR-002: Registro de reservas sin conexión

**Fecha:** 20/10/2026  
**Estado:** Aceptado  
**Responsable:** Sencia Ale Bryan Daniel  
**Relacionado con:** ADR-001 (React SPA, React PWA, Java 21 / Spring Boot, PostgreSQL 16). Este ADR solo agrega IndexedDB.

## Contexto

En Chivay la conexión es intermitente. El operador necesita registrar solicitudes presenciales aunque no tenga internet (HU-05). La solución debe mantener el portal React PWA y una sola API, sin agregar servidores ni servicios de mensajería.

## Decisión

Agregar **Reservas locales**, un contenedor de almacenamiento con **IndexedDB**, en el navegador de la tablet. El portal guarda una solicitud con identificador único, salida, cantidad de pasajeros, número de boleto y estado `pendiente`. Solo se conserva la información mínima para atender la reserva.

El portal se prepara previamente con conexión y conserva los archivos necesarios para abrirse sin red. La relación nueva es portal → reservas locales, mediante la API local de IndexedDB. La relación portal → API conserva JSON/HTTPS, pero también sincroniza solicitudes pendientes al recuperar conexión o al pulsar «Sincronizar».

**Regla de conflictos.** Al sincronizar, la API identifica la solicitud para evitar duplicarla, valida el boleto y comprueba cupos en la base central. La asignación de cupo se hace en una transacción: gana la primera solicitud válida que el servidor procesa, no la fecha guardada por la tablet. Si no quedan cupos, la solicitud se marca `en conflicto` y el operador ofrece otra salida. No se sobrevende ni se reemplaza una reserva confirmada.

**Pago.** Sin conexión no se cobra ni se garantiza una reserva. Con cupo retenido, el pago se completa en línea mediante la pasarela y la confirmación ocurre al verificarlo. Reenviar el mismo identificador devuelve el estado existente y no genera otro cobro.

**Sesión y seguridad.** La sincronización se autoriza con un token JWT de la sesión del operador. Si el token expiró al volver la conexión, el portal pide iniciar sesión de nuevo y conserva las solicitudes pendientes; se envían después de autenticarse. El token identifica a la agencia, de modo que una solicitud solo se sincroniza bajo su propia agencia.

**Datos locales.** El portal conserva lo pendiente hasta recibir respuesta y elimina los datos locales de solicitudes ya sincronizadas cuando el resultado queda mostrado y registrado.

## Consecuencias

La agencia puede seguir registrando solicitudes durante un corte. No se necesita una aplicación nativa. IndexedDB aparece en `ContenedoresReto` y como instancia dentro de la tablet en `Despliegue`; el contexto no cambia.

El cupo mostrado sin internet puede estar desactualizado. Dos agencias pueden pedir el último asiento y una deberá ofrecer otra fecha. Borrar los datos del navegador o perder la tablet antes de sincronizar puede perder solicitudes. El portal debe mostrar claramente los estados `pendiente`, `en conflicto`, `pendiente de pago` y `confirmada`.
