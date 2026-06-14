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

### 1. Clonar el repositorio
```bash
git clone https://github.com
cd Ecommify_Database_Design
```

### 2. Desplegar la Base de Datos Relacional Completa (PostgreSQL)
Para levantar el modelo relacional junto con sus optimizaciones y datos de prueba, conéctate a tu cliente de PostgreSQL (psql, pgAdmin o DBeaver) y ejecuta los scripts en el siguiente **orden jerárquico estricto**:

* **Paso A: Crear la base de datos**
  ```sql
  CREATE DATABASE ecommify_db;
  ```
  *(Asegúrate de conectarte a `ecommify_db` antes de proceder con los siguientes comandos)*

* **Paso B: Levantar la estructura (Esquema)**
  Ejecuta el archivo del esquema para construir las tablas, llaves primarias, foráneas y restricciones `CHECK`:
  ```bash
  psql -d ecommify_db -f postgresql/schema.sql
  ```

* **Paso C: Cargar los datos semilla (Seeds)**
  Pobla las tablas con datos iniciales de prueba (usuarios, productos, categorías) antes de aplicar restricciones de consulta avanzadas:
  ```bash
  psql -d ecommify_db -f postgresql/seeds.sql
  ```

* **Paso D: Crear los Índices de optimización**
  Una vez que las tablas contienen registros, genera los índices compuestos, parciales y de búsqueda de texto completo para agilizar el rendimiento de las consultas:
  ```bash
  psql -d ecommify_db -f postgresql/indexes.sql
  ```

### 3. Configurar la Base de Datos NoSQL (MongoDB)
* Importa o ejecuta las estructuras de colecciones documentadas en la carpeta `/mongodb/schema` en tu instancia local o clúster de MongoDB Atlas.

### 4. Ejecutar los Notebooks de Análisis
* Instala las dependencias requeridas (como `psycopg2`, `pymongo` o `pandas`) y levanta el entorno de Jupyter:
  ```bash
  pip install -r requirements.txt  # Si aplica
  jupyter notebook
  ```
* Abre los archivos de la carpeta `/notebooks` para explorar las pruebas de rendimiento y los flujos de datos.

## 📝 Licencia

Este proyecto está bajo la licencia que el autor determine conveniente. Consulta el archivo correspondiente para más detalles.
