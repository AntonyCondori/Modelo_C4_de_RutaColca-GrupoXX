# Bitácora de asistencia de IA

**Fecha:** 20/10/2026.  
**Herramienta:** asistente Codex.  

| N.º | Fecha | Prompt o tarea de referencia | Qué se incorporó | Qué se rechazó o corrigió | Responsable de la comprobación |
|---|---|---|---|---|---|
| 1 | 20/10/2026 | P1: revisar el inventario del caso. | Cuatro personas, RutaColca, tres externos y cuatro contenedores base. | Se precisó que el guía recibe información indirectamente y que Docker no es un contenedor C4. | Asistente; revisión humana pendiente. |
| 2 | 20/10/2026 | P2: definir contexto y relaciones. | Sistemas externos y relaciones específicas. | No se añadió guía → portal; se representó WhatsApp → guía. | Asistente; revisión humana pendiente. |
| 3 | 20/10/2026 | P3: aplicar ADR-001 a contenedores. | React SPA, React PWA, Java 21/Spring Boot y PostgreSQL 16. | Se mantuvo una sola API y se asignó el acceso del administrador al portal existente. | Asistente; revisión humana pendiente. |
| 4 | 20/10/2026 | P4: reservar y pagar. | Validar boleto, retener cupo, gestionar pago y confirmar. | Se separó el aviso un día antes y se agregó verificación del pago con la pasarela. | Asistente y comprobación local de relaciones; revisión humana pendiente. |
| 5 | 20/10/2026 | P5: revisar con el Anexo A. | Lista y tabla de hallazgos. | No se presentó la revisión técnica como revisión cruzada real. | Asistente; otro grupo pendiente. |
| 6 | 20/10/2026 | P6: explicación de 120 palabras. | Texto sencillo dirigido a la gerente. | Se evitó incluir siglas técnicas en el párrafo de explicación. | Asistente y conteo de palabras; vocero pendiente. |
| 7 | 20/10/2026 | P7: despliegue en producción. | Dos VM con Docker, balanceador, PostgreSQL gestionado, celular y tablet. | Se retiró la instancia adicional del portal del administrador por una relación derivada incorrecta con el almacén de otra tablet. | Asistente y revisión de PNG; revisión humana pendiente. |
| 8 | 20/10/2026 | P8: analizar el trabajo sin conexión. | Se abordaron los cinco temas de análisis enumerados debajo. | La solución se documentó aparte en ADR-002; P8 es una pauta de preguntas y no una evidencia de decisión grupal. | Asistente; equipo pendiente. |
| 9 | 20/10/2026 | Pasos 9 y 10: generar formatos y registrar evidencias. | Exportador local y scripts para la ejecución oficial posterior. | Se informó que no fue posible descargar ni ejecutar Structurizr CLI. | Asistente; validación CLI pendiente. |

## Cinco preguntas de análisis de P8

1. ¿Qué datos mínimos necesita guardar una solicitud sin internet? Elementos afectados: portal y almacén local en contenedores.
2. ¿Cómo sabrá el operador si una solicitud está pendiente o confirmada? Elementos afectados: responsabilidad del portal y relación portal → API.
3. ¿Qué ocurre si dos agencias solicitan el último cupo? Elementos afectados: API, base central y sincronización.
4. ¿Cómo se reconocerá una solicitud que se envía nuevamente después de un corte? Elementos afectados: almacén local, API y base central.
5. ¿Qué pasa si se borra el navegador o se pierde la tablet antes de sincronizar? Elementos afectados: nodo tablet y persistencia del almacén local.
