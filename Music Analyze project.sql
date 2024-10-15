------Who is the senior most employee based on job title?

select * from employee
order by title desc 

-----Which countries have the most Invoices?

select count(*) as c ,billing_country  --- count entiry invoices tabel 
from invoice
group by billing_country
order by c desc

---- What are top 3 values of total invoice?
select * from invoice

select total from invoice
order by total desc
limit 3

/*Which city has the best customers? We would like to throw a promotional Music
Festival in the city we made the most money. Write a query that returns one city that
has the highest sum of invoice totals. Return both the city name & sum of all invoice
totals*/

select * from invoice

select sum(total) as s ,billing_city
from invoice
group by billing_city
order by s  desc

/*Who is the best customer? The customer who has spent the most money will be
declared the best customer. Write a query that returns the person who has spent the
most money*/

select * from customer

select customer.customer_id,customer.first_name,customer.last_name,sum(invoice.total) as total 
from customer 
join invoice 
on customer.customer_id = invoice.customer_id
group by customer.customer_id
order by total desc
LIMIT 1

/*Write query to return the email, first name, last name, & Genre of all Rock Music
listeners. Return your list ordered alphabetically by email starting with A*/

--SELECT * from customer
select DISTINCT first_name,last_name,email
from customer 
JOIN invoice
on customer.customer_id = invoice .customer_id
JOIN invoice_line
on invoice.Invoice_Id = invoice_line.Invoice_Id
WHERE Track_Id IN(
        SELECT Track_Id from Track
		JOIN Genre
		ON Track.Genre_Id = genre.Genre_Id
		WHERE Genre.name LIKE 'Rock'

       )

	   ORDER BY email ;

/*Let's invite the artists who have written the most rock music in our dataset. Write a
query that returns the Artist name and total track count of the top 10 rock bands*/

SELECT * FROM artist
SELECT artist.artist_id,artist.name ,count(artist.artist_id) as total_song
FROM Track
JOIN Album
ON Album.Album_Id = Track.Album_Id
JOIN Artist 
ON Artist.Artist_Id = Album.Artist_Id
JOIN Genre
ON Genre.genre_id = Track.genre_id
WHERE Genre.name LIKE 'Rock'
GROUP BY Artist.Artist_id
ORDER BY total_song Desc
limit 10;

/*Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the
longest songs listed first*/

SELECT Name, Milliseconds 
FROM Track
WHERE Milliseconds > (
  SELECT AVG(Milliseconds) 
  FROM Track
)
ORDER BY Milliseconds DESC;

/*Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent*/

WITH best_selling_artist as ( 
  select artist.artist_id as artist_id , artist.name as artist_name,
  sum(invoice_line.unit_price*invoice_line.quantity) as total_sales
  from invoice_line
  join track
  on track.track_id =invoice_line.track_id
  join album
  on album.album_id = track.album_id
  join artist
  on artist.artist_id = album.artist_id
  group by artist.artist_id
  order by total_sales desc
  limit 1 
  )
SELECT c.customer_id,c.first_name, c.last_name,bsa.artist_name,
sum(il.unit_price * il.quantity) as amount_spent
from invoice i
Join customer c 
on c.customer_id = i.customer_id
join invoice_line il 
on il.invoice_id = i.invoice_id
join track t
on t.track_id = il.track_id
join album alb
on alb.album_id = t.album_id
join best_selling_artist bsa on bsa.artist_id = alb.artist_id
group by 1,2,3,4
order by 5 DESC;


/*We want to find out the most popular music Genre for each country. We determine the
most popular genre as the genre with the highest amount of purchases. Write a query
that returns each country along with the top Genre. For countries where the maximum
number of purchases is shared return all Genres*/

with popular_genre as(
select count(invoice_line.quantity) as purchases, customer.country,genre.name,genre.genre_id,
ROW_NUMBER() OVER(PARTITION BY customer.country order by count(invoice_line.quantity) desc) as rowno
from invoice_line
join invoice ON invoice.invoice_id = invoice_line.invoice_id
join customer ON customer.customer_id = invoice.customer_id
join track ON track.track_id = invoice_line.track_id
join  genre ON genre.genre_id = track.genre_id
GROUP BY 2,3,4
ORDER BY 2 asc,1 desc
)
select * from popular_genre where RowNo <=1




