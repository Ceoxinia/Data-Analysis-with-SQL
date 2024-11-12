/* Question 1 Who is the senior most employee based on job title? */
SELECT *
FROM employee
WHERE ReportsTo IS NULL;

/* Question 2 Which countries have the most Invoices? */
SELECT COUNT(InvoiceID) AS InvoiceTotal, BillingCountry 
FROM Invoice
GROUP BY BillingCountry
ORDER BY InvoiceTotal DESC;

/* Question 3 What are top 3 values of total invoice?  */
SELECT TOP 3 Total, BillingCountry
FROM invoice
ORDER BY Total DESC;

/* Question 4 : Which city has the best customers? We would like to throw a promotional Music
 Festival in the city we made the most money.*/
 SELECT * FROM INVOICE;
SELECT TOP 1 BillingCity, SUM(total) AS InvoiceTotal
FROM invoice
GROUP BY BillingCity
ORDER BY InvoiceTotal DESC;

/* Question 5 :Who is the best customer? The customer who has spent the most money will be declared the best customer. */

SELECT TOP 1 Customer.CustomerId,Customer.LastName,Customer.FirstName,SUM(Total) AS total_spending
FROM Customer
JOIN invoice ON Customer.CustomerId = Invoice.CustomerId
GROUP BY Customer.CustomerId, Customer.LastName,Customer.FirstName
ORDER BY total_spending DESC;

/* Question 6:  Write query to return the email, first name, last name, & Genre of all Rock Music
 listeners. Return your list ordered alphabetically by email starting with A. */
 SELECT Distinct C.FirstName,C.LastName,C.Email, G.Name
 From Customer C 
 Inner Join Invoice I On C.CustomerId=I.CustomerId
 Inner Join InvoiceLine L On L.InvoiceId=I.InvoiceId
 Inner Join Track T On T.TrackID = L.TrackID 
 Inner Join Genre G ON G.GenreID = T.GenreID
 Where G.Name ='Rock'
 Order by C.Email ASC;

 /* Question 7: Let's invite the artists who have written the most rock music in our dataset.
 Write a query that returns the Artist name and total track count of the top 10 rock bands. */

SELECT TOP 10 Artist.ArtistId, 
              Artist.Name, 
              COUNT(Artist.ArtistId) AS Songs_Nbr
FROM Track
JOIN Album ON Album.AlbumId = Track.AlbumId
JOIN Artist ON Artist.ArtistId = Album.ArtistId
JOIN Genre ON Genre.GenreId = Track.GenreId
WHERE Genre.Name = 'Rock'
GROUP BY Artist.ArtistId, Artist.Name
ORDER BY Songs_Nbr DESC;

/* CTEs */ 
WITH RockSongsByArtist AS (
    SELECT 
        Artist.ArtistId, 
        Artist.Name, 
        COUNT(Track.TrackId) AS Songs_Nbr
    FROM 
        Track
    JOIN 
        Album ON Album.AlbumId = Track.AlbumId
    JOIN 
        Artist ON Artist.ArtistId = Album.ArtistId
    JOIN 
        Genre ON Genre.GenreId = Track.GenreId
    WHERE 
        Genre.Name = 'Rock'
    GROUP BY 
        Artist.ArtistId, Artist.Name
)

SELECT 
    TOP 10 ArtistId, 
    Name, 
    Songs_Nbr
FROM 
    RockSongsByArtist
ORDER BY 
    Songs_Nbr DESC;
 /* SUBQUERIES : Question 8 : Return all the track names that have a song length longer than the average song
 length.*/
 /* > , < . !=  , = , BETWEEN , >= , <= */ 
 
SELECT Name, Milliseconds
FROM Track
WHERE Milliseconds > (
    SELECT AVG(Milliseconds) 
    FROM Track
)
ORDER BY Milliseconds DESC;

/* Example About Between */ 
SELECT Name, Milliseconds
FROM Track
WHERE Milliseconds BETWEEN (
    SELECT AVG(Milliseconds) - 100000
    FROM Track
) AND (
    SELECT AVG(Milliseconds) + 100000
    FROM Track
)
ORDER BY Milliseconds DESC;

/* SubQuery : Multi Row : Artists that have more than 5 Albums */

SELECT Name
FROM Artist
WHERE ArtistId IN (
    SELECT ArtistId
    FROM Album
    GROUP BY ArtistId
    HAVING COUNT(AlbumId) > 5
);


/* Question 9 : Find how much amount spent by each customer on artists? Write a query to return
customer name, artist name and total spent */
SELECT 
    c.CustomerId, 
    c.FirstName, 
    c.LastName, 
    a.Name AS ArtistName, 
    SUM(il.UnitPrice * il.Quantity) AS AmountSpent
