# FAHAJ – Keys and Constraints

## INTRODUCTION
A relational database's keys and constraints are crucial components because they provide record identification, table relationships, and data accuracy. Primary keys, foreign keys, and other restrictions are employed in the FAHAJ database to guarantee that records are uniquely identifiable and that table relationships are consistent.

## 1. Primary Keys (PK)
A primary key uniquely identifies each record in a database table. It prevents duplicate records and does not allow NULL values. Each table in the FAHAJ database has a primary key.

## 2. Foreign Keys (FK)
Foreign keys establish relationships between tables by referencing primary keys in other tables. They help maintain referential integrity by ensuring that referenced records exist.



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