--Case 1 : Sipariş Analizi --------------------------------------------------------------------
--Question 1 : 
--Aylık olarak order dağılımını inceleyiniz. Tarih verisi için order_approved_at kullanılmalıdır

SELECT  
	TO_CHAR(o.order_approved_at,'YYYY-MM') AS order_date,
	COUNT(distinct order_id) AS order_count
FROM orders o
	WHERE o.order_approved_at IS NOT NULL
	GROUP BY 1
	ORDER BY 1 
	
--Question 2 : ----------------------------------------------------------------------------------
--Aylık olarak order status kırılımında order sayılarını inceleyiniz. Sorgu sonucunda çıkan outputu excel ile görselleştiriniz. Dramatik bir düşüşün ya da yükselişin olduğu aylar var mı? Veriyi inceleyerek yorumlayınız.

--Query 1
--Başarılı siparişler:
WITH status AS
(
SELECT
	TO_CHAR(o.order_approved_at,'YYYY-MM') AS order_date,
	o.order_status AS order_status,
	COUNT(DISTINCT order_id) AS order_count
FROM orders o
	WHERE o.order_approved_at IS NOT NULL 
	GROUP BY 1,2
	ORDER BY 1
)
SELECT order_date,order_status,order_count
FROM status
WHERE order_status  NOT IN (' unavailable','canceled')

--Başarısız siparişler.(unvaliable,canceled)
--Query 2

WITH status AS
(
SELECT
	TO_CHAR(o.order_approved_at,'YYYY-MM') AS order_date,
	o.order_status AS order_status,
	COUNT(DISTINCT order_id) AS order_count
FROM orders o
	WHERE o.order_approved_at IS NOT NULL 
	GROUP BY 1,2
	ORDER BY 1
)
SELECT order_date,order_status,order_count
FROM status
WHERE order_status  IN (' unavailable','canceled')


--Question 3 : ---------------------------------------------------------------------------
--Ürün kategorisi kırılımında sipariş sayılarını inceleyiniz. Özel günlerde öne çıkan kategoriler nelerdir? Örneğin yılbaşı, sevgililer günü…

--Query1

SELECT 
	t.category_name_english,
	COUNT(DISTINCT o.order_id ) AS order_count
FROM orders o
LEFT JOIN order_items oi on oi.order_id=o.order_id
LEFT JOIN products p on p.product_id=oi.product_id
LEFT JOIN translation t on t.category_name = p.product_category_name
WHERE p.product_category_name IS NOT NULL 
GROUP BY 1
ORDER  BY 2 DESC

--Query 2 sorgusu Yıl/Ay/Kategori kırılımında en yüksek sipariş sayılarını incelediğimizde en yüksek sipariş rakamlarının 2018/1 aya ait olduğu görülmüş en çok sipariş alan ilk 3 kategori ise sırası ile 
--bed_bath_table, health_beauty, sports_leisure olmuştur.
--Query2
SELECT
	EXTRACT(YEAR FROM o.order_approved_at) AS year,
	EXTRACT(month FROM o.order_approved_at) AS month,
	TO_CHAR(o.order_approved_at,'YYYY-MM') AS order_date,
	t.category_name_english,
	COUNT(DISTINCT o.order_id ) AS order_count
FROM orders o	
LEFT JOIN order_items oi on oi.order_id=o.order_id
LEFT JOIN products p on p.product_id=oi.product_id
LEFT JOIN translation t on t.category_name = p.product_category_name
WHERE p.product_category_name IS NOT NULL
GROUP BY 1,2,3,4
ORDER  BY 2,5 DESC
--Query 3 sorgusu ile Ana sorguda yaptığım değişiklik ile yılların aylarını yanyana getirerek toplam sipariş sayılarında bir anlam aradım.
 --Query3
 WITH month_count as(
SELECT
	DISTINCT(TO_CHAR(o.order_approved_at,'YYYY-MM')) AS order_date,
	EXTRACT(MONTH FROM o.order_approved_at) AS year_month,
	--p.product_category_name,
	t.category_name_english,
	COUNT(DISTINCT o.order_id ) AS count_order
FROM orders o
LEFT JOIN order_items oi on oi.order_id=o.order_id
LEFT JOIN products p on p.product_id=oi.product_id
LEFT JOIN translation t on t.category_name = p.product_category_name
WHERE p.product_category_name IS NOT NULL
GROUP BY 1,2,3
ORDER BY 2
)
SELECT order_date,year_month,SUM(count_order)
FROM month_count
WHERE year_month IS NOT NULL
GROUP BY 1,2
ORDER BY 2,3 DESC

