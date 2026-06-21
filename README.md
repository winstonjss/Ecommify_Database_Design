# Ecommify Database Design 🛒📊

¡Bienvenido a **Ecommify Database Design**! Este repositorio contiene el diseño relacional avanzado, la arquitectura de datos y la implementación de bases de datos para una plataforma moderna de comercio electrónico (E-commerce). 

El proyecto combina la robustez del modelo relacional en **PostgreSQL** con la flexibilidad de modelos NoSQL en **MongoDB** para optimizar el rendimiento, la escalabilidad y la consistencia de los datos.

## 🚀 Estructura del Proyecto

El repositorio está organizado de la siguiente manera:

* **`postgresql/`**: Scripts SQL de creación de tablas, restricciones, índices avanzados, funciones, disparadores (triggers) y optimización de consultas.
* **`mongodb/schema/`**: Definición de esquemas, colecciones y estructuras de documentos JSON para los módulos que requieren alta escalabilidad o flexibilidad (ej. catálogo dinámico de productos, carritos de compra o logs).
* **`notebooks/`**: Cuadernos de Jupyter utilizados para el análisis de datos, ingeniería de características, prototipado de consultas y validación del modelo de datos.
* **`docs/`**: Documentación técnica complementaria, diagramas entidad-relación (DER) y archivos de diseño.

## 🛠️ Tecnologías Utilizadas

* **PostgreSQL**: Motor principal para el almacenamiento relacional, gestión de transacciones ACID y lógica de negocio en el servidor.
* **MongoDB**: Almacenamiento NoSQL enfocado en documentos para subprocesos específicos de alta disponibilidad.
* **Jupyter Notebook**: Entorno interactivo para análisis, pruebas de carga y manipulación de datos con Python.

## 📐 Características del Diseño Relacional

El diseño en PostgreSQL implementa conceptos avanzados de bases de datos:
1. **Normalización y Rendimiento**: Estructuras en tercera forma normal (3FN) con desnormalizaciones estratégicas controladas para reportes rápidos.
2. **Integridad Referencial Estricta**: Uso de llaves primarias, foráneas y restricciones de verificación (`CHECK constraints`) para asegurar la calidad de la información comercial.
3. **Automatización**: Triggers y funciones almacenadas (PL/pgSQL) para la actualización automática de inventarios, cálculo de totales y auditoría de cambios.
4. **Optimización**: Índices compuestos, parciales y de texto completo (`Full-Text Search`) para agilizar la búsqueda de productos.

## 📋 Requisitos Previos

Asegúrate de tener instalado lo siguiente en tu entorno local:
* PostgreSQL (versión 13 o superior)
* MongoDB (versión 5.0 o superior)
* Python 3.8+ (con Jupyter Notebook o JupyterLab instalado)

## 🔧 Instrucciones de Instalación y Uso

## 🍃 Configuración e Instalación de MongoDB

Esta sección detalla cómo preparar el entorno de MongoDB, aplicar las reglas de validación de esquemas JSON (JSON Schema Validation) e importar datos de prueba para el catálogo de productos polimórfico y el sistema de logs.

### 1. Requisitos Previos
* **MongoDB Server:** Versión 5.0 o superior instalada localmente o una instancia en la nube (MongoDB Atlas).
* **MongoDB Database Tools:** Asegúrate de tener instalada la suite de herramientas CLI de Mongo (`mongosh` y `mongoimport`).
  * *Verificar instalación:* `mongosh --version` y `mongoimport --version`

---

### 2. Inicio del Servicio de MongoDB
Si estás ejecutando MongoDB de forma local, asegúrate de que el demonio del sistema esté activo antes de continuar.

* **En Linux (systemd):**
  ```bash
  sudo systemctl start mongod
  sudo systemctl enable mongod
  ```
* **En macOS (Homebrew):**
  ```bash
  brew services start mongodb-community
  ```
* **En Windows:**
  Abre una terminal como administrador y ejecuta:
  ```cmd
  net start MongoDB
  ```

---

### 3. Creación de la Base de Datos y Colecciones con Validación de Esquema
MongoDB en este proyecto utiliza **JSON Schema** para garantizar la integridad de datos en el catálogo flexible de productos (manejo de variantes, atributos dinámicos) y carritos de compra.

1. Accede a la consola interactiva de MongoDB:
   ```bash
   mongosh "mongodb://localhost:27017"
   ```
2. Crea y selecciona la base de datos del proyecto:
   ```javascript
   use ecommify_db;
   ```
3. Ejecuta los scripts ubicados en la ruta `mongodb/schema/` para crear las colecciones aplicando sus respectivas reglas de validación. Puedes copiar y pegar los scripts directamente en `mongosh` o ejecutarlos desde la terminal del sistema:

   ```bash
   # Opción desde la terminal del sistema apuntando a los archivos del repositorio:
   mongosh ecommify_db mongodb/schema/products_schema.js
   mongosh ecommify_db mongodb/schema/carts_schema.js
   ```

