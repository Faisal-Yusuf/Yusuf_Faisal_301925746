## This portfolio focuses on query processing and optimisation.

## Queries and results

The FAHAJ database was used to illustrate SQL queries with related tables, filtering and aggregation.

Three SQL queries were created and run:

1. A query joining customers, customer orders, order items and watch models to display purchased watches.
2. A query identifying watch models with no available stock at Abuja Central Warehouse.
3. A query counting order items for each watch model, including models that have not been ordered.

The queries were successfully run in PostgreSQL, and the output was saved as screenshots.

An additional benchmark schema called `p2_benchmark` was also developed for the indexing experiment. It does not alter the original FAHAJ tables, but contains 100,000 synthetic order-history records.

### Query 1: Customer orders and purchased watches

This query is a combination of tables CUSTOMER, CUSTOMER_ORDER, ORDER_ITEM and WATCH_MODEL to show customer names, order details, and watch models purchased by the customer.

Six rows were returned by the query, representing the watches bought by customers in four orders. One of the order items was not linked to a standard watch model since it was a custom watch item.

**Result:** 6 rows returned.

### Query 2: Watch models with no available stock

This query is used to determine the models of the watches not available at Abuja Central Warehouse using the NOT EXISTS predicate. It takes into account both models without an inventory record for the location and models with zero inventory.

Result: 3 models of watch were returned.

### Query 3: Number of order items per watch model

This is a query that uses a `LEFT JOIN` and `COUNT` to find the number of order items for each watch model. The `LEFT JOIN` will include models that have no order items.

Result: 4 models of watch returned, 0 items ordered.

