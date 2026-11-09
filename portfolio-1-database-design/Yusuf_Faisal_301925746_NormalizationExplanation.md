# FAHAJ Normalisation

## 1. Introduction

Normalisation is the process of structuring data into related tables to minimise data duplication and ensure data integrity. It helps to avoid insertion, update and deletion anomalies, problems that can arise when data is poorly organised and is inserted, updated or deleted.

The following explanation will be based on a wristwatch manufacturing and distribution company called FAHAJ. This will illustrate the stages of normalisation: First Normal Form (1NF), Second Normal Form (2NF) and Third Normal Form (3NF).

The examples are based on fictional customers, orders and watch models to illustrate the changes in the database structure at every step.

## 2. Starting Record: Unnormalised Data

Prior to normalisation, customer order information might be held in a single record while multiple watches ordered by a customer could be listed in a repeating list.

For example:

| OrderID | OrderDate  | CustomerID | CustomerName | CustomerEmail                                   | OrderedItems                                                    |
| ------- | ---------- | ---------- | ------------ | ----------------------------------------------- | --------------------------------------------------------------- |
| 5001    | 2026-10-12 | 101        | Amina Bello  | [amina@example.com](mailto:amina@example.com)   | (301, Classic Silver, 1, 85000); (302, Classic Black, 1, 90000) |
| 5002    | 2026-10-13 | 102        | Daniel Musa  | [daniel@example.com](mailto:daniel@example.com) | (301, Classic Silver, 2, 85000)                                 |

The `OrderedItems` column has several watch details in a single field. This makes it hard to get, update or manage individual order items.

For instance, if the quantity of one watch changes, one has to find the appropriate item in the repeated list. This also makes it hard to add database constraints to individual order items.

The first step is to eliminate these repeating groups.

## 3. First Normal Form (1NF)

A table is in 1NF if all of the fields have only one value and there are no repeating groups.

To get to 1NF, the ordered items are broken into separate records. Each row is now a single watch in a customer order.

The resulting table is:

**ORDER_RECORD_1NF**

| OrderID | LineNo | OrderDate  | CustomerID | FirstName | LastName | CustomerEmail                                   | ModelID | ModelName      | BasePrice | Quantity | UnitPrice |
| ------- | ------ | ---------- | ---------- | --------- | -------- | ----------------------------------------------- | ------- | -------------- | --------- | -------- | --------- |
| 5001    | 1      | 2026-10-12 | 101        | Amina     | Bello    | [amina@example.com](mailto:amina@example.com)   | 301     | Classic Silver | 85000     | 1        | 85000     |
| 5001    | 2      | 2026-10-12 | 101        | Amina     | Bello    | [amina@example.com](mailto:amina@example.com)   | 302     | Classic Black  | 90000     | 1        | 90000     |
| 5002    | 1      | 2026-10-13 | 102        | Daniel    | Musa     | [daniel@example.com](mailto:daniel@example.com) | 301     | Classic Silver | 85000     | 2        | 85000     |

**Primary key:** (OrderID, LineNo)

The primary key consists of two attributes: OrderID and LineNo.

You have two fields in the primary key because an order may have multiple items: LineNo is used to identify an item in a specific order, and OrderID is used to identify the order.

What are the changes in 1NF?

Repeated list of ordered watches is replaced by separate rows.
- An order item is represented by each row.
- A value is present in each field.

This eliminates the repeating-group problem and simplifies the identification and management of individual order items.

But there is still repeat of customer and order information in multiple rows. This results in the next step.

## 4. Second Normal Form (2NF)

A table is in 2NF if it is in 1NF and each non-key attribute is dependent on the whole primary key, not just a part of a composite primary key.

The primary key for the 1NF table is OrderID and LineNo.

Some fields are only required by `OrderID`, and not by the combination of `OrderID` and `LineNo`.

For example:

OrderDate is dependent on OrderID.
CustomerID is dependent on OrderID.
FirstName, LastName and CustomerEmail are related to the Customer identified by CustomerID.

These are “partial” dependencies. Partial dependency is when an attribute is dependent on just some of the primary key.

These dependencies are eliminated by splitting the order information from the individual order-item information.

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

**What happens if 2NF changes?**

- Order dates and customer details are moved out of the order-item table.
Order header is not stored with the individual items.
- OrderID is a link between each order item and its customer order.

This eliminates the partial dependency on OrderID and avoids having to repeat order information for each item.

The tables are now in 2NF. There are some information that still requires another non-key field. For instance, ModelName and BasePrice are dependent on ModelID. This is solved in 3NF.

## 5. Third Normal Form (3NF)

A table is in 3NF if it is already in 2NF and the non-key attributes of the table depend directly on the primary key and not on any other non-key attribute.

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