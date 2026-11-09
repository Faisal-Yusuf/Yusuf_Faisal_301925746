
# FAHAJ ER Diagram

## 1. Entity Relationship Diagram

## 1. Entity Relationship Diagram

The following Entity Relationship Diagram (ERD) shows the database design for a wristwatch manufacturing and distributing company called FAHAJ. It illustrates the entities, their attributes, primary keys, foreign keys, unique fields and relationships.

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

Some suppliers may provide none or several components, and each component must be linked to a single supplier.

### 2. Location and Inventory (||--o{)

There is zero or more inventory records at one location, and one inventory record at each location.

### 3. Component and Inventory (||--o{)

Each component-related inventory record refers to exactly one component, and one component can be present in zero or many inventory records, at different locations.

### 4. A watch that is used to check the time and inventories.A watch used for checking time and inventories.

A watch model can be listed in zero or multiple inventory records at different stores, and each inventory record for a watch model has exactly one watch model.

### 5. Customer and Customer Order (||--o{)

A customer may place any number of orders, and each order is placed by exactly one customer.

### 6. Each customer order contains one or more Order Items.A Customer Order has one or more Order Items.

There must be at least one order item in each customer order and each order item must be in exactly one customer order.

### 7. Watch Model and Order Item (o|--o{)

A watch model may have no or many order items, and an order item may have no or one watch model. It is suitable for standard, modified or bespoke watches that are not based on a standard model.

### 8. Order Item and Customisation Specification (||--o|)

A customisation specification can be attached to zero or one order item, and an order item can have at most one customisation specification.

### 9. Customer Order and Shipment (||--o{)

A customer order may have 0 or many shipments, and each shipment is associated with exactly one customer order.

### 10. Location and Shipment (||--o{)

A shipment may be sent from a single location or from multiple locations, and each shipment is sent from a single location.


## 3. Understanding the Symbols
- | represents one.
- o represents zero or optional.
- { represents many (the crow's foot).
The symbols at the ends of a relationship indicate the number of records that can be related to one record at the other end of the relationship.


#### 4. Conclusion
The relationships between the ten entities in the FAHAJ database are depicted in the Crow's Foot Notation. It indicates the cardinality and optionality of each relationship, which helps to understand the structure of the database and its business rules.