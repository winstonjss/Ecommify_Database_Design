# Documentación Técnica: Motor NoSQL (mongodb_notebook.ipynb) 🍃

Este cuaderno implementa el pipeline de **Extracción, Transformación y Carga (ETL)** hacia el clúster NoSQL de MongoDB Atlas. Además, ejecuta algoritmos de agregación para el cálculo de estadísticas comerciales y análisis de concentración de mercado.

## 🔑 Seguridad y Variables de Entorno (Secrets)
Para conectarse de forma segura sin exponer credenciales en el código, el cuaderno utiliza el gestor `userdata` de Google Colab. Debes registrar las siguientes llaves:
*   `user`: Nombre del usuario administrador del clúster de MongoDB Atlas.
*   `password`: Contraseña del usuario (el script procesa caracteres especiales automáticamente con `quote_plus`).

## 🔀 Componentes y Arquitectura del Código

1.  **Conexión (`connect_database`)**:
    Establece el puente con la cadena de conexión `mongodb+srv`. Ejecuta un comando de control de bajo costo (`client.admin.command('ping')`) para certificar la conexión antes de iniciar transferencias masivas.
2.  **Ingesta Masiva Optimizada (`csv_to_mongo`)**:
    *   **Técnica:** Implementa segmentación de datos (*chunking*) procesando bloques fijos de 1,000 registros (`chunksize=1000`) mediante Pandas.
    *   **Beneficio:** Evita desbordamientos de memoria RAM en el entorno de ejecución al procesar archivos CSV de gran escala.
3.  **Pipelines de Agregación (`Aggregate`)**:
    *   `calculate_and_update_product_stats`: Agrupa el historial de artículos comprados, calcula las unidades totales vendidas por cada ID de producto y actualiza (`update_one`) la colección del catálogo de forma asíncrona.
    *   `calculate_and_update_order_stats`: Agrupa las reseñas de los clientes, extrae el promedio aritmético de satisfacción (`$avg: '$score'`) redondeado a dos decimales y lo inyecta directamente en el documento de la orden.
4.  **Análisis de Mercado (`concentration_of_product_categories`)**:
    *   Calcula la cuota de mercado (*market share*) de cada categoría de producto.
    *   Aplica la fórmula económica del **Índice Herfindahl-Hirschman (HHI)** elevando al cuadrado las cuotas multiplicadas por 10,000.
    *   **Lógica de Evaluación:** Clasifica automáticamente si el marketplace opera bajo competencia perfecta ($HHI < 1500$), concentración moderada ($1500 \le HHI \le 2500$) o un monopolio/oligopolio de categorías ($HHI > 2500$).

## 📈 Resultados Esperados de la Ejecución
*   **Persistencia en la Nube:** Base de datos `ecommify` poblada en MongoDB Atlas con esquemas documentales optimizados.
*   **Enriquecimiento Documental:** Documentos actualizados con campos calculados (`total_units_sold` y `average_rating`).
*   **Reporte de Competitividad:** Diagnóstico cuantitativo sobre el balance de stock y monopolio de categorías del e-commerce.
