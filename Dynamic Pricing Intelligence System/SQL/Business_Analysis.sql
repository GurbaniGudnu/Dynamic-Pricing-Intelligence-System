--===================================
--Product Analysis 
--===================================
--Show all products
select * from product; 
--Show only Electronics products.
select * from product where categoryID=1; 
--Find products with stock less than 30.
select * from product where stock<30; 
--Find the most expensive product.
select * from product where sellPrice=(select max(sellPrice) from product); 
--Find the cheapest product.
select * from product where sellPrice=(select min(sellPrice) from product); 
--Find products with selling price above 3000.
select * from product where sellPrice>3000; 
--Find products with highest stock.
select * from product where stock=(select max(stock) from product); 
--Find products sorted by selling price descending.
select * from product order by sellPrice desc; 
--Find top 3 expensive products.
select * from product order by sellPrice desc limit 3; 
--Find products where profit margin is high.
select prodName, price, sellPrice, (sellPrice - price) AS profit, ROUND(((sellPrice - price)::numeric / price) * 100, 2) AS profit_margin FROM product WHERE ((sellPrice - price)::numeric / price) * 100 > 50 ORDER BY profit_margin DESC;

--===================================
--Sales Analysis 
--===================================
--Show all sales records.
select * from sales; 
--Find total quantity sold.
select sum(quantitySold) as TotalQuantity from sales; 
--Count total sales transactions.
select count(salesID) as TotalSales from sales; 
--Find all sales from Mumbai.
select * from sales where region='Mumbai'; 
--Find sales made after May 2.
select * from sales where salesDate>'2026-05-02'; 
--Find total revenue generated.
select sum(p.sellPrice * s.quantitySold) as TotalRevenue from sales s join product p on s.prodID=p.prodID; 
--Find product-wise quantity sold.
select p.prodName, sum(s.quantitySold)as totalQuantitySold from sales s join product p on s.prodID=p.prodID; 
--Find region-wise sales count.
select region, count(salesID) as sales_count from sales group by region; 
--Find which product sold the most.
select p.prodName, sum(s.quantitySold) as TotalQuantitySold from sales s join product p on s.prodID=p.prodID group by p.prodName order by TotalQuantitySold desc limit 1; 
--Find total revenue per product.
select p.prodName, sum(p.sellPrice * s.quantitySold) as TotalRev from sales s join product p on s.prodID=p.prodID group by p.prodName; 
--Find highest sales day.
select salesDate, sum(quantitySold) as totalSales from sales group by salesDate order by totalSales desc limit 1; 
--Find products never sold multiple times.
select p.prodName, count(s.salesID) as salesCount from sales s join product p on s.prodID=p.prodID group by p.prodName having count(s.salesID)=1; 
--Find average quantity sold per transaction.
select avg(quantitySold) from sales; 
--Find regions with highest sales.
select region, sum(quantitySold) as High_Region from sales group by region order by High_Region desc limit 1; 
--Find top revenue-generating product.
select p.prodName, sum(p.sellPrice * s.quantitySold) as total_rev from sales s join product p on s.prodID=p.prodID group by p.prodName order by total_rev desc limit 1;

--===================================
--Category Analysis 
--===================================
--Count products in each category.
select c.categoryName, count(p.prodID) as totalProd from category c join product p on p.categoryID=c.categoryID group by c.categoryName; 
--Find average selling price per category.
select c.categoryName, avg(p.sellPrice) as avgPrice from category c join product p on p.categoryID=c.categoryID group by c.categoryName order by avgPrice desc limit 1; 
--Find highest-priced category.
select c.categoryName, max(sellPrice) as HighPrice from category c join product p on p.categoryID= c.categoryID group by c.categoryName order by HighPrice desc limit 1; 
--Find category generating highest revenue.
select c.categoryName, sum(p.sellPrice * s.quantitySold) as totalRev from category c join product p on c.categoryID=p.categoryID join sales s on p.prodID=s.prodID group by c.categoryName order by totalRev desc limit 1; 
--Find categories with low stock overall.
select c.categoryName, sum(p.stock) as totalStock from category c join product p on p.categoryID= c.categoryID group by c.categoryName order by totalStock asc limit 1; 
--Find category with most products.
select c.categoryName, count(p.prodID) as totalProd from category c join product p on p.categoryID=c.categoryID group by c.categoryName order by totalProd desc limit 1; 
--Find category-wise average profit.
select c.categoryName, avg(p.sellPrice-p.price) as avgProfit from category c join product p on p.categoryID=c.categoryID group by c.categoryName; 
--Find categories whose average price is above overall average.
select c.categoryName, avg(p.sellPrice) as avgPrice from category c join product p on p.categoryID=c.categoryID group by c.categoryName having avg(p.sellPrice)>(select avg(sellPrice) from product); 
--Find categories contributing most to total sales.
select c.categoryName, sum(p.sellPrice * s.quantitySold) as totalSales from category c join product p on p.categoryID=c.categoryID join sales s on p.prodID=s.prodID group by c.categoryName order by totalSales desc; 
--Rank categories based on revenue.
select c.categoryName, sum(p.sellPrice * s.quantitySold) as totalRev, rank() over(order by sum(p.sellPrice * s.quantitySold) desc) as rev_rank from category c join product p on p.categoryID=c.categoryID join sales s on p.prodID=s.prodID group by c.categoryName;

