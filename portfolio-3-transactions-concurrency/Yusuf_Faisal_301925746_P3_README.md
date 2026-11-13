# Portfolio 3: Transactions and Concurrency

## 1. Introduction

This portfolio shows how to use database transactions, transaction isolation and concurrency control to manipulate the FAHAJ Watch Manufacturing database. All of the exercises are performed with PostgreSQL 16.

The goal was to learn how transactions ensure the consistency of data, how changes can be applied or discarded, and how PostgreSQL results when multiple users access and modify the same record.

## 2. Transaction Management

Two transaction operations were demonstrated:

**COMMIT**: A transaction added a watch to the inventory table. Successfully applied and saved changes.
A temporary inventory update was carried out (ROLLBACK). A database CHECK constraint was violated when attempting to insert a negative quantity. The temporary change was reversed, as though it had not occurred.

These exercises illustrated the process by which transactions ensure accuracy and consistency of data.


## 3. Transaction Isolation

Two different PostgreSQL sessions were used to test the READ COMMITTED isolation level.

In Session 1, a transaction was initiated that affected an inventory quantity, but did not commit it at the time of the transaction. During that same transaction, Session 2 asked for the same inventory record.

The return value in session 2 was the committed value, not the uncommitted one. This showed how READ COMMITTED blocks out other transactions from reading uncommitted changes.

## 4. Concurrency Control

Two PostgreSQL sessions were used to execute a concurrent update exercise.

Session 1: Updated an inventory record and left the transaction open. In Session 2 they tried to update the same record, but were unable to do so due to the row-level lock they encountered in Session 1.

Session 1 has been rolled back, unlocking the session. The waiting update for Session 2 was then successfully completed and committed.

The actual inventory was confirmed at the end as 30.

This illustrated how PostgreSQL manages concurrency and keeps data consistent, at a row level.

## 5. Tools and Technologies

- PostgreSQL 16
- SQL
- PostgreSQL command-line interface (psql)
- Visual Studio Code Codespaces

## 6. Files and Evidence

The portfolio folder contains:

- `Yusuf_Faisal_301025746_Transactions.sql` – SQL commands used for the transaction and concurrency exercises.
- `CommitRollback` – Evidence of COMMIT and ROLLBACK operations.
- `Session1Concurrency` – Evidence of a completed transaction in Session 1.
- `IsolationEvidence` – Evidence of READ COMMITTED isolation across two sessions.
- `ConcurrencyCompletion` – Evidence of the concurrent update, transaction completion and final inventory quantity.

## 7. Conclusion

The exercises helped to reinforce the concept of transaction management and concurrency control in a relational database. The use of COMMIT and ROLLBACK ensured that the data could be changed reliably, and the use of READ COMMITTED isolation and row-level locking ensured that uncommitted data were not read and that simultaneous updates to the inventory record were not coordinated.