
-- ============================================================
-- FAHAJ WATCH MANUFACTURING DATABASE
-- PORTFOLIO 3: TRANSACTIONS AND CONCURRENCY
-- ============================================================
-- Database: fahaj_portfolio
-- DBMS: PostgreSQL 16
--
-- This script is used to record the transaction and concurrency
-- exercises carried out with the information of FAHAJ.
--
-- These are demonstration commands that you can use.
-- Do not run the whole file.
-- The two sets of concurrency exercises need to be done in two separate sessions.
-- ============================================================


-- ============================================================
-- SECTION 1: COMMIT TRANSACTION
-- ============================================================
-- -- Results: The output should be:--
--  Output: Purpose should yield the following output:
--
-- Initially there were 15 objects in inventory 5.
-- The purchase bumped it up to 16.

BEGIN;

UPDATE public."INVENTORY"
SET
    "QuantityAvailable" = "QuantityAvailable" + 1,
    "LastUpdated" = CURRENT_DATE
WHERE "InventoryID" = 5
  AND "QuantityAvailable" = 15;

COMMIT;


-- Commit Changes and verify them

SELECT
    "InventoryID",
    "QuantityAvailable"
FROM public."INVENTORY"
WHERE "InventoryID" = 5;


-- ============================================================
-- SECTION 2: ROLLBACK TRANSACTION
-- ============================================================
-- Description: ROLLBACK will drop any uncommitted changes.
--
-- While inventoryID 6 was temporarily updated to 5.
-- A negative number was then added.
-- The CHECK constraint failed to accept the negative number.
-- It was rolled back and rolled back is.

BEGIN;

UPDATE public."INVENTORY"
SET "QuantityAvailable" = 5
WHERE "InventoryID" = 6;

-- This statement was intentionally failed and tried:
UPDATE public."INVENTORY"
SET "QuantityAvailable" = -10
WHERE "InventoryID" = 6;

-- Run after the failed statement:
ROLLBACK;


-- Verify that the temporary change was undone

SELECT
    "InventoryID",
    "ModelID",
    "QuantityAvailable"
FROM public."INVENTORY"
WHERE "InventoryID" IN (5, 6)
ORDER BY "InventoryID";


-- ============================================================
-- SECTION 3: TRANSACTION ISOLATION
-- ============================================================
-- Isolation level used: READ COMMITTED
--
-- SESSION 1:
-- Begin a transaction and change the value of InventoryID to 20.
--Don't say "yes" right away.

SHOW transaction_isolation;

BEGIN;

UPDATE public."INVENTORY"
SET "QuantityAvailable" = 20
WHERE "InventoryID" = 5;


--Read InventoryID 5 during Session 1, which is still uncommitted.
-- Session 2 has the same amount committed as before (25).

SELECT
    "InventoryID",
    "QuantityAvailable"
FROM public."INVENTORY"
WHERE "InventoryID" = 5;


-- SESSION 1:
-- This transaction was rolled back in the recreated exercise.
-- The row lock was released by the rollback.

ROLLBACK;


-- ============================================================
-- SECTION 4: CONCURRENCY AND ROW-LEVEL LOCKING
-- ============================================================
-- Purpose: Demonstrate how concurrent transactions interact
-- when they attempt to update the same inventory record.
--
-- SESSION 1:
-- Begin a transaction and update InventoryID 5.
-- Keep this transaction open.

BEGIN;

UPDATE public."INVENTORY"
SET "QuantityAvailable" = 20
WHERE "InventoryID" = 5;


-- SESSION 2:
-- During Session 1, try for another update.
-- This statement is waiting for the end of Session 1.

BEGIN;

UPDATE public."INVENTORY"
SET "QuantityAvailable" = 30
WHERE "InventoryID" = 5;


-- SESSION 1:
-- In the practical exercise, Session 1 was reverted.
--This released its row level lock.

ROLLBACK;


-- SESSION 2:
-- After Session 1 released the lock, the waiting update
-- completed successfully.

COMMIT;


-- Verify the final committed quantity

SELECT
    "InventoryID",
    "QuantityAvailable"
FROM public."INVENTORY"
WHERE "InventoryID" = 5;


