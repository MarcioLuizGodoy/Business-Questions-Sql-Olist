        -- Operadores de comparação (Exercicio sobre a base de dados Olist (Kaggle) )
        
        
        
        
        
        -- As perguntas do CEO 
        


select
    count(distinct(customer_id)) as numero_clientes
from
    customer
where
    customer_state = 'SP';


-- Qual o número total de pedidos únicos feitos no dia 08 de Outubro de 2016?

select count(distinct(order_id))
from orders
where DATE (order_purchase_timestamp) = '2016-10-08'; --aplicando função date pra converter o valor e podere comparar.


-- Qual o número total de pedidos únicos feitos a partir do dia 08 de Outubro de 2016?

select count(distinct(order_id))
from orders
where date( order_purchase_timestamp) > '2016-10-08';

-- Qual o número total de pedidos únicos feitos com a data limite de envio, a partir do dia 08 de Outubro de 2016 incluso?

select count(distinct(order_id))
from order_items
where date( shipping_limit_date) > '2016-10-08';

-- Qual é o número total de pedidos únicos e o valor médio do frete para pedidos com valor abaixo de R$ 1.100?

select count(distinct(order_id)) as total_pedidos_unicos, avg(freight_value) as valor_medio_fre
from order_items
where price < 1100;


-- Qual é o número total de pedidos únicos, a data mínima e máxima de limite de envio, 
--e os valores máximo, mínimo e médio do frete para pedidos com valor abaixo de R$ 1.100,
--agrupados por cada vendedor?


select * from order_items; -- consulta exploratoria dos nomes das colunas


select 
seller_id as vendeor,
count(distinct(order_id)) as total_pedidos_unicos, 
min(shipping_limit_date) as data_minima, 
max(shipping_limit_date) as data_maxima, 

max(freight_value) as frete_maximo,
min(freight_value) as frete_minimo, 
avg(freight_value) as media_do_frete
from order_items
where price< 1100
group by seller_id;



                    -- Operadores Booleanos
                    


-- Qual o número de clientes únicos nos estado de Minas Gerais ou Rio de Janeiro?

select customer_state as estados, count(distinct(customer_id)) as clientes_unicos
from customer
where customer_state = 'MG' or customer_state = 'RJ'
group by customer_state;


-- Qual a quantidade de cidades únicas dos vendedores no estado de São Paulo ou Riode Janeiro com a latitude maior que -24.54 e longitude menor que -45.63?

select geolocation_state ,count(distinct(geolocation_city)) as ciade_unicas
from geolocation
where (geolocation_state = 'SP' or geolocation_state = 'RJ') and geolocation_lat > -24.54 and geolocation_lng < -45.63
group by geolocation_state;


--  Qual o número total de pedidos únicos, o número total de produtos e o preço médio
--dos pedidos com o preço de frete maior que R$ 20 e a data limite de envio entre os dias 1 e
--31 de Outubro de 2016? OBS: Use a função DATE() para converter a data no formato
--timestamp (data e hora) para data.

select count(distinct order_id), count(product_id), avg( price )
from order_items
where freight_value > 20 
and date(shipping_limit_date) >= '2016-10-01' 
and date(shipping_limit_date) <='2016-10-31';


--Mostre a quantidade total dos pedidos e o valor total do pagamento, para pagamentos 
--entre 1 e 5 prestações ou um valor de pagamento acima de R$ 5000. Agrupe por
--quantidade de prestações.

select payment_installments, count (order_id) , payment_value
from order_payments
where payment_installments >= 1 and payment_installments <= 5 or payment_value > 5000
group by payment_installments;


--Qual a quantidade de pedidos com o status em processamento ou cancelada
--acontecem com a data estimada de entrega maior que 01 de Janeiro de 2017 ou menor que
--23 de Novembro de 2016?

select order_status from orders;  -- consulta investigativa pra formular a de baixo.

select order_status, count(order_id) as pedidos
from orders
where (order_status ='processing' or order_status = 'canceled') 
and 
(order_estimated_delivery_date >'2017-01-01' or  order_estimated_delivery_date <'2016-11-23')
group by order_status;


-- Quantos produtos estão cadastrados nas categorias: perfumaria, brinquedos, esporte
--lazer, cama mesa e banho e móveis de escritório que possuem mais de 5 fotos, um peso
--maior que 5 g, um altura maior que 10 cm, uma largura maior que 20 cm?

select product_category_name, count (product_id)
from  products
where (
product_category_name = 'perfumaria'
or product_category_name = 'brinquedos' 
or product_category_name = 'esporte_lazer' 
or product_category_name = 'cama_mesa_banho' 
or product_category_name = 'moveis_escritorio') 
and ( product_photos_qty > 5 and product_weight_g > 5 and product_height_cm > 10 and product_width_cm > 20)
group by product_category_name;


                        



					-- Operadores de Lógica de Intervalos

--  Quantos clientes únicos tiveram seu pedidos com status de “processingˮ, “shippedˮ e
--“deliveredˮ, feitos entre os dias 01 e 31 de Outubro de 2016. Mostrar o resultado somente se
--o número total de clientes for acima de 5.

