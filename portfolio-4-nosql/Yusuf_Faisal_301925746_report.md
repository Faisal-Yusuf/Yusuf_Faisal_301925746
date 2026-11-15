# FAHAJ – Portfolio 4: NoSQL and Advanced Data Models

## 1. Overview of the NoSQL Implementation

This portfolio extends the FAHAJ database case study developed in Portfolio 1 by exploring how its data can be represented and managed using NoSQL database technologies.

MongoDB was selected for the practical implementation because its document-oriented structure supports flexible data organisation, embedded documents, arrays and references between collections. The implementation uses four main collections: Customers, WatchModels, CustomerOrders and Inventory.

The exercise demonstrates how MongoDB can support FAHAJ's customer records, watch catalogue, order processing, customisation details and inventory management. It also examines key-value, column-family and graph data models to evaluate their potential applications within the FAHAJ system.

## 2. MongoDB Database Design

### 2.1 Database Structure

A MongoDB database named `FAHAJ` was created to store the company's operational data. Unlike the relational database design in Portfolio 1, where each entity was represented by a separate table, the MongoDB implementation organises related information into four main collections.

The collections are:

| Collection | Purpose |
|---|---|
| Customers | Stores customer information, including names, contact details, addresses and account-related data. |
| WatchModels | Stores the watch catalogue, including model names, descriptions, prices and specifications. |
| CustomerOrders | Stores customer orders, order items, customisation specifications and shipment information. |
| Inventory | Stores component and finished-watch stock records, together with relevant supplier and location information. |

These four collections collectively represent the main data requirements of the FAHAJ system. Related information is grouped within documents where appropriate, reducing the need to maintain a separate collection for every entity in the original relational design.

### 2.2 Document Structure and Data Organisation

Each collection stores documents containing fields and values. MongoDB automatically assigns an `_id` field to each document to provide a unique identifier.

The collections use a combination of embedded documents and references.

**Customers:** Customer information is stored as individual documents. Each document contains fields such as first name, last name, email, phone number, address and a sample passwordHash field. The password hash values used in the sample data are placeholders and are not intended for actual authentication.

**WatchModels:** Each watch model is stored as an individual document containing its model name, description, category, base price, currency, case material and dial type.

**CustomerOrders:** Each order is stored as a document containing the customer reference, order date and order status. Its order items are stored in an embedded `items` array. Customisation details are embedded within the relevant order item, while shipment details are stored in an embedded `shipments` array.

**Inventory:** Each inventory record represents a stock item at a particular location. The `stockItem` field uses different structures depending on whether the record represents a component or a finished watch. Component documents also contain embedded supplier information, while location details are embedded within the inventory record.

### 2.3 Embedded Documents and References

The design uses embedded documents where related information is commonly retrieved together. For example, order items and their customisation specifications are stored within the corresponding customer order. This allows an order and its associated details to be retrieved as one document.

References are used where information belongs to another main collection. For example, a customer order stores a reference to a document in the `Customers` collection, while standard order items reference documents in `WatchModels`.

The `Inventory` collection embeds location and supplier details instead of maintaining separate operational collections for these records.

These design choices demonstrate two important MongoDB approaches:

- **Embedding:** Storing related information inside a parent document.
- **Referencing:** Connecting documents using identifiers.

MongoDB references are not automatically enforced as foreign keys in the same way as relational database constraints. Their validity must therefore be managed through application logic or other validation mechanisms.



## 3. MongoDB Implementation and Operations

### 3.1 Environment and Database Setup

The implementation was carried out using MongoDB Community Server 8.0.38 and MongoDB Shell (`mongosh`) 2.14.2 within an existing GitHub Codespace environment.

A database named `FAHAJ` was selected using:

```javascript
use FAHAJ
```

The MongoDB server used a local data directory and was bound to `127.0.0.1` to restrict database access to the local environment.

### 3.2 Data Insertion and Query Operations

Sample data was inserted into the four main collections to represent FAHAJ's customers, watch models, customer orders and inventory.

| Collection | Documents |
|---|---:|
| Customers | 3 |
| WatchModels | 4 |
| CustomerOrders | 4 |
| Inventory | 8 |
| **Total** | **19** |