--Query 4 yorum:  Önceki yıllara göre bir karşılaştırma yapılabilir mi onu araştırdım.Ana sorguda yaptığım 
--değişiklik ile veri setinde benzer aylardan kaç adet olduğunu inceleyen bir sorgu yazdım.
--Genelde yılın her ayından 2 adet ay olduğunu sadece 9. Aydan 3 adet veri ve 11. Aydan sadece 1 veri olduğunu gördüm.
--Bundan dolayı yılların aylarına göre eşit sayıda ay denk gelmediği için Yıllara/Aylara göre toplam sipariş sayılarında bir anlamlı veriye ulaşamadım.
 -- Query 4
WITH general_month_count AS
(	
WITH month_count AS
(
SELECT
	DISTINCT(TO_CHAR(o.order_approved_at,'YYYY-MM')) AS order_date,
	EXTRACT(MONTH FROM o.order_approved_at) AS year_month,
	t.category_name_english,
	COUNT(DISTINCT o.order_id ) AS count_order
FROM orders o
LEFT JOIN order_items oi on oi.order_id=o.order_id
LEFT JOIN products p on p.product_id=oi.product_id
LEFT JOIN translation t on t.category_name = p.product_category_name
WHERE p.product_category_name IS NOT NULL
GROUP BY 1,2,3
ORDER BY 2
)
SELECT order_date,year_month,SUM(count_order)
FROM month_count
WHERE year_month IS NOT NULL
GROUP BY 1,2
ORDER BY 2,3 desc
)
SELECT year_month,
COUNT(*)
FROM general_month_count
GROUP BY 1

--ÖZEL GÜNLER

-- Query karnaval
  
SELECT
	EXTRACT(YEAR FROM o.order_approved_at) AS year,
	EXTRACT(month FROM o.order_approved_at) AS month,
	TO_CHAR(o.order_approved_at,'YYYY-MM') AS order_date,
	t.category_name_english,
	COUNT(DISTINCT o.order_id ) AS order_count
FROM orders o
LEFT JOIN order_items oi on oi.order_id=o.order_id
LEFT JOIN products p on p.product_id=oi.product_id
LEFT JOIN translation t on t.category_name = p.product_category_name
WHERE p.product_category_name IS NOT NULL AND EXTRACT(month FROM o.order_approved_at)  in (2,3)
GROUP BY 1,2,3,4
ORDER BY 5 desc

--Query 2017 Sevgililer günü

SELECT 
	t.category_name_english,
	COUNT(DISTINCT o.order_id ) AS order_count
FROM orders o	
LEFT JOIN order_items oi on oi.order_id=o.order_id
LEFT JOIN products p on p.product_id=oi.product_id
LEFT JOIN translation t on t.category_name = p.product_category_name
WHERE p.product_category_name IS NOT NULL AND  order_purchase_timestamp::date  BETWEEN '2017-02-7' AND '2017-02-14'
GROUP BY 1
ORDER BY 2 DESC

---2018 yılbaşı kategorilerin incelenmesi -----
SELECT 
	t.category_name_english,
	COUNT(DISTINCT o.order_id ) AS order_count
FROM orders o
LEFT JOIN order_items oi on oi.order_id=o.order_id
LEFT JOIN products p on p.product_id=oi.product_id
LEFT JOIN translation t on t.category_name = p.product_category_name
WHERE p.product_category_name IS NOT NULL and  o.order_purchase_timestamp::date  BETWEEN '2017-12-25' AND '2018-01-01'
GROUP BY 1
ORDER BY 2 DESC

29.11.2017 --Black Friday------
-- Query black friday

SELECT  
DISTINCT(p.product_category_name),
t.category_name_english,
COUNT(DISTINCT oi.order_id) AS order_count
From products AS p
LEFT JOIN order_items AS oi ON p.product_id = oi.product_id
LEFT JOIN orders AS o ON oi.order_id = o.order_id
LEFT JOIN TRANSLATION T ON t.category_name = p.product_category_name
WHERE O.ORDER_PURCHASE_TIMESTAMP::date  between '2017-11-17' and '2017-11-24'
GROUP BY p.product_category_name,2
ORDER BY order_count DESC;

