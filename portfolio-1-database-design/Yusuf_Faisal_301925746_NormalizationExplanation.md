# FAHAJ – Normalisation Explanation

## 1. Introduction

Database normalisation is the process of organising data into related tables to reduce unnecessary duplication and improve data integrity. It helps prevent insertion, update and deletion anomalies while making the database easier to maintain.

The FAHAJ database design applies the principles of First Normal Form (1NF), Second Normal Form (2NF) and Third Normal Form (3NF).

## 2. First Normal Form (1NF)

A database table satisfies First Normal Form when each column contains a single, atomic value and there are no repeating groups of data.

In the FAHAJ database, each customer, supplier, component, watch model and other record is stored separately.

For example, when a customer orders three different watches, the system stores one record in CUSTOMER_ORDER and three separate records in ORDER_ITEM. Each order item represents an individual product within that order.

This structure prevents multiple products from being stored in a single field and makes individual order items easier to manage.

## 3. Second Normal Form (2NF)

A database table satisfies Second Normal Form when it is already in First Normal Form and every non-key attribute depends on the whole primary key.

The FAHAJ database uses individual primary keys to identify records in its tables. For example, ORDER_ITEM uses OrderItemID to uniquely identify each order item, while OrderID identifies the customer order to which the item belongs.

Watch model information, such as ModelName, CaseMaterial and DialType, is stored in WATCH_MODEL rather than repeatedly storing those details in ORDER_ITEM.

This separation reduces unnecessary duplication and ensures that watch model information is maintained in one place.

Since the tables use single-column primary keys, they do not have partial dependencies on a composite primary key.

## 4. Third Normal Form (3NF)

A database table satisfies Third Normal Form when it is already in Second Normal Form and its non-key attributes depend directly on the primary key rather than on other non-key attributes.

The FAHAJ database separates information about different business entities into their respective tables.

Examples include:

- Supplier names and contact details are stored in SUPPLIER rather than repeated in COMPONENT.
- Watch model descriptions and specifications are stored in WATCH_MODEL rather than repeated in ORDER_ITEM.
- Location details are maintained in LOCATION rather than duplicated across INVENTORY and SHIPMENT.
- Customer information is stored in CUSTOMER, while individual orders are recorded separately in CUSTOMER_ORDER.

These arrangements reduce transitive dependencies and help prevent inconsistencies when information is updated.

## 5. Benefits of Normalisation

Normalising the FAHAJ database provides several benefits:

1. **Reduced data duplication:** Information is stored in appropriate tables instead of being unnecessarily repeated.
2. **Improved data consistency:** Updates to supplier, customer, model and location details can be made in one place.
3. **Prevention of anomalies:** The design reduces insertion, update and deletion anomalies.
4. **Improved data integrity:** Relationships between tables are maintained through primary and foreign keys.
5. **Easier maintenance:** The database structure is easier to manage as FAHAJ expands its manufacturing and distribution operations.

## 6. Conclusion

The FAHAJ database design applies 1NF, 2NF and 3NF principles by organising information into related tables and reducing unnecessary duplication. This structure supports data consistency, integrity and easier maintenance while accommodating the company's manufacturing, ordering, inventory and distribution activities.