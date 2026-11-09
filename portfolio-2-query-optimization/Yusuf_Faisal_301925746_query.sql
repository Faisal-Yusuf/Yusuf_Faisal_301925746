-- Q1: Display customer orders and purchased watches.
SELECT c."FirstName", c."LastName",
       co."OrderID", co."OrderStatus",
       wm."ModelName", oi."Quantity"
FROM public."CUSTOMER" c
JOIN public."CUSTOMER_ORDER" co USING ("CustomerID")
JOIN public."ORDER_ITEM" oi USING ("OrderID")
LEFT JOIN public."WATCH_MODEL" wm USING ("ModelID")
ORDER BY co."OrderID";


-- Q2: Find watch models with no available stock
-- at Abuja Central Warehouse.
SELECT wm."ModelID", wm."ModelName"
FROM public."WATCH_MODEL" wm
WHERE NOT EXISTS (
    SELECT 1
    FROM public."INVENTORY" i
    JOIN public."LOCATION" l USING ("LocationID")
    WHERE i."ModelID" = wm."ModelID"
      AND l."LocationName" = 'Abuja Central Warehouse'
      AND i."QuantityAvailable" > 0
)
ORDER BY wm."ModelName";


-- Q3: Count order items for each watch model,
-- including models with no order items.
SELECT wm."ModelName",
       COUNT(oi."OrderItemID") AS total_order_items
FROM public."WATCH_MODEL" wm
LEFT JOIN public."ORDER_ITEM" oi USING ("ModelID")
GROUP BY wm."ModelID", wm."ModelName"
ORDER BY wm."ModelName";