--Question 4 : -----------------------------------------------------------------------------------------------------------
--Haftanın günleri(pazartesi, perşembe, ….) ve ay günleri (ayın 1’i,2’si gibi) bazında order sayılarını inceleyiniz. Yazdığınız sorgunun outputu ile excel’de bir görsel oluşturup yorumlayınız.

--Query haftanın günleri

SELECT
	TO_CHAR(o.order_purchase_timestamp, 'DAY') AS day_name,
	COUNT(distinct order_id) AS order_count
FROM orders o
WHERE  order_status != 'canceled' or order_status != 'unavailable'
GROUP BY 1	
ORDER BY 2 DESC;

--Query Ay ‘ın günleri


SELECT
	EXTRACT(day FROM o.order_purchase_timestamp) AS month_day,
	COUNT(DISTINCT order_id) AS order_count
FROM orders o
	WHERE  order_status != 'canceled' or order_status != 'unavailable'
	GROUP BY 1
	ORDER BY 2 DESC

--Case 2 : Müşteri Analizi -----------------------------------------------------------------------------------------
--Question 1 : 
--Hangi şehirlerdeki müşteriler daha çok alışveriş yapıyor? Müşterinin şehrini en çok sipariş verdiği şehir olarak belirleyip analizi ona göre yapınız. 

--Örneğin; Sibel Çanakkale’den 3, Muğla’dan 8 ve İstanbul’dan 10 sipariş olmak üzere 3 farklı şehirden sipariş veriyor. 
--Sibel’in şehrini en çok sipariş verdiği şehir olan İstanbul olarak seçmelisiniz ve Sibel’in yaptığı siparişleri İstanbul’dan 21 sipariş vermiş şekilde görünmelidir.

 with main1 as
(
SELECT 
		c.customer_unique_id,
		customer_city,
		COUNT(DISTINCT order_id) as order_count
		FROM orders o
		LEFT JOIN customers c on c.customer_id=o.customer_id
	--where c.customer_unique_id= 'f34cd7fd85a1f8baff886edf09567be3'
	GROUP BY 1,2
),
main2 as
(
select
	 customer_unique_id,
	 customer_city,
	 order_count,
	 ROW_NUMBER() OVER (PARTITION BY customer_unique_id ORDER BY order_count DESC) AS rn
	 from main1
	 order by 1
),
main3 as
(
select 
	customer_unique_id,
	customer_city
from main2
where rn =1
),
main4 as
(
select 
	customer_unique_id,
	sum(order_count) total
from main2
group by 1
),
endmain as
(
select
	t3.customer_unique_id,
	customer_city,
	total
from main4 t4
join main3 t3 on t4.customer_unique_id=t3.customer_unique_id
)
select
	customer_city,
	sum(total)
from endmain
group by 1
order by 2 desc 

--Case 3: Satıcı Analizi   --------------------------------------------------------------------------------
--Question 1 : 
--Siparişleri en hızlı şekilde müşterilere ulaştıran satıcılar kimlerdir? Top 5 getiriniz. 
--Bu satıcıların order sayıları ile ürünlerindeki yorumlar ve puanlamaları inceleyiniz ve yorumlayınız.

--Query Satıcı ortalama sipariş

WITH avg_order AS
(
SELECT 
	s.seller_id,
	COUNT(DISTINCT o.order_id) order_count
FROM sellers s
LEFT JOIN order_items oi on oi.seller_id=s.seller_id
LEFT JOIN orders o on o.order_id=oi.order_id
GROUP BY 1
)
SELECT round(AVG(order_count),0)
FROM avg_order


--Query en hızlı satıcılar

WITH main as
(	
SELECT 
	s.seller_id,
	AVG(AGE(o.order_delivered_customer_date ,o.order_purchase_timestamp)) AS delivery_performance,
	COUNT(distinct o.order_id) as order_count,
	ROUND(avg(r.review_score),2) as review_avg,
	COUNT(r.review_comment_message) as comment_count
FROM sellers s
	LEFT JOIN order_items oi on oi.seller_id=s.seller_id
	LEFT JOIN orders o on o.order_id=oi.order_id
	LEFT JOIN reviews r on r.order_id=o.order_id
GROUP BY 1
 HAVING COUNT(DISTINCT  o.order_id)>32
ORDER BY 2,3 DESC
LIMIT 5
)
SELECT
	CONCAT('Seller_name',' ',LEFT(m.seller_id,2)),
	m.delivery_performance,
	m.order_count,
	m.review_avg,
	m.comment_count
