# FAHAJ – Relational Schema

By converting the entities and relationships shown in the Entity Relationship Diagram (ERD) into relational tables, the relational schema depicts the logical structure of the FAHAJ database. While primary keys and foreign keys create unique identification and linkages across tables, each table has attributes that characterise the data stored.

The schemas used are:

## 1. SUPPLIER

Maintains data on suppliers of parts used in the manufacture of watches by FAHAJ.

### Relational representation:
SUPPLIER(
    SupplierID PK,
    SupplierName,
    Email,
    Phone,
    Address
)

## 2. COMPONENT
Records information about the components provided to FAHAJ for making watches.

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
Records customer data for customers who sign up with FAHAJ.

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
Records orders from registered FAHAJ customers.

### Relational representation
CUSTOMER_ORDER(
    OrderID PK,
    CustomerID FK → CUSTOMER(CustomerID),
    OrderDate,
    OrderStatus
)

## 7. ORDER_ITEM
Provides information about the watches that are part of a customer's order.

### Relational representation
ORDER_ITEM(
    OrderItemID PK,
    OrderID FK → CUSTOMER_ORDER(OrderID),
    ModelID FK → WATCH_MODEL(ModelID) NULL,
    Quantity,
    UnitPrice
)

## 8. WATCH MODEL
Contains the information of the normal watch models produced by FAHAJ.

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
Holds the design specifications for specific order items as requested by customers.

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
Records the details of customer orders sent from FAHAJ sites.

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

By grouping the FAHAJ database's business data into ten linked tables, the relational schema offers an organised depiction of the database. A foreign key is used to establish relationships between tables, while a primary key is used to uniquely identify records. The organization's main operations, such as supplier administration, inventory monitoring, customer registration, order processing, watch customisation, and shipment management, are supported by the schema.