select order_status, count(distinct(customer_id))
from orders
where order_status in ('processing', 'shipped', 'delivered') and  order_purchase_timestamp between '2016-10-01 and' and '2016-10-31'
group by order_status
having count(distinct(customer_id))> 5;

-- Mostre a quantidade total dos pedidos e o valor total do pagamento, para pagamentos entre 1 e 5 prestações ou um valor de pagamento acima de R$ 5000.

select payment_installments, count(order_id) as total_pedidos , sum(payment_value) as total_pagamentos
from order_payments 
where (payment_installments between 1 and 5) or (payment_value > 5000)
group by payment_installments;



--Quantos produtos estão cadastrados nas categorias: perfumaria, brinquedos, esporte 
--lazer e cama mesa, que possuem entre 5 e 10 fotos, um peso que não está entre 1 e 5 g, um
--altura maior que 10 cm, uma largura maior que 20 cm. Mostra somente as linhas com mais
--de 10 produtos únicos.

select 
product_category_name, 
count(distinct product_id) as produtos_unicos
from products
where product_category_name in ('perfumaria','brinquedos','esporte_lazer','cama_mesa_banho') 
and product_photos_qty between 5 and 10
and product_weight_g not between 1 and 5
and  product_height_cm > 10
and product_width_cm > 20
group by product_category_name
having count( distinct product_id ) > 10;



-- Qual a quantidade de cidades únicas dos vendedores no estado de São Paulo ou Rio de Janeiro com a latitude maior que -24.54 e longitude menor que -45.63?

select geolocation_state, count( distinct geolocation_city) as cidades
from geolocation 
where geolocation_state in ('SP', 'RJ') 
and (geolocation_lat > -24.54 and geolocation_lng < -45.63)
group by geolocation_state;



--Quantos produtos estão cadastrados em qualquer categorias que comece com a letra
--“aˮ e termine com a letra “oˮ e que possuem mais de 5 fotos? Mostrar as linhas com mais
--de 10 produtos.

select product_category_name    , count(distinct product_id ) as produtos
from products 
where product_category_name like  'a%o' and product_photos_qty > 5
group by product_category_name 
having count(distinct product_id ) > 10;



--Qual o número de clientes únicos, agrupados por estado e por cidades que comecem
--com a letra “mˮ, tem a letra “oˮ e terminem com a letra “aˮ? Mostrar os resultados somente
--para o número de clientes únicos maior que 10.

select  customer_city, customer_state , count(distinct customer_id )
from customer
WHERE customer_city  like 'm%o%a'
group by customer_city, customer_state
having  count(distinct customer_id ) > 10



													
													
																--INNER JOIN 
			
			
			
--Gerar uma tabela de dados com 10 linhas, contendo o id do pedido, o id do cliente, o status do pedido, o id do produto e o preço do produto.

select o.order_id, o.customer_id, o.order_status, oi.product_id, oi.price
from orders o inner join order_items oi on (oi.order_id = o.order_id )
limit 500;


--Gerar uma tabela de dados com 20 linhas, contendo o id do pedido, o estado do cliente, a cidade do cliente, o status do pedido, o id do produto e o preço do produto,
--somente para clientes do estado de São Paulo

select o.order_id, c.customer_state, c.customer_city, o.order_status, oi.product_id, oi.price 
from orders  o inner join order_items oi on ( oi.order_id = o.order_id ) inner join customer c on (c.customer_id = o.customer_id)
where c.customer_state  = 'SP'
limit 20; 


--Gerar uma tabela de dados com 50 linhas, contendo o id do pedido, o estado e a cidade do cliente, o status do pedido, o nome da categoria do produto e o preço do
--produto, somente para pedidos com o status igual a cancelado.

select o.order_id , c.customer_state , c.customer_city , o.order_status , p.product_category_name ,oi.price 
from orders o inner join order_items oi  on (oi.order_id =o.order_id ) inner join customer c  on( c.customer_id  = o.customer_id) inner join products p  on (p.product_id = oi.product_id)
where o.order_status  = 'canceled'
limit 50;



--Gerar uma tabela de dados com 80 linhas, contendo o id do pedido, o estado e a cidade do cliente, o status do pedido, o nome da categoria do produto, o preço do produto,
--a cidade e o estado do vendedor e a data de aprovação do pedido, somente para os pedidos aprovadas a partir do dia 16 de Setembro de 2016.

select o.order_id, c.customer_state ,c.customer_city , o.order_status , p.product_category_name , oi.price , s.seller_state ,s.seller_city ,o.order_approved_at 
from orders o inner join order_items oi  on( oi.order_id = o.order_id ) inner join customer c on (c.customer_id = o.customer_id) inner join products p on (p.product_id = oi.product_id) 
inner join sellers s on (s.seller_id =oi.seller_id )
where date (o.order_approved_at ) > '2016-8-16'
limit 80; 


--Gerar uma tabela de dados com 10 linhas, contendo o id do pedido, o estado e a cidade do cliente, o status do pedido, o nome da categoria do produto, o preço do produto, a
--cidade e o estado do vendedor, a data de aprovação do pedido e o tipo de pagamento, somente para o tipo de pagamento igual a boleto.


