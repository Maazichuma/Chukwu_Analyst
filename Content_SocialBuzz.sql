---FOR Content
SELECT*
FROM Content

---Dropping unwanted columns
ALTER TABLE Content
DROP column F1,User_Id, URL

--Removing trailing and leading quotes

SELECT DISTINCT Category
FROM Content

SELECT DISTINCT TRIM (BOTH '"' FROM Category)
FROM Content

UPDATE Content
SET Category = TRIM (BOTH '"' FROM Category)

--- FOR REACTIONS
SELECT *
FROM Reactions

--Removing unwanted columns
ALTER TABLE Reactions
DROP COLUMN user_id, f1

--Removing null rows
SELECT *
FROM Reactions
WHERE Content_ID IS NULL OR Reaction_Type IS NULL OR Datetime IS NULL

DELETE
FROM Reactions
WHERE Reaction_Type is null

--Trimming for spaces
SELECT DISTINCT Reaction_Type, TRIM(Reaction_Type)
FROM Reactions

UPDATE Reactions
SET Reaction_Type = TRIM(Reaction_Type) 

--JOINING THREE TABLES
SELECT R.Content_ID, R.Datetime, C.Category,C.Content_Type,RT.Reaction_Type,RT.Sentiment,RT.Score
FROM Reactions  R
JOIN Content  C
ON R.Content_ID = C.Content_ID
JOIN ReactionTypes  RT
ON R.Reaction_Type = RT.Reaction_Type

--Creating View for the query
CREATE VIEW Content_Catgory (Content_ID, Datetime, Category, Content_Type, Reaction_Type, Sentiment, Score) AS
SELECT R.Content_ID, R.Datetime, C.Category,C.Content_Type,RT.Reaction_Type,RT.Sentiment,RT.Score
FROM Reactions  R
JOIN Content  C
ON R.Content_ID=c.Content_ID
JOIN ReactionTypes  RT
ON R.Reaction_Type = RT.Reaction_Type

SELECT*
FROM Content_Catgory

--FINDING THE CONTENT SCORE FOR EACH CONTENT CATEGORY
WITH Content_score as 
(
SELECT Category,SUM(Score) AS ContentScore
FROM Content_Catgory
GROUP BY Category

)
SELECT Category, ContentScore 
FROM Content_score
ORDER BY ContentScore DESC

---

--Creating view for each category and its content score, and then for Top 5 content category

CREATE VIEW Content_Category (Category, Content_score) AS
WITH Content_score as 
(
SELECT Category, SUM(Score) AS ContentScore
FROM Content_Catgory
GROUP BY Category

)
SELECT TOP 18 Category, ContentScore 
FROM Content_score
ORDER BY ContentScore DESC

--Finding Top 5 content category and the percentage by content score
SELECT TOP 5 Category, Content_score, ROUND(Content_score/350886*100,2) as percentage_cat_score
FROM [dbo].[Content_Category]
GROUP BY Content_score, Category

--calculating unique categories
SELECT COUNT(DISTINCT Category) AS Count_of_Unique_category
FROM Content_Catgory

--- How many reactions are there to the most popular category?

With Rr As (
SELECT Category, Reaction_Type, COUNT(datetime) over (partition by reaction_type order by category)  Reaction
FROM Content_Catgory)
SELECT DISTINCT Category, reaction_type, Reaction AS Rxt
FROM Rr
WHERE Category = 'animals'
ORDER BY Reaction DESC;

--COUNT of reactions to most popular Category: Animals
SELECT COUNT(Reaction_Type)
FROM Content_Catgory
WHERE Category = 'Animals'


---What was the month with the most posts?
SELECT DISTINCT Month(Datetime) AS month, YEAR(Datetime) AS Year, COUNT(Month(Datetime))
from Content_Catgory
GROUP BY Month(Datetime), YEAR(Datetime)
ORDER BY month

--CREATING VIEWS FOR VISUALIZATION

--view for top 5 content category and the percentage by content score
CREATE VIEW Top_5_content AS 
SELECT TOP 5 Category, Content_score, ROUND(Content_score/350886*100,2) as percentage_cat_score
FROM [dbo].[Content_Category]
GROUP BY Content_score, Category

--View for unique categories
CREATE VIEW Count_Unique_Categories AS 
SELECT COUNT(DISTINCT Category) AS Count_of_Unique_category
FROM Content_Catgory

--- creating View for reactions to the most popular category reaction?

CREATE VIEW Animal_reactions AS 
With Rr As (
SELECT Category, Reaction_Type, COUNT(datetime) over (partition by reaction_type order by category)  Reaction
FROM Content_Catgory)
SELECT DISTINCT Category, reaction_type, Reaction AS Rxt
FROM Rr
WHERE Category = 'animals'
--ORDER BY Reaction DESC;

--- creating View for count of reactions to the most popular category reaction?
CREATE VIEW Count_reactions AS
SELECT COUNT(Reaction_Type) Total_Reaction
FROM Content_Catgory
WHERE Category = 'Animals'

---View for the month with the most posts?
CREATE VIEW Month_with_Most_Post AS 
SELECT Month(Datetime) AS month, YEAR(Datetime) AS Year, COUNT(*)  Posts
from Content_Catgory
GROUP BY Month(Datetime), YEAR(Datetime)
ORDER BY month

 



 