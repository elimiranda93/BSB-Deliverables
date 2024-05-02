/*
Author: Eli Miranda 
Description: Air Traffic Deliverable 1 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------
QUESTION 1:
The managers of the BrainStation Mutual Fund want to know some basic details about the data. Use fully commented SQL queries to address each of the following questions:

-----1.1 How many flights were there in 2018 and 2019 separately?
SELECT flightdate FROM flights LIMIT 10; -- exploring data 

/*Below is my query to count the total amount of flights from the year 2018 from flight_number_reporting_airline colmun of the flights table. There were a total of 
3,218,653 flights in 2018.*/

SELECT
	COUNT(Flight_Number_Reporting_Airline) AS flight_count_2018
FROM flights
WHERE YEAR(flightdate) = 2018
;

/* Below is my query to count the total amount of flights from the year 2019 from flight_number_reporting_airline colmun of the flights table. There were a total of 
3,302,708 flights in 2018.*/

SELECT
	COUNT(Flight_Number_Reporting_Airline) AS flight_count_2019
FROM flights
WHERE YEAR(flightdate) = 2019
;

/* -----1.2 In total, how many flights were cancelled or departed late over both years?

I ran the two DISTINCT queries to see what values appear the Cancelled and DepDelay columns, so that I have a better understanding as to how I should structure my queries.

SELECT DISTINCT cancelled FROM flights ;
SELECT DISTINCT DepDelay FROM flights ;

This query is counting all rows for Cancelled and lates flights, but filtering out values based on two conditions. The first condition will apply to the Cancelled column where 
we are looking for any value that is '1' which signifies that the flight was cancelled. The second condition will apply to the DepDelay column where we are looking values > 0 
as those values represent that is flight has departed late or is delayed. Count (*) was used to count all the columns that meet these conditions. It is also likely that flights 
that departed late were cancelled. 

Based on this query, 2,633,237 flights were canceled or departed late. */

SELECT
	COUNT(*) AS cancelled_or_late_flights
FROM flights
WHERE cancelled = 1
	OR DepDelay > 0
;

/*-----1.3 Show the number of flights that were cancelled broken down by the reason for cancellation.
SELECT DISTINCT CancellationReason FROM flights; -- exploring data 

The query below counts all cancelled flights where the cancelled value condition = 1 for cancelled flights. The then goes a step further can groups by CancellationReason.*/

SELECT
	CancellationReason,
	COUNT(*) AS cancelled_by_reason
FROM flights
WHERE cancelled = 1
GROUP BY CancellationReason
;

/* The first column displays each of the possible reasons for cancellation. The reasons for cancellation are carrier, national air system, security and weather.
The second column displays the amount of cancellations that correspond the CancellationReason in the first column. Based on these results it appears weather seems to be the
cause of the most amount of cancellations at 50,225 and security is the least amount at 35. 

CancellationReason	cancelled_by_reason
Carrier				34141
National Air System	7962
Security			35
Weather				50225

-----1.4 For each month in 2019, report both the total number of flights and percentage of flights cancelled. Based on your results, what might you say about the cyclic nature of airline revenue?

The query below will generate a table with three columns. The first column will be the months within 2019. The second column will show the total flights for each month and the third column shows 
the percentage of flights cancelled. The query generates these columns by first gathering the total amount of flights in the flights table for the year 2019. Then the query sums the total values 
for cancelled flights for 2019 where there are only two values, '1' representing a cancellation and '0' representing noncancelled flights. SUM(Cancelled) can be used here only because the value for 
cancelled flights is '1' and noncancelled flights is '0', so when the cancelled flights are summed up we will only see a sum for cancelled flights. The SUM for cancelled flights is divided by the 
total flights in 2019 within the whole flights table to create percentage of flights cancelled. The query then groups by month and then order thems ascending.*/

SELECT
	MONTH(flightdate) AS month,
	COUNT(*) AS total_flights,
	SUM(Cancelled) / COUNT(*) * 100 AS perc_cancelled
FROM flights
WHERE YEAR(Flightdate) = 2019
GROUP BY MONTH(Flightdate)
ORDER BY MONTH(Flightdate)
;

