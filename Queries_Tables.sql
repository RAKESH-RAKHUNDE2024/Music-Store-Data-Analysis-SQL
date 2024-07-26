-- SQL PROJECT- MUSIC STORE DATA ANALYSIS 

                                                        -- QUESTION SET 1 - EASY :- 

-- Q 1) Who Is The Senior Most Employee Based On Job Title? 
-- ANS -

 SELECT * FROM EMPLOYEE
 WHERE REPORTS_TO IS NULL

-- Q 2) Which Countries Have The Most Invoices? 
-- ANS -

SELECT TOP 1 BILLING_COUNTRY, COUNT(BILLING_COUNTRY) AS INVOICE_COUNT FROM INVOICE
GROUP BY BILLING_COUNTRY
ORDER BY BILLING_COUNTRY DESC


-- Q 3) What Are Top 3 Values Of Total Invoice? 
-- ANS -

SELECT TOP 3 TOTAL FROM INVOICE
ORDER BY TOTAL DESC


-- Q 4) Which City Has The Best Customers? We Would Like To Throw A Promotional Music  Festival In The City We Made The Most Money. Write A Query That Returns One City That 
-- Has The Highest Sum Of Invoice Totals. Return Both The City Name & Sum Of All Invoice Totals ?

-- ANS -

SELECT TOP 1 BILLING_CITY, SUM(TOTAL) AS TOTAL_INVOICE_VALUE 
FROM INVOICE 
GROUP BY BILLING_CITY
ORDER BY TOTAL_INVOICE_VALUE  DESC;
 

-- Q 5) Who Is The Best Customer? The Customer Who Has Spent The Most Money Will Be 
-- Declared The Best Customer. Write A Query That Returns The Person Who Has Spent The Most Money ?

-- ANS -


SELECT CONCAT(FIRST_NAME,' ',LAST_NAME) AS CUSTOMER_NAME FROM CUSTOMER
WHERE CUSTOMER_ID IN
             ( SELECT TOP 1 CUSTOMER_ID FROM INVOICE
			  GROUP BY CUSTOMER_ID
			  HAVING SUM(TOTAL) = (SELECT TOP 1 SUM(TOTAL) AS TOTAL FROM INVOICE
			  GROUP BY CUSTOMER_ID ORDER BY TOTAL DESC));




                                                    -- QUESTION SET 2 – MODERATE :-

-- Q 1) Write Query To Return The Email, First Name, Last Name, & Genre Of All Rock Music Listeners. Return Your List Ordered Alphabetically By Email Starting With A )
-- ANS-

--- METHOD :- 1

WITH GENRE_NAME AS
             (SELECT * FROM CUSTOMER
			 CROSS JOIN GENRE)
     SELECT DISTINCT EMAIL,FIRST_NAME, LAST_NAME FROM GENRE_NAME
	 WHERE NAME = 'Rock'
	 ORDER BY EMAIL


--- METHOD :- 2


    WITH CTE AS
	     (SELECT C.EMAIL,C.FIRST_NAME,C.LAST_NAME,G.NAME FROM GENRE G
		 JOIN TRACK T
		 ON G.GENRE_ID = T.GENRE_ID
		 JOIN INVOICE_LINE IL
		 ON IL.TRACK_ID = T.TRACK_ID
		 JOIN INVOICE I ON
		 I.INVOICE_ID = IL.INVOICE_ID
		 JOIN CUSTOMER C ON
		 C.CUSTOMER_ID = I.CUSTOMER_ID)
SELECT DISTINCT * FROM CTE
WHERE NAME = 'Rock';
		 

--- METHOD :- 3

SELECT DISTINCT EMAIL,FIRST_NAME, LAST_NAME
FROM CUSTOMER
JOIN INVOICE ON CUSTOMER.CUSTOMER_ID = INVOICE.CUSTOMER_ID
JOIN INVOICE_LINE ON INVOICE.INVOICE_ID = INVOICE_LINE.INVOICE_ID
WHERE TRACK_ID IN (
      SELECT TRACK_ID FROM TRACK
	  JOIN GENRE ON TRACK.GENRE_ID = GENRE.GENRE_ID
	  WHERE GENRE.NAME LIKE 'Rock'
)
ORDER BY EMAIL;


-- Q 2) Let's Invite The Artists Who Have Written The Most Rock Music In Our Dataset. Write A Query That Returns The Artist Name And Total Track Count Of The Top 10 Rock Bands ?
-- ANS -

