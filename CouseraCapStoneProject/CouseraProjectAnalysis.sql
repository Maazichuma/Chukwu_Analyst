
---------------------------COUSERA DATA ANALYSIS CAPSTONE PROJECT-----------------------------------------------------
--------This is my first SQL Project hence I documented my mistakes and limitatons in the course of the project

----EARLY MISTAKES
--1)I lost early data cleaning I did which involved importing from Excel to SQL and  matching each columns datatype 
----in EDIT MAPPING of SQL Import Wizard to ensure that data loaded correctly. I however found out along the process that I can change the 
----datatype in EXCEL and then import to SQL without much hitches.
--2) I also lost a good percentage of my data cleaning queries because I wasnt saving the files as I worked.

----DATA LIMITATIONS
--1) All data were downloaded from files given by Cousera. This files have cyclist dataset from 2013-2023 and a total of about 23 million rolls.
-----I had wanted to create matching columns for instance 2020-2023 datasets that have Lng, and Lat but  is absent in 2013-2019 
----- so I can be able to union all. But my SSMS 19 popped that I do not have enough space for that in my database. So I resorted to union 
----- in batches as much as space in the database could allow as I dropped already unioned table. I unioned 2013-2019. 2020 and 2023, 2021 and 2022.
--2) I couldn't do queries on JOIN on the tables because it took longer time to load. I mean, Hours. Perherps your own PC might be more 
-----powerful than mine. Hence you might use less time. Hence I ran seperate smilar queries on the datasets, created VIEWS and UNIONED them
----- into new tables. Same reason I couldnt do subqueries on the tables.


------------------------------DATA ANALYSIS OF CYCLIST DATASETS--------------------------------------------------------------------


------FINDING TRIPDURATION FOR EACH TRIP

--Finding tripduration of each trip for divvy_tripdata_2023_2019
SELECT*
FROM CouseraProject..Divvy_tripdata_2013_2019


SELECT *, CAST(stoptime-starttime AS TIME) AS triptime
  FROM [CouseraProject].[dbo].[Divvy_tripdata_2013_2019]

  ALTER TABLE CouseraProject..divvy_tripdata_2013_2019
  ADD triptime TIME
  
 UPDATE CouseraProject..Divvy_tripdata_2013_2019
 SET triptime = CAST(stoptime-starttime AS TIME)
 FROM [CouseraProject].[dbo].[Divvy_tripdata_2013_2019]
 WHERE stopday IS NOT NULL

 --Finding tripduration of each trip for divvy_tripdata_2021_2022
 SELECT*
FROM CouseraProject..Divvy_tripdata_2021_2022

--Finding tripduration of each trip
SELECT *, CAST(stoptime-starttime AS TIME) AS triptime
  FROM CouseraProject..Divvy_tripdata_2021_2022

  ALTER TABLE CouseraProject..Divvy_tripdata_2021_2022
  ADD triptime TIME
  
 UPDATE CouseraProject..Divvy_tripdata_2021_2022
 SET triptime = CAST(stoptime-starttime AS TIME)
 FROM CouseraProject..Divvy_tripdata_2021_2022
-- WHERE stopday IS NOT NULL

--Finding tripduration of each trip for divvy_tripdata_2023_2019

SELECT*
FROM CouseraProject..Divvy_tripdata_2020_and_2023

--Finding tripduration of each trip
SELECT *, CAST(ended_at-started_at AS TIME) AS triptime
  FROM [CouseraProject].[dbo].[Divvy_tripdata_2020_and_2023]

  ALTER TABLE CouseraProject..divvy_tripdata_2020_and_2023
  ADD triptime TIME
  
 UPDATE CouseraProject..Divvy_tripdata_2020_and_2023
 SET triptime = CAST(ended_at-started_at AS TIME)
 FROM CouseraProject..Divvy_tripdata_2020_and_2023
-- WHERE stopday IS NOT NULL

-------------------------------------------------------------------------------------------------------------------

--FINDING THE AVERAGE TIMETRIP FOR EACH USERTYPE 


--Finding the average timetrip for each usertype 2013_2019
CREATE VIEW avg_timestrip_by_usertype_2013_2019 as ------VIEWS CREATED AFTER THE QUERY HAS BEEN RAN
SELECT usertype,
	   CAST(CAST(AVG(CAST((stoptime-starttime) AS float) 
		- floor(cast((stoptime-starttime) as float))) as 
		datetime) as time) as Avg_time
