workspace "RutaColca" "Modelo C4 para la actividad AG-08" {
    !identifiers hierarchical
    !impliedRelationships false

    model {
        turista = person "Turista" "Busca tours y reserva una salida al Colca."
        operador = person "Operador de agencia" "Publica tours y registra reservas presenciales."
        guia = person "Guía de turismo" "Recibe el itinerario y la lista del grupo por WhatsApp."
        administrador = person "Administrador" "Aprueba agencias y consulta reportes de ventas."

        ruta = softwareSystem "RutaColca" "Organiza tours, reservas y pagos de agencias del Colca." {
            web = container "Web del turista" "Permite buscar tours, registrar el boleto y solicitar una reserva." "React (SPA)"
            portal = container "Portal de agencias" "Gestiona tours y reservas; incluye acceso del administrador según su rol." "React (PWA)"
            api = container "API de RutaColca" "Gestiona cupos, valida boletos, coordina pagos y programa avisos." "Java 21 / Spring Boot"
            db = container "Base de datos" "Guarda agencias, tours, salidas, reservas y referencias de pago." "PostgreSQL 16" {
                tags "Almacen"
            }
            local = container "Reservas locales" "Guarda solicitudes presenciales pendientes de sincronización en la tablet." "IndexedDB" {
                tags "Almacen,Reto"
            }
        }

        pagos = softwareSystem "Pasarela de pagos" "Procesa tarjetas y billeteras; devuelve una referencia y el resultado del pago." {
            tags "Externo"
        }
        whatsapp = softwareSystem "WhatsApp Business" "Entrega al guía el itinerario y la lista del grupo." {
            tags "Externo"
        }
        autocolca = softwareSystem "Sistema de AUTOCOLCA" "Valida el número del boleto turístico mediante una API HTTPS supuesta para el caso." {
            tags "Externo"
        }

        // Contexto: relaciones explícitas para evitar duplicados por inferencia.
        turista -> ruta "Busca tours y reserva salidas en"
        operador -> ruta "Publica tours y registra reservas en"
        administrador -> ruta "Aprueba agencias y consulta ventas en"
        ruta -> pagos "Solicita el cobro de reservas a"
        ruta -> autocolca "Consulta la validez de boletos en"
        ruta -> whatsapp "Solicita el envío del itinerario y la lista a"
        whatsapp -> guia "Entrega el itinerario y la lista del grupo a"

        // Contenedores: los datos de tarjeta se ingresan en la pasarela.
        turista -> ruta.web "Busca tours y solicita reservas en" "HTTPS"
        operador -> ruta.portal "Publica tours y registra reservas en" "HTTPS"
        administrador -> ruta.portal "Aprueba agencias y consulta ventas en" "HTTPS"
        ruta.web -> ruta.api "Solicita disponibilidad, validación y pago a" "JSON/HTTPS"
        ruta.portal -> ruta.api "Gestiona tours y sincroniza solicitudes al recuperar conexión con" "JSON/HTTPS"
        ruta.portal -> ruta.local "Guarda y consulta solicitudes pendientes en" "API IndexedDB (local)"
        ruta.api -> ruta.db "Consulta cupos y guarda reservas y referencias de pago en" "JDBC/TLS"
        ruta.api -> autocolca "Valida el número del boleto en" "JSON/HTTPS"
        ruta.api -> pagos "Crea órdenes de cobro y consulta su estado en" "JSON/HTTPS"
        ruta.web -> pagos "Abre el formulario de pago alojado en" "HTTPS"
        ruta.api -> whatsapp "Envía el itinerario y la lista un día antes mediante" "JSON/HTTPS"

        produccion = deploymentEnvironment "Produccion" {
            celular = deploymentNode "Celular del turista" "Dispositivo desde el que se reserva el tour." "Navegador web" {
                web = containerInstance ruta.web
            }
            tablet = deploymentNode "Tablet de la agencia" "Dispositivo que mantiene solicitudes cuando no hay conexión." "Navegador compatible con PWA e IndexedDB" {
                portal = containerInstance ruta.portal
                local = containerInstance ruta.local
            }
            cloud = deploymentNode "Proveedor cloud" "Infraestructura de producción; dos réplicas de API en temporada alta." "Cloud" {
                balanceador = infrastructureNode "Balanceador HTTPS" "Distribuye solicitudes entre las dos réplicas de la API." "Balanceador gestionado"
                estaticos = infrastructureNode "Alojamiento web" "Entrega los archivos React al navegador; la aplicación se ejecuta en el cliente." "Hosting estático HTTPS"
                vm1 = deploymentNode "VM 1" "Primera réplica de la API." "Linux / Docker" {
                    api = containerInstance ruta.api
                }
                vm2 = deploymentNode "VM 2" "Segunda réplica de la API." "Linux / Docker" {
                    api = containerInstance ruta.api
                }
                datos = deploymentNode "Base de datos gestionada" "Servicio persistente compartido por las dos réplicas." "PostgreSQL 16 gestionado" {
                    db = containerInstance ruta.db
                }
            }
        }

        // Relaciones de infraestructura fuera del entorno, con rutas jerárquicas.
        produccion.celular -> produccion.cloud.balanceador "Envía solicitudes de reserva a" "JSON/HTTPS"
        produccion.tablet -> produccion.cloud.balanceador "Envía gestiones y sincronizaciones a" "JSON/HTTPS"
        produccion.celular -> produccion.cloud.estaticos "Descarga la web del turista desde" "HTTPS"
        produccion.tablet -> produccion.cloud.estaticos "Descarga y actualiza el portal desde" "HTTPS"
        produccion.cloud.balanceador -> produccion.cloud.vm1 "Distribuye solicitudes hacia" "HTTPS"
        produccion.cloud.balanceador -> produccion.cloud.vm2 "Distribuye solicitudes hacia" "HTTPS"
    }

    views {
        systemContext ruta "Contexto" "Diagrama de contexto de RutaColca" {
            title "Diagrama de contexto de RutaColca"
            include turista operador administrador guia ruta pagos whatsapp autocolca
            autolayout lr
        }
        container ruta "Contenedores" "Diagrama de contenedores de RutaColca - base" {
            title "Diagrama de contenedores de RutaColca - base"
            include turista operador administrador guia ruta.web ruta.portal ruta.api ruta.db pagos whatsapp autocolca
            autolayout tb
        }
        dynamic ruta "Dinamico" "Diagrama dinámico de RutaColca - reservar y pagar un tour" {
            title "Diagrama dinámico de RutaColca - reservar y pagar un tour"
            turista -> ruta.web "Elige una salida e ingresa el número del boleto"
            ruta.web -> ruta.api "Solicita reservar la salida y comenzar el pago"
            ruta.api -> autocolca "Valida el boleto antes de iniciar el cobro"
            ruta.api -> ruta.db "Retiene un cupo y registra una reserva pendiente de pago"
            ruta.api -> pagos "Crea una orden de pago para la reserva"
            ruta.web -> pagos "Abre el formulario externo donde el turista paga"
            ruta.web -> ruta.api "Solicita verificar el resultado del pago"
            ruta.api -> pagos "Consulta y comprueba el pago aprobado"
            ruta.api -> ruta.db "Confirma la reserva y guarda la referencia del pago"
            ruta.api -> whatsapp "Un día antes de la salida envía el itinerario y la lista"
            whatsapp -> guia "Entrega el itinerario y la lista del grupo"
            autolayout lr
        }
        container ruta "ContenedoresReto" "Diagrama de contenedores de RutaColca - reservas sin conexión" {
            title "Diagrama de contenedores de RutaColca - reservas sin conexión"
            include turista operador administrador guia ruta.web ruta.portal ruta.api ruta.db ruta.local pagos whatsapp autocolca
            autolayout tb
        }
        deployment ruta "Produccion" "Despliegue" "Diagrama de despliegue de RutaColca - producción en temporada alta" {
            title "Diagrama de despliegue de RutaColca - producción en temporada alta"
            include *
            autolayout tb
        }
        styles {
            element "Person" {
                shape Person
                background #0B3D62
                color #ffffff
            }
            element "Software System" {
                background #1B5E8B
                color #ffffff
            }
            element "Container" {
                background #0E7D73
                color #ffffff
            }
            element "Externo" {
                background #8C8C8C
                color #ffffff
            }
            element "Almacen" {
                shape Cylinder
            }
            element "Reto" {
                stroke #A65E00
                strokeWidth 3
            }
            element "Infrastructure Node" {
                background #E1E7EB
                color #222222
            }
            relationship "Relationship" {
                routing Orthogonal
            }
        }
        properties {
            "structurizr.groupSeparator" "/"
            "c4plantuml.tags" "true"
        }
    }
}
