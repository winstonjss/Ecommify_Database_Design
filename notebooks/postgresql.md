# Documentación Técnica: Motor Relacional (postgresql_notebook.ipynb) 🐘

Este cuaderno gestiona la conectividad y la carga de datos masivos hacia el motor relacional PostgreSQL alojado en la infraestructura en la nube de **Supabase**, utilizando el mapeador objeto-relacional `SQLAlchemy`.

## 🔑 Seguridad y Variables de Entorno (Secrets)
El script requiere que se configuren las siguientes credenciales en el apartado de secretos de Google Colab para ensamblar la URI de conexión de tipo `postgresql://`:
*   `SUPABASE_DB_USER`: Usuario maestro de la base de datos de Supabase.
*   `SUPABASE_DB_PASSWORD`: Contraseña asignada.
*   `SUPABASE_DB_HOST`: Endpoint del pooler de Supabase (ej. `aws-0-...supabase.com`).
*   `SUPABASE_DB_PORT`: Puerto estándar de comunicación relacional (`5432`).
*   `SUPABASE_DB_NAME`: Nombre del esquema de destino (por defecto `postgres`).

## 🔀 Componentes y Arquitectura del Código

1.  **Gestión del Motor de Base de Datos (`connect_to_supabase_postgres`)**:
    *   Construye de manera dinámica el objeto `engine` de SQLAlchemy.
    *   Realiza una prueba de aislamiento transaccional seguro ejecutando una consulta primitiva encapsulada (`SELECT 1`). Si la conexión responde con éxito, el entorno queda habilitado para operaciones DDL/DML.
2.  **Carga Masiva de Alta Densidad (`insert_geolocation_data`)**:
    *   **Técnica:** Ejecuta inserciones en ráfagas masivas utilizando un tamaño de bloque extendido de 5,000 registros (`chunk_size=5000`).
    *   **Propósito:** Especialmente diseñado para procesar el set de datos de geolocalización, el cual suele contener cientos de miles de filas, reduciendo drásticamente los viajes de red (*network round-trips*) hacia los servidores de Supabase.
3.  **Liberación de Recursos (`engine.dispose()`)**:
    *   Garantiza el cierre correcto de todas las conexiones abiertas dentro del pool transaccional una vez finalizados los inserts, evitando el bloqueo del pooler en Supabase.

## 📈 Resultados Esperados de la Ejecución
*   **Canal Seguro:** Conexión remota verificada y cifrada con Supabase.
*   **Migración Relacional Eficiente:** Poblamiento de tablas de alta densidad (como coordenadas geográficas y catálogos estructurados) manteniendo restricciones ACID activas.