Several queries were executed to retrieve and analyse the stored information. These included retrieving the watch catalogue, identifying models without positive stock at the Abuja Central Warehouse, finding customised orders, and retrieving component and finished-watch inventory.

MongoDB's `find()` method, field projections, nested-field queries and operators such as `$nin`, `$gt` and `$exists` were used to perform these operations.

### 3.3 Aggregation Operations

An aggregation pipeline was used to calculate the number of order items associated with each watch model. The pipeline combined information from `WatchModels` and `CustomerOrders` using `$lookup`, `$unwind`, `$match`, `$count` and `$project`.

The results were:

| Watch Model | Total Order Items |
|---|---:|
| Chronograph Gold | 2 |
| Classic Black | 1 |
| Classic Silver | 2 |
| Heritage Leather | 0 |

The aggregation included watch models with no recorded orders by using `$ifNull` to assign a count of zero. This demonstrates how MongoDB can perform operations comparable to relational joins and grouped queries.

### 3.4 Indexing and Query Performance

Unique indexes were created on customer email addresses, watch model names and source order identifiers. These indexes help prevent duplicate values in the selected fields.

A compound index was also created on the `Inventory` collection using `location.locationName` and `stockItem.type`.

The `explain("executionStats")` method was used to compare an indexed inventory query with a forced collection scan.

| Measurement | Indexed Query | Collection Scan |
|---|---:|---:|
| Execution stage | IXSCAN | COLLSCAN |
| Documents returned | 2 | 2 |
| Index keys examined | 2 | 0 |
| Documents examined | 2 | 8 |
| Execution time | 183 ms | 0 ms |

Both queries returned the same two documents. However, the indexed query examined only two documents, whereas the collection scan examined all eight documents in the collection.

Although the indexed query recorded a higher execution time in this particular test, the dataset was very small and execution times can vary. Therefore, the main observation is that the compound index reduced the number of documents examined during query execution.

These experiments demonstrate how indexing can support data integrity and reduce the amount of data examined when retrieving records in MongoDB.



## 4. Evaluation of Other NoSQL Data Models

Although MongoDB was selected for the practical implementation, other NoSQL database models could also support specific requirements within the FAHAJ system.

### 4.1 Key-Value Data Model

A key-value database stores information as pairs consisting of a unique key and its associated value. It provides a simple structure for retrieving information when the key is known.

For FAHAJ, this model could be used to store temporary shopping cart information. A customer's identifier could be used as the key, while the associated shopping cart details would be stored as the value.

For example:

**Key:**
`cart:C001`

**Value:**
```json
{
  "customerId": "C001",
  "items": [
    {
      "model": "Classic Silver",
      "quantity": 2
    }
  ],
  "currency": "NGN"
}
```

In this example, retrieving the key `cart:C001` returns the shopping cart information associated with customer C001.

This approach supports fast key-based retrieval and is suitable for temporary or frequently accessed information. However, it is less suitable for complex queries involving multiple fields and relationships.

### 4.2 Column-Family Data Model

A column-family database organises data into rows, with related columns grouped into column families. It is designed to handle large volumes of distributed data and can support high-volume read and write operations.

FAHAJ could use this model to manage inventory records and stock movement across its warehouses and retail stores.

For example, an inventory record could use a combination of warehouse and watch model identifiers as its row key, while a column family named `Inventory` stores related information such as available quantity, reserved quantity and the date of the last stock update.

An example representation is shown below:

| Row Key | Inventory:quantityAvailable | Inventory:quantityReserved | Inventory:lastUpdated |
|---|---:|---:|---|
| Abuja:WS001 | 15 | 3 | 2026-11-10 |
| Lagos:WS001 | 25 | 5 | 2026-11-11 |
| Abuja:WS002 | 8 | 2 | 2026-11-12 |

This model could support large-scale inventory management and analysis across multiple locations. However, its structure and query patterns would require careful planning based on FAHAJ's data access requirements.

### 4.3 Graph Data Model

A graph database represents information using nodes, relationships and properties. Nodes represent entities, while relationships describe how those entities are connected.

