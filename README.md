# Panel de Ventas y Logística — Olist (marketplace estilo Amazon)

Proyecto de análisis de datos de extremo a extremo: limpieza y exploración con Python, consultas de negocio en SQL, y un dashboard interactivo en Power BI.

**Autor:** Alberto Gallego · proyecto 1 de portafolio (retail / e-commerce)

Hice este proyecto para practicar el proceso completo de un análisis de datos real, desde limpiar los CSV en bruto hasta tener un dashboard que se pueda enseñar. Elegí el dataset de Olist porque su estructura (varios vendedores, envíos, reseñas de clientes) se parece bastante a un marketplace tipo Amazon, que es el sector donde quiero enfocar mi búsqueda de trabajo como analista de datos.

## Pregunta de negocio

¿Qué categorías, estados y vendedores impulsan más las ventas del marketplace, y dónde falla la logística (entregas fuera de plazo)?

## Dataset

[Brazilian E-Commerce Public Dataset by Olist](https://www.kaggle.com/datasets/olistbr/brazilian-ecommerce) — cerca de 99.000 pedidos de un marketplace real en Brasil (2016-2018). La estructura es muy parecida a la de Amazon: múltiples vendedores, catálogo de productos, envíos y reseñas de clientes.

## Estructura del repositorio

```
cuadernos/           → notebook de limpieza y EDA en Python (01_limpieza_y_eda.ipynb)
datos/procesados/     → tabla de ventas ya limpia (ventas_clean.csv)
SQL/                  → consultas de negocio (consultas.sql) y script para generar la base (crear_base_datos.py)
dashboard/            → captura del dashboard final en Power BI
```

## Proceso

1. **Python (pandas):** carga de los 8 CSV originales, limpieza de fechas, filtrado a pedidos entregados, cálculo de métricas de logística (días de entrega, retraso, % a tiempo) y construcción de una tabla de ventas a nivel de línea de pedido.
2. **SQL (SQLite):** 8 consultas de negocio sobre esa misma tabla — ingresos por mes, top categorías y estados, ticket medio, % de entregas a tiempo por estado, top vendedores, métodos de pago y categorías peor valoradas.
3. **Power BI:** dashboard interactivo con KPIs generales y 4 visualizaciones clave, construido sobre `datos/procesados/ventas_clean.csv`.

## Resultado: dashboard

![Panel de Ventas y Logística](dashboard/dashboard_ventas_logistica.png)

## Lo que encontré

São Paulo se lleva la mayor parte del pastel, tanto en número de clientes como en ingresos. Tiene sentido si piensas en dónde vive la mayoría de la población brasileña, pero al verlo en el gráfico sorprende lo grande que es la diferencia con el resto de estados.

Un grupo pequeño de categorías (salud y belleza, relojes y regalos, hogar) mueve buena parte de los ingresos totales. Si estuviera en el negocio, ahí es donde miraría primero para negociar mejor con los vendedores o asegurarme de que nunca falte stock.

La logística es el punto más flojo: el % de pedidos que llegan a tiempo cae bastante en los estados del norte y noreste, los más alejados del sudeste. Probablemente explica por qué las reseñas también bajan en esas zonas — nadie puntúa bien un pedido que llega tarde.

## Cómo reproducirlo

1. Descarga el dataset de Kaggle y colócalo en `data/raw/` (no se sube al repo por su tamaño).
2. Ejecuta el notebook `cuadernos/01_limpieza_y_eda.ipynb` para generar `datos/procesados/ventas_clean.csv`.
3. (Opcional) Ejecuta `SQL/crear_base_datos.py` para generar una base SQLite local y probar las consultas de `SQL/consultas.sql`.
4. Abre Power BI Desktop y conecta el origen de datos a `ventas_clean.csv` para explorar el dashboard.