---

### 4. Importación de Datos de Prueba (Seeding)
Una vez que las colecciones y sus reglas de validación estructural están creadas, poblaremos la base de datos utilizando los archivos `.json` o `.csv` de prueba incluidos en el repositorio.

Utiliza la herramienta `mongoimport` desde la terminal de tu sistema operativo (no dentro de mongosh):

```bash
# Importar catálogo de productos masivo
mongoimport --db ecommify_db --collection products --file mongodb/seeds/products_seed.json --jsonArray

# Importar registros de sesiones y actividad (logs)
mongoimport --db ecommify_db --collection user_logs --file mongodb/seeds/logs_seed.json --jsonArray
```

*Nota: Si estás usando una instancia remota o protegida, añade los flags de autenticación:* `--uri="mongodb+srv://usuario:password@cluster.mongodb.net/ecommify_db"`

---

### 5. Verificación de la Instalación
Para comprobar que los datos se importaron correctamente y que respetan la estructura polimórfica diseñada, ejecuta el siguiente comando en la consola de Mongo:

```javascript
// Contar los documentos en cada colección
db.getCollectionNames().forEach(function(collection) {
    print(collection + ": " + db[collection].countDocuments());
});

// Ver una muestra de un producto con sus atributos dinámicos
db.products.findOne();
```
## 🐘 Configuración e Instalación de PostgreSQL

Esta sección detalla los pasos para inicializar el servidor de PostgreSQL, configurar las credenciales, desplegar el esquema relacional normalizado (3FN), activar las funciones/triggers automatizados, cargar los datos de prueba y aplicar la estrategia de indexación avanzada.

### 1. Requisitos Previos
* **PostgreSQL Server:** Versión 13 o superior instalada localmente o en un servidor remoto.
* **Cliente de Base de Datos:** Herramienta de línea de comandos `psql` instalada y accesible en tus variables de entorno, o en su defecto, un entorno gráfico como PGAdmin 4 / DBeaver.
  * *Verificar instalación CLI:* `psql --version`

---

### 2. Inicio del Servicio de PostgreSQL
Asegúrate de que el motor de la base de datos esté corriendo en tu sistema operativo:

* **En Linux (systemd):**
  ```bash
  sudo systemctl start postgresql
  sudo systemctl enable postgresql
  ```
* **En macOS (Homebrew):**
  ```bash
  brew services start postgresql
  ```
* **En Windows:**
  Abre una terminal de comandos (`cmd` o `PowerShell`) como Administrador y ejecuta:
  ```cmd
  net start postgresql-x64-15
  ```
  *(Nota: Reemplaza `15` por la versión mayor de PostgreSQL que tengas instalada).*

---

### 3. Creación de Usuario y Base de Datos
Es una buena práctica crear un usuario dedicado para la aplicación en lugar de utilizar el superusuario `postgres`. Abre tu terminal y accede al prompt de PostgreSQL:

```bash
# Acceder como superusuario
psql -U postgres
```

Dentro del prompt interactivo de PostgreSQL (`postgres=#`), ejecuta los siguientes comandos:

```sql
-- 1. Crear el usuario del proyecto con una contraseña segura
CREATE USER ecommify_user WITH PASSWORD 'TuContraseñaSegura123';

-- 2. Crear la base de datos relacional para el proyecto
CREATE DATABASE ecommify_db OWNER ecommify_user;

-- 3. Otorgar todos los privilegios sobre la base de datos al nuevo usuario
GRANT ALL PRIVILEGES ON DATABASE ecommify_db TO ecommify_user;

-- 4. Salir del prompt
\q
```

---

### 4. Despliegue de Esquemas y Automatizaciones (Scripts en Orden)
Para garantizar la integridad referencial y evitar errores de dependencias de llaves foráneas, los scripts ubicados en la carpeta `/postgresql` **deben ejecutarse estrictamente en el siguiente orden secuencial**:

#### Paso A: Crear el Esquema y Triggers (`schema.sql`)
Este archivo crea la estructura completa de tablas, restricciones de tipo `CHECK`, llaves primarias/foráneas y los procedimientos almacenados en **PL/pgSQL** (como el recálculo automático de stock y auditorías).

Ejecuta desde la terminal de tu sistema operativo:
```bash
psql -U ecommify_user -d ecommify_db -f postgresql/schema.sql
```

#### Paso B: Poblado de la Base de Datos (`seeds.sql`)
Este archivo carga los datos maestros iniciales (países, roles, categorías estables) y un conjunto masivo de registros de prueba (usuarios, órdenes, detalles de transacciones) para simulaciones.