FROM CouseraProject..Divvy_tripdata_2013_2019
GROUP BY usertype

--Finding the average timetrip for each usertype 2021_2022
CREATE VIEW avg_timetrip_usertype_2021_2022 as------VIEWS CREATED AFTER THE QUERY HAS BEEN RAN
SELECT usertype,
	   CAST(CAST(AVG(CAST((stoptime-starttime) AS float) 
		- floor(cast((stoptime-starttime) as float))) as 
		datetime) as time) as Avg_time 
FROM CouseraProject..Divvy_tripdata_2021_2022
GROUP BY usertype

--Finding the average timetrip for each usertype 2020_and_2023
CREATE VIEW Avg_timetrip_by_usertype_2020_and_2023 AS ------VIEWS CREATED AFTER THE QUERY HAS BEEN RAN
SELECT usertype,
	   CAST(CAST(AVG(CAST((stoptime-starttime) AS float) 
		- floor(cast((stoptime-starttime) as float))) as 
		datetime) as time) as Avg_time 
FROM CouseraProject..Divvy_tripdata_2020_and_2023
GROUP BY usertype


------------------------------------------------------------------------------------------------------

--FINDING THE COUNT OF TRIPS BY USERTYPE
  --(Views were created after the queries have been ran)

--finding the count of trips by usertype 2013-2019
CREATE VIEW tripcount_by_usetype_2013_2019 as
SELECT COUNT(trip_id)  CountofBike, usertype
FROM CouseraProject..Divvy_tripdata_2013_2019
GROUP BY usertype

--finding the count of trips by usertype 2021-2022
CREATE VIEW tripcount_by_usertype_2021_2022 as
SELECT COUNT(ride_id)  CountofBike, usertype
FROM CouseraProject..Divvy_tripdata_2021_2022
GROUP BY usertype

--finding the count of trips by usertype 2020 and 2023
CREATE VIEW tripcount_by_usertype_2020_and_2023 AS
SELECT COUNT(trip_id)  CountofBike, usertype
FROM CouseraProject..Divvy_tripdata_2020_and_2023
GROUP BY usertype

----------------------------------------------------------------
--FINDING THE COUNT OF BIKETRIP BY USERTYPE BY YEAR

---finding usertype biketrip by year 2013_2019
ALTER TABLE CouseraProject..Divvy_tripdata_2013_2019
ADD Year varchar(50)

SELECT YEAR(stoptime)
FROM CouseraProject..Divvy_tripdata_2013_2019

UPDATE CouseraProject..Divvy_tripdata_2013_2019
SET Year = YEAR(stoptime)
FROM CouseraProject..Divvy_tripdata_2013_2019



SELECT COUNT(trip_id)  CountofTrip, YEAR
FROM CouseraProject..Divvy_tripdata_2013_2019
GROUP BY YEAR
 
CREATE VIEW usertype_bike_use_by_yearS_2013_2019 as
SELECT Usertype, COUNT(usertype)  countofUsertype, Year
FROM CouseraProject..Divvy_tripdata_2013_2019
GROUP BY year, usertype
--order by year asc

---finding usertype biketrip by year 2020 and 2023
ALTER TABLE CouseraProject..Divvy_tripdata_2020_and_2023
ADD Year varchar(50)

SELECT YEAR(stoptime)
FROM CouseraProject..Divvy_tripdata_2020_and_2023

UPDATE CouseraProject..Divvy_tripdata_2020_and_2023
SET Year = YEAR(stoptime)
FROM CouseraProject..Divvy_tripdata_2020_and_2023

CREATE VIEW usertype_bike_use_by_yearS_2020_and_2023 as
SELECT Usertype, COUNT(usertype)  countofUsertype, Year
FROM CouseraProject..Divvy_tripdata_2020_and_2023
GROUP BY year, usertype

---extracting year from stoptime to find usertype bike use by year 2021-2022
ALTER TABLE CouseraProject..Divvy_tripdata_2021_2022
ADD Year varchar(50)

SELECT YEAR
FROM CouseraProject..Divvy_tripdata_2021_2022
order by year asc

