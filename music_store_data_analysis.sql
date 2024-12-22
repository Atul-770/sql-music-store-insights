-- Q1. Who is the senior most Employee based on job title?

Select *
From employee
Order by hire_date
limit 1

-- Q2. Which countries have the most invoices?

Select Count(*) as c, billing_country
From invoice
Group by billing_country
Order by c desc

-- Q3. What are top 3 values of total invoice

select total
from invoice
order by total desc
limit 3

-- Q4. Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals

Select Sum(total) as s,billing_city
From invoice
group by billing_city
order by s desc
limit 1

-- Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money.

select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as total
from customer
Join invoice on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
limit 1

--                                                       Moderate Questions
-- Q1: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A.

select distinct email, first_name, last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id = invoice_line.invoice_id
where track_id in (
	select track_id 
	from track 
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock'
)
order by email

-- Q2: Lets invite the artists who have written the most rock music in our dataset. 
-- Write a query that returns the Artist name and total track count of the top 10 rock bands.

select artist.name, count(artist.artist_id) as no_of_songs
from artist
join album on artist.artist_id = album.artist_id
join track on album.album_id = track.album_id
where track_id in (
	select track_id
	from track
	join genre on track.genre_id = genre.genre_id
	where genre.name like 'Rock'
)
group by artist.artist_id
order by no_of_songs desc
limit 10

-- Q3: Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first

Select track.name, milliseconds
From track
where milliseconds > (
	select avg(milliseconds) as ave
	from track
)
order by milliseconds desc

--                                                     Advance
-- Q1: Find how much amount spent by each customer on artists? Write a query to return customer name, artist name and total spent 

with best_selling_artist as(
	select artist.artist_id, artist.name, Sum(invoice_line.unit_price* invoice_line.quantity)
	from invoice_line
	join track on invoice_line.track_id = track.track_id
	join album on track.album_id = album.album_id
	join artist on album.artist_id = artist.artist_id
	group by 1
	order by 3 desc
	limit 1
)
Select c.first_name,c.last_name,bsa.name,Sum(il.unit_price* il.quantity) as amt
from customer c
join invoice i on c.customer_id = i.customer_id
join invoice_line il on i.invoice_id = il.invoice_id
join track t on il.track_id = t.track_id
join album alb on t.album_id = alb.album_id
join best_selling_artist bsa on alb.artist_id = bsa.artist_id
group by 1, 2, 3
order by amt desc


-- Q2. We want to find out the most popular music Genre for each country. We determine the most popular genre as the genre 
-- with the highest amount of purchases. Write a query that returns each country along with the top Genre. For countries where 
-- the maximum number of purchases is shared return all Genres.

with popular_genre as(
	select g.genre_id, g.name, sum(il.quantity) as total_record_sale, c.country,
	ROW_NUMBER() OVER(PARTITION BY c.country ORDER BY COUNT(il.quantity) DESC) AS RowNo
	from genre g
	join track t on t.genre_id = g.genre_id
	join invoice_line il on il.track_id = t.track_id
	join invoice i on il.invoice_id = i.invoice_id
	join customer c on i.customer_id = c.customer_id
	group by 1,2,4
	order by 4 asc, 3 desc
)
select pg.name, pg.total_record_sale,pg.country from popular_genre pg where rowno<=1

-- Q3. Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount.

with recursive 
	best_customer as (
		select i.customer_id, c.first_name,c.last_name,c.country, sum(il.unit_price * il.quantity) as total
		from invoice i
		join customer c on i.customer_id = c.customer_id
		join invoice_line il on il.invoice_id = i.invoice_id
		group by 1,2,3,4
		order by 4 asc, 5 desc	
	),
	for_each_country as (
		select country ,max(total) as maxi
		from best_customer
		group by 1
		order by 1
	)
select bc.* 
from best_customer bc
join for_each_country foc on foc.country = bc.country
where foc.maxi = bc.total

-- another method
with bcfec as(
	select i.customer_id, c.first_name,c.last_name,c.country, sum(il.unit_price * il.quantity) as total,
	row_number() over(partition by c.country order by sum(il.unit_price * il.quantity) desc) as rowNo
	from invoice i
	join customer c on i.customer_id = c.customer_id
	join invoice_line il on il.invoice_id = i.invoice_id
	group by 1,2,3,4
	order by 4 asc, 5 desc 
)
select b.first_name, b.last_name, b.country,b.total
from bcfec b
where rowNo <=1