SELECT TOP 10 AR.ARTIST_ID, MAX(AR.NAME) AS ARTIST_NAME,COUNT(AR.ARTIST_ID) AS NUM_OF_SONGS FROM ARTIST AR
JOIN ALBUM AL ON
AR.ARTIST_ID = AL.ARTIST_ID
JOIN TRACK T
ON AL.ALBUM_ID = T.ALBUM_ID
JOIN GENRE G ON
G.GENRE_ID = T.GENRE_ID
WHERE G.NAME = 'Rock'
GROUP BY AR.ARTIST_ID
ORDER BY NUM_OF_SONGS DESC;



-- Q 3) Return All The Track Names That Have A Song Length Longer Than The Average Song Length.Return The Name And Milliseconds For Each Track. 
-- Order By The Song Length With The Longest Songs Listed First ?
-- ANS -

SELECT NAME,MILLISECONDS
FROM TRACK
WHERE MILLISECONDS > (
	SELECT AVG(MILLISECONDS) AS AVG_TRACK_LENGTH
	FROM track )
ORDER BY MILLISECONDS DESC;



                                                      -- QUESTION SET 3 :– ADVANCE --

-- Q 1) Find How Much Amount Spent By Each Customer On Artists? Write A Query To Return 
-- Customer Name, Artist Name And Total Spent ?
-- ANS-

WITH CTE AS
            (SELECT C.FIRST_NAME,AR.NAME,SUM(IL.QUANTITY*IL.UNIT_PRICE) AS TOTAL_SPENT FROM CUSTOMER C
			JOIN INVOICE I ON C.CUSTOMER_ID = I.CUSTOMER_ID
			JOIN INVOICE_LINE IL ON I.INVOICE_ID = IL.INVOICE_ID
			JOIN TRACK T ON IL.TRACK_ID = T.TRACK_ID
			JOIN ALBUM AL ON T.ALBUM_ID = AL.ALBUM_ID
			JOIN ARTIST AR ON AR.ARTIST_ID = AL.ARTIST_ID
			GROUP BY AR.NAME, C.FIRST_NAME
			) 
SELECT * FROM CTE
WHERE NAME = 'Queen'
ORDER BY TOTAL_SPENT DESC;



-- Q 2) We Want To Find Out The Most Popular Music Genre For Each Country. We Determine The Most Popular Genre As The Genre With The Highest Amount Of Purchases. Write A Query 
-- That Returns Each Country Along With The Top Genre. For Countries Where The Maximum Number Of Purchases Is Shared Return All Genres ?
-- ANS-

WITH CTE AS 
          (SELECT I.BILLING_COUNTRY AS COUNTRY, SUM(IL.QUANTITY) AS PURCHASED_UNITS, G.NAME FROM CUSTOMER C
		  JOIN INVOICE I ON C.CUSTOMER_ID = I.CUSTOMER_ID
		  JOIN INVOICE_LINE IL ON IL.INVOICE_ID = I.INVOICE_ID
		  JOIN TRACK T ON T.TRACK_ID = IL.TRACK_ID
		  JOIN GENRE G ON G.GENRE_ID = T.GENRE_ID
		  GROUP BY I.BILLING_COUNTRY,G.NAME
		  ) 
SELECT DISTINCT COUNTRY, NAME,SUM(PURCHASED_UNITS) AS PU FROM CTE
GROUP BY COUNTRY,NAME
ORDER BY PU DESC;


-- Q 3) Write A Query That Determines The Customer That Has Spent The Most On Music For Each Country. Write A Query That Returns The Country Along With The Top Customer
-- And How Much They Spent. For Countries Where The Top Amount Spent Is Shared, Provide All Customers Who Spent This Amount ?
-- ANS-

		 
SELECT BILLING_COUNTRY, SUM(TOTAL) AS AMT FROM CUSTOMER C
JOIN INVOICE I ON C.CUSTOMER_ID = I.CUSTOMER_ID
GROUP BY BILLING_COUNTRY
ORDER BY AMT DESC

        WITH CTE AS
		         (SELECT MIN(CUSTOMER_ID) AS CUST_ID,SUM(TOTAL) AS AMT,BILLING_COUNTRY FROM INVOICE
				 GROUP BY BILLING_COUNTRY)
        SELECT C.CUST_ID, CU.FIRST_NAME,AMT,BILLING_COUNTRY FROM CTE C JOIN CUSTOMER CU
		ON CU.CUSTOMER_ID = C.CUST_ID
		ORDER BY AMT DESC




-- ALL TABLE RECORDS :-

SELECT * FROM ALBUM
SELECT * FROM ARTIST
SELECT * FROM CUSTOMER
SELECT * FROM EMPLOYEE
SELECT * FROM GENRE
SELECT * FROM INVOICE
SELECT * FROM INVOICE_LINE
SELECT * FROM MEDIA_TYPE
SELECT * FROM PLAYLIST
SELECT * FROM PLAYLIST_TRACK
SELECT * FROM TRACK






