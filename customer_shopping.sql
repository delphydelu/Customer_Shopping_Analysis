SELECT * FROM customer_shopping;

# what is the total revenue generated bu male and female customer
select gender, sum(purchase_amount) as revenue from customer_shopping group by gender;

#which customer used discount ut still spent more than the discount amount
select customer_id,purchase_amount from customer_shopping where discount_applied='Yes' and purchase_amount>=(select avg(purchase_amount) from customer_shopping)

#which are the top 5 products with highest review rating
select item_purchased, round(avg(review_rating),2) as "Average product Rating" from customer_shopping group by item_purchased
order by avg(review_rating)desc
limit 5;

#Compare average purachse amount btwn standard and expressing shipping
select shipping_type,
round(avg(purchase_amount),2) from customer_shopping where shipping_type in ('standard','Express')
group by shipping_type;

#Do subscribed customer spend more? compare avg spend with discount applied
select subscription_status,
count(customer_id) as total_customers,
round(avg(purchase_amount),2) as avg_spend,
round(sum(purchase_amount),2) as total_revenue
from customer_shopping
group by subscription_status
order by total_revenue, avg_spend desc;

#which 5 product has the highest percentage with discounts applied
SELECT item_purchased,
ROUND(
    SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) / COUNT(*) * 100,
    2
) AS discount_rate
FROM customer_shopping
GROUP BY item_purchased
ORDER BY discount_rate DESC
LIMIT 5;

#Segment customer into new, Returning and loyal based on their total number of previous purchases and show the count of each segment
with customer_type as (
select customer_id, previous_purchases,
case
    when previous_purchases = 1 then 'New'
	when previous_purchases between 2 and 10 then 'Returning'
    else 'Loyal'
    end as customer_segment
from customer_shopping
)
select customer_segment, count(*) as 'Number of Customers'
from customer_type
group by customer_segment

#what are the top 3 most purchased products within each category
with item_counts as(
select category, item_purchased,
count(customer_id) as total_orders,
row_number() over(partition by category order by count(customer_id)desc) as item_rank
from customer_shopping
group by category, item_purchased
)
select item_rank, category,item_purchased, total_orders from item_counts
where item_rank<=3;

#are customer who are repeat buyers(more than 5 previous purchases) also likely to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from customer_shopping
where previous_purchases>5
group by subscription_status;

#what is the revenue contribution of each age group
select age_group,
sum(purchase_amount) as total_revenue
from customer_shopping group by age_group
order by total_revenue desc;