FAHAJ could use this model to represent relationships between customers, orders, watch models, components and suppliers. For example, a customer could be connected to an order through a PLACES relationship, while an order could be connected to a watch model through a CONTAINS relationship. A watch model could also be connected to its components, which are linked to their suppliers.

An example graph query using Cypher is shown below:

```cypher
MATCH (c:Customer)-[:PLACES]->(o:Order)
      -[:CONTAINS]->(w:WatchModel)
RETURN c, o, w;
```

This query retrieves customers, their orders and the watch models associated with those orders.

A graph database could help FAHAJ analyse supplier relationships, component dependencies and customer purchasing patterns. However, it may be unnecessary for routine operations that can be handled effectively by the existing document-oriented database design.

### 4.4 Comparison of NoSQL Data Models

The four NoSQL data models offer different approaches to storing and managing data.

| Data Model | Potential FAHAJ Application | Main Advantage | Limitation |
|---|---|---|---|
| Key-Value | Customer sessions and shopping carts | Fast retrieval using unique keys | Limited support for complex queries |
| Column-Family | Inventory records and stock history across warehouses | Supports large-scale distributed data | Requires careful data and query design |
| Graph | Relationships between customers, orders, components and suppliers | Efficient analysis of connected data | May introduce unnecessary complexity for simple operations |
| Document | Customer records, orders, watch models and inventory | Flexible documents, embedded data and references | Complex relationships may require additional queries or lookups |

MongoDB's document-oriented model was selected for the practical implementation because it provides a suitable balance between flexible data structures, embedded information and references between collections. It supports the main operational requirements of FAHAJ without requiring multiple database technologies.

The other models could complement MongoDB if FAHAJ's requirements expand. However, adopting them would depend on actual workload demands, scalability requirements and the additional complexity and cost involved.


## 5. Conclusion and Reflection

### 5.1 Conclusion

This portfolio explored how NoSQL database technologies can support the data management requirements of FAHAJ. MongoDB was implemented using four main collections to manage customer information, watch models, customer orders and inventory.

The implementation demonstrated document storage, embedded documents, references, querying, aggregation and indexing. The query execution plans also showed how indexing reduced the number of documents examined during inventory retrieval.

The evaluation of key-value, column-family and graph database models highlighted alternative approaches that could support specific FAHAJ operations. Overall, MongoDB was considered suitable for the practical implementation because of its flexible document structure and ability to organise related information efficiently.

### 5.2 Individual Reflection

Working on this portfolio improved my understanding of how NoSQL databases differ from relational databases. I gained practical experience creating MongoDB collections, inserting documents, querying nested fields, performing aggregations and creating indexes.

One important lesson was that database design involves choosing how information should be embedded or referenced based on how it will be accessed. I also learned that indexes can improve query efficiency, although their benefits should be evaluated using appropriate performance measurements.

The exercise strengthened my understanding of NoSQL database design and how different data models can be selected according to an organisation's requirements.



## 6. References

Apache Software Foundation. (n.d.). *Introduction*. Apache Cassandra Documentation. https://cassandra.apache.org/doc/stable/cassandra/developing/data-modeling/intro.html

MongoDB, Inc. (n.d.-a). *Aggregation pipeline*. MongoDB Manual. https://www.mongodb.com/docs/manual/core/aggregation-pipeline/

MongoDB, Inc. (n.d.-b). *Document relationships*. MongoDB Manual. https://www.mongodb.com/docs/manual/applications/data-models-relationships/

MongoDB, Inc. (n.d.-c). *Embedded data in your MongoDB schema*. MongoDB Manual. https://www.mongodb.com/docs/manual/data-modeling/embedding/

MongoDB, Inc. (n.d.-d). *Explain results*. MongoDB Manual. https://www.mongodb.com/docs/manual/reference/explain-results/

MongoDB, Inc. (n.d.-e). *Indexes*. MongoDB Manual. https://www.mongodb.com/docs/manual/indexes/

Neo4j, Inc. (n.d.). *What is a graph database?* Neo4j Documentation. https://neo4j.com/docs/getting-started/graph-database/

Redis Ltd. (n.d.). *Data types*. Redis Documentation. https://redis.io/docs/latest/develop/data-types/


