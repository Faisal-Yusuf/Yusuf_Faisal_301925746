
-- FAHAJ SAMPLE DATA
-- All records are fictional test data.

BEGIN;

-- 1. Supplier records

INSERT INTO public."SUPPLIER"
    ("SupplierName", "Email", "Phone", "Address")
VALUES
    ('Precision Watch Parts Ltd',
     'sales@precisionparts.test',
     '08030000001',
     '12 Industrial Road, Abuja'),

    ('TimeCraft Components',
     'orders@timecraft.test',
     '08030000002',
     '25 Manufacturing Avenue, Lagos');



-- 2. Location records

INSERT INTO public."LOCATION"
    ("LocationName", "LocationType", "Address", "City", "Country")
VALUES
    ('Abuja Central Warehouse',
     'Warehouse',
     '12 Industrial Road',
     'Abuja',
     'Nigeria'),

    ('Lagos Retail Store',
     'Retail Store',
     '25 Victoria Island',
     'Lagos',
     'Nigeria');