--===================================
--Competitor Analysis 
--===================================
--Show all competitor prices.
select c.compName, p.prodName, cp.compPricing from competitor c join compPrice cp on c.compID=cp.compID join product p on p.prodID=cp.prodID; 
--Find lowest competitor price.
select * from compPrice where compPricing=(select min(compPricing) from compPrice); 
--Find highest competitor price.
select * from compPrice where compPricing=(select max(compPricing) from compPrice); 
--Find products where competitors sell cheaper than your company.
select p.prodName, p.sellPrice, cp.compPricing from product p join compPrice cp on p.prodID=cp.prodID where cp.compPricing<p.sellPrice; 
--Find price difference between your price and competitor price.
select p.prodName, sum(p.sellPrice-cp.compPricing) as diffPrice from product p join compPrice cp on p.prodID=cp.prodID group by p.prodName; 
--Find competitors with cheapest average pricing.
select c.compID, c.compName, avg(cp.compPricing) as avgPrice from product p join compPrice cp on p.prodID=cp.prodID join competitor c on c.compID= cp.compID group by c.compID,c.compName order by avgPrice asc limit 1; 
--Find products overpriced compared to competitors.
select p.prodName, p.sellPrice, cp.compPricing from product p join compPrice cp on p.prodId=cp.prodID where p.sellPrice>cp.compPricing; 
--Find products competitively priced.
select p.prodName, p.sellPrice, cp.compPricing from product p join compPrice cp on p.prodId=cp.prodID where p.sellPrice=cp.compPricing; 
--Find which competitor undercuts prices most often.
select c.compName, count(*) as undercut_count from competitor c join compPrice cp on c.compID=cp.compID join product p on p.prodID=cp.prodID where cp.compPricing<p.sellPrice group by c.compName order by undercut_count desc limit 1; 
--Find products where your price is lower than competitors.
select p.prodName,p.sellPrice,cp.compPricing from product p join compPrice cp on p.prodID=cp.prodID where p.sellPrice<cp.compPricing;

--===================================
--Business Insights
--===================================
--Which category performs best?
select c.categoryName,sum(p.sellPrice*s.quantitySOld) as totalRev from category c join product p on c.categoryID=p.categoryID join sales s on p.prodID=s.prodID group by c.categoryName order by totalRev desc limit 1; 
--Which product should increase stock?
select p.prodName, p.stock,sum(s.quantitySold) as totalSold from product p join sales s on p.prodID=s.prodID group by p.prodName, p.stock order by totalSold desc, p.stock asc; 
--Which products may need discounting? 
select p.prodName, p.stock,sum(s.quantitySold) as totalSold from product p join sales s on p.prodID=s.prodID group by p.prodName, p.stock having sum(s.quantitySold)<3 order by p.stock desc; 
--Which competitor is strongest? 
select c.compName, count(*) as undercut_count from competitor c join compPrice cp on c.compID=cp.compID join product p on p.prodID=cp.prodID where cp.compPricing<p.sellPrice group by c.compName order by undercut_count desc limit 1; 
--Which products are overpriced? 
select p.prodName,p.sellPrice, cp.compPricing from product p join compPrice cp on p.prodID=cp.prodID where p.sellPrice>cp.compPricing; 
--Which region performs best? 
select region, sum(p.sellPrice*s.quantitySold) as totalRev from sales s join product p on s.prodID=p.prodID group by region order by totalRev desc limit 1; 
--Which products are risky for inventory?
select p.prodName,p.stock,sum(s.quantitySold) as totalSold from product p join sales s on p.prodID=s.prodID group by p.prodName,p.stock having p.stock<20 order by totalSold desc;

--===================================
--Updates
--===================================
SELECT cp.priceID, p.prodName, p.sellPrice AS our_price, cp.compPricing AS competitor_price FROM compPrice cp JOIN product p ON cp.prodID = p.prodID ORDER BY cp.priceID;
UPDATE compPrice SET compPricing = 1999 WHERE priceID = 2;
UPDATE compPrice SET compPricing = 899 WHERE priceID = 4;
UPDATE compPrice SET compPricing = 4700 WHERE priceID = 6;
UPDATE compPrice SET compPricing = 7200 WHERE priceID = 7;
SELECT p.prodName, p.sellPrice AS our_price, cp.compPricing AS competitor_price,
    CASE
        WHEN p.sellPrice > cp.compPricing THEN 'Overpriced'
        WHEN p.sellPrice = cp.compPricing THEN 'Competitive'
        ELSE 'Price Advantage'
    END AS pricing_status
FROM product p JOIN compPrice cp ON p.prodID = cp.prodID ORDER BY pricing_status;