```bash
psql -U ecommify_user -d ecommify_db -f postgresql/seeds.sql
```

#### Paso C: Optimización e Índices (`indexes.sql`)
Este script aplica la estrategia de indexación avanzada sobre la base de datos ya poblada. Incluye la creación de índices compuestos para consultas frecuentes, índices parciales para registros activos e índices GIN para habilitar **Full-Text Search** en las búsquedas de productos.

```bash
psql -U ecommify_user -d ecommify_db -f postgresql/indexes.sql
```

---

### 5. Verificación de la Instalación Relacional
Para validar que todas las tablas, triggers y optimizaciones se hayan aplicado correctamente, conéctate a la base de datos:

```bash
psql -U ecommify_user -d ecommify_db
```

Una vez dentro de `ecommify_db=>`, puedes realizar los siguientes comandos de diagnóstico:

```sql
-- 1. Listar todas las tablas creadas en el esquema público
\dt

-- 2. Verificar que los índices se hayan asociado correctamente a una tabla crítica (ej. ordenes)
\d orders

-- 3. Validar el correcto funcionamiento de los triggers de inventario
SELECT * FROM products WHERE id = 1; -- Nota el stock actual
-- Realiza una inserción de prueba en la tabla de detalles de orden para reducir stock y verifica el cambio.
```
## 📂 Análisis de Documentación Técnica y Resultados de Rendimiento

Este proyecto adopta un enfoque basado en datos y métricas (Metrics-Driven Design). En las carpetas `/docs` y `/test_results` se consolidan los artefactos de diseño arquitectónico y las evidencias empíricas que respaldan la viabilidad y optimización del sistema híbrido.

---

### 🗺️ Carpeta `/docs`: Planos de Arquitectura y Modelado de Datos

Los archivos dentro de este directorio actúan como la "única fuente de verdad" (Single Source of Truth) para comprender la estructura jerárquica, relacional y documental del ecosistema.

*   **Diagrama Entidad-Relación Ampliado (EERD):** Representación visual detallada del motor transaccional en PostgreSQL. Muestra de forma explícita la normalización en **Tercera Forma Normal (3FN)**, la cardinalidad de las relaciones, restricciones de integridad referencial (`ON DELETE CASCADE`, `ON UPDATE RESTRICT`) y los puntos de anclaje de los Triggers PL/pgSQL.
*   **Diccionario de Datos Exhaustivo:** Documentación técnica de cada tabla y colección. Detalla los tipos de datos nativos asignados (ej. `UUID`, `TIMESTAMP WITH TIME ZONE`, `NUMERIC(10,2)`), valores por defecto, nulidades y descripciones funcionales del propósito de cada atributo.
*   **Especificación del Modelo Polimórfico NoSQL:** Esquema abstracto que justifica la desnormalización en MongoDB, detallando cómo se estructuran los atributos dinámicos y las variantes de productos dentro de subdocumentos para eliminar la necesidad de costosos operadores `$lookup`.

---

### 📊 Carpeta `/test_results`: Reportes de Benchmark y Optimización de Consultas

Este espacio almacena las métricas e informes de rendimiento obtenidos tras someter a ambas bases de datos a escenarios simulados de alta concurrencia y estrés de lecturas/escrituras.

*   **Planes de Ejecución (`EXPLAIN ANALYZE` Reports):** Trazas y auditorías detalladas extraídas del optimizador de consultas de PostgreSQL. Estos reportes demuestran empíricamente el impacto del archivo `indexes.sql`, evidenciando la transición de escaneos secuenciales costosos (*Sequential Scans*) a búsquedas indexadas ultra rápidas (*Index Scans* y *Bitmap Index Scans*) en consultas de reportería compleja.
*   **Métricas de Rendimiento en Alta Concurrencia (Load Testing):** Gráficos y tablas que documentan el comportamiento del sistema ante picos de tráfico simulados. Incluye indicadores clave de rendimiento (KPIs) como:
    *   **TPS / QPS:** Transacciones y Consultas procesadas por segundo de forma estable.
    *   **Percentiles de Latencia (p95, p99):** Tiempo de respuesta del servidor medido en milisegundos para garantizar una experiencia de usuario fluida bajo estrés.
    *   **Tasa de Error (Error Rate):** Evidencia de la robustez del manejo de bloqueos (*locks*) y concurrencia sin pérdida de consistencia ACID.
*   **Análisis Comparativo Híbrido:** Reportes técnicos que contrastan el costo de almacenamiento y velocidad de consulta entre operaciones complejas en PostgreSQL frente al acceso directo por clave-valor/documento en MongoDB para logs de auditoría y carritos de compra activos.

## 📝 Licencia

Este proyecto está bajo la licencia que el autor determine conveniente. Consulta el archivo correspondiente para más detalles.