UPDATE CouseraProject..Divvy_tripdata_2021_2022
SET Year = YEAR(stoptime)
FROM CouseraProject..Divvy_tripdata_2021_2022


CREATE VIEW usertype_bike_use_by_yearS_2021_2022 as
SELECT Usertype, COUNT(usertype)  countofUsertype, Year
FROM CouseraProject..Divvy_tripdata_2021_2022
GROUP BY year, usertype
--------------------------------------------------------------------------------------------------------
--FINDING RIDEABLE BIKES BY USERTYPE
--(views were created after the queries have been ran)

---rideable bike by usertype 2013_2019
CREATE VIEW Count_of_rideable_biketype_by_usertype_2013_2019 as
SELECT rideable_type, usertype, COUNT(rideable_type)  count_of_rideable_type
FROM CouseraProject..Divvy_tripdata_2013_2019
GROUP BY usertype, rideable_type

---rideable bike by usertype 2021_2022
CREATE VIEW Count_of_rideable_biketype_by_usertype_2021_2022 as
SELECT rideable_type, usertype, COUNT(rideable_type)  count_of_rideable_type
FROM CouseraProject..Divvy_tripdata_2021_2022
GROUP BY usertype, rideable_type

---rideable bike by usertype 2020_and_2023
CREATE VIEW Count_of_rideable_biketype_by_usertype_2020_and_2023 as
SELECT rideable_type, usertype, COUNT(rideable_type)  count_of_rideable_type
FROM CouseraProject..Divvy_tripdata_2020_and_2023
GROUP BY usertype, rideable_type


-------------------------------------------------------------------------------------------------------------
--FINDING DISTANCE IN MILES COVERED BY EACH USERTYPE


--Finding Distance 2020_and_2023
SELECT usertype, geography::Point(start_lat, start_lng, 4326).STDistance(geography::Point(end_lat, end_lng, 4326)) AS Distance_in_miles
FROM CouseraProject..Divvy_tripdata_2020_and_2023
WHERE start_lat IS NOT NULL AND start_lng IS NOT NULL AND end_lat IS NOT NULL AND end_lng IS NOT NULL
--Group by usertype

----creating view
CREATE VIEW Distance_by_usertype_2020_and_2023 AS
SELECT usertype, geography::Point(start_lat, start_lng, 4326).STDistance(geography::Point(end_lat, end_lng, 4326)) AS Distance_in_miles
FROM CouseraProject..Divvy_tripdata_2020_and_2023
WHERE start_lat IS NOT NULL AND start_lng IS NOT NULL AND end_lat IS NOT NULL AND end_lng IS NOT NULL
--Group by usertype


--Finding Distance 2021_2022

SELECT usertype, geography::Point(start_lat, start_lng, 4326).STDistance(geography::Point(end_lat, end_lng, 4326)) AS Distance_in_miles
FROM CouseraProject..Divvy_tripdata_2021_2022
WHERE start_lat IS NOT NULL AND start_lng IS NOT NULL AND end_lat IS NOT NULL AND end_lng IS NOT NULL
--Group by usertype

----creating view 2021_2022
CREATE VIEW Distance_by_usertype_2021_2022 AS
SELECT usertype, geography::Point(start_lat, start_lng, 4326).STDistance(geography::Point(end_lat, end_lng, 4326)) AS Distance_in_miles
FROM CouseraProject..Divvy_tripdata_2021_2022
WHERE start_lat IS NOT NULL AND start_lng IS NOT NULL AND end_lat IS NOT NULL AND end_lng IS NOT NULL
--Group by usertype

------------------------------------------PART B------------------------------------------------------------------------------------
---------------------MERGING THE VIEWS TO CREATE TABLES FOR VISUALIZATION -------------------

--CREATING TABLE FOR AVG_TIMETRIP BY USERTYPE BY UNIONING VIEWS
--Creating table
SELECT* 
INTO Avg_timetrip_by_usertype1
FROM (
SELECT*
FROM avg_timestrip_by_usertype_2013_2019
UNION
SELECT *
FROM Avg_timetrip_by_usertype_2020_and_2023
UNION
SELECT*
FROM avg_timetrip_usertype_2021_2022
)  A

