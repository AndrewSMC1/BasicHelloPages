-- drop tables in case any are still in the database
DROP TABLE IF EXISTS line;
DROP TABLE IF EXISTS invoice;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS product;
DROP TABLE IF EXISTS rep;

-- create the rep, customer, product, invoice, and line tables
CREATE TABLE rep
(rep_id		CHAR(3) PRIMARY KEY,
 rep_lname	VARCHAR(20),
 rep_fname	VARCHAR(15),
 rep_street	VARCHAR(20),
 rep_city	VARCHAR(15),
 rep_State	CHAR(2),
 rep_zip	CHAR(5),
 rep_comm	DECIMAL(7,2),
 rep_rate	DECIMAL(3,2) );

--insert data into the rep table
INSERT INTO rep 
VALUES ( 223, 'Roma', 'Theresa', '735 First', 'Leonard', 'GA', '23342', 21756.50, 0.06 );
INSERT INTO rep 
VALUES ( 237, 'Miller', 'Fred', '643 High', 'Sheldon', 'GA', '23553', 38612.00, 0.08 );
INSERT INTO rep 
VALUES ( 268, 'Rodriguez', 'Miguel', '2737 Tyler', 'Springfield', 'GA', '23342', 19774.00, 0.06 );

CREATE TABLE customer
(cust_id		CHAR(4) PRIMARY KEY,
 cust_name		VARCHAR(30),
 cust_street	VARCHAR(20),
 cust_city		VARCHAR(20),
 cust_state		CHAR(2),
 cust_zip		CHAR(5),
 cust_balance	DECIMAL(8,2),
 cust_limit		DECIMAL(8,2),
 rep_id			CHAR(3) REFERENCES rep(rep_id) );

--insert data into the customer table
INSERT INTO customer 
VALUES ( 1159, 'Charles Appliance and Sport', '3948 Brown', 'Leonard', 'GA', '23342', 5560.00, 7500.00, 223 );
INSERT INTO customer 
VALUES ( 1193, 'Streaming Direct', '4938 Maple', 'Grove', 'GA', '23321', 210.40, 10000.00, 237 );
INSERT INTO customer 
VALUES ( 1367, 'Hollister''s', '493 Oakwood', 'Farmerville', 'GA', '23146', 6896.00, 7500.00, 268 );
INSERT INTO customer 
VALUES ( 1419, 'Everything Sports Shop', '2939 Cardinal', 'Crystal', 'GA', '23503', 5396.36, 5000.00, 237 );
INSERT INTO customer 
VALUES ( 1462, 'Bargain House', '4930 Main', 'Grove', 'GA', '23321', 4523.00, 10000.00, 268 );
INSERT INTO customer 
VALUES ( 1524, 'Jackson''s', '946 Second', 'Leonard', 'GA', '23342', 13817.00, 15000.00, 223 );
INSERT INTO customer 
VALUES ( 1619, 'Murray''s Department Store', '483 Cambridge', 'Sheldon', 'GA', '23553', 2217.00, 10000.00, 268 );
INSERT INTO customer 
VALUES ( 1687, 'Lawrence Sport and Appliance', '393 Jefferson', 'Lafayette', 'GA', '22543', 3962.00, 5000.00, 237 );
INSERT INTO customer 
VALUES ( 1725, 'Dustin''s All Seasons', '171 Washington', 'Sheldon', 'GA', '23553', 359.00, 7500.00, 237 );
INSERT INTO customer 
VALUES ( 1842, 'Four Seasons Store', '19 Front', 'Grove', 'GA', '23321', 8113.00, 7500.00, 223 );
INSERT INTO customer 
VALUES ( 1873, 'Suburban Appliance', '128 High', 'Springfield', 'GA', '23358', 1257.50, 5000.00, 268 );

CREATE TABLE product
(prod_id	CHAR(5)	primary key,
 prod_desc	VARCHAR(20),
 prod_quantity	SMALLINT,
 prod_type	CHAR(2),
 prod_warehouse	CHAR(1),
 prod_price	DECIMAL(7,2) );

--insert data into the product table
INSERT INTO product
VALUES ( 'BT105', 'Blender', 52, 'HW', 'A', 24.95 );
INSERT INTO product
VALUES ( 'BZ117', 'Exercise Bicycle', 47, 'SG', 'C', 283.95 );
INSERT INTO product
VALUES ( 'CE163', 'Convection Oven', 28, 'AP', 'B', 186.00 );
INSERT INTO product
VALUES ( 'DM182', 'Electric Screwdriver', 23, 'HW', 'A', 49.95 );
INSERT INTO product
VALUES ( 'DS104', 'Electric Range', 6, 'AP', 'C', 395.00 );
INSERT INTO product
VALUES ( 'DW111', 'Clothes Washer', 14, 'AP', 'A', 399.99 );
INSERT INTO product
VALUES ( 'FP132', 'Plasma Television', 15, 'HW', 'A', 999.95 );
INSERT INTO product
VALUES ( 'KM173', 'Clothes Dryer', 16, 'AP', 'B', 349.95 );
INSERT INTO product
VALUES ( 'KW114', 'Dishwasher', 7, 'AP', 'C', 435.00 );
INSERT INTO product
VALUES ( 'KG130', 'Home Workout Center', 5, 'SG', 'C', 1390.00 );
INSERT INTO product
VALUES ( 'RD147', 'HD Radio', 7, 'HW', 'B', 280.00 );

CREATE TABLE invoice
(invoice_num	INT PRIMARY KEY,
 invoice_date	DATE,
 cust_id	CHAR(4) REFERENCES customer(cust_id) );

--insert data into the invoice table
INSERT INTO invoice
VALUES ( 42419, '10-SEP-07', '1159' );
INSERT INTO invoice
VALUES ( 42420, '10-SEP-07', '1367' );
INSERT INTO invoice
VALUES ( 42433, '12-SEP-07', '1419' );
INSERT INTO invoice
VALUES ( 42434, '12-SEP-07', '1193' );
INSERT INTO invoice
VALUES ( 42447, '13-SEP-07', '1619' );
INSERT INTO invoice
VALUES ( 42449, '13-SEP-07', '1159' );
INSERT INTO invoice
VALUES ( 42453, '13-SEP-07', '1619' );

CREATE TABLE line
(invoice_num		INT REFERENCES invoice(invoice_num),
 prod_id			CHAR(5)	REFERENCES product(prod_id),
 line_num_ordered	INT,
 line_price			DECIMAL(7,2),
 PRIMARY KEY (invoice_num,prod_id) );

--insert data into the line table
INSERT INTO line
VALUES ( 42419, 'BT105', 9, 26.35 );
INSERT INTO line
VALUES ( 42420, 'DS104', 2, 379.95 );
INSERT INTO line
VALUES ( 42420, 'DW111', 1, 399.99 );
INSERT INTO line
VALUES ( 42433, 'KM173', 3, 379.95 );
INSERT INTO line
VALUES ( 42434, 'KW114', 2, 595.00 );
INSERT INTO line
VALUES ( 42447, 'BZ117', 2, 794.95 );
INSERT INTO line
VALUES ( 42447, 'CE163', 3, 199.95 );
INSERT INTO line
VALUES ( 42449, 'DS104', 1, 495.00 );
INSERT INTO line
VALUES ( 42453, 'KG130', 3, 1290.00 );


--COMMIT;

--display table contents
SELECT * FROM rep;
SELECT * FROM customer;
SELECT * FROM product;
SELECT * FROM invoice;
SELECT * FROM line;