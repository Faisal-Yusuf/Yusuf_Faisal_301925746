# FAHAJ – Keys and Constraints

## INTRODUCTION
A relational database's keys and constraints are crucial components because they provide record identification, table relationships, and data accuracy. Primary keys, foreign keys, and other restrictions are employed in the FAHAJ database to guarantee that records are uniquely identifiable and that table relationships are consistent.

## 1. Primary Keys (PK)
A Primary Key uniquely identifies each record in a database table. It prevents two records from having the same identifying value.

For example, SupplierID uniquely identifies every supplier registered in the FAHAJ database.

## 2. Foreign Keys (FK)
A Foreign Key is an attribute that references the Primary Key of another table. It establishes a relationship between two tables.

For example, SupplierID in the Component table references SupplierID in the Supplier table. This allows FAHAJ to identify which supplier provides each component.


## 3. Unique Key (UK)
A Unique Key ensures that duplicate values are not allowed in a particular field.

For example, the Email field in the Customer table must be unique so that two customer accounts cannot use the same email address.


## Other Database Constraints
Constraints are rules applied to database columns or tables to prevent invalid or inconsistent data from being stored.

The FAHAJ database uses the following constraints:

- NOT NULL: Prevents a column from accepting NULL values.
- UNIQUE: Prevents duplicate values in a column or combination of columns.

- CHECK: Ensures that stored values satisfy a specified condition.
- DEFAULT: Automatically provides a value when one is not supplied.


#### Additional constraints include:

UnitPrice and BasePrice must not be negative.

OrderItemID in CUSTOMISATION_SPECIFICATION must be unique, ensuring that an order item has at most one customisation specification.

TrackingNumber must be unique when provided.

Each INVENTORY record must reference either a component or a watch model, but not both.

A location must not have duplicate stock records for the same component or watch model.


## Conclusion

The use of primary keys, foreign keys and other database constraints helps maintain data integrity and consistency within the FAHAJ database. These rules ensure that records are properly identified, relationships between tables remain valid and important business requirements are enforced.