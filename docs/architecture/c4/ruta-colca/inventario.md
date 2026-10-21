# Inventario C4 de RutaColca

| Elemento | Tipo C4 | Justificación |
|---|---|---|
| Turista | Persona | Busca tours, reserva una salida y paga. |
| Operador de agencia | Persona | Publica tours y registra reservas de su agencia. |
| Guía de turismo | Persona | Recibe el itinerario y la lista mediante WhatsApp. |
| Administrador | Persona | Aprueba agencias y revisa las ventas. |
| RutaColca | Sistema de software propio | Reúne las funciones de venta y coordinación de tours. |
| Pasarela de pagos | Sistema externo | Procesa pagos fuera de RutaColca. |
| WhatsApp Business | Sistema externo | Entrega los mensajes al guía. |
| Sistema de AUTOCOLCA | Sistema externo | Valida boletos; su conexión HTTPS es un supuesto del caso. |
| Web del turista | Contenedor: aplicación | Interfaz React SPA para buscar y reservar. |
| Portal de agencias | Contenedor: aplicación | Interfaz React PWA para operadores y administrador. |
| API de RutaColca | Contenedor: aplicación | Aplicación Java 21/Spring Boot que aplica las reglas del negocio. |
| Base de datos | Contenedor: almacén de datos | PostgreSQL 16 conserva los datos centrales. |
| Reservas locales, Parte B | Contenedor: almacén de datos | IndexedDB guarda las solicitudes pendientes en la tablet. |