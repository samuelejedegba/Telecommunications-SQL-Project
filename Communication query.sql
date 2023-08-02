--Analysing The Data

 --First, we view the table to analyse each columns. The following Points will be analysed
--1.	How many customers joined the company during the last quarter? 
--2.	What is the customer profile for a customer that churned, joined, and stayed? Are they different?
--3.	What seem to be the key drivers of customer churn?
--4.	Is the company losing high-value customers? If so, how can they retain them?


select *
from Churn_table

select *
from zip_code

--1. How many Customers Joined the company in the last quarter?

--The last quarter is the last 3 months.

select COUNT (customer_ID)
from Churn_table
where Tenure_in_Months <= 3

--1051 Customers joined in the last 3 months, which is the last quarter of the year.

--2. What is the customer profile for a customer that churned, joined, and stayed? Are they different?
-- First we create three smaller tables to analyse these three customer status differently.

select *
into Stayed_table
from Churn_table
where Customer_Status = 'Stayed'

select *
into Churn_customers_table
from Churn_table
where Customer_Status = 'Churned'

select *
into Joined_table
from Churn_table
where Customer_Status = 'Joined'

--Now we view each table to see how different they are.

select *
from Stayed_table

select *
from Joined_table

Select *
from Churn_customers_table

--First we analyse the average age of each customer profile.

select AVG(Age)
from Stayed_table

select AVG(Age)
from Joined_table

select AVG(Age)
from Churn_customers_table

--Not much difference between the average age difference. Average Age for customers who stayed is 45 and for churned customers, 49.
No insight to be gotten from this.

--Next we examine Marriage status among these 3 smaller tables.

select count(customer_id)
from Churn_customers_table
where Married = 1

select count(customer_id)
from Churn_customers_table
where Married = 0

select count(customer_id)
from Stayed_table
where Married = 1

select count(customer_id)
from Stayed_table
where Married = 0

--Even though More single people tend to leave the service than married people (1200 single people left and 669 Married people left)
--The opposite is not the case for people that stayed with the service. The numbers are similar (2649 Married to 2071 Single).

--Next we look at Number of referrals.

Select count(customer_ID)
from Churn_customers_table
where Number_of_Referrals <> 0

Select count(customer_ID)
from Churn_customers_table
where Number_of_Referrals = 0

--The above result shows that 624 customers with at least one referral left the service while 1245 of customers with no referrals left the service.
--The huge discrepancy in numbers shows that people with who refer others to the service are more likely to stay than those who don't. 
--Recommendation: A plan to reward those who refer others to the service must be put in place as it does not just only bring others to the service,
--it also likely ensures customer loyalty.

--Internet Type
Select Internet_type, count (customer_ID)
from Churn_customers_table
group by Internet_type

Select Internet_type, count (customer_ID)
from Stayed_table
group by Internet_type

--People using Fiber Optic are the highest churned customers (1236).
--However, DSL users tend to be more loyal (1230 stayed while only 307 left).
--Recommendation: Fibre Optic are usually more reliable and faster than DSL.
--People that use Fiber Optic leaving might be a service delivery problem.
--The service of the fibre optic internet should be looked into and improved upon to reduce churn rate.

--Next we examine the contract from the sub-tables
Select Contract, count (customer_ID)
from Churn_customers_table
group by Contract

Select Contract, count (customer_ID)
from Stayed_table
group by Contract

Select Contract, count (customer_ID)
from Joined_table
group by Contract

--People with a month to month contract are obviously leaving the most (the number is 1655).
--People with one and two year contracts are staying with the service more.
--Recommendation: There should be a reward system for customers with more than a month contract.
--A discount for all services to ensure new users take up longer than a month contract.
--The 'Joined' table proves that new customers are not taking longer contracts.
--out of 454 customers that joined, only 24 took the one year contract and 22 the two year contract.
--A whooping 408 opted for the Month-to-Month contract.
--More has to be done to ensure people go for longer contracts in order to keep them.

--Next we examine the city.
Select City, count(city) as stayed_by_city
from Stayed_table
group by City
order by stayed_by_city desc
--Los Angeles has the highest number of customers that stayed with 197. San Diego is second with 93.

Select City, count(city) as Joined_by_city
from Joined_table
group by City
order by Joined_by_city desc
--Los Angeles also has the highest number of customers that Joined with 18. San Diego and San Francisco comes second with 7

Select City, count(city) as churned_by_city
from Churn_customers_table
group by City
order by churned_by_city desc
--San Diego has the highest Churn with 185 while Lost Angeles is second with 78. San Fansisco is third with 31 while San Jose is 29
--While San Diego and San Fracisco has the highest number of customers, they also have the highest churn rate (especially San Diego.)
--There is clearly a market for the service especially at Los Angeles and San Diego but the churn rate in those two states are way too high.

--Next we find the reasons for the high churn rate in these two cities.
--First San Diego
--Churn Category

select churn_category, count(customer_id) as churn_category_no
from Churn_customers_table
where City = 'San Diego'
group by churn_category
order by churn_category_no desc
--The biggest category for the churn rate in San Diego is 'Competitor' with 52.

--Next is churn reason
select churn_reason, count(customer_id) as churn_reason_no
from Churn_customers_table
where City = 'San Diego'
group by churn_reason
order by churn_reason_no desc
--The biggest reason for the churn rate is that 'competitor made a better offer' with 146.
--The second reason 'Don't know' is 15.

