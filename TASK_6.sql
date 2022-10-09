/*
Задание 6
Используя JOIN’s и ShopDB получить имена покупателей и имена сотрудников у которых TotalPrice товара больше 1000
*/
 drop database HW_03_T_02_BD;

CREATE DATABASE HW_03_T_02_BD;
 ------------------------------------------------------------------------- 
 CREATE TABLE HW_03_T_02_BD.Customer  -- Покупатель
(
    Customerid INT AUTO_INCREMENT NOT NULL,
	surnamesNC VARCHAR(30) NOT NULL,   			  -- Фамили
    nameNC VARCHAR(30) NOT NULL, 				  -- Имя
    patronymicNC VARCHAR(30) DEFAULT 'Unknown',   -- Отчество
	dateR date,                                   -- Дата регистрации	
    PRIMARY KEY (Customerid)
);
INSERT HW_03_T_02_BD.Customer( nameNC, patronymicNC, surnamesNC, dateR)
VALUES
('Василий', 'Петрович', 'Лященко', now()),
('Зигмунд', 'Федорович', 'Унакий', now()),
('Олег', 'Евстафьевич', 'Выжлецов', now());
 SELECT * FROM HW_03_T_02_BD.Customer;
  ------------------------------------------------------------------------- 
  CREATE TABLE HW_03_T_02_BD.delivery  -- доставка
(
    deliveryid INT AUTO_INCREMENT NOT NULL,
    IDCustomer_del int NOT NULL, 
	city VARCHAR(30) not null,    -- город
    street varchar(30), -- улица
    house int, -- дом	
    FOREIGN KEY(IDCustomer_del) references Customer(Customerid),
    PRIMARY KEY (deliveryid, IDCustomer_del)
);
INSERT HW_03_T_02_BD.delivery(IDCustomer_del, city, street, house)
VALUES
(1, 'Харьков', 'Лужная', 15),
(1, 'Днепр', 'Богдана Хмельницкого', 16),
(2, 'Киев', 'Дегтяревская', 5),
(3, 'Чернигов', 'Киевская', 5);
 SELECT * FROM HW_03_T_02_BD.delivery;
  -------------------------------------------------------------------------
  CREATE TABLE HW_03_T_02_BD.phone  -- номер моб
(
	phone VARCHAR(20) NOT NULL, -- телефон
    IDCustomerPhone int NOT NULL, 
    FOREIGN KEY(IDCustomerPhone) references Customer(Customerid),
    PRIMARY KEY (IDCustomerPhone, phone)
);
INSERT HW_03_T_02_BD.phone(IDCustomerPhone, phone)
VALUES
(1, '(092)0000001'),
-- (1, '(092)0000001'),
(1, '(095)0000001'),
(2, '(095)0000002'),
(3, '(095)0000003');

 SELECT * FROM HW_03_T_02_BD.phone; 
  ------------------------------------------------------------------------- 
 CREATE TABLE HW_03_T_02_BD.Employee  -- работник
(
    Employeeid INT AUTO_INCREMENT NOT NULL,
	surnamesN_E VARCHAR(30) NOT NULL,   			 -- Фамили
    nameN_E VARCHAR(30) NOT NULL, 				 -- Имя
    patronymicN_E VARCHAR(30) DEFAULT 'Unknown', 	 -- Отчество
    jobTitle VARCHAR(30) NOT NULL, 	             -- должность
	PRIMARY KEY (Employeeid)
);
INSERT HW_03_T_02_BD.Employee(surnamesN_E, nameN_E, patronymicN_E , jobTitle)
VALUES
('Белецкий', 'Иван', 'Иванович', 'Старший продавец'),
('Лялечкина', 'Светлана', 'Олеговна', 'Продавец');
 SELECT * FROM HW_03_T_02_BD.Employee; 
-------------------------------------------------------------------------
  CREATE TABLE HW_03_T_02_BD.store  -- склад магазина
(
    storeid INT AUTO_INCREMENT NOT NULL,
	art VARCHAR(30) NOT NULL,  -- артикул производителя может быть не уникальным 
    nameProduct VARCHAR(100) NOT NULL,  -- категория или названия  
    price double NOT NULL, -- цена реализации
    currency VARCHAR(10), -- валюта реализации
    totalStock int DEFAULT 0, -- количество на складе
	PRIMARY KEY (storeid)
);
INSERT HW_03_T_02_BD.store(art, nameProduct, price, currency, totalStock)
VALUES
('LV12', 'Обувь', 26, '$', 1001),
('GC11', 'Шапка', 32, '$', 1002),
('GC111', 'Футболка', 20, '$', 1003),
('LV231', 'Джинсы', 45, '$', 1004),
('DG30', 'Ремень', 30, '$', 1005);
 SELECT * FROM HW_03_T_02_BD.store; 
 ------------------------------------------------------------------------- 
 CREATE TABLE HW_03_T_02_BD.OrdersV2
