
BEGIN;

-- =====================================================
-- 1. SUPPLIER
-- Stores component supplier important infos.
-- =====================================================

CREATE TABLE public."SUPPLIER" (
    "SupplierID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "SupplierName" VARCHAR(100) NOT NULL,
    "Email" VARCHAR(100),
    "Phone" VARCHAR(20),
    "Address" VARCHAR(255)
);


-- =====================================================
-- 2. LOCATION
-- Stores warehouses and retail store locations.
-- =====================================================

CREATE TABLE public."LOCATION" (
    "LocationID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "LocationName" VARCHAR(100) NOT NULL,
    "LocationType" VARCHAR(30) NOT NULL
        CHECK ("LocationType" IN ('Warehouse', 'Retail Store')),
    "Address" VARCHAR(255),
    "City" VARCHAR(100),
    "Country" VARCHAR(100)
);


-- =====================================================
-- 3. CUSTOMER
-- Stores customer account information.
-- Passwords are stored as hashes, never plain text.
-- =====================================================

CREATE TABLE public."CUSTOMER" (
    "CustomerID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "FirstName" VARCHAR(50) NOT NULL,
    "LastName" VARCHAR(50) NOT NULL,
    "Email" VARCHAR(100) NOT NULL UNIQUE,
    "Phone" VARCHAR(20),
    "Address" VARCHAR(255),
    "PasswordHash" VARCHAR(255) NOT NULL
);


-- =====================================================
-- 4. WATCH_MODEL
-- Stores information about standard watch models.
-- =====================================================

CREATE TABLE public."WATCH_MODEL" (
    "ModelID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "ModelName" VARCHAR(100) NOT NULL,
    "Description" TEXT,
    "BasePrice" DECIMAL(10,2) NOT NULL
        CHECK ("BasePrice" >= 0),
    "CaseMaterial" VARCHAR(50),
    "DialType" VARCHAR(50)
);


-- =====================================================
-- 5. COMPONENT
-- Stores watch components supplied to FAHAJ.
-- Each component is associated with one supplier.
-- =====================================================

CREATE TABLE public."COMPONENT" (
    "ComponentID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "SupplierID" INTEGER NOT NULL,
    "ComponentName" VARCHAR(100) NOT NULL,
    "Description" TEXT,
    "UnitCost" DECIMAL(10,2) NOT NULL
        CHECK ("UnitCost" >= 0),

    CONSTRAINT fk_component_supplier
        FOREIGN KEY ("SupplierID")
        REFERENCES public."SUPPLIER" ("SupplierID")
);


-- =====================================================
-- 6. CUSTOMER_ORDER
-- Stores customer orders.
-- Each order belongs to one customer.
-- =====================================================

CREATE TABLE public."CUSTOMER_ORDER" (
    "OrderID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "CustomerID" INTEGER NOT NULL,
    "OrderDate" TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "OrderStatus" VARCHAR(30) NOT NULL,

    CONSTRAINT fk_order_customer
        FOREIGN KEY ("CustomerID")
        REFERENCES public."CUSTOMER" ("CustomerID")
);


-- =====================================================
-- 7. ORDER_ITEM
-- Stores individual watch items within an order.
-- ModelID can be NULL for a fully bespoke watch.
-- =====================================================

CREATE TABLE public."ORDER_ITEM" (
    "OrderItemID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "OrderID" INTEGER NOT NULL,
    "ModelID" INTEGER,
    "Quantity" INTEGER NOT NULL
        CHECK ("Quantity" > 0),
    "UnitPrice" DECIMAL(10,2) NOT NULL
        CHECK ("UnitPrice" >= 0),

    CONSTRAINT fk_order_item_order
        FOREIGN KEY ("OrderID")
        REFERENCES public."CUSTOMER_ORDER" ("OrderID"),

    CONSTRAINT fk_order_item_model
        FOREIGN KEY ("ModelID")
        REFERENCES public."WATCH_MODEL" ("ModelID")
);


-- =====================================================
-- 8. CUSTOMISATION_SPECIFICATION
-- Stores customisation requests for order items.
-- Each order item can have at most one specification.
-- =====================================================

CREATE TABLE public."CUSTOMISATION_SPECIFICATION" (
    "SpecificationID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "OrderItemID" INTEGER NOT NULL UNIQUE,
    "StrapColour" VARCHAR(50),
    "DialColour" VARCHAR(50),
    "RequestedMaterial" VARCHAR(100),
    "AdditionalDetails" TEXT,

    CONSTRAINT fk_specification_order_item
        FOREIGN KEY ("OrderItemID")
        REFERENCES public."ORDER_ITEM" ("OrderItemID")
);


-- =====================================================
-- 9. INVENTORY
-- Tracks components and finished watch models
-- held at warehouses and retail stores.
-- Each inventory record must represent either
-- a component OR a watch model, never both.
-- =====================================================

CREATE TABLE public."INVENTORY" (
    "InventoryID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "LocationID" INTEGER NOT NULL,
    "ComponentID" INTEGER,
    "ModelID" INTEGER,
    "QuantityAvailable" INTEGER NOT NULL
        CHECK ("QuantityAvailable" >= 0),
    "LastUpdated" DATE,

    CONSTRAINT fk_inventory_location
        FOREIGN KEY ("LocationID")
        REFERENCES public."LOCATION" ("LocationID"),

    CONSTRAINT fk_inventory_component
        FOREIGN KEY ("ComponentID")
        REFERENCES public."COMPONENT" ("ComponentID"),

    CONSTRAINT fk_inventory_model
        FOREIGN KEY ("ModelID")
        REFERENCES public."WATCH_MODEL" ("ModelID"),

    CONSTRAINT chk_inventory_item_type
        CHECK (
            ("ComponentID" IS NOT NULL AND "ModelID" IS NULL)
            OR
            ("ComponentID" IS NULL AND "ModelID" IS NOT NULL)
        )
);


-- Prevents duplicate component inventory records
-- for the same location.

CREATE UNIQUE INDEX uq_inventory_location_component
ON public."INVENTORY" ("LocationID", "ComponentID")
WHERE "ComponentID" IS NOT NULL;


-- Prevents duplicate watch model inventory records
-- for the same location.

CREATE UNIQUE INDEX uq_inventory_location_model
ON public."INVENTORY" ("LocationID", "ModelID")
WHERE "ModelID" IS NOT NULL;


-- =====================================================
-- 10. SHIPMENT
-- Stores shipment and delivery tracking information.
-- Each shipment belongs to an order and has a
-- dispatch location.
-- =====================================================

CREATE TABLE public."SHIPMENT" (
    "ShipmentID" INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    "OrderID" INTEGER NOT NULL,
    "LocationID" INTEGER NOT NULL,
    "ShipmentDate" DATE,
    "TrackingNumber" VARCHAR(100) UNIQUE,
    "ShipmentStatus" VARCHAR(30),

    CONSTRAINT fk_shipment_order
        FOREIGN KEY ("OrderID")
        REFERENCES public."CUSTOMER_ORDER" ("OrderID"),

    CONSTRAINT fk_shipment_location
        FOREIGN KEY ("LocationID")
        REFERENCES public."LOCATION" ("LocationID")
);

COMMIT;