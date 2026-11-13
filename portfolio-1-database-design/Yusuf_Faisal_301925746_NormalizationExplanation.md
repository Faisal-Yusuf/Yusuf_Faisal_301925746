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


**What are the changes in 3NF?**

Customer information is stored in CUSTOMER and is related to CUSTOMER_ORDER via CustomerID.
The Watch model information is stored in WATCH_MODEL and is associated to ORDER_ITEM via ModelID.
ORDER_ITEM includes the information about the individual items, not the full watch model descriptions.

This eliminates the transitive dependencies and unneeded duplication of customer and watch model details.

## 6. The IDs are used to link the Tables.The IDs are used to join the Tables.

The relationships between the resulting tables are maintained in the IDs.

For example:

- `CustomerID` is a foreign key that links CUSTOMER with CUSTOMER_ORDER.
- `OrderID` is the relationship between CUSTOMER_ORDER and ORDER_ITEM.
This is a one-to-one link between WATCH_MODEL and ORDER_ITEM.

Foreign key is a key that points to a primary key of another table. This enables related information to be retrieved without having to store the same information multiple times.

The Combined Key has been replaced.The Combined Key has been replaced.

In the previous examples in 1NF and 2NF, ORDER_ITEM has a composite primary key of OrderID and LineNo.

The final FAHAJ design, however, has an automatically generated `OrderItemID` as the primary key of ORDER_ITEM.

Each order item will have its own identifier and OrderID will be a foreign key that references CUSTOMER_ORDER.

The change makes it easier to identify order items and their references on other tables. But, an automatically generated ID is not sufficient to make a table 3NF. Normalisation still requires the relationship between the attributes.

## 7. Final FAHAJ Database Tables

The final normalized design has 10 related tables. The examples above illustrate the normalisation process with regard to customer orders and watch models. The other tables are used for the suppliers, components, inventory, locations, customisation and shipment operations of FAHAJ.

The agreed final design is shown in the following tables:

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

The final design also contains the following business rules:

- INVENTORY refers to either a component or a watch model, but not both in the same record.
A component or watch model may have inventory records in various locations.
Many order items can be added to an order.
An order item may refer to an existing watch model or may be NULL if it is a completely bespoke watch.
- A customisation specification is an order item level specification and can only be a single specification per order item.
There needs to be a customisation specification for a bespoke order item. This requirement requires more validation in the database or application.

The following fields are not included in the example tables:

Selected attributes have been included in the earlier example tables to make the normalisation stages readable. The following agreed attributes are also part of the final database design:


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

Normalisation is the process of structuring FAHAJ's database in a way that avoids unnecessary duplication of data and ensures the integrity of the data. The first normal form eliminates repeating groups, the second normal form eliminates partial dependencies on a combined key, and the third normal form eliminates transitive dependencies.