--Now for Los Angeles
--churn category
select churn_category, count(customer_id) as churn_category_no
from Churn_customers_table
where City = 'Los Angeles'
group by churn_category
order by churn_category_no desc
--Like San Diego, 'Competitor' is the biggest category but with 39, followed by price with '13.'

--Churn Reason
select churn_reason, count(customer_id) as churn_reason_no
from Churn_customers_table
where City = 'Los Angeles'
group by churn_reason
order by churn_reason_no desc
--'Competitor had better devices' is top with 15 while 'Competitor' offered higher download speed' is second with 9.

--Recommendations: Clearly Competition is the biggest reason for the churn rate in these two cities.
--This service has to offer better services than the competition.
--For San Diego, 'Competitor made better offer' is biggest reason people are leaving.
--The service needs to examine its competition and the offers they make and try to match or better them.

--Next we examine the gender of the churned customers.
select Gender, count(customer_ID) as gender_churned_customers
from Churn_customers_table
group by Gender
--There is no much difference between the gender of the churned customers and those who stayed.

--Next we examine offers.
--We look at the table with the churned customers.
select Offer, count(customer_id) as offer_number
from Churn_customers_table
group by offer
order by offer_number desc
-- customers with no offer are leaving the most. The number is 1051. Offer E is second with 426.

-- Examining customers that stayed.
select Offer, count(customer_id) as offer_number
from Stayed_table
group by offer
order by offer_number desc
--Customers with No offer are also staying the most. So having no offer might not be a significant determinant of Churn rate.
--However, Offer E and Offer A tell an interesting story.
--Offer A has the lowest churn number with 35 while they have the 3rd highest stay number with 485.
--Clearly those with this offer are loyal. Offer E however, has the lowest stay number with 204 and the 2nd highest churn number with 426.
--Offer E has more people leaving than staying. 
--Recommendations: Offer A should be offered more and promoted to new users.
--While Offer E should be taken off the market or modified to make it more attractive.


--Next, let us examine the churn reasons focusing on all the cities

--Focus on Churn Categories
select churn_category, count(churn_category) as churn_category_number
from Churn_customers_table
group by churn_category
order by churn_category_number desc
--There are five distinct info in the churn category number, the highest being 'Competitor' with 841, followed by 'Dissatisfaction' with 321.
--The third is 'Attitude' with 314.

--Drilling down to churn reason
select churn_reason, count(churn_reason) as churn_reason_number
from Churn_customers_table
group by churn_reason
order by churn_reason_number desc
--'Competitor had better devices' is the top reason with 313, followed by 'Competitor made better offer' with 311.
--The third is 'Attitude of support person with 220 people giving this reason for leaving.
--However, 'Don't Know' is 4th with 130.
--This is a very high number of customers that left and it is important to get more information on what might have caused them to leave the service. 
--Recommendation: Like stated before, service must be improved on.
--better devices and better offers must be made (especially Offer A as stated above and offer E to be improved upon or taken off the market).
--Also, as recommended before, better devices must be offered especially the fibre optic device that must be improved on to beat the competition.
--Worryingly, attitude of support person is high on the list with 220 people claiming to have left the service for that.
--This is especially high in San Diego and Los Angeles area.
--The company needs to invest in retraining its support staff as they are cursing people to leave the service.


--However, 'Don't Know' is 4th with 130 customers. This is very significant and must be further investigated.
--I ran a query on different categories on the customers that fell into the 'Don't Know' category in the churn table to find a pattern.

select *
from Churn_customers_table
where churn_reason like '%Know%'

--Gender
select Gender, count(gender)
from Churn_customers_table
where churn_reason like '%Know%'
group by Gender

--Location
select City, count(city) as No_city
from Churn_customers_table
where churn_reason like '%Know%'
group by city
order by No_city Desc

--Contract
select Contract, count(contract) as No_contract
from Churn_customers_table
where churn_reason like '%Know%'
group by contract
order by No_contract Desc
--There was no pattern in all the other categories until I got to the ‘Contract’ category and noticed a pattern.
--The people in the 'Don't Know' category are predominantly in the Month-to-Month category of the Contract.
--The 'Month-to-month' has 116 churned customers in the ‘Don’t Know’ category while One year contracts has only 13.
--Recommendation: The people who fall into the ‘Don’t Know’ category will most likely stay if they were convinced to take a longer contracts.
--As recommended before, a reward system for customers who take longer contracts should be set in place.

--Cost of Churn.
select sum(total_revenue)
from Churn_customers_table

select sum(total_revenue)
from Churn_table

--The total amount the customers that have left the service contributed to the company is 3,684,459.820.
select *
from churn_table

select AVG(monthly_charge)
from churn_table

--The average monthly charge of the customers that have left the service is 63.596.

select top 20 Monthly_Charge, customer_status
from churn_table
order by Monthly_charge Desc

-- For the top 20 customers with the highest monthly charge, only 3 left the services.

--Next we find how many churned customers spend above the average monthly charge of 64.

select count (*)
from Churn_customers_table

select count(customer_id)
from churn_table
where customer_status = 'Churned' and Monthly_charge >= 64

--Out of 1869 churned customers, 1343 spend the averege monthly charge or above. These are some high value customers.