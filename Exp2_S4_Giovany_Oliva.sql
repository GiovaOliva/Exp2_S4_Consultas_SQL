-- 1)
SELECT 
    C.nombre AS nombre_cliente,
    P.nombre_producto,
    V.cantidad,
    V.fecha_venta,
    CASE 
        WHEN P.categoria IN ('Monitores', 'Portatiles', 'Proyectores', 'Impresoras') THEN V.fecha_venta + 90
        WHEN P.categoria IN ('Almacenamiento', 'Energía') THEN V.fecha_venta + 180
        ELSE V.fecha_venta + 30
    END AS fecha_final_garantia,
    CASE 
        WHEN (CASE 
            WHEN P.categoria IN ('Monitores', 'Portatiles', 'Proyectores', 'Impresoras') THEN V.fecha_venta + 90
            WHEN P.categoria IN ('Almacenamiento', 'Energia') THEN V.fecha_venta + 180
            ELSE V.fecha_venta + 30
        END) >= SYSDATE THEN 'SI'
        ELSE 'NO'
    END AS garantia_vigente
FROM 
    Ventas V
JOIN 
    Clientes C ON V.customer_id = C.customer_id
JOIN 
    Productos P ON V.product_id = P.product_id
WHERE 
    V.fecha_venta >= ADD_MONTHS(SYSDATE, -3);

-- 2)
SELECT 
    UPPER(CONCAT(PV.nombre, ' ' || PV.apellido)) AS nombre_completo,
    CASE 
        WHEN SUBSTR(PV.telefono, 1, 3) = '123' THEN 'Zona Alpha'
        WHEN SUBSTR(PV.telefono, 1, 3) = '456' THEN 'Zona Beta'
        WHEN SUBSTR(PV.telefono, 1, 3) = '789' THEN 'Zona Gamma'
        ELSE 'Zona Desconocida'
    END AS zona,
    NVL(SUM(V.total_venta), 0) AS total_ventas
FROM 
    Personal_de_Ventas PV
LEFT JOIN 
    Ventas V ON PV.staff_id = V.staff_id
GROUP BY 
    PV.nombre, PV.apellido, PV.telefono
HAVING 
    NVL(SUM(V.total_venta), 0) >= 1000;

-- 3) 
SELECT 
    C.nombre AS nombre_cliente,
    C.email,
    NVL(P.nombre_producto, 'Sin compras') AS nombre_producto,
    NVL(V.cantidad, 0) AS cantidad_vendida
FROM 
    Clientes C
LEFT JOIN 
    Ventas V ON C.customer_id = V.customer_id
LEFT JOIN 
    Productos P ON V.product_id = P.product_id;

-- 4) 
SELECT 
    C.nombre AS nombre_cliente,
    C.apellido AS apellido_cliente,
    P.nombre_producto
FROM 
    Clientes C
CROSS JOIN 
    Productos P;