FROM invoice i
JOIN customer c ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
JOIN track t ON t.TrackId = il.TrackId
JOIN album alb ON alb.AlbumId = t.AlbumId
JOIN artist a ON a.ArtistId = alb.ArtistId
GROUP BY c.CustomerId, c.FirstName, c.LastName, a.Name
ORDER BY c.CustomerId, AmountSpent DESC;


WITH best_selling_artist AS (
    SELECT TOP 1 artist.ArtistId AS ArtistId, 
                artist.Name AS ArtistName, 
                SUM(InvoiceLine.UnitPrice * InvoiceLine.Quantity) AS TotalSales
    FROM InvoiceLine
    JOIN track ON track.TrackId = InvoiceLine.TrackId
    JOIN album ON album.AlbumId = track.AlbumId
    JOIN artist ON artist.ArtistId = album.ArtistId
    GROUP BY artist.ArtistId, artist.Name
    ORDER BY TotalSales DESC
)

SELECT c.CustomerId, 
       c.FirstName, 
       c.LastName, 
       bsa.ArtistName, 
       SUM(il.UnitPrice * il.Quantity) AS AmountSpent
FROM invoice i
JOIN customer c ON c.CustomerId = i.CustomerId
JOIN InvoiceLine il ON il.InvoiceId = i.InvoiceId
JOIN track t ON t.TrackId = il.TrackId
JOIN album alb ON alb.AlbumId = t.AlbumId
JOIN best_selling_artist bsa ON bsa.ArtistId = alb.ArtistId
GROUP BY c.CustomerId, c.FirstName, c.LastName, bsa.ArtistName
ORDER BY AmountSpent DESC;

/* Question 10: We want to find out the most popular music Genre for each country. We determine
the most popular genre as the genre
with the highest amount of purchases. Write a query that returns each country along with
the top Genre. For countries where
the maximum number of purchases is shared return all Genres. */

WITH popular_genre AS 
(
    SELECT 
        SUM(InvoiceLine.Quantity) AS purchases, 
        Customer.Country, 
        Genre.Name AS genre_name, 
        Genre.GenreId, 
        ROW_NUMBER() OVER(PARTITION BY Customer.Country ORDER BY SUM(InvoiceLine.Quantity) DESC) AS RowNo 
    FROM InvoiceLine
    JOIN Invoice ON Invoice.InvoiceId = InvoiceLine.InvoiceId
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
    JOIN Track ON Track.TrackId = InvoiceLine.TrackId
    JOIN Genre ON Genre.GenreId = Track.GenreId
    GROUP BY Customer.Country, Genre.Name, Genre.GenreId
)
SELECT 
    Country, 
    genre_name AS MostPopularGenre, 
    purchases AS TotalPurchases
FROM popular_genre 
WHERE RowNo = 1
ORDER BY Country;

/* Question 11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

WITH Customer_with_country AS (
    SELECT 
        Customer.CustomerId,
        Customer.FirstName,
        Customer.LastName,
        Invoice.BillingCountry,
        SUM(Invoice.Total) AS TotalSpending,
        ROW_NUMBER() OVER(PARTITION BY Invoice.BillingCountry ORDER BY SUM(Invoice.Total) DESC) AS RowNo
    FROM Invoice
    JOIN Customer ON Customer.CustomerId = Invoice.CustomerId
    GROUP BY Customer.CustomerId, Customer.FirstName, Customer.LastName, Invoice.BillingCountry
)
SELECT 
    BillingCountry,
    CustomerId,
    FirstName,
    LastName,
    TotalSpending
FROM Customer_with_country
WHERE RowNo = 1
ORDER BY BillingCountry;


/* Views : Create a view that returns each customer’s total spending on music. */

CREATE VIEW CustomerSpending AS
SELECT 
    Customer.CustomerId,
    Customer.FirstName,
    Customer.LastName,
    SUM(Invoice.Total) AS TotalSpent
FROM 
    Invoice
JOIN 
    Customer ON Invoice.CustomerId = Customer.CustomerId
GROUP BY 
    Customer.CustomerId, Customer.FirstName, Customer.LastName;

SELECT * FROM CustomerSpending;

/* Functions : Create a function to calculate total spending by a specific customer. */

CREATE FUNCTION fn_CustomerTotalSpent (@CustomerId INT)
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @TotalSpent DECIMAL(10, 2);
    SELECT @TotalSpent = SUM(Invoice.Total)
    FROM Invoice
    WHERE Invoice.CustomerId = @CustomerId;
    RETURN @TotalSpent;
END;

SELECT dbo.fn_CustomerTotalSpent(10) AS TotalSpentByCustomer;