/* To simplify these results I will discuss them in term of quarters and then highlight noteworthy months. Let us first establish that there does not appear to be a clear relationship between the 
total flights per month vs the percentage of cancelled flights as the range of total flights is narrow between 237,896 - 291,995 and does not show any particular linear trends. So, the only observable 
patterns in revenue can be extrapolated from the percentage of cancelled flights. It appears that airline revenue decreases with we move through the first quarter based on the increasing percentation 
of cancelled flights. The revenue is likely to be at its lowest within the first month of the second quarter (April). From there revenue starts to increase as the percentage of cancellations starts 
consitently to decrease through each quarter until year end.  

month	total_flights	perc_cancelled
1		262165			2.2078
2		237896			2.3128
3		283648			2.4957
4		274115			2.7102
5		285094			2.4245
6		282653			2.1836
7		291955			1.5492
8		290493			1.2475
9		268625			1.2352
10		283815			0.8072
11		266878			0.5920
12		275371			0.5073

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

QUESTION 2:
-----2.1 Create two new tables, one for each year (2018 and 2019) showing the total miles traveled and number of flights broken down by airline.

The query below creates a table that shows the total miles traveled and number of flights broken down by airline for the year 2018. The table 
will consist of 3 columns, where the first colummn will list airline names that exist within the flights table. However, the GROUP BY statement will 
restrict each airline name to one row per DISTINCT airline name. The second column consists of the SUM of all flights rows found in the flight table, GROUPed 
BY airline name, so that each row only contains the SUMed flights for their respective airline names found in the first column. The third column 
consists of the SUM of all the distance(or miles) rows in the flight table GROUPed BY airline name, so that each row only contains the SUMed distance 
for their respective airline names found in the first column. The WHERE statement restricts the data pulled form the flights table to only be for the 
year 2018.*/

DROP TABLE IF EXISTS Flights_2018 ; -- Check for any prexisting tables, to ensure we start with a clean slate. 
CREATE TABLE Flights_2018 AS 
SELECT
	AirlineName,
    COUNT(id) AS total_flights_2018,
	SUM(Distance) AS total_dist_2018
FROM flights
WHERE YEAR(Flightdate) = 2018
GROUP BY AirlineName
;

/* The table below shows that for the year 2018 Southwest Airlines Co had the most flights and the most most miles traveled for 2018. 
American Airlines Inc had the least amount of flights, but managed to still have the 2nd most miles traveled in 2018. Where as, Delta Air lines Inc 
had the least miles traveled for 2018, despite having the second most flights for that year.  

AirlineName 			total_flights_2018	total_dist_2018
Delta Air Lines Inc.	949283				842409169
American Airlines Inc.	916818				933094276
Southwest Airlines Co.	1352552				1012847097
*/

SELECT * FROM airtraffic.flights_2018; -- sanity check 

/* The query below creates a table that shows the total miles traveled and number of flights broken down by airline for the year 2019. The table 
will consist of 3 columns, where the first colummn will list airline names that exist within the flights table. However, the GROUP BY statement will 
restrict each airline name to one row per DISTINCT airline name. The second column consists of the SUM of all flights rows found in the flight table, GROUPed 
BY airline name, so that each row only contains the SUMed flights for their respective airline names found in the first column. The third column 
consists of the SUM of all the distance(or miles) rows in the flight table GROUPed BY airline name, so that each row only contains the SUMed distance 
for their respective airline names found in the first column. The WHERE statement restricts the data pulled form the flights table to only be for the 
year 2019.*/

DROP TABLE IF EXISTS Flights_2019 ; -- Check for any prexisting tables to ensure we start with a clean slate. 
CREATE TABLE Flights_2019 AS
SELECT 
	AirlineName,
    COUNT(id) AS total_flights_2019,
	SUM(Distance) AS total_dist_2019
FROM flights
WHERE YEAR(Flightdate) = 2019
GROUP BY AirlineName
;

/* The table below show that the total flights and miles traveled by airline has the same trends for 2019 as for 2018, with 
Southwest Airlines Co. still having the most flights and miles traveled. American Airlanes Inc. continued to have 
the least overall flights and second most miles traveled. And Delta Air Lines Inc. still has the least miles traveled, but 
second most flights. 

AirlineName 			total_flights_2019	total_dist_2019
Delta Air Lines Inc.	991986				889277534
American Airlines Inc.	946776				938328443
Southwest Airlines Co.	1363946				1011583832
*/

SELECT * FROM airtraffic.flights_2019; -- sanity check 

/*-----2.2 Using your new tables, find the year-over-year percent change in total flights and miles traveled for each airline.
Use fully commented SQL queries to address the questions above. What investment guidance would you give to the fund managers based on your results?*/

