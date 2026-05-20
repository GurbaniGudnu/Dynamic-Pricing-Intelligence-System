--Data Insertion in Category Table
INSERT INTO category (categoryName) VALUES
('Electronics'),
('Fashion'),
('Sports'),
('Beauty'),
('Home Decor');

--Data Insertion in Product Table
INSERT INTO product (
	prodID,
    prodName,
    categoryID,
    price,
    sellPrice,
    stock
)
VALUES
(101, 'Wireless Earbuds', 1, 1200, 1999, 45),
(102, 'Gaming Keyboard', 1, 1800, 2999, 30),
(103, 'Smart Watch', 1, 2500, 4499, 25),
(104, 'Running Shoes', 3, 1500, 2799, 60),
(105, 'Yoga Mat', 3, 400, 899, 80),
(106, 'Leather Jacket', 2, 2200, 4999, 20),
(107, 'Face Serum', 4, 350, 999, 50),
(108, 'Table Lamp', 5, 700, 1599, 35),
(109, 'Office Chair', 5, 3500, 6999, 15),
(110, 'Hoodie', 2, 900, 1999, 40);

--Data Insertion in Sales Table
INSERT INTO sales (
    salesID,
    prodID,
    quantitySold,
    salesDate,
    region
)
VALUES
(1001, 101, 2, '2026-05-01', 'Mumbai'),
(1002, 103, 1, '2026-05-01', 'Pune'),
(1003, 104, 3, '2026-05-02', 'Delhi'),
(1004, 107, 5, '2026-05-02', 'Bangalore'),
(1005, 101, 1, '2026-05-03', 'Mumbai'),
(1006, 105, 4, '2026-05-03', 'Hyderabad'),
(1007, 110, 2, '2026-05-04', 'Pune'),
(1008, 108, 1, '2026-05-04', 'Chennai'),
(1009, 102, 2, '2026-05-05', 'Mumbai'),
(1010, 109, 1, '2026-05-05', 'Delhi'),
(1011, 101, 3, '2026-04-28', 'Mumbai'),
(1012, 104, 2, '2026-04-29', 'Delhi'),
(1013, 107, 4, '2026-06-01', 'Bangalore'),
(1014, 103, 1, '2026-06-02', 'Pune');

--Data Insertion in Competitor Table
INSERT INTO competitors (
    compet
    competitor_name
)
VALUES
(1, 'Amazon'),
(2, 'Flipkart'),
(3, 'Meesho'),
(4, 'Myntra');

--Data Insertion in Competitor Pricing Table
INSERT INTO compPrice (
    priceID,
    compID,
    prodID,
    compPricing,
    checkDate
)
VALUES
(1, 1, 101, 1899, '2026-05-01'),
(2, 2, 101, 1949, '2026-05-01'),
(3, 1, 104, 2699, '2026-05-02'),
(4, 3, 107, 899, '2026-05-02'),
(5, 4, 110, 1899, '2026-05-03'),
(6, 2, 103, 4299, '2026-05-03'),
(7, 1, 109, 6799, '2026-05-04');
