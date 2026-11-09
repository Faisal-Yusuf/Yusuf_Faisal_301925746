# FAHAJ Normalisation

## 1. Introduction

Database normalisation is the process of organising information into related tables to reduce unnecessary data duplication and improve data integrity. It helps prevent insertion, update and deletion anomalies, which are problems that occur when poorly organised data is added, changed or removed.

This explanation uses FAHAJ, a wristwatch manufacturing and distribution company, to demonstrate the stages of normalisation: First Normal Form (1NF), Second Normal Form (2NF) and Third Normal Form (3NF).

The examples use fictional customers, orders and watch models to demonstrate how the database structure changes at each stage.

## 2. Starting Record: Unnormalised Data

Before normalisation, customer order information may be stored in one record, with several ordered watches grouped together in a repeating list.

For example:

| OrderID | OrderDate  | CustomerID | CustomerName | CustomerEmail                                   | OrderedItems                                                    |
| ------- | ---------- | ---------- | ------------ | ----------------------------------------------- | --------------------------------------------------------------- |
| 5001    | 2026-10-12 | 101        | Amina Bello  | [amina@example.com](mailto:amina@example.com)   | (301, Classic Silver, 1, 85000); (302, Classic Black, 1, 90000) |
| 5002    | 2026-10-13 | 102        | Daniel Musa  | [daniel@example.com](mailto:daniel@example.com) | (301, Classic Silver, 2, 85000)                                 |

The `OrderedItems` column contains multiple watch details in a single field. This makes it difficult to retrieve, update or manage individual order items.

For example, changing the quantity of one watch requires locating the correct item within the repeated list. This structure also makes it difficult to apply database constraints to individual order items.

**The first step is to remove these repeating groups.**

## 3. First Normal Form (1NF)

A table satisfies First Normal Form when every field contains a single value and there are no repeating groups.

To achieve 1NF, the ordered items are separated into individual records. Each row now represents one watch within a customer order.

The resulting table is:

**ORDER_RECORD_1NF**

| OrderID | LineNo | OrderDate  | CustomerID | FirstName | LastName | CustomerEmail                                   | ModelID | ModelName      | BasePrice | Quantity | UnitPrice |
| ------- | ------ | ---------- | ---------- | --------- | -------- | ----------------------------------------------- | ------- | -------------- | --------- | -------- | --------- |
| 5001    | 1      | 2026-10-12 | 101        | Amina     | Bello    | [amina@example.com](mailto:amina@example.com)   | 301     | Classic Silver | 85000     | 1        | 85000     |
| 5001    | 2      | 2026-10-12 | 101        | Amina     | Bello    | [amina@example.com](mailto:amina@example.com)   | 302     | Classic Black  | 90000     | 1        | 90000     |
| 5002    | 1      | 2026-10-13 | 102        | Daniel    | Musa     | [daniel@example.com](mailto:daniel@example.com) | 301     | Classic Silver | 85000     | 2        | 85000     |

**Primary key:** (OrderID, LineNo)

The primary key is a combination of two fields because an order can contain several items. `LineNo` identifies an item within a particular order, while `OrderID` identifies the order itself.

**What changes in 1NF?**

- The repeated list of ordered watches is replaced with separate rows.
- Each row contains details for one order item.
- Each field contains a single value.

This removes the repeating-group problem and makes individual order items easier to identify and manage.

However, customer and order information is still repeated across multiple rows. This leads to the next stage.

## 4. Second Normal Form (2NF)

A table satisfies Second Normal Form when it is already in 1NF and every non-key attribute depends on the entire primary key, not just part of a combined primary key.

In the 1NF table, the primary key consists of `OrderID` and `LineNo`.

Some fields depend only on `OrderID`, rather than the entire combination of `OrderID` and `LineNo`.

For example:

- OrderDate depends on OrderID.
- CustomerID depends on OrderID.
- FirstName, LastName and CustomerEmail are associated with the customer identified by CustomerID.