FROM main m 

--Question 2 : -------------------------------------------------------------------------------------------------------
--Hangi satıcılar daha fazla kategoriye ait ürün satışı yapmaktadır? 
 --Fazla kategoriye sahip satıcıların order sayıları da fazla mı? 


--Query satıcı kategori
SELECT
	s.seller_id,
	COUNT(DISTINCT p.product_category_name) as category_count,
	COUNT(DISTINCT o.order_id) as order_count
FROM sellers s
	LEFT JOIN order_items oi on oi.seller_id=s.seller_id
	LEFT JOIN products p on p.product_id=oi.product_id
	LEFT JOIN orders o on o.order_id=oi.order_id
WHERE p.product_category_name is not null
GROUP BY 1
ORDER BY 2 desc,3 desc

--Case 4 : Payment Analizi -------------------------------------------------------------------------------------------------
--Question 1 : 
--Ödeme yaparken taksit sayısı fazla olan kullanıcılar en çok hangi bölgede yaşamaktadır? Bu çıktıyı yorumlayınız.

--Query taksit sayısı  fazla olan müşteriler
WITH Customer_Region  as
(
	SELECT 
		c.customer_city,
		c.customer_state,
		COUNT(DISTINCT customer_unique_id) AS customer_count
	FROM payments p
	INNER JOIN orders o on o.order_id=p.order_id
	INNER JOIN customers c on c.customer_id=o.customer_id 
	WHERE  payment_installments>=2  
	GROUP BY customer_city,customer_state
)
SELECT
	cr.customer_state,cr.customer_city,cr.customer_count
FROM Customer_Region cr
WHERE customer_count>1
ORDER BY 3 DESC

--Question 2 : -----------------------------------------------------------------------------------------------------------------
--Ödeme tipine göre başarılı order sayısı ve toplam başarılı ödeme tutarını hesaplayınız. En çok kullanılan ödeme tipinden en az olana göre sıralayınız.

--Query ödeme tipi başarılı order


SELECT
	p.payment_type ,
	COUNT(DISTINCT o.order_id) as order_count,
	ROUND(SUM(p.payment_value)::numeric,2) as total_value
FROM payments p
INNER JOIN orders o on o.order_id=p.order_id
WHERE o.order_status='delivered'
GROUP BY 1 
ORDER BY 2 desc 

--Question 3 : -------------------------------------------------------------------------------------------------
--Tek çekimde ve taksitle ödenen siparişlerin kategori bazlı analizini yapınız. 
--En çok hangi kategorilerde taksitle ödeme kullanılmaktadır?

--Query peşin ve tek çekim kredi kartı

SELECT
	p.product_category_name,
	t.category_name_english,
	COUNT(DISTINCT o.order_id)
FROM products p
INNER JOIN order_items oi on oi.product_id=p.product_id
INNER JOIN orders o on o.order_id=oi.order_id
INNER JOIN payments py on py.order_id=o.order_id
INNER JOIN translation t on t.category_name=p.product_category_name
WHERE py.payment_installments=1 
GROUP BY 1,2
ORDER BY 3 DESC

--Query çift taksitli siparişler

SELECT
	p.product_category_name,
	t.category_name_english,
	COUNT(DISTINCT o.order_id)
FROM products p
INNER JOIN order_items oi on oi.product_id=p.product_id
INNER JOIN orders o on o.order_id=oi.order_id
INNER JOIN payments py on py.order_id=o.order_id
INNER JOIN translation t on t.category_name=p.product_category_name
WHERE py.payment_installments>1 
GROUP BY 1,2	
ORDER BY 3 DESC 

--Case 5 : RFM Analizi -------------------------------------------------------------------------------------------------------
	
--Aşağıdaki e_commerce_data_.csv doyasındaki veri setini kullanarak RFM analizi yapınız. 
--Recency hesaplarken bugünün tarihi değil en son sipariş tarihini baz alınız. 

--Veri seti bu linkten alınmıştır, veriyi tanımak için linke girip inceleyebilirsiniz.

--Query 1.kod aşağıdadır.Rfm analizi bir sonraki kodda yapılacaktır