SELECT 
    flights_2018.AirlineName,
	ROUND(((flights_2019.total_flights_2019 - flights_2018.total_flights_2018) / flights_2018.total_flights_2018) * 100 ,2) AS total_flights_diff,
    ROUND(((flights_2019.total_dist_2019 - flights_2018.total_dist_2018) / flights_2018.total_dist_2018) * 100 ,2) AS total_dist_diff
FROM flights_2018
INNER JOIN flights_2019 
ON flights_2018.AirlineName = flights_2019.AirlineName 
;   

/* The below table shows total year-over-year percent change in total flights and miles traveled for each airline. Based on this table, Delta Air Lines Inc. 
had a 4.5% increase in total flighst and a 5.56% increasse in miles traveled from 2018 to 2019. American Airlines Inc, saw a modest increase of 3.27% in total 
flights, but a small increase in miles traveled from 2018 to 2019. Although, Southwest Airlinces Co. have the most flights and miles traveled for both 2018 and 2019,
they saw the smallest increase in total flights at 0.84% and a decrease in miles traveled by 0.12%. Based on the these findings Delta Air Lines Inc. would be the best 
airline to invest in as they saw the most significant increase in flights and miles traveled when compared to their peers from 2018 to 2019. 

AirlineName 			total_flights_diff 		total_dist_diff
Delta Air Lines Inc.	4.50					5.56
American Airlines Inc.	3.27					0.56
Southwest Airlines Co.	0.84					-0.12
-----------------------------------------------------------------------------------------------------------------------------------------------------------------

QUESTION 3:
Another critical piece of information is what airports the three airlines utilize most commonly.
-----3.1 What are the names of the 10 most popular destination airports overall? For this question, generate a SQL query that first joins flights and airports then does the necessary aggregation.*/

SELECT 
	airports.AirportName,
	COUNT(*) AS totalflights_by_Dest
FROM flights 
INNER JOIN airports
ON flights.DestAirportID = airports.airportID
GROUP BY airports.AirportName
ORDER BY totalflights_by_Dest DESC
LIMIT 10
;
 
/* Below is a table with the top 10 most popular destination airports. The first columns shows the airport name and the second column shows the amount of flights that coorrespond with the destination 
airport in the first column. It is in descending order, so the most popular airport of the top ten is in the first row and the popularity decreases as we descend into the each row below. 

AirportName 											totalflights_by_Dest
Hartsfield-Jackson Atlanta International				595527
Dallas/Fort Worth International							314423
Phoenix Sky Harbor International						253697
Los Angeles International								238092
Charlotte Douglas International							216389
Harry Reid International								200121
Denver International									184935
Baltimore/Washington International Thurgood Marshall	168334
Minneapolis-St Paul International						165367
Chicago Midway International							165007

-----3.2 Answer the same question but using a subquery to aggregate & limit the flight data before your join with the airport information, hence optimizing your query runtime.
If done correctly, the results of these two queries are the same, but their runtime is not. In your SQL script, comment on the runtime: which is faster and why?*/

SELECT 
	airports.AirportName,
	top10_Dest.totalflights_by_Dest
FROM (
	SELECT
		DestAirportID,
		COUNT(*) AS totalflights_by_Dest
	FROM flights 
	GROUP BY DestAirportID 
    ORDER BY totalflights_by_Dest DESC
	LIMIT 10
    ) AS top10_Dest
INNER JOIN airports
ON top10_Dest.DestAirportID = airports.airportID
ORDER BY top10_Dest.totalflights_by_Dest DESC
; 

/*  Query without Subquery runtime = 25.313 sec
	Query with Subquery runtime = 5.734 sec 

Based on the runtimes above, the SQL script with the subquery was faster. This is because the subquery completes the aggregation of flight data
and then limits it before the main query runs and completes joining the airports and flights tables. Completing the aggregation and limiting the 
date prior to join the tables is significant because the subquery is only aggregating the data from 1 table and then make that data set even smaller
by limiting it to 10 rows. Without the subquery, the aggregation would happened on all the data found in the newly joined airports and flights table
which a larger data set which will take longer to process. 

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

QUESTION 4:

The fund managers are interested in operating costs for each airline. We don't have actual cost or revenue information available, 
but we may be able to infer a general overview of how each airline's costs compare by looking at data that reflects equipment 
and fuel costs.

-----4.1 A flight's tail number is the actual number affixed to the fuselage of an aircraft, much like a car license plate. As such, 
each plane has a unique tail number and the number of unique tail numbers for each airline should approximate how many planes the 
airline operates in total. Using this information, determine the number of unique aircrafts each airline operated in total over 2018-2019.

SELECT DISTINCT Tail_number FROM Flights; -- Exploring data. 
SELECT DISTINCT AirlineName FROM Flights; -- Exploring data. 

The query below COUNTs the total amount of planes with unique tail numbers and GROUPs them by airline.*/