(    
	OrderID int AUTO_INCREMENT NOT NULL,   -- уникальный номер заказа
    PRIMARY KEY (OrderID),       
    OrderDate date NOT NULL, -- дата заказа  
    
    IDEmployee int,  -- id работника	
	FOREIGN KEY(IDEmployee) REFERENCES HW_03_T_02_BD.Employee(Employeeid),    
    
 	IDCustomer int,
 	FOREIGN KEY(IDCustomer) REFERENCES HW_03_T_02_BD.Customer(Customerid),    
    
    IDdelivery int,
    FOREIGN KEY(IDdelivery, IDCustomer) REFERENCES HW_03_T_02_BD.delivery(deliveryID, IDCustomer_del), -- у клиента может быть несколько адрессов доставки    
    
    IDphone VARCHAR(20) NOT NULL  
);
INSERT HW_03_T_02_BD.OrdersV2(OrderDate, IDEmployee, IDCustomer, IDdelivery, IDphone)
VALUES
(now(), 1, 1, 1, '(092)0000001'),
(now(), 2, 2, 3, '(095)0000002'),
(now(), 2, 3, 4, '(095)0000003');
 SELECT * FROM HW_03_T_02_BD.OrdersV2; 
  -------------------------------------------------------------------------  
 CREATE TABLE HW_03_T_02_BD.OrderDetails 
(
    idTest int auto_increment not null,
	DetailsOrderID int NOT NULL, 		-- номер заказа или ID заказа
	LineItem int NOT NULL,  	-- уникальная позиции в заказе
	IDstore int NOT NULL,    	-- ID продукта
	totalQty int NOT NULL,  	-- количесвто однотипных товаров в заказе
    FOREIGN KEY(DetailsOrderID) REFERENCES HW_03_T_02_BD.OrdersV2(OrderID),
	FOREIGN KEY(IDstore) REFERENCES HW_03_T_02_BD.store(storeid),  
	PRIMARY KEY (idTest)
);
INSERT HW_03_T_02_BD.OrderDetails(DetailsOrderID, LineItem, IDstore, totalQty)
VALUES
		(1, 1, 1, 20), -- ('LV12', 'Обувь', 26, '$', 1001),
        (1, 2, 2, 18), -- ('GC11', 'Шапка', 32, '$', 1002),
        (2, 1, 2, 15),
        (2, 2, 3, 30), 
		(3, 1, 4, 5),
		(3, 2, 5, 5),
		(3, 3, 1, 5);
 SELECT * FROM HW_03_T_02_BD.OrderDetails; 

 CREATE TEMPORARY TABLE HW_03_T_02_BD.Table_Customer_Worker
 SELECT
  DetailsOrderID ,
  LineItem as поз_в_заказ,
 (SELECT IDEmployee  FROM HW_03_T_02_BD.ordersv2 WHERE  DetailsOrderID = OrderID ) AS Worker_ID,
 (SELECT CONCAT(surnamesN_E, ' ', nameN_E)  FROM HW_03_T_02_BD.employee WHERE  employee.Employeeid = Worker_ID ) AS Worker,
  
 (SELECT IDCustomer  FROM HW_03_T_02_BD.ordersv2 WHERE  DetailsOrderID = OrderID ) AS Customer_ID,
 (SELECT CONCAT(surnamesNC, ' ', nameNC)  FROM HW_03_T_02_BD.customer WHERE  Customerid = Customer_ID ) AS Customer,
  
 (SELECT price * totalQty from HW_03_T_02_BD.store WHERE store.storeid =  OrderDetails.IDstore ) AS TotalPrice
FROM HW_03_T_02_BD.OrderDetails;

select * from HW_03_T_02_BD.Table_Customer_Worker;

-- drop TABLE HW_03_T_02_BD.Table_Customer_Worker;

SELECT
 DetailsOrderID  as №_заказа,
 COUNT(DetailsOrderID) as Количество_позиц,
 sum(TotalPrice) as Сумма_заказа, 
 Worker as Работник, 
 Customer as Покупатель 

 FROM HW_03_T_02_BD.Table_Customer_Worker 
 group by Table_Customer_Worker.DetailsOrderID
 having Сумма_заказа  > 1000;

 
 