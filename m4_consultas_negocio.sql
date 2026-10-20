-- ============================================================
-- Entregable M4: Consultas SQL de negocio
-- Base de datos: Ventas_Tech_DB
-- Motor SQL: SQL Server
-- Tabla utilizada en las consultas: ventas
-- ============================================================

USE Ventas_Tech_DB;
GO

-- Consulta 1: Resumen ejecutivo mensual
-- Calcula facturación, cantidad de ventas/pedidos y ticket promedio.
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    AVG(cantidad * precio_unitario) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;
GO


-- Consulta 2: Ranking de los 5 productos con mayor facturación
-- Muestra las unidades vendidas y el total generado por producto.
SELECT TOP 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;
GO


-- Consulta 3: Clientes recurrentes
-- Muestra clientes con más de un pedido, la cantidad de pedidos
-- y el total gastado.
SELECT
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY cantidad_pedidos DESC, total_gastado DESC;
GO


-- Consulta 4: Facturación mensual comparada con el promedio general
-- Se calcula primero la facturación de cada mes y luego se compara
-- cada resultado con el promedio de facturación mensual.
-- Se agrega la categoría 'Igual al promedio' para contemplar empates.
WITH facturacion_mensual AS (
    SELECT
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_facturado
    FROM ventas
    GROUP BY MONTH(fecha_venta)
)
SELECT
    mes,
    total_facturado,
    CASE
        WHEN total_facturado >
             (SELECT AVG(total_facturado) FROM facturacion_mensual)
            THEN 'Por encima'
        WHEN total_facturado <
             (SELECT AVG(total_facturado) FROM facturacion_mensual)
            THEN 'Por debajo'
        ELSE 'Igual al promedio'
    END AS comparacion_con_promedio
FROM facturacion_mensual
ORDER BY mes;
GO


-- ============================================================
-- Bloque de cierre: 3 hallazgos encontrados
-- Resultados calculados a partir de los 10 registros INSERTados
-- en el archivo de creación de la base de datos de M3.
--
-- Hallazgo 1: En marzo de 2024 se facturaron $6.444,00 en
--             10 pedidos, con un ticket promedio de $644,40.
--
-- Hallazgo 2: El producto con ID 1 fue el de mayor facturación,
--             con $3.600,00 generados por la venta de 3 unidades.
--
-- Hallazgo 3: Los 5 clientes realizaron 2 pedidos cada uno.
--             El cliente con ID 1 fue el que más gastó, con un
--             total de $2.640,00.
-- ============================================================