SELECT
	AirlineName,
	COUNT(DISTINCT Tail_Number) AS total_planes
FROM flights
GROUP BY AirlineName
;

/*The table below shows two columns where the Airline Name is in the first column and the total number of planes with with 
unique tail number, all of which is GROUPed by airlines. Based on the table, Southwest Airlines has the least amount of planes. 
Where as American Airlines and Delta Air Lines have a similar amount of planes. 

AirlineName 			total_planes
American Airlines Inc.	993
Delta Air Lines Inc.	988
Southwest Airlines Co.	754
 
-----4.2 Similarly, the total miles traveled by each airline gives an idea of total fuel costs and the distance traveled per 
plane gives an approximation of total equipment costs. 

What is the average distance traveled per aircraft for each of the three airlines? As before, use fully commented SQL queries 
to address the questions. Compare the three airlines with respect to your findings: how do these results impact your estimates 
of each airline's finances?

SELECT DISTINCT Distance FROM Flights; -- Exploring data
*/

SELECT
	AirlineName,
	ROUND(SUM(distance) / COUNT(DISTINCT Tail_Number),2) AS avg_dist_byplane
FROM flights
GROUP BY AirlineName
ORDER BY Avg_dist_byplane DESC
;

/* The table below shows two columns where first columns contains all of the DISTINCT airline names from the flights table. The second column shows the average 
distancts traveled by a single plane for each airline. Considering that total miles traveled by each airline gives an idea of total fuel costs and the distance 
traveled per plane gives an approximation of total equipment costs, the table belows shows that Southwest Airlines Co. likley has the highest fuel and equipment cost 
when compared to their peers. This is because Southwest Airlines Co.has the highest average distance traveled per plane. Additionally, American Airlines Inc. comes in 
second for  fuel and equipment cost, while Delta Air LInes Inc. has the least fuel and equipment costs. 

AirlineName				avg_dist_byplane
Southwest Airlines Co.	2684921.66
American Airlines Inc.	1884615.02
Delta Air Lines Inc.	1752719.34

-----------------------------------------------------------------------------------------------------------------------------------------------------------------

QUESTION 5:
Finally, the fund managers would like you to investigate the three airlines and major airports in terms of on-time performance as well. For each of the following questions, 
consider early departures and arrivals (negative values) as on-time (0 delay) in your calculations.

-----5.1 Next, we will look into on-time performance more granularly in relation to the time of departure. We can break up the departure times into three categories as follows:
CASE
    WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
    WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
    WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
    ELSE "4-night"
END AS "time_of_day"

Find the average departure delay for each time-of-day across the whole data set. Can you explain the pattern you see?*/

SELECT 	
	ROUND(AVG(IF(DepDelay < 0, 0, DepDelay)),2) AS avg_DepDelay,
    CASE
		WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
		WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
		WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
		ELSE "4-night"
	END AS "time_of_day"
FROM flights
GROUP BY time_of_day
ORDER BY time_of_day
;

/* The table below shows two columns, where the first column shows the average depature delay time in hours. The second column groups the depature times into 1 of 4 categories 
based on time of day. Based on the table below, the night is time of the day with shortest delays at 7.79hrs. The morning has the second shortest delays at 7.91hrs. The 
afternoon sees a significant increase in delays, coming in at 13.66hr. The evening continues the same pattern as the afternoon, with longest delays of 18.31hrs. In short, the morning 
and night experience the shortest delays, where as the afternoon and evening experience the longest delays. 

avg_DepDelay	time_of_day
7.91			1-morning
13.66			2-afternoon
18.31			3-evening
7.79			4-night

-----5.2 Now, find the average departure delay for each airport and time-of-day combination.*/

SELECT 
	OriginAirportID,
	ROUND(AVG(IF(DepDelay < 0, 0, DepDelay)),2) AS avg_DepDelay,
    CASE
		WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
		WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
		WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
		ELSE "4-night"
	END AS "time_of_day"
