--===================================
--Business Labels
--===================================
--Inventory Status
select prodName, stock, 
case 
when stock<20 then 'Low Stock' 
when stock between 20 and 50 then 'Medium Stock' 
else 'High Stock' 
end as InventoryStatus 
from product; 
--Pricing Status
select p.prodName,p.sellPrice, cp.compPricing, 
case 
when p.sellPrice>cp.compPricing then 'Overpriced' 
when p.sellPrice=cp.compPricing then 'Competitive' 
else 'Price Advantage' 
end as PricingStatus 
from product p join compPrice cp on p.prodID=cp.prodID; 
--Performance Status
select p.prodName, sum(p.sellPrice*s.quantitySold) as totalRev, 
case 
when sum(p.sellPrice*s.quantitySold)>6000 then 'Best Seller' 
when sum(p.sellPrice*s.quantitySold) between 4000 and 6000 then 'Average Seller' 
else 'Weak Seller' 
end as PerformanceStatus 
from product p join sales s on p.prodID=s.prodID group by p.prodName order by totalRev desc; 

--===================================
--Busines Analysis 
--===================================
--Which products may go out of stock?
select p.prodName, p.stock, sum(s.quantitySold) as totalSold from product p join sales s on p.prodID=s.prodID group by p.prodName,p.stock having p.stock<50 and sum(s.quantitySold)>=2 order by totalSold desc; 
--Which products are not selling?
select p.prodName, p.stock, coalesce(sum(s.quantitySold),0) as totalSold from product p left join sales s on p.prodID=s.prodID group by p.prodName, p.stock having p.stock>25 and coalesce(sum(s.quantitySold),0)<=2 order by p.stock desc; 
--Which products make most money?
select p.prodName, (p.sellPrice-p.price) as profitProd, sum((p.sellPrice-p.price)*s.quantitySold) as totalProfit from product p join sales s on p.prodID=s.prodID group by p.prodName,p.sellPrice,p.price order by totalProfit desc; 
--Which category performs badly?
select c.categoryName, sum(p.sellPrice*s.quantitySold) as revenue, sum(s.quantitySold) as totalSales from product p left join sales s on p.prodID=s.prodID join category c on c.categoryID=p.categoryID group by c.categoryName order by revenue asc; 
--Which city performs badly?
select s.region, sum(p.sellPrice*s.quantitySold) as revenue,sum(s.quantitySold)as totalSales from product p join sales s on p.prodID=s.prodID group by s.region order by revenue asc; 
--Which products may lose customers?
select p.prodName,p.sellPrice as ourPrice,cp.compPricing as competitorPrice, (p.sellPrice-cp.compPricing) as diffProd from product p join compPrice cp on cp.prodID=p.prodID where p.sellPrice>cp.compPricing order by diffProd desc; 

--===================================
--Winners & Losers 
--===================================
--Top Revenue Products
select p.prodName,sum(p.sellPrice*s.quantitySold)as totalRev from product p join sales s on p.prodID=s.prodID group by p.prodName order by totalRev desc limit 5; 
--Top Categories
select c.categoryName, sum(p.sellPrice*s.quantitySold) as totalRev from category c join product p on c.categoryID=p.categoryID join sales s on s.prodID=p.prodID group by c.categoryName order by totalRev desc; 
--Best Regions
select s.region,sum(p.sellPrice*s.quantitySold)as totalRev from product p join sales s on p.prodID=s.prodID group by s.region order by totalRev desc; 
--Highest Profit Margin Products
select prodName,price,sellPrice, round(((sellPrice-price)::numeric/price)*100,2) as profitMargin from product order by profitMargin desc; 
--Daily Sales Trend
select s.salesDate, sum(p.sellPrice*s.quantitySold)as totalRev,sum(s.quantitySold)as totalSales from product p join sales s on p.prodID=s.prodID group by s.salesDate order by s.salesDate asc; 

--===================================
--Dashboard Report
--===================================
--Product Report
select p.prodName, c.categoryName,sum(p.sellPrice*s.quantitySold)as revenue,sum(s.quantitySold)as totalSold,p.stock, 
case 
when sum(s.quantitySold)>=4 then 'Best Seller' 
when sum(s.quantitySold) between 2 and 3 then 'Average Seller' 
else 'Weak Seller' 
end as ProductPerformance 
from product p join category c on p.categoryID=c.categoryID join sales s on p.prodID=s.prodID group by p.prodName,c.categoryName,p.stock order by revenue desc; 

--Category Report
select c.categoryName, sum(p.sellPrice*s.quantitySold)as revenue, round(avg(p.sellPrice),2) as avgSellPrice, 
rank()over(order by sum(p.sellPrice*s.quantitySold) desc) as categoryRank from category c join product p on c.categoryID=p.categoryID join sales s on s.prodID=p.prodID group by c.categoryName order by revenue desc; 

--Pricing Report
select p.prodName,p.sellPrice as ourPrice, cp.compPricing as competitorPrice, 
case 
when p.sellPrice>cp.compPricing then 'Overpriced' 
when p.sellPrice=cp.compPricing then 'Competitive' 
else 'Price Advantage' 
end as PricePerformance 
from product p join compPrice cp on p.prodID=cp.prodID order by p.prodName; 

--Inventory Report
select p.prodName,p.stock,sum(s.quantitySold) as totalSold, 
case 
when p.stock<30 then 'Low Stock' 
when p.stock between 30 and 50 then 'Medium Stock' 
else 'High Stock' 
end as InventoryPerformance 
from product p join sales s on p.prodID=s.prodID group by p.prodName,p.stock order by totalSold desc;