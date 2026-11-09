
-- FAHAJ SAMPLE DATA
-- All records are fictional test data.

BEGIN;

-- 1. Supplier records

INSERT INTO public."SUPPLIER"
    ("SupplierName", "Email", "Phone", "Address")
VALUES
    ('Precision Watch Parts Ltd',
     'sales@precisionparts.test',
     '08030000001',
     '12 Industrial Road, Abuja'),

    ('TimeCraft Components',
     'orders@timecraft.test',
     '08030000002',
     '25 Manufacturing Avenue, Lagos');




-- 2. Location records

INSERT INTO public."LOCATION"
    ("LocationName", "LocationType", "Address", "City", "Country")
VALUES
    ('Abuja Central Warehouse',
     'Warehouse',
     '12 Industrial Road',
     'Abuja',
     'Nigeria'),

    ('Lagos Retail Store',
     'Retail Store',
     '25 Victoria Island',
     'Lagos',
     'Nigeria');




-- 3. Customer records

INSERT INTO public."CUSTOMER"
    ("FirstName", "LastName", "Email", "Phone", "Address", "PasswordHash")
VALUES
    ('Amina', 'Bello', 'amina@example.test',
     '08040000001', 'Abuja, Nigeria', 'test_hash_amina'),

    ('Daniel', 'Musa', 'daniel@example.test',
     '08040000002', 'Lagos, Nigeria', 'test_hash_daniel'),

    ('Sarah', 'Ibrahim', 'sarah@example.test',
     '08040000003', 'Kano, Nigeria', 'test_hash_sarah');




-- 4. Watch model records

INSERT INTO public."WATCH_MODEL"
    ("ModelName", "Description", "BasePrice", "CaseMaterial", "DialType")
VALUES
    ('Classic Silver', 'Silver stainless steel wristwatch',
     85000.00, 'Stainless Steel', 'Analog'),

    ('Classic Black', 'Black stainless steel wristwatch',
     95000.00, 'Stainless Steel', 'Analog'),

    ('Chronograph Gold', 'Gold finish chronograph wristwatch',
     150000.00, 'Gold Plated', 'Chronograph'),

    ('Heritage Leather', 'Traditional leather strap wristwatch',
     120000.00, 'Stainless Steel', 'Analog');




-- 5. Component records

INSERT INTO public."COMPONENT"
    ("SupplierID", "ComponentName", "Description", "UnitCost")
VALUES
    (1, 'Watch Case', 'Stainless steel watch case', 12000.00),

    (1, 'Watch Dial', 'Standard analog watch dial', 5000.00),

    (2, 'Leather Strap', 'Genuine leather watch strap', 7000.00),

    (2, 'Watch Movement', 'Quartz watch movement mechanism', 9000.00);




-- 6. Customer order records

INSERT INTO public."CUSTOMER_ORDER"
    ("CustomerID", "OrderDate", "OrderStatus")
VALUES
    (1, '2026-11-01 10:00:00', 'Processing'),

    (2, '2026-11-02 11:30:00', 'Shipped'),

    (1, '2026-11-03 14:00:00', 'Processing'),

    (2, '2026-11-04 09:15:00', 'Delivered');




-- 7. Order item records

INSERT INTO public."ORDER_ITEM"
    ("OrderID", "ModelID", "Quantity", "UnitPrice")
VALUES
    (1, 1, 1, 85000.00),

    (1, 2, 1, 95000.00),

    (2, 3, 1, 150000.00),

    (3, NULL, 1, 180000.00),

    (3, 3, 1, 150000.00),

    (4, 1, 2, 85000.00);




-- 8. Customisation specification records

INSERT INTO public."CUSTOMISATION_SPECIFICATION"
    ("OrderItemID", "StrapColour", "DialColour",
     "RequestedMaterial", "AdditionalDetails")
VALUES
    (1, 'Brown', 'White', 'Leather',
     'Customer requested a brown strap instead of the standard strap.'),

    (4, 'Black', 'Blue', 'Stainless Steel',
     'Fully bespoke watch designed according to customer specifications.');


    

-- 9. Inventory records

INSERT INTO public."INVENTORY"
    ("LocationID", "ComponentID", "ModelID",
     "QuantityAvailable", "LastUpdated")
VALUES
    -- Components at Abuja Central Warehouse
    (1, 1, NULL, 100, '2026-11-05'),
    (1, 2, NULL, 80,  '2026-11-05'),
    (1, 3, NULL, 60,  '2026-11-05'),

    -- Component at Lagos Retail Store
    (2, 4, NULL, 20,  '2026-11-05'),

    -- Finished watches at Abuja Central Warehouse
    (1, NULL, 1, 15, '2026-11-05'),
    (1, NULL, 2, 0,  '2026-11-05'),

    -- Finished watches at Lagos Retail Store
    (2, NULL, 3, 5,  '2026-11-05'),
    (2, NULL, 1, 3,  '2026-11-05');




-- 10. Shipment records

INSERT INTO public."SHIPMENT"
    ("OrderID", "LocationID", "ShipmentDate",
     "TrackingNumber", "ShipmentStatus")
VALUES
    (2, 1, '2026-11-03', 'FAH-SHP-001', 'Delivered'),

    (3, 1, '2026-11-05', 'FAH-SHP-002', 'In Transit'),

    (4, 1, '2026-11-06', 'FAH-SHP-003', 'Dispatched');


    COMMIT;