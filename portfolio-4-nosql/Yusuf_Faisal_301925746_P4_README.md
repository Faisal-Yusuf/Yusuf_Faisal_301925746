# Portfolio 4: NoSQL and Advanced Data Models

## 1. Portfolio Overview

This portfolio demonstrates the design, implementation and evaluation of a NoSQL database using MongoDB. It covers document modelling, data organisation, CRUD operations, aggregation, indexing, query performance and an evaluation of other NoSQL data models.

## 2. Database Environment

| Item | Details |
|---|---|
| Database technology | MongoDB Community Server |
| MongoDB version | 8.0.38 |
| MongoDB Shell | mongosh 2.14.2 |
| Database name | FAHAJ |
| Operational collections | Customers, WatchModels, CustomerOrders, Inventory |
| Total operational documents | 19 |

## 3. Database Design and Data Organisation

The implementation uses four operational collections:

- **Customers:** Stores customer information.
- **WatchModels:** Stores standard watch model details.
- **CustomerOrders:** Stores customer orders, with order items, customisation details and shipment information embedded in documents.
- **Inventory:** Stores stock records for watch models and components, including associated supplier and location information.

The data model uses embedded documents and arrays where related information is commonly accessed together. References connect customer orders to customer records and standard order items to watch model records.

## 4. Implementation and Practical Operations

The MongoDB implementation includes:

- Database creation and collection verification.
- Insertion and retrieval of sample documents.
- Query operations using filtering and projections.
- Aggregation pipelines for retrieving and analysing related data.
- Queries involving inventory availability and customised orders.
- Creation and verification of indexes.
- A duplicate-value test to demonstrate unique index enforcement.
- Query execution-plan analysis using `explain("executionStats")`.
- Comparison of indexed query execution with a collection scan.

The implementation contains 19 operational documents across the four collections. Backup collections were also created for backup demonstration purposes and are excluded from this count.

## 5. Indexing and Query Performance

Indexes were created to support frequently used queries and enforce uniqueness where appropriate.

The performance comparison produced the following results:

| Measurement | Indexed Query | Collection Scan |
|---|---:|---:|
| Execution stage | IXSCAN | COLLSCAN |
| Documents returned | 2 | 2 |
| Index keys examined | 2 | 0 |
| Documents examined | 2 | 8 |
| Execution time | 183 ms | 0 ms |

The indexed query examined fewer documents than the collection scan. However, its measured execution time was higher in this test. The small dataset and variability in execution time mean that the result should not be interpreted as proof of faster execution.

## 6. Evaluation of Other NoSQL Data Models

The portfolio also evaluates:

- **Key-value databases:** Their organisation of data into key-value pairs and possible applications.
- **Column-family databases:** Their use of column families for large-scale and distributed data.
- **Graph databases:** Their representation of entities and relationships using nodes and edges.

These models are discussed through examples and compared with the document-oriented approach used in the MongoDB implementation.

## 7. Project Files and Evidence

| File or folder | Purpose |
|---|---|
| `Yusuf_Faisal_301925746_P4_Report.md` | Portfolio report covering database design, implementation, operations, evaluation and reflection |
| `Yusuf_Faisal_301925746_P4_Setup.md` | MongoDB installation, configuration and connection documentation |
| `Yusuf_Faisal_301925746_mongoDBSource.list` | MongoDB package repository configuration |
| `screenshot/` | Screenshots showing database setup, collections, queries, aggregation, indexes and query-performance results |
| `Yusuf_Faisal_301925746_P4_README.md` | Portfolio overview and repository documentation |

## 8. Conclusion

The portfolio demonstrates a practical MongoDB implementation, including document modelling, embedded and referenced data, query and aggregation operations, indexing and execution-plan analysis. It also evaluates alternative NoSQL data models and considers their suitability for different data-management requirements.