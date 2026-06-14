# Ecommify Notebooks - Guía de Ejecución en Google Colab 🛒📊

Este directorio contiene los cuadernos interactivos de Jupyter diseñados para el análisis exploratorio de datos (EDA), la carga en bloque (*bulk insert*) y el procesamiento analítico dentro de la arquitectura híbrida de **Ecommify** (PostgreSQL en Supabase + MongoDB Atlas).

---

## 🚀 Cómo Ejecutar los Notebooks en Google Colab

Puedes abrir y ejecutar cualquier cuaderno directamente en la nube siguiendo estos pasos:

1. Dirígete a [Google Colab](https://google.com).
2. Selecciona la pestaña **GitHub** en el menú emergente.
3. Introduce la URL de este repositorio: `https://github.com`.
4. Elige la rama correspondiente y haz clic sobre el archivo `.ipynb` que deseas ejecutar.

> ⚠️ **Importante**: Antes de correr las celdas, ve a *Archivo > Guardar una copia en Drive* para poder salvar tus propios cambios y resultados.

---

## 🔑 Configuración de Secretos en Colab (Obligatorio)

Los cuadernos de bases de datos interactúan de forma segura con servicios en la nube (MongoDB Atlas y Supabase). Antes de ejecutarlos, debes registrar tus credenciales en la sección de **Secretos** (icono de llave 🔑 en la barra lateral izquierda de Colab):

### Para el entorno de MongoDB:
*   `user`: Nombre de usuario de tu clúster de MongoDB Atlas.
*   `password`: Contraseña del usuario de la base de datos.

### Para el entorno de PostgreSQL (Supabase):
*   `SUPABASE_DB_USER`: Usuario de la base de datos (ej. `postgres`).
*   `SUPABASE_DB_PASSWORD`: Contraseña de acceso a la base de datos de Supabase.
*   `SUPABASE_DB_HOST`: Dirección del host provista por Supabase (ej. `aws-0-...pooler.supabase.com`).
*   `SUPABASE_DB_PORT`: Puerto de conexión (normalmente `5432`).
*   `SUPABASE_DB_NAME`: Nombre de la base de datos (normalmente `postgres`).

---

## 📈 Notebooks Disponibles y Resultados de Ejecución

### 1. Cuaderno: Explorador de Datos (`data_explorer.ipynb`)
*   **Propósito:** Realizar un Análisis Exploratorio de Datos (EDA) sobre los archivos CSV del ecosistema de comercio electrónico.
*   **Requisito de ejecución:** Crear una carpeta llamada `e-commerce` en el almacenamiento local de Colab y subir los archivos `.csv` del dataset en ella.
*   **Resultados Obtenidos:**
    *   **Metadata del Esquema:** Resumen técnico de la estructura de las tablas (`df.info()`) y métricas descriptivas tradicionales de las variables.
    *   **Diagnóstico de Nulos:** Una tabla limpia formateada con `tabulate` que desglosa el conteo total de valores nulos por columna y su peso porcentual exacto.
    *   **Visualización Geográfica:** Un mapa interactivo de dispersión global generado con `Plotly Express` (`scatter_mapbox`) enfocado en la geolocalización de las transacciones (activado específicamente para el set de datos *Olist_Geolocation*).

### 2. Cuaderno: Motor NoSQL (`mongodb_notebook.ipynb`)
*   **Propósito:** Migrar la información estructurada de los archivos CSV hacia un clúster de MongoDB Atlas y ejecutar agregaciones analíticas orientadas al mercado.
*   **Resultados Obtenidos:**
    *   **Ingesta Eficiente (Chunking):** Carga masiva de documentos particionados en bloques optimizados de 1,000 registros para evitar la saturación de memoria.
    *   **Pipelines de Agregación:** Actualización de estadísticas cruzadas, cálculo del volumen total de unidades vendidas por producto y promedios de calificación por orden (`average_rating`) basados en reseñas.
    *   **Métricas de Concentración de Mercado:** Obtención de la distribución de productos por categoría y el cálculo automatizado del **Índice Herfindahl-Hirschman (HHI)** para clasificar el nivel de competitividad o monopolio dentro del marketplace.

### 3. Cuaderno: Motor Relacional (`postgresql_notebook.ipynb`)
*   **Propósito:** Establecer comunicación con una base de datos relacional PostgreSQL alojada en Supabase mediante `SQLAlchemy` para la persistencia transaccional del e-commerce.
*   **Resultados Obtenidos:**
    *   **Validación de Conectividad:** Comprobación nativa mediante consultas de control (`SELECT 1`) que certifican que el canal de comunicación con el pooler de Supabase está activo y seguro.
    *   **Inserción Masiva de Alta Densidad:** Ingesta por bloques optimizados de gran escala (como datos geográficos complejos en bloques de 5,000 registros a través de `insert_geolocation_data`) asegurando la integridad relacional de la plataforma.

---
💡 *Consejo: Si tras ejecutar cualquiera de estos cuadernos deseas guardar los resultados estadísticos, las tablas consolidadas o los mapas geográficos de forma local como un archivo de imagen continuo, puedes revisar los métodos de captura con el inspector del navegador (F12) explicados en la guía de documentación del repositorio.*