These are partial dependencies. A partial dependency occurs when an attribute depends on only part of a combined primary key.

To remove these dependencies, the order information is separated from the individual order-item information.

**Table 1: CUSTOMER_ORDER_2NF**

| OrderID (PK) | OrderDate  | CustomerID | FirstName | LastName | CustomerEmail                                   |
| ------------ | ---------- | ---------- | --------- | -------- | ----------------------------------------------- |
| 5001         | 2026-10-12 | 101        | Amina     | Bello    | [amina@example.com](mailto:amina@example.com)   |
| 5002         | 2026-10-13 | 102        | Daniel    | Musa     | [daniel@example.com](mailto:daniel@example.com) |

**Table 2: ORDER_ITEM_2NF**

| OrderID (PK, FK) | LineNo (PK) | ModelID | ModelName      | BasePrice | Quantity | UnitPrice |
| ---------------- | ----------- | ------- | -------------- | --------- | -------- | --------- |
| 5001             | 1           | 301     | Classic Silver | 85000     | 1        | 85000     |
| 5001             | 2           | 302     | Classic Black  | 90000     | 1        | 90000     |
| 5002             | 1           | 301     | Classic Silver | 85000     | 2        | 85000     |

The primary key of ORDER_ITEM_2NF is the combination of `OrderID` and `LineNo`. `OrderID` is also a foreign key referencing CUSTOMER_ORDER_2NF.

**What changes in 2NF?**

- Order dates and customer details are moved out of the order-item table.
- The order header is stored separately from its individual items.
- Each order item remains linked to its customer order through OrderID.

This removes the partial dependency on OrderID and prevents order information from being unnecessarily repeated for every item.

At this stage, the tables satisfy 2NF. However, some information still depends on another non-key field. For example, ModelName and BasePrice depend on ModelID. This is addressed in 3NF.

## 5. Third Normal Form (3NF)

A table satisfies Third Normal Form when it is already in 2NF and its non-key attributes depend directly on the primary key rather than on another non-key attribute.

This means that a table should not contain transitive dependencies. A transitive dependency occurs when one non-key attribute determines another non-key attribute.

In the 2NF example:

- CustomerID determines FirstName, LastName and CustomerEmail.
- ModelID determines ModelName and BasePrice.

Therefore, customer details and watch model details are separated into their own tables.

### Table 1: CUSTOMER

| CustomerID (PK) | FirstName | LastName | Email                                           |
| --------------- | --------- | -------- | ----------------------------------------------- |
| 101             | Amina     | Bello    | [amina@example.com](mailto:amina@example.com)   |
| 102             | Daniel    | Musa     | [daniel@example.com](mailto:daniel@example.com) |

### Table 2: CUSTOMER_ORDER

| OrderID (PK) | CustomerID (FK) | OrderDate  | OrderStatus |
| ------------ | --------------- | ---------- | ----------- |
| 5001         | 101             | 2026-10-12 | Processing  |
| 5002         | 102             | 2026-10-13 | Confirmed   |

### Table 3: WATCH_MODEL

| ModelID (PK) | ModelName      | BasePrice |
| ------------ | -------------- | --------- |
| 301          | Classic Silver | 85000     |
| 302          | Classic Black  | 90000     |

### Table 4: ORDER_ITEM

| OrderItemID (PK) | OrderID (FK) | ModelID (FK) | Quantity | UnitPrice |
| ---------------- | ------------ | ------------ | -------- | --------- |
| 7001             | 5001         | 301          | 1        | 85000     |
| 7002             | 5001         | 302          | 1        | 90000     |
| 7003             | 5002         | 301          | 2        | 85000     |

**What changes in 3NF?**

- Customer information is stored in CUSTOMER and linked to CUSTOMER_ORDER through CustomerID.
- Watch model information is stored in WATCH_MODEL and linked to ORDER_ITEM through ModelID.
- ORDER_ITEM contains the details of the individual items rather than repeating full watch model descriptions.

