# FAHAJ – Portfolio 5: Distributed and Cloud Databases

## 1. Introduction

This portfolio explores the application of distributed database concepts to FAHAJ, a proposed wristwatch manufacturing and distribution company. FAHAJ manufactures standard wristwatch models and produces customised watches based on customer specifications. Its operations involve managing customers, watch models, customer orders, inventory, warehouses and distribution activities.

As FAHAJ expands its online sales and physical store operations across different countries, its database infrastructure must support data availability, reliability, consistency and future growth.

MongoDB replica sets were used to demonstrate database replication through a three-member configuration. The implementation was carried out using the existing local MongoDB environment in the GitHub Codespace. Additional distributed database concepts, including sharding, availability, consistency and cloud deployment, are discussed in relation to FAHAJ's potential future requirements.



## 2. Distributed Database Implementation

### 2.1 Database Environment

MongoDB Community Server 8.0.38 was used for the practical implementation, with MongoDB Shell (mongosh) 2.14.2 for database administration and testing.

An existing local MongoDB database environment was configured as a replica set named `fahajRS`. The replica set contains three MongoDB members running on separate ports within the same GitHub Codespace environment:

| Member | Address | Role |
|---|---|---|
| Member 1 | 127.0.0.1:27017 | Primary |
| Member 2 | 127.0.0.1:27018 | Secondary |
| Member 3 | 127.0.0.1:27019 | Secondary |

The primary member accepts database writes, while the secondary members maintain replicated copies of the primary's data. The replica set was configured using `rs.initiate()` and its operational status was checked using `rs.status()`.

All three members reported a healthy status. The configuration and member roles were also inspected using `rs.conf()`.

**Implementation note:** Although the three members run as separate MongoDB processes with separate data directories, they share the same Codespace host. Therefore, this implementation demonstrates replica-set configuration and replication, but it does not provide protection against failure of the entire host or physical infrastructure.


### 2.2 Replication Testing

Replication was tested by inserting a sample document into a separate test database named `FAHAJ_P5_ReplicationDemo` through the primary member.

The document was inserted into the `replicationDemo` collection using `insertOne()` with the write concern set to `w: "majority"`. This requested acknowledgement from a majority of the replica-set members before confirming the write.

The insert operation returned `acknowledged: true`, confirming that the write was successful.

To verify replication, a separate MongoDB Shell connection was established directly to the secondary member at `127.0.0.1:27018`. The `replicationDemo` collection was queried, and the same document was successfully retrieved.

The returned document contained the same `_id`, test description and message as the document inserted through the primary. This confirmed that the data had been replicated to the secondary member.

A separate test database was used to avoid modifying the existing FAHAJ operational database during the experiment.



## 3. Availability and Consistency

### 3.1 Database Availability

Database availability is important to FAHAJ because customers and employees depend on timely access to product information, orders and inventory records.

MongoDB replica sets improve availability by maintaining multiple copies of data across replica-set members. If the primary member becomes unavailable, the remaining eligible members can hold an election to select a new primary, provided the replica set retains the required voting majority.

For example, if FAHAJ's primary database server experiences a failure, a secondary member may become the new primary. This can allow database write operations to resume without requiring the database to be rebuilt from the beginning.

The three-member replica set configured in this portfolio demonstrates the membership and election structure required for this approach. However, because all three members run within the same Codespace host, a failure of that host would affect all members. A production deployment should distribute replica-set members across separate servers or availability zones.

### 3.2 Data Consistency

Data consistency ensures that database operations maintain reliable and valid information across the system.

MongoDB replication is asynchronous. This means that secondary members may experience a short delay before receiving and applying changes made by the primary. Consequently, a read from a secondary may occasionally return slightly older data.

For FAHAJ, this is particularly important when processing customer orders and updating inventory. A customer order should not be treated as successfully completed if the corresponding stock update has not been reliably recorded. This helps reduce the risk of an order being confirmed without the corresponding database write receiving the required acknowledgement.

MongoDB also supports read concerns that allow applications to specify the level of data consistency required when reading records. FAHAJ can use appropriate read and write settings for important operations such as order processing, inventory updates and payment confirmation.



## 4. Sharding and Scalability

Sharding is a database scaling technique that distributes data across multiple servers, known as shards. Instead of storing all records on a single database server, the data is divided across multiple servers to support larger workloads and increased storage requirements.

For FAHAJ, sharding could become useful as the company expands its online sales, physical stores and warehouse operations across different countries. The growing number of customers, orders, inventory records and transactions could eventually exceed the capacity of a single database server.

A possible sharding strategy would involve distributing the `CustomerOrders` collection using a suitable shard key based on customer or regional information. This could help spread order data across multiple shards and support increased transaction volumes.

However, choosing a shard key requires careful consideration of how the application accesses its data. An unsuitable shard key could create uneven data distribution or reduce query efficiency.

Sharding was not implemented in this portfolio because the current FAHAJ demonstration contains a relatively small dataset. The three-member replica set was sufficient to demonstrate replication, while sharding would introduce additional infrastructure and administration requirements without a meaningful benefit at this scale.

Therefore, sharding is considered a future scalability option for FAHAJ rather than part of the current practical implementation.


## 5. Proposed Cloud Database Deployment

As FAHAJ expands its operations across different countries, deploying its database infrastructure in a cloud environment could provide better scalability, availability and operational flexibility.

A managed MongoDB cloud service, such as MongoDB Atlas, could be considered for the production environment. This would reduce the need for FAHAJ to manage the underlying database servers and provide access to managed database infrastructure.

A proposed cloud deployment would include:

- **Database layer:** A MongoDB replica set distributed across separate cloud availability zones to maintain multiple copies of the database.
- **Application layer:** FAHAJ's online ordering system and internal business applications would communicate with the database through a secure application connection.
- **Network security:** Database access would be restricted to authorised application servers and trusted network connections.
- **Data protection:** Automated backups and periodic restore testing would help protect customer, order and inventory records.
- **Monitoring:** Database performance, storage capacity, replication status and system health would be monitored to identify potential problems.

For sensitive operations such as order processing and inventory updates, the application would use appropriate read and write concerns to maintain the required data consistency.

Cloud deployment was considered as a proposed architecture rather than a completed implementation. The practical work in this portfolio was carried out using MongoDB Community Server in the existing GitHub Codespace environment.



## 6. Conclusion

This portfolio demonstrated how distributed database concepts can support FAHAJ's database requirements as the business grows. A three-member MongoDB replica set was configured successfully, with one primary and two secondary members. The replication test confirmed that a document written to the primary could also be retrieved from a secondary member.

The portfolio also examined the importance of database availability, consistency, sharding and cloud deployment. Although sharding and cloud deployment were not implemented, their potential benefits and requirements were considered in relation to FAHAJ's future operations.

The practical implementation provided an understanding of MongoDB replication and how distributed database architecture can improve data reliability and support business growth. However, a production environment would require replica-set members distributed across independent infrastructure to provide stronger fault tolerance.