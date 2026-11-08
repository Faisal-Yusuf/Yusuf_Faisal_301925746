# FAHAJ – Relational Schema

By converting the entities and relationships shown in the Entity Relationship Diagram (ERD) into relational tables, the relational schema depicts the logical structure of the FAHAJ database. While primary keys and foreign keys create unique identification and linkages across tables, each table has attributes that characterise the data stored.

The schemas used are:

## 1. SUPPLIER

Stores information about suppliers who provide components used in FAHAJ's watch manufacturing operations.

### Relational representation:
SUPPLIER(
    SupplierID PK,
    SupplierName,
    Email,
    Phone,
    Address
)

## 2. COMPONENT
Stores details of the components supplied to FAHAJ for watch manufacturing.

### Relational representation:
COMPONENT(
    ComponentID PK,
    SupplierID FK → SUPPLIER(SupplierID),
    ComponentName,
    Description,
    UnitCost
)

## 3. LOCATION
Contains information about FAHAJ's warehouses and retail stores.
### Relational representation:
LOCATION(
    LocationID PK,
    LocationName,
    LocationType,
    Address,
    City,
    Country
)

## 4. INVENTORY
Keeps track of components and finished watches available at different FAHAJ locations.

### Relational representation:
INVENTORY(
    InventoryID PK,
    LocationID FK → LOCATION(LocationID),
    ComponentID FK → COMPONENT(ComponentID) NULL,
    ModelID FK → WATCH_MODEL(ModelID) NULL,
    QuantityAvailable,
    LastUpdated
)

## 5.  CUSTOMER
Stores information about customers who register with FAHAJ.

### Relational representation:
CUSTOMER(
    CustomerID PK,
    FirstName,
    LastName,
    Email UK,
    Phone,
    Address,
    PasswordHash
)

## 6. CUSTOMER_ORDER
Records orders placed by registered FAHAJ customers.

### Relational representation
CUSTOMER_ORDER(
    OrderID PK,
    CustomerID FK → CUSTOMER(CustomerID),
    OrderDate,
    OrderStatus
)

## 7. ORDER_ITEM
Contains details of individual watches included in a customer's order.

### Relational representation
ORDER_ITEM(
    OrderItemID PK,
    OrderID FK → CUSTOMER_ORDER(OrderID),
    ModelID FK → WATCH_MODEL(ModelID) NULL,
    Quantity,
    UnitPrice
)

## 8. WATCH MODEL
Stores information about the standard watch models manufactured by FAHAJ.

### Relational representation
WATCH_MODEL(
    ModelID PK,
    ModelName,
    Description,
    BasePrice,
    CaseMaterial,
    DialType
)


## 9. CUSTOMISATION_SPECIFICATION
Stores the specific design requirements requested by customers for individual order items.

### Relational representation
CUSTOMISATION_SPECIFICATION(
    SpecificationID PK,
    OrderItemID FK → ORDER_ITEM(OrderItemID) UK,
    StrapColour,
    DialColour,
    RequestedMaterial,
    AdditionalDetails
)


## 10. SHIPMENT
Records information about customer orders dispatched from FAHAJ locations.

### Relational representation
SHIPMENT(
    ShipmentID PK,
    OrderID FK → CUSTOMER_ORDER(OrderID),
    LocationID FK → LOCATION(LocationID),
    ShipmentDate,
    TrackingNumber UK,
    ShipmentStatus
)



## Conclusion

By grouping the FAHAJ database's business data into ten linked tables, the relational schema offers an organised depiction of the database. Foreign keys create links between related tables, whereas primary keys uniquely identify records. The organization's main operations, such as supplier administration, inventory monitoring, customer registration, order processing, watch customisation, and shipment management, are supported by the schema.
