
# FAHAJ ER Diagram

## 1. Entity Relationship Diagram

The following Entity Relationship Diagram (ERD) represents the proposed database design for FAHAJ, a wristwatch manufacturing and distribution company. It illustrates the entities, their attributes, primary keys, foreign keys, unique fields and relationships.

```mermaid
erDiagram
    direction LR

    SUPPLIER {
        int SupplierID PK
        varchar(100) SupplierName
        varchar(100) Email
        varchar(20) Phone
        varchar(255) Address
    }

    COMPONENT {
        int ComponentID PK
        int SupplierID FK
        varchar(100) ComponentName
        text Description
        decimal(10,2) UnitCost
    }

    LOCATION {
        int LocationID PK
        varchar(100) LocationName
        varchar(30) LocationType
        varchar(255) Address
        varchar(100) City
        varchar(100) Country
    }

    INVENTORY {
        int InventoryID PK
        int LocationID FK
        int ComponentID FK
        int ModelID FK
        int QuantityAvailable
        date LastUpdated
    }

    CUSTOMER {
        int CustomerID PK
        varchar(50) FirstName
        varchar(50) LastName
        varchar(100) Email UK
        varchar(20) Phone
        varchar(255) Address
        varchar(255) PasswordHash
    }

    CUSTOMER_ORDER {
        int OrderID PK
        int CustomerID FK
        datetime OrderDate
        varchar(30) OrderStatus
    }

    ORDER_ITEM {
        int OrderItemID PK
        int OrderID FK
        int ModelID FK
        int Quantity
        decimal(10,2) UnitPrice
    }

    WATCH_MODEL {
        int ModelID PK
        varchar(100) ModelName
        text Description
        decimal(10,2) BasePrice
        varchar(50) CaseMaterial
        varchar(50) DialType
    }

    CUSTOMISATION_SPECIFICATION {
        int SpecificationID PK
        int OrderItemID FK, UK
        varchar(50) StrapColour
        varchar(50) DialColour
        varchar(100) RequestedMaterial
        text AdditionalDetails
    }

    SHIPMENT {
        int ShipmentID PK
        int OrderID FK
        int LocationID FK
        date ShipmentDate
        varchar(100) TrackingNumber UK
        varchar(30) ShipmentStatus
    }

    SUPPLIER ||--o{ COMPONENT : supplies
    LOCATION ||--o{ INVENTORY : stores
    COMPONENT ||--o{ INVENTORY : stocked_in
    WATCH_MODEL ||--o{ INVENTORY : stocked_as
    CUSTOMER ||--o{ CUSTOMER_ORDER : places
    CUSTOMER_ORDER ||--|{ ORDER_ITEM : contains
    WATCH_MODEL o|--o{ ORDER_ITEM : identifies
    ORDER_ITEM ||--o| CUSTOMISATION_SPECIFICATION : has
    CUSTOMER_ORDER ||--o{ SHIPMENT : generates
    LOCATION ||--o{ SHIPMENT : dispatches
```

## 2. Explanation of Relationship Symbols

| Symbol | Meaning | Explanation |
|---|---|---|
| || | Exactly one | One and only one record must exist. |
| o| | Zero or one | A record may be associated with zero or one record. |
| o{ | Zero or many | A record may be associated with no records or many records. |
| |{ | One or many | A record must be associated with at least one record, possibly many. |


### 1. Supplier and Component (||--o{)

One supplier can supply zero or many components, while each component must be associated with exactly one supplier.

### 2. Location and Inventory (||--o{)

One location can have zero or many inventory records, while each inventory record belongs to exactly one location.

### 3. Component and Inventory (||--o{)

One component can appear in zero or many inventory records across different locations, while each component-related inventory record references exactly one component.

### 4. Watch Model and Inventory (||--o{)

One watch model can appear in zero or many inventory records across different locations, while each watch-model-related inventory record references exactly one watch model.

### 5. Customer and Customer Order (||--o{)

One customer can place zero or many orders, while each order belongs to exactly one customer.

### 6. Customer Order and Order Item (||--|{)

Each customer order must contain at least one order item, while each order item belongs to exactly one customer order.

### 7. Watch Model and Order Item (o|--o{)

A watch model can be associated with zero or many order items, while an order item can reference zero or one watch model. This supports both standard or modified watches and fully bespoke watches that do not use an existing model.

### 8. Order Item and Customisation Specification (||--o|)

Each order item can have zero or one customisation specification, while each customisation specification belongs to exactly one order item.

### 9. Customer Order and Shipment (||--o{)

One customer order can generate zero or many shipments, while each shipment belongs to exactly one customer order.

### 10. Location and Shipment (||--o{)

One location can dispatch zero or many shipments, while each shipment is dispatched from exactly one location.


## 3. Understanding the Symbols
- | represents one.
- o represents zero or optional.
- { represents many (the crow's foot).
The symbols at each end of a relationship describe how many records can be associated with one record at the opposite end.


#### 4. Conclusion
Crow's Foot Notation provides a visual representation of the relationships between the ten entities in the FAHAJ database. It shows the cardinality and optionality of each relationship, making the database structure and its business rules easier to understand.