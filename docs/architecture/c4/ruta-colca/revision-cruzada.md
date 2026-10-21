# Revisión cruzada del modelo de RutaColca

## Ficha de revisión

- **Fecha:** 20/10/2026.
- **Modalidad:** revisión por pares con otro grupo de la clase.
- **Revisor:** Mikhail.
- **Revisor del grupo autor:** Sencia Ale Bryan Daniel.
- **Criterio de referencia:** Anexo A de la guía y [lista oficial de revisión C4](https://c4model.com/diagrams/checklist).

## 1. Hallazgos y acciones correctivas

| N.º | Elemento o relación | Gravedad | Hallazgo detectado | Corrección o mitigación aplicada | Estado |
|---|---|---|---|---|---|
| 1 | API → WhatsApp | Alta | El prompt P4 es ambiguo: puede entenderse como notificación inmediata, pero HU-04 pide avisar un día antes. | El paso 10 del diagrama dinámico se fijó como envío diferido, según HU-04. | Aceptado |
| 2 | Portal → API | Alta | Riesgo de sobreventa por reservas sin conexión que compiten por el mismo cupo. | IndexedDB guarda solo solicitudes pendientes. La API asigna el cupo en una transacción al sincronizar (ADR-002). | Aceptado |
| 3 | Portal del administrador → Reservas locales | Alta | El despliegue inicial sugería acceso a IndexedDB entre dispositivos distintos. | Se acotó el despliegue a los dispositivos necesarios. El almacenamiento del navegador es local a cada dispositivo. | Aceptado |
| 4 | Portal (PWA) → API | Media | Faltaba definir la resolución de conflictos y la expiración de sesión tras recuperar la conexión. | ADR-002 documenta el rechazo por falta de cupo (estado «en conflicto») y la validación con token JWT. | Aceptado |
| 5 | Despliegue: base de datos gestionada | Baja | La delimitación de red de la base de datos no estaba explícita. | La descripción del nodo en `workspace.dsl` indica subred privada, accesible solo desde las VM por JDBC. | Aceptado |

## 2. Cumplimiento de criterios (Anexo A)

| Criterio | Resultado y evidencia |
|---|---|
| Título y alcance | Las cinco vistas (Contexto, Contenedores, Dinámico, ContenedoresReto y Despliegue) tienen título y nombran RutaColca. |
| Niveles C4 | Contexto: 4 personas, 1 sistema propio y 3 externos. Contenedores: 4 en la vista base; el reto agrega el quinto (Reservas locales). |
| Descripciones y tecnología | Cada elemento tiene descripción en `workspace.dsl`; contenedores y nodos declaran tecnología. |
| Relaciones | Flechas unidireccionales con verbo específico; entre contenedores se indica protocolo (JSON/HTTPS, JDBC/TLS, API IndexedDB local). |
| Pasos dinámicos | Once pasos numerados, todos con relación en el modelo estático. El boleto se valida antes del cobro. |
| Despliegue | Celular, tablet, balanceador, alojamiento estático, dos VM con Docker y PostgreSQL gestionado. No se dibuja infraestructura de terceros fuera del control del sistema. |
| Reto sin conexión | IndexedDB en la tablet, cola local y sincronización diferida (ADR-002). |
| Leyenda y siglas | Las exportaciones incluyen leyenda y definición de SPA, PWA, API, VM, JDBC, HTTPS, TLS y JSON. |
| Fuente única | Los diagramas se generan desde `workspace.dsl`; no se retocan a mano. |
| Validación formal | Revisión técnica y visual hecha. **Pendiente:** ejecutar `structurizr.sh validate` con la CLI oficial. No se declara como aprobada hasta correrla. |

## Dictamen del revisor

El modelo cumple la especificación arquitectónica y los criterios C4 revisados. Se incorporaron las correcciones para asegurar consistencia en concurrencia y seguridad. Queda pendiente la validación con Structurizr CLI antes de la entrega final.