WITH recency AS
(
WITH max_b_d as
	(
	 	SELECT
		customer_id,
		max(invoicedate::date) max_invoicedate
		FROM rfm
		WHERE customer_id is not null AND invoiceno NOT LIKE 'C%'
		GROUP BY 1
		
	)
	SELECT
	customer_id,
	max_invoicedate,
	('2011-12-09'-max_invoicedate) as recency
	from max_b_d
),frequency as
(
SELECT
customer_id,
count(distinct invoiceno) as frequency
from rfm
group by 1
),monetary as
(
select
customer_id,
round(sum(quantity*unitprice::numeric),2) as monetary
from rfm
group by 1
)
select
	r.customer_id,
	r.recency,
	NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
	f.frequency,
	case when f.frequency >=1 and f.frequency<=4
	then f.frequency
	else 5 end as frequency_score, 
	m.monetary,
	NTILE(5) OVER (ORDER BY monetary ) as monetary_score
	
FROM recency as r
inner join frequency as f on r.customer_id=f.customer_id
inner join monetary as m on m.customer_id=r.customer_id
order by f.frequency desc


--Query 2 RFM Analizi 1-------------------
SELECT 
rfm_score,
count(customer_id) as customer_count
FROM 
(
SELECT 
    customer_id,
    recency_score::text || '-' || frequency_score::text || '-' || monetary_score::text as rfm_score
FROM 
(

WITH recency AS
(
	WITH max_b_d AS
	(
	 	SELECT
		customer_id,
		MAX(invoicedate::date) AS max_invoicedate
		FROM rfm
		WHERE customer_id IS NOT NULL AND invoiceno NOT LIKE 'C%'
		GROUP BY 1
	)
	SELECT
	customer_id,
	max_invoicedate,
	('2011-12-09'::date - max_invoicedate) AS recency
	FROM max_b_d
),
frequency AS
(
	SELECT
	customer_id,
	COUNT(DISTINCT invoiceno) AS frequency
	FROM rfm
	GROUP BY 1
),
monetary AS
(
	SELECT
	customer_id,
	ROUND(SUM(quantity*unitprice::numeric), 2) AS monetary
	FROM rfm
	GROUP BY 1
)
SELECT
	r.customer_id,
	r.recency,
	NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
	f.frequency,
	CASE WHEN f.frequency >= 1 AND f.frequency <= 4 THEN f.frequency ELSE 5 END AS frequency_score,
	m.monetary,
	NTILE(5) OVER (ORDER BY monetary) AS monetary_score
FROM recency AS r
INNER JOIN frequency AS f ON r.customer_id = f.customer_id
INNER JOIN monetary AS m ON m.customer_id = r.customer_id
ORDER BY f.frequency DESC
) as rfm	
) as rfm_score
WHERE customer_id is not null
GROUP BY 1
ORDER BY 2 DESC

---Query 3 RFM Analizi 2------

SELECT 
rfm_score,recency_score,frequency_score,monetary_score,
count(customer_id) as customer_count
FROM 
(
SELECT 
    customer_id,recency_score,frequency_score,monetary_score,
    recency_score::text || '-' || frequency_score::text || '-' || monetary_score::text as rfm_score
FROM 
(

WITH recency AS
(
	WITH max_b_d AS
	(
	 	SELECT
		customer_id,
		MAX(invoicedate::date) AS max_invoicedate 
		FROM rfm
		WHERE customer_id IS NOT NULL AND invoiceno NOT LIKE 'C%'
		GROUP BY 1
	)
	SELECT
	customer_id,
	max_invoicedate,
	('2011-12-09'::date - max_invoicedate) AS recency
	FROM max_b_d
),
frequency AS
(
	SELECT
	customer_id,
	COUNT(DISTINCT invoiceno) AS frequency
	FROM rfm
	GROUP BY 1
),
monetary AS
(
	SELECT
	customer_id,
	ROUND(SUM(quantity*unitprice::numeric), 2) AS monetary
	FROM rfm
	GROUP BY 1
)
SELECT
	r.customer_id,
	r.recency,
	NTILE(5) OVER (ORDER BY recency DESC) AS recency_score,
	f.frequency,
	CASE WHEN f.frequency >= 1 AND f.frequency <= 4 THEN f.frequency ELSE 5 END AS frequency_score,
	m.monetary,
	NTILE(5) OVER (ORDER BY monetary) AS monetary_score
FROM recency AS r
INNER JOIN frequency AS f ON r.customer_id = f.customer_id
INNER JOIN monetary AS m ON m.customer_id = r.customer_id
ORDER BY f.frequency DESC
) as rfm
) as rfm_score
WHERE customer_id is not null
GROUP BY 1,2,3,4
ORDER BY 2  ,3 desc,4 desc
