FROM flights
GROUP BY OriginAirportID, time_of_day
-- LIMIT 10
;
/* Below is a table of airports and their average depature delays grouped by time of day based on military tie. The time of day groups are as follows: 
departures between 700-1100 are consider morning, departures between 1200-1600 are considered afternoon, departures between 1700-2100 are considered 
evening and all other hours are considered night. Only 10/623 rows are visible in the table below. 

OriginAirportID		avg_DepDelay	time_of_day
10135				3.00			2-afternoon
10135				15.86			3-evening
10135				7.69			4-night
10140				8.14			1-morning
10140				13.62			2-afternoon
10140				18.08			3-evening
10140				4.66			4-night
10208				9.13			1-morning
10208				13.26			2-afternoon
10208				10.26			3-evening

-----5.3 Next, limit your average departure delay analysis to morning delays and airports with at least 10,000 flights.*/

SELECT 
	OriginAirportID,
	COUNT(OriginAirportID) AS flight_count,
	ROUND(AVG(IF(DepDelay < 0, 0, DepDelay)),2) AS avg_DepDelay,
    CASE
		WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
		WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
		WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
		ELSE "4-night"
	END AS "time_of_day"
FROM flights
GROUP BY OriginAirportID, time_of_day
HAVING 
	time_of_day = '1-morning'
	AND flight_count >= 10000 
-- ORDER BY avg_DepDelay DESC - Sanity check for 5.4. 
-- LIMIT 10
;
/*Below is a table of airports that had at least 10,000 total flights and experienced morning delays. The average departure delay in hours was also included 
so that we can see the difference in morning delays across all the airports in the table. 10/47 rows were show to make for better readability. 

OriginAirportID		flight_count	avg_DepDelay	time_of_day
10397				179940			5.62			1-morning
10423				24737			7.47			1-morning
10693				33985			7.27			1-morning
10721				35650			8.93			1-morning
10800				16715			5.69			1-morning
10821				51614			6.84			1-morning
11057				68672			6.90			1-morning
11066				11974			7.03			1-morning
11193				10492			5.03			1-morning
11259				41007			8.35			1-morning

-----5.4 By extending the query from the previous question, name the top-10 airports (with >10000 flights) with the highest average morning delay. In what cities are these airports located?*/

SELECT
	airportname,
    City,
    top10_airports.avg_DepDelay,
    top10_airports.flight_count,
	top10_airports.time_of_day
FROM (
		SELECT 
			OriginAirportID,
			COUNT(OriginAirportID) AS flight_count,
			ROUND(AVG(IF(DepDelay < 0, 0, DepDelay)),2) AS avg_DepDelay,
			CASE
				WHEN HOUR(CRSDepTime) BETWEEN 7 AND 11 THEN "1-morning"
				WHEN HOUR(CRSDepTime) BETWEEN 12 AND 16 THEN "2-afternoon"
				WHEN HOUR(CRSDepTime) BETWEEN 17 AND 21 THEN "3-evening"
				ELSE "4-night"
			END AS "time_of_day"
		FROM flights
		GROUP BY OriginAirportID, time_of_day
		HAVING 
			time_of_day = '1-morning'
			AND flight_count >= 10000  
	) AS top10_airports
INNER JOIN airports
ON top10_airports.OriginAirportID = airports.AirportID
ORDER BY avg_DepDelay DESC
LIMIT 10
;

/*Below is a table showing the top-10 airports with >10000 flights, the highest average morning delay in hours and the cities the airports are located in. 
According to this table San Francisco International is the number 1 airport with the highest average departure delays in the morning of 13.61hrs despite having 
the least amount of flights when compared to the 9 other airports in the table. 

airportname							City					avg_DepDelay	flight_count	time_of_day
San Francisco International			San Francisco, CA		13.61			29517			1-morning
Chicago O'Hare International		Chicago, IL				11.54			51333			1-morning
Dallas/Fort Worth International		Dallas/Fort Worth, TX	11.44			101468			1-morning
Los Angeles International			Los Angeles, CA			10.96			82301			1-morning
Seattle/Tacoma International		Seattle, WA				10.18			35530			1-morning
Chicago Midway International		Chicago, IL				10.15			46019			1-morning
Logan International					Boston, MA				8.93			35650			1-morning
Raleigh-Durham International		Raleigh/Durham, NC		8.78			19713			1-morning
Denver International				Denver, CO				8.73			56619			1-morning
San Diego International				San Diego, CA			8.66			38018			1-morning

