--Category Table
create table category( 
categoryID serial primary key not null, 
categoryname varchar(30) not null 
); 

--Product Table
create table product( 
prodID serial primary key not null, 
prodName varchar(30) not null, 
categoryID int, price int, 
sellPrice int, 
stock int check (stock>0), 
foreign key (categoryID) references category(categoryID) 
); 

--Sales Table
CREATE TABLE sales ( 
salesID INTEGER PRIMARY KEY, 
prodID INTEGER, 
quantitySold INTEGER, 
salesDate DATE, 
region VARCHAR(20), 
FOREIGN KEY (prodID) REFERENCES product(prodID), 
CONSTRAINT sales_quantitysold_check CHECK (quantitySold > 0) 
); 

--Competitor Table
CREATE TABLE competitor ( 
compID INTEGER PRIMARY KEY, 
compName VARCHAR(30) 
); 

--Competitor Pricing Table
CREATE TABLE compPrice ( 
priceID INTEGER PRIMARY KEY, 
compID INTEGER, 
prodID INTEGER, 
compPricing INTEGER, 
checkDate DATE, 
FOREIGN KEY (compID) REFERENCES competitor(compID), 
FOREIGN KEY (prodID) REFERENCES product(prodID) 
);