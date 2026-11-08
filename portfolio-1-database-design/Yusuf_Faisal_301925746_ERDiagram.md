
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

## 2. Explanation of Database Keys

**Primary Key (PK)**

A Primary Key uniquely identifies each record in a database table. It prevents two records from having the same identifying value.

For example, SupplierID uniquely identifies every supplier registered in the FAHAJ database.

**Foreign Key (FK)**

A Foreign Key is an attribute that references the Primary Key of another table. It establishes a relationship between two tables.

For example, SupplierID in the Component table references SupplierID in the Supplier table. This allows FAHAJ to identify which supplier provides each component.

**Unique Key (UK)**

A Unique Key ensures that duplicate values are not allowed in a particular field.

For example, the Email field in the Customer table must be unique so that two customer accounts cannot use the same email address.

## 3. Explanation of Relationship Symbols

The ER diagram uses Crow's Foot notation to represent relationships between entities.

| Symbol | Meaning |
|---|---|
| `||` | Exactly one |
| `o|` | Zero or one |
| `o{` | Zero or many |
| `|{` | One or many |

For example, the relationship:

`SUPPLIER ||--o{ COMPONENT`

means that one supplier can supply zero or many components, while each component must be associated with exactly one supplier.

Similarly, one customer can place zero or many orders, but every order must belong to exactly one registered customer.

## 4. Optional Fields and Relationships

Some attributes and relationships in the proposed database are optional.

- Supplier Email, Phone and Address may be optional.
- Component Description may be optional.
- Some Location details, including Address, City and Country, may be optional.
- Customer Phone and Address may be optional, but Email and PasswordHash are mandatory.
- Inventory ComponentID and ModelID are conditionally optional. Exactly one must contain a value in each inventory record.
- Inventory LastUpdated may be optional.
- OrderItem ModelID may be NULL for a completely bespoke watch design.
- WatchModel Description, CaseMaterial and DialType may be optional.
- A CustomisationSpecification is optional for an OrderItem. Its individual customisation fields may also be optional depending on the customer's requirements.
- Shipment ShipmentDate, TrackingNumber and ShipmentStatus may be optional until shipment processing begins.

## 5. Additional Database Constraints and Business Rules

Some business rules require additional database constraints or transaction logic beyond the relationships shown in the ER diagram.

1. **Inventory identification:** Each inventory record must reference either a Component or a WatchModel, but never both or neither.

2. **Inventory uniqueness:** A component or watch model should have only one inventory record at a particular location. This requires appropriate composite unique constraints.

3. **Inventory quantity:** QuantityAvailable must not be negative.

4. **Order items:** Every order must contain at least one order item. This may require transaction logic or additional database enforcement.

5. **Order item quantity:** Quantity must be greater than zero.

6. **Custom watch designs:** A standard or modified watch references an existing WatchModel. A completely bespoke watch may have a NULL ModelID and must have a corresponding CustomisationSpecification.

7. **Customer registration:** Every customer must register before placing an order. Each CustomerOrder must therefore reference an existing Customer.

8. **Shipment management:** An order may be dispatched in one shipment or divided into multiple shipments. Each shipment must reference its customer order and dispatch location.

9. **Password security:** Customer passwords are stored as securely generated password hashes rather than plain-text passwords.

These constraints help maintain data integrity, consistency and accuracy throughout the FAHAJ database.
