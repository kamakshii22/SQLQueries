Use music_store;
-- easy 
Q1: who is the senior most employee based on the job title?;

select * from employee
order by levels desc
limit 1;

Q2: Which country have the most invoices?;

select billing_country, count(*) as invoices from invoice
group by billing_country
order by invoices desc
limit 1;

Q3: what are top 3 values of total invoices? ;

select * from invoice
order by total desc
limit 3;

Q4: Which city has the best customers? We would like to throw a promotional Music Festival in city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals.
return both the city name & sum of all the invoice totals.; 

select billing_city, sum(total) as sum_total from invoice
group by billing_city
order by sum_total desc
limit 1; 

Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer.
Write a query that returns the person who has spent ths most money.;
select * from customer;

select customer.customer_id, customer.first_name, customer.last_name, sum(invoice.total) as sum_total
from customer
join invoice on customer.customer_id= invoice.customer_id
group by customer.customer_id,customer.first_name, customer.last_name
order by sum_total desc
limit 1;

 -- Moderate: 
Q1: Write query to return the email, first name & last name Where Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A.;

select customer.email, customer.first_name, customer.last_name
from customer
join invoice on customer.customer_id = invoice.customer_id
join invoice_line on invoice.invoice_id= invoice_line.invoice_id
Where track_id in (
       select track.track_id from track 
	   join genre on track.genre_id= genre.genre_id
	   where genre.name = 'Rock'
       )
order by customer.email ;

Q2: Lets invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands.;

select artist.artist_id, artist.name, count(artist.artist_id) as no_of_songs
from track
join album2  on album2.album_id = track.album_id
join artist on  artist.artist_id = album2.artist_id
join genre on genre.genre_id = track.genre_id
Where genre.name = 'Rock' 
group by artist.artist_id, artist.name
order by no_of_songs desc
Limit 10;

Q3: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first.;

select name, milliseconds from track 
where milliseconds > (select avg(milliseconds) from track)
order by milliseconds desc;

 -- Advance: 
Q1: Find how much amount spent by each customer on artists?
Write a query to return customer name, artist name and total spent;

-- With best_selling_artist as ( 
-- 	select artist.artist_id, artist.name artist_name, sum(invoice_line.unit_price* invoice_line.quantity) as total_sales
-- 	from invoice_line
-- 	join track on track.track_id = invoice_line.track_id
-- 	join album2 on album2.album_id = track.album_id
-- 	join artist on artist.artist_id = album2.artist_id
-- 	group by artist.artist_id, artist.name
-- 	order by total_sales desc
--     limit 1
-- )
-- select c.customer_id, c.first_name, bsa.artist_name, sum(il.unit_price*il.quantity) as amount_spent
-- from invoice i 
-- join customer c on c.customer_id = i.customer_id
-- join invoice_line il on il.invoice_id = i.invoice_id
-- join track t on il.track_id = t.track_id
-- join album2 alb on alb.album_id = t.album_id
-- join best_selling_artist bsa on bsa.artist_id = alb.artist_id
-- group by c.customer_id, c.first_name, bsa.artist_name
-- order by amount_spent desc;
 
Q2: We want to find out the most popular music Genre for each country.
We determine the most popular genre as the genre with the highest amount of purchases.
Write a query that returns each country along with the top Genre.
For countries where the maximum number of purchases is shared return all Genres.;

-- WITH popular_genre AS 
-- (
--     SELECT COUNT(invoice_line.quantity) AS purchases, customer.country, genre.name, genre.genre_id, 
-- 	ROW_NUMBER() OVER(PARTITION BY customer.country ORDER BY COUNT(invoice_line.quantity) DESC) AS RowNo 
--     FROM invoice_line 
-- 	JOIN invoice ON invoice.invoice_id = invoice_line.invoice_id
-- 	JOIN customer ON customer.customer_id = invoice.customer_id
-- 	JOIN track ON track.track_id = invoice_line.track_id
-- 	JOIN genre ON genre.genre_id = track.genre_id
-- 	GROUP BY 2,3,4
-- 	ORDER BY 2 ASC, 1 DESC
-- )
-- SELECT * FROM popular_genre WHERE RowNo <= 1


Q3: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount.;

-- WITH Customter_with_country AS (
-- 		SELECT customer.customer_id,first_name,last_name,billing_country,SUM(total) AS total_spending,
-- 	    ROW_NUMBER() OVER(PARTITION BY billing_country ORDER BY SUM(total) DESC) AS RowNo 
-- 		FROM invoice
-- 		JOIN customer ON customer.customer_id = invoice.customer_id
-- 		GROUP BY 1,2,3,4
-- 		ORDER BY 4 ASC,5 DESC)
-- SELECT * FROM Customter_with_country WHERE RowNo <= 1