This removes the transitive dependencies and prevents customer and watch model details from being unnecessarily duplicated.

## 6. How the IDs Keep the Tables Connected

The IDs maintain the relationships between the resulting tables.

For example:

- `CustomerID` connects CUSTOMER to CUSTOMER_ORDER.
- `OrderID` connects CUSTOMER_ORDER to ORDER_ITEM.
- `ModelID` connects WATCH_MODEL to ORDER_ITEM.

A foreign key references the primary key of another table. This allows related information to be retrieved without storing the same details repeatedly.

### Replacement of the Combined Key

In the earlier 1NF and 2NF examples, ORDER_ITEM uses a combined primary key consisting of `OrderID` and `LineNo`.

However, the final FAHAJ design uses an automatically generated `OrderItemID` as the primary key of ORDER_ITEM.

This means that each order item has its own unique identifier, while `OrderID` remains a foreign key linking it to CUSTOMER_ORDER.

The change simplifies the identification of order items and their references from other tables. However, using an automatically generated ID does not automatically make a table satisfy 3NF. Normalisation still depends on how the attributes relate to one another.

## 7. Final FAHAJ Database Tables

The final normalised design contains ten related tables. The examples above focus on customer orders and watch models to demonstrate the normalisation process. The remaining tables support FAHAJ's suppliers, components, inventory, locations, customisation and shipment operations.

The following tables represent the agreed final design.

| Table                       | Primary key     | Important foreign keys           |
| --------------------------- | --------------- | -------------------------------- |
| SUPPLIER                    | SupplierID      | None                             |
| COMPONENT                   | ComponentID     | SupplierID                       |
| LOCATION                    | LocationID      | None                             |
| INVENTORY                   | InventoryID     | LocationID, ComponentID, ModelID |
| CUSTOMER                    | CustomerID      | None                             |
| CUSTOMER_ORDER              | OrderID         | CustomerID                       |
| ORDER_ITEM                  | OrderItemID     | OrderID, ModelID                 |
| WATCH_MODEL                 | ModelID         | None                             |
| CUSTOMISATION_SPECIFICATION | SpecificationID | OrderItemID                      |
| SHIPMENT                    | ShipmentID      | OrderID, LocationID              |

The final design also includes the following business rules:

- INVENTORY references either a component or a watch model, but not both in the same record.
- A component or watch model can have inventory records at different locations.
- An order can contain multiple order items.
- An order item can reference an existing watch model or have a NULL ModelID when it represents a fully bespoke watch.
- A customisation specification belongs to one order item and is limited to one specification per item.
- A bespoke order item must have a corresponding customisation specification. This requirement needs additional database or application-level validation.

### Fields Not Shown in the Example Tables

The earlier example tables display selected attributes to keep the normalisation stages readable. The following agreed attributes are also included in the final database design:

| Table                       | Additional attributes                                         |
| --------------------------- | ------------------------------------------------------------- |
| SUPPLIER                    | Email, Phone, Address                                         |
| COMPONENT                   | Description, UnitCost                                         |
| LOCATION                    | LocationType, Address, City, Country                          |
| INVENTORY                   | QuantityAvailable, LastUpdated                                |
| CUSTOMER                    | Phone, Address, PasswordHash                                  |
| CUSTOMER_ORDER              | OrderDate, OrderStatus (both already shown in the example)    |
| ORDER_ITEM                  | ModelID, Quantity, UnitPrice (already shown in the example)   |
| WATCH_MODEL                 | Description, CaseMaterial, DialType                           |
| CUSTOMISATION_SPECIFICATION | StrapColour, DialColour, RequestedMaterial, AdditionalDetails |
| SHIPMENT                    | ShipmentDate, TrackingNumber, ShipmentStatus                  |

## 8. Conclusion

Normalisation organises FAHAJ's database into related tables to reduce unnecessary data duplication and improve data integrity. First Normal Form removes repeating groups, Second Normal Form removes partial dependencies on a combined key, and Third Normal Form removes transitive dependencies.