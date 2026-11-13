```sql
-- Portfolio 2
-- Query Processing and Optimisation

-- This file demonstrates how a B-tree index
-- improves the performance of a date-range query.
--
-- The benchmark uses a separate schema so that
-- the original FAHAJ Portfolio 1 tables remain unchanged.


-- =====================================================
-- STEP 1: CREATE BENCHMARK SCHEMA
-- =====================================================

CREATE SCHEMA p2_benchmark;


-- =====================================================
-- STEP 2: GENERATE 100,000 SYNTHETIC RECORDS
-- =====================================================

CREATE TABLE p2_benchmark.order_history AS
SELECT
    g AS history_id,
    c."CustomerID",
    TIMESTAMP '2020-01-01 00:00:00'
        + g * INTERVAL '1 hour' AS "OrderDate"
FROM generate_series(1, 100000) AS g
CROSS JOIN (
    SELECT "CustomerID"
    FROM public."CUSTOMER"
    ORDER BY "CustomerID"
    LIMIT 1
) AS c;


-- =====================================================
-- STEP 3: REFRESH STATISTICS AND CHECK RECORD COUNT
-- =====================================================

ANALYZE p2_benchmark.order_history;

SELECT COUNT(*) AS test_rows
FROM p2_benchmark.order_history;


-- =====================================================
-- STEP 4: DATE-RANGE QUERY
-- Expected result: 24
-- =====================================================

SELECT COUNT(*) AS orders_on_day
FROM p2_benchmark.order_history
WHERE "OrderDate" >= TIMESTAMP '2025-01-01 00:00:00'
  AND "OrderDate" < TIMESTAMP '2025-01-02 00:00:00';


-- =====================================================
-- STEP 5: EXECUTION PLAN BEFORE INDEXING
-- Warm-up: Run once.
-- Measurements: Run three additional times.
-- Record execution times and buffer hits.
-- =====================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) AS orders_on_day
FROM p2_benchmark.order_history
WHERE "OrderDate" >= TIMESTAMP '2025-01-01 00:00:00'
  AND "OrderDate" < TIMESTAMP '2025-01-02 00:00:00';


-- =====================================================
-- STEP 6: CREATE B-TREE INDEX
-- =====================================================

CREATE INDEX order_history_order_date_idx
ON p2_benchmark.order_history ("OrderDate");


-- =====================================================
-- STEP 7: EXECUTION PLAN AFTER INDEXING
-- Warm-up: Run once.
-- Measurements: Run three additional times.
-- Record execution times and buffer hits.
-- =====================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT COUNT(*) AS orders_on_day
FROM p2_benchmark.order_history
WHERE "OrderDate" >= TIMESTAMP '2025-01-01 00:00:00'
  AND "OrderDate" < TIMESTAMP '2025-01-02 00:00:00';


-- =====================================================
-- STEP 8: VERIFY QUERY RESULT AFTER INDEXING
-- Expected result: 24
-- =====================================================

SELECT COUNT(*) AS orders_on_day
FROM p2_benchmark.order_history
WHERE "OrderDate" >= TIMESTAMP '2025-01-01 00:00:00'
  AND "OrderDate" < TIMESTAMP '2025-01-02 00:00:00';
```