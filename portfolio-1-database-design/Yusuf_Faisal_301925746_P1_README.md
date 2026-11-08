# Portfolio 1: Database Design and Modelling

## Case study

## Organizations Name or Scenario
Fahaj / Wrist watch manufacturing and distributions company

## Nature of the business
FAHAJ produces a standard range of watches and accepts Custom watch designs based on customers specification. Customers can place an Online order or visit any of Fahajs' physical stores across several countries. Fahaj also ship orders worldwide from warehouses.

## Users of the Database
Customers, store staff, Management, warehouse staff, production staff, procurement staff, sales staff.

## Major Data to be stored
Suppliers, components, warehouses and stores, inventory, customers, customer orders, watch models, customization specifications, production records, payment, shipment.

## Key Operations the database will support
Create an Account, Place an Order online, Place store order, record payment, Receive components, update stock, Create shipment, update delivery status, Run reports.

Business Rules
1. Customers ID is always Unique for easy identification.
2. An order should never exist without a customer making them.
3. A shipment cannot exist without an Order.
4. A shipment status changes are recorded with a time, from dispatch to delivery or collection.
5. Every shipment must come from a warehouse
6. Each shipment is either home delivery or store delivery.