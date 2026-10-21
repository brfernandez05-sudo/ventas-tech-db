
-- =============================================
-- RetailPro - M5: Consultas con JOINs
-- Archivo: m5_consultas_joins.sql
-- =============================================


-- CONSULTA 1: Ventas con información de clientes y productos
SELECT
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    v.cantidad * v.precio_unitario AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p
    ON v.id_producto = p.id_producto
LEFT JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria;
GO
-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- Busca clientes que todavía no realizaron compras.

SELECT
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v
    ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;



-- CONSULTA 3: Productos sin ventas

SELECT
    p.nombre_producto,
    cat.nombre_categoria AS categoria,
    p.precio
FROM productos AS p
INNER JOIN categorias AS cat
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;



-- CONSULTA 4: Consolidado por origen (UNION ALL)

SELECT
    origen,
    SUM(total) AS total_origen
FROM (
    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Primer semestre' AS origen
    FROM dbo.ventas
    WHERE MONTH(fecha_venta) BETWEEN 1 AND 6

    UNION ALL

    SELECT
        fecha_venta,
        cantidad * precio_unitario AS total,
        'Segundo semestre' AS origen
    FROM dbo.ventas
    WHERE MONTH(fecha_venta) BETWEEN 7 AND 12
) AS consolidado
GROUP BY origen;
GO
