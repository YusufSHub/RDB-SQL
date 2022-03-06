CREATE VIEW product
AS
SELECT	distinct D.customer_id, D.first_name, D.last_name
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = '2TB Red 5400 rpm SATA III 3.5 Internal NAS HDD';


SELECT * FROM [dbo].[product];


CREATE VIEW product1
AS
SELECT	distinct D.customer_id, A.product_name First_product
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Polk Audio - 50 W Woofer - Black';

SELECT * FROM [dbo].[FIRST_PRODUCT];

CREATE VIEW product2
AS
SELECT	distinct D.customer_id, A.product_name Second_product
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'SB-2000 12 500W Subwoofer (Piano Gloss Black)';

SELECT * FROM [dbo].[SECOND_PRODUCT];

CREATE VIEW product3
AS
SELECT	distinct D.customer_id, A.product_name Third_product
FROM	product.product A, sale.order_item B, sale.orders C, sale.customer D
WHERE	A.product_id = B.product_id
AND		B.order_id = C.order_id
AND		C.customer_id = D.customer_id
AND		A.product_name = 'Virtually Invisible 891 In-Wall Speakers (Pair)';

SELECT * FROM [dbo].[THIRD_PRODUCT];


CREATE VIEW final_product
AS
SELECT A.*, B.First_product, C.Second_product, D.Third_product
FROM [dbo].[product] A
LEFT JOIN [dbo].[product1] B
ON A.customer_id = B.customer_id
LEFT JOIN [dbo].[product2] C
ON A.customer_id = C.customer_id
LEFT JOIN [dbo].[product3] D
ON A.customer_id = D.customer_id

SELECT * FROM [dbo].[final_product];


SELECT 
    A.customer_id, 
    A.first_name, 
    A.last_name, 
    REPLACE(ISNULL(A.First_product, 'No'),'Polk Audio - 50 W Woofer - Black','Yes') First_product, 
    REPLACE(ISNULL(A.Second_product, 'No') , 'SB-2000 12 500W Subwoofer (Piano Gloss Black)','Yes')Second_product,
    REPLACE(ISNULL(A.Third_product, 'No'),'Virtually Invisible 891 In-Wall Speakers (Pair)', 'Yes') Third_product
FROM [dbo].[final_product] A
ORDER BY A.customer_id;