--updating table to have same usertype names
 UPDATE Avg_timetrip_by_usertype1
 SET usertype = CASE WHEN usertype = 'customer' THEN 'casual'
				WHEN usertype = 'Subscriber' THEN 'member'
				WHEN usertype = 'member' THEN 'member'
				WHEN usertype = 'casual' THEN 'casual'
				WHEN usertype = 'dependent' THEN 'dependent'
END

--summing the avg_time for each usertype in a new table
SELECT* 
INTO Avg_timetrip_by_usertype
FROM (
SELECT usertype, Avg_time = SUM(DATEDIFF(MINUTE, '0:00:00', Avg_time))
FROM Avg_timetrip_by_usertype1
GROUP BY usertype)  B

SELECT*
FROM Analysis..Avg_timetrip_by_usertype


-----------------------------------------------------------------------------------------------------
--CREATING TABLE FOR COUNT OF RIDEABLE BIKETYPE BY USERTYPE

Select *
INTO count_of_rideable_bike_by_usertype
FROM(
SELECT*
FROM count_of_rideable_biketype_by_usertype_2020_and_2023
UNION
SELECT*
FROM count_of_rideable_biketype_by_usertype_2021_2022
)  D

DROP TABLE count_of_rideable_bike_by_usertype

--finding the sum of these biketypes to be grouped by year and usertype
SELECT*
INTO count_of_rideable_bike_by_usertypee
FROM (
SELECT rideable_type, usertype, SUM(count_of_rideable_type) AS count_of_rideablebike
FROM count_of_rideable_bike_by_usertype
GROUP BY rideable_type, usertype)  T

SELECT*
FROM Analysis..count_of_rideable_bike_by_usertypee
------------------------------------------------------------------------------------
--CREATING TABLE FOR THE NUMBER OF TRIPS BY USERTYPE

SELECT*
INTO tripcount_by_usertype
FROM (
SELECT *
FROM tripcount_by_usertype_2020_and_2023
UNION
SELECT *
FROM tripcount_by_usertype_2021_2022
UNION
SELECT *
FROM tripcount_by_usetype_2023_2019
) D

--updating this table to have matching names for usertype
UPDATE tripcount_by_usertype
 SET usertype = CASE WHEN usertype = 'customer' THEN 'casual'
				WHEN usertype = 'Subscriber' THEN 'member'
				WHEN usertype = 'member' THEN 'member'
				WHEN usertype = 'casual' THEN 'casual'
				WHEN usertype = 'dependent' THEN 'dependent'
				END
--creating table to sum the 
select*
into tripcount_by_usertypee
FROM (
SELECT usertype,SUM(countofBike)  countofBike
FROM Analysis..tripcount_by_usertype
GROUP BY usertype) H

DROP TABLE tripcount_by_usertype

select*
FROM tripcount_by_usertype

-------------------------------------------------------------------------------
--CREATING TABLE FORCOUNT OF BIKEUSE BY YEAR BY USERTYPE
Select *
INTO usertype_bikeuse_by_year
FROM(
SELECT*
FROM usertype_bike_use_by_years_2013_2019
UNION
SELECT*
FROM usertype_bike_use_by_years_2020_and_2023
UNION
SELECT*
FROM usertype_bike_use_by_yearS_2021_2022
)  D

SELECT *
FROM usertype_bikeuse_by_year
ORDER BY year asc

--updating this table to have matching names for usertype
UPDATE usertype_bikeuse_by_year
 SET usertype = CASE WHEN usertype = 'customer' THEN 'casual'
				WHEN usertype = 'Subscriber' THEN 'member'
				WHEN usertype = 'member' THEN 'member'
				WHEN usertype = 'casual' THEN 'casual'
				WHEN usertype = 'dependent' THEN 'dependent'
				END
---------------------------------------------------------------------------------------------------------------
--CREATING TABLE FOR DISTANCE COVERED BY USERTYPE BY YEAR

SELECT*
INTO distance_covered_by_usertype
FROM (
SELECT *
FROM Distance_by_usertype_2020_and_2023
UNION
SELECT *
FROM Distance_by_usertype_2021_2022
) A

SELECT*
FROM Analysis..distance_covered_by_usertype

--finding the Avg. distance and grouping by year, usertype and creating view for visualization
CREATE VIEW Distance_by_usertype AS
SELECT year, usertype, avg(Distance_in_miles) AS Sum_distance
FROM Analysis..distance_covered_by_usertype
GROUP BY year, usertype

