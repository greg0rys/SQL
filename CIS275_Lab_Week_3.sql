/*
*******************************************************************************************
CIS275 at PCC
CIS275 Lab Week 3: using SQL SERVER 2012 and various databases
*******************************************************************************************

                                   CERTIFICATION:

   By typing my name below I certify that the enclosed is original coding written by myself
without unauthorized assistance.  I agree to abide by class restrictions and understand that
if I have violated them, I may receive reduced credit (or none) for this assignment.

                CONSENT:   [Greg Shenefelt]
                DATE:      [01.27.2022]

*******************************************************************************************
*/

GO
PRINT '|---' + REPLICATE('+----',15) + '|'
PRINT 'Read the questions below and insert your queries where prompted.  When  you are finished,
you should be able to run the file as a script to execute all answers sequentially (without errors!)' + CHAR(10)
PRINT 'Queries should be well-formatted.  SQL is not case-sensitive, but it is good form to
capitalize keywords and to capitalize table names as they appear in the database; you should also put 
each projected column on its own line and use indentation for neatness.  Example:

   SELECT Name,
          CustomerID
   FROM   CUSTOMER
   WHERE  CustomerID < 106;

All SQL statements should end in a semicolon.  Whatever format you choose for your queries, make
sure that it is readable and consistent.' + CHAR(10)
PRINT 'Be sure to remove the double-dash comment indicator when you insert your code!';
PRINT '|---' + REPLICATE('+----',15) + '|' + CHAR(10) + CHAR(10)
GO


GO
PRINT 'CIS 275, Lab Week 3, Question 1  [3pts possible]:
What is on TV?
---------------
This is an exact repeat of Question 7 from Lab Week 2. However, instead of using the all_data 
view, instead JOIN the CHANNEL, SHOW, and SCHEDULE tables together. Consult the ERD (if needed)
to determine which columns to match in the ON parts of the JOINs.

Show the first 100 TV shows that start on 9/10/2017 at 8:00PM (StartTime is 20:00:00).

Display results in order by ChannelNumber. 

Show ONLY the DisplayName, ChannelNumber, StartTime, EndTime, and Title.

Use CONVERT to format the StartTime and EndTime hh:mi:ss without the day, month, or year. 

Use CAST or CONVERT make DisplayName 10 characters wide, and Title 30 characters wide. 

Make sure all columns have appropriate names (using AS where needed).

Hint: A DATETIME column can be matched against a string like 8/30/1962 13:00:00.

Hint 2: Correct results will have 100 rows, and look like this:

Channel Name Channel Number Start Time End Time Title
------------ -------------- ---------- -------- ------------------------------
KATU         2              20:00:00   21:00:00 Celebrity Family Feud         
KRCW         3              20:00:00   20:30:00 Two and a Half Men            
KPXG         5              20:00:00   21:00:00 Law & Order: Criminal Intent  
KOIN         6              20:00:00   21:00:00 Big Brother                   
DSCP         7              20:00:00   21:00:00 Alaska: The Last Frontier     
WGNAP        9              20:00:00   21:00:00 Blue Bloods                   
KOPB         10             20:00:00   21:30:00 The Carpenters: Close to You (
KPTV         12             20:00:00   21:00:00 The Orville                   
KPDX         13             20:00:00   21:00:00 Rookie Blue                   
TELEP        15             20:00:00   00:00:00 Ad Channel                    
QVC          16             20:00:00   21:00:00 Today''s Top Tech              
...
MEXCAN       625            20:00:00   20:30:00 Liga Mexicana de Jaripeo Profe
MULTV        626            20:00:00   22:00:00 Poncho en Domingo             
TEFEI        629            20:00:00   22:30:00 La Pe??a de Morfi  
' + CHAR(10)

GO

USE TV

SELECT TOP 100 CONVERT(char(10), CHANNEL.DisplayName) AS [Channel Name] , CHANNEL.ChannelNumber AS [Channel Number],CONVERT(char, SCHEDULE.StartTime, 8) AS [Start Time],CONVERT(char,SCHEDULE.EndTime,8) AS [End Time],CONVERT(char(30),SHOW.Title) AS [Title]
FROM CHANNEL 
JOIN SCHEDULE 
	ON CHANNEL.ChannelID = SCHEDULE.FK_ChannelID
JOIN SHOW 
	ON SHOW.ShowID = SCHEDULE.FK_ShowID
WHERE SCHEDULE.StartTime = '09-10-2017 20:00:00'
ORDER BY CHANNEL.ChannelNumber;



GO
PRINT 'CIS 275, Lab Week 3, Question 2  [3pts possible]:
HD Channels
-----------
Find channels in the CHANNEL table where there is a matching HD channel. For this problem,
only retrieve channels where the DisplayName of the standard definition channel matches the
DisplayName of the HD channel with an HD added to the end (ignore the case where, for example,
SYFYP matches SYFYHDP). Produce results as shown below, using 10 characters for both display
names, and ordering by Standard Name.

Hint: JOIN CHANNEL to itself and alias the tables using AS.

Hint 2: The correct answer will have 58 rows and will look like this:

Standard Channel Standard Name HD Channel  HD Name
---------------- ------------- ----------- ----------
71               AMCP          1405        AMCPHD    
129              BLOOM         1122        BLOOMHD   
412              CBSSN         1303        CBSSNHD   
46               CNBC          1121        CNBCHD    
44               CNN           1111        CNNHD     
184              COOK          1485        COOKHD    
24               CSPAN         1128        CSPANHD   
201              DEST          1487        DESTHD    
121              DFC           1714        DFCHD     
70               EP            1466        EPHD      
35               ESPN          1205        ESPNHD    
36               ESPN2         1206        ESPN2HD   
609              ESPND         1231        ESPNDHD   
411              ESPNU         1301        ESPNUHD   
130              FBN           1123        FBNHD     
...
276              VICEP         1436        VICEPHD   
47               WEATH         1102        WEATHHD   
9                WGNAP         1420        WGNAPHD   
' + CHAR(10)

GO

USE TV

SELECT DISTINCT CHANNEL1.ChannelNumber AS [Standard Channel],CONVERT(char(10), CHANNEL1.DisplayName) AS [Standard Name], CHANNEL2.ChannelNumber AS [Standard Channel], CONVERT(char(10),CHANNEL2.DisplayName) AS [HD NAME]
FROM CHANNEL AS CHANNEL1 JOIN CHANNEL AS CHANNEL2
	ON CHANNEL2.DisplayName = CHANNEL1.DisplayName +'HD' 
ORDER BY [Standard Name];

GO
PRINT 'CIS 275, Lab Week 3, Question 3  [3pts possible]:
HD Channels Part 2
------------------
Repeat the previous query, except this time use a CROSS JOIN. Add a WHERE
clause that matches display names that end in P with display names that end in
HDP.

Note: There are ways to do this that don''t require a CROSS JOIN, but use a CROSS
JOIN anyway.

Hint: The function LEFT will return the left part of a string. For example, given
a column like "Animal", with a value like "fruitbat", the function LEFT(Animal, 5)
will return the value "fruit". The function RIGHT(Animal, 3) will return the value
"bat". The function LEN(Animal) will return 8.

Hint 2: The correct answer will look like this:

Standard Channel Standard Name HD Channel  HD Name
---------------- ------------- ----------- ----------
52               AETVP         1402        AETVHDP   
43               APLP          1471        APLHDP    
56               BETP          1625        BETHDP    
61               CMTVP         1608        CMTVHDP   
41               DISNP         1715        DISNHDP   
7                DSCP          1449        DSCHDP    
122              DXDP          1716        DXDHDP    
551              HBOP          1803        HBOHDP    
561              MAXP          1821        MAXHDP    
576              SHOWP         1841        SHOWHDP   
59               SYFYP         1411        SYFYHDP   
55               TBSP          1434        TBSHDP    
591              TMCP          1861        TMCHDP    
58               USAP          1403        USAHDP    
' + CHAR(10)

GO

USE TV

SELECT  CHANNEL1.ChannelNumber AS [Standard Channel],CONVERT(char(10), CHANNEL1.DisplayName) AS [Standard Name], CHANNEL2.ChannelNumber AS [Standard Channel], CONVERT(char(10),CHANNEL2.DisplayName) AS [HD NAME]
FROM CHANNEL AS CHANNEL1 CROSS JOIN CHANNEL AS CHANNEL2
WHERE RIGHT(CHANNEL1.DisplayName,1) = 'P' -- ensure that the ending of channel1 display name === p
AND RIGHT(CHANNEL2.DisplayName,3) = 'HDP' -- ensure that the 3 chars on the right of channel two ARE HDP
AND RIGHT(CHANNEL1.DisplayName,3) <> 'HDP' -- ensure the last 3 chars on the right of channel one ARE NOT HDP
AND LEFT(CHANNEL1.DisplayName,3) = LEFT(CHANNEL2.DisplayName,3) -- ensure both channel names start with the same chars 
AND LEN(CHANNEL1.DisplayName) -1 = LEN(CHANNEL2.DisplayName)  - 3 -- (-1) compares AETV to (-3)  AETV to ensure that they are the same channels
ORDER BY [Standard Name];


GO
PRINT 'CIS 275, Lab Week 3, Question 4  [3pts possible]:
HD Channels Part 3
------------------
Use UNION to merge the results from Question 2 and Question 3 into a single set of results. Be
sure that your final results are ordered by display name.

Correct results will have 72 rows and will look like this:

Standard Channel Standard Name HD Channel  HD Name
---------------- ------------- ----------- ----------
52               AETVP         1402        AETVHDP   
71               AMCP          1405        AMCPHD    
43               APLP          1471        APLHDP    
56               BETP          1625        BETHDP    
129              BLOOM         1122        BLOOMHD   
412              CBSSN         1303        CBSSNHD   
61               CMTVP         1608        CMTVHDP   
46               CNBC          1121        CNBCHD    
44               CNN           1111        CNNHD      
...
276              VICEP         1436        VICEPHD   
47               WEATH         1102        WEATHHD   
9                WGNAP         1420        WGNAPHD   
' + CHAR(10)

GO


USE TV

	SELECT DISTINCT CHANNEL1.ChannelNumber AS [Standard Channel],CAST( CHANNEL1.DisplayName AS char(10)) AS [Standard Name], CHANNEL2.ChannelNumber AS [Standard Channel], CAST(CHANNEL2.DisplayName AS char(10) ) AS [HD NAME]
	FROM CHANNEL AS CHANNEL1 JOIN CHANNEL AS CHANNEL2
	ON CHANNEL2.DisplayName = CHANNEL1.DisplayName +'HD'
UNION
	SELECT  CHANNEL1.ChannelNumber AS [Standard Channel],CAST( CHANNEL1.DisplayName AS char(10)) AS [Standard Name], CHANNEL2.ChannelNumber AS [Standard Channel], CAST(CHANNEL2.DisplayName AS char(10)) AS [HD NAME]
	FROM CHANNEL AS CHANNEL1 CROSS JOIN CHANNEL AS CHANNEL2
	WHERE RIGHT(CHANNEL1.DisplayName,1) = 'P' 
	AND RIGHT(CHANNEL2.DisplayName,3) = 'HDP' 
	AND RIGHT(CHANNEL1.DisplayName,3) <> 'HDP' 
	AND LEFT(CHANNEL1.DisplayName,3) = LEFT(CHANNEL2.DisplayName,3) 
	AND LEN(CHANNEL1.DisplayName) -1 = LEN(CHANNEL2.DisplayName)  - 3 
ORDER BY [Standard Name];
GO


GO
PRINT 'CIS 275, Lab Week 3, Question 5  [3pts possible]:
Too late!
---------
Find TV episodes in the SHOW table that aren''t currently scheduled. Include only results that have
an episode name and a description.

Use DISTINCT. To match my results, title and episode should be 20 characters wide and description should
be 50 characters wide.

Hint: Use an outer join with the SCHEDULE table along with IS NULL on the primary key to find the shows. 

Correct results will have 360 rows and will look like this:

Title                Episode              Description
-------------------- -------------------- --------------------------------------------------
12 Corazones         Normal               Normal:  (First aired 9/6/2014)                   
90 in 30             Bolivia vs. Chile    Bolivia vs. Chile:                                
A Different World    A Stepping Stone     A Stepping Stone: Whitley wants to be the team lea
A Different World    Dr. War Is Hell      Dr. War Is Hell: Jaleesa and Whitley have new room
A Different World    Dream Lover          Dream Lover: Whitley is upset by the romantic drea
A Different World    Some Enchanted Late  Some Enchanted Late Afternoon: Walter and Jaleesa 
A Different World    Two Gentlemen of Hil Two Gentlemen of Hillman: Dwayne and Ron''s friend
A la Cachi Cachi Por CECYT 15 ''Di??doro A CECYT 15 ''Di??doro Ant??nez Echegaray'' vs. CECYT 3
Accessorize Your Fal Clarks               Clarks:                                           
Adrenaline           Preparation          Preparation: The crew preps and plans for the midw
Alaska: The Last Fro Episode 13           Episode 13:                                       
...
Wings                Legacy               Legacy: Brian returns to Nantucket when a mysterio
Women''s Volleybal   FIVB World Grand Cha FIVB World Grand Champions Cup: Japan vs. USA: Fro
You Can Do Better    Afterhours           Afterhours:                                       
' + CHAR(10)

GO

--
USE TV

SELECT DISTINCT CAST(SHOW.Title AS char(20)) AS [Title] ,CAST(SHOW.EpisodeName AS char(20)) AS [Episode Name] ,CAST( SHOW.Description AS char(50)) AS [Description] 
FROM SHOW 
	LEFT JOIN SCHEDULE 
	ON SHOW.ShowID = SCHEDULE.FK_ShowID
WHERE  SCHEDULE.FK_ShowID IS NULL 
AND SHOW.EpisodeName IS NOT NULL
AND SHOW.Description IS NOT NULL;

--
GO


GO
PRINT 'CIS 275, Lab Week 3, Question 6  [3pts possible]:
Eraserhead
----------
We''ll be switching over to the IMDB database for the remaining questions this week.

Show all principals listed for the movie "Eraserhead." For each principal, show the name of the movie,
the category, and the name of the principal. Also include the characters that actors and actresses
played (display N/A for NULL values). Format all columns to 20 characters wide.

Display in order by name.

Hint: title_basics has information about shows and name_basics has information about people.
title_principals links people to shows with information about the what kind of job the
person had on the show. Use the category column in title_principals here, rather than the job column.

Correct results will look like this:

Title                Category             Name                 Characters
-------------------- -------------------- -------------------- --------------------
Eraserhead           actor                Allen Joseph         ["Mr. X"]           
Eraserhead           actress              Charlotte Stewart    ["Mary X"]          
Eraserhead           director             David Lynch          N/A                 
Eraserhead           cinematographer      Frederick Elmes      N/A                 
Eraserhead           cinematographer      Herbert Cardwell     N/A                 
Eraserhead           actor                Jack Nance           ["Henry Spencer"]   
Eraserhead           actress              Jeanne Bates         ["Mrs. X"]          
' + CHAR(10)

GO

USE IMDB

SELECT CAST(title_basics.originalTitle AS char(20)) AS [Title],CAST(title_principals.category AS char(20)) AS [Category],CAST(name_basics.primaryName AS char(20)) AS [Name] , ISNULL(CAST(title_principals.characters AS char(20)),'N/A') AS [Characters]
FROM title_basics 
	JOIN title_principals
	ON title_basics.tconst = title_principals.tconst --make sure both tconst keys match
	JOIN name_basics 
	ON name_basics.nconst = title_principals.nconst --make sure both nconst keys match
WHERE title_basics.originalTitle = 'Eraserhead'
AND title_basics.titleType ='movie' --make sure they have the titleType of movie to remove results of 'self'
ORDER BY [Name];


--
GO


GO
PRINT 'CIS 275, Lab Week 3, Question 7  [3pts possible]:
Quentin Tarantino
-----------------
What genres has Quentin Tarantino directed? Produce the title, type, year and genre
for shows where Quentin Tarantino was the director. Format Title as 30 characters wide
and genre as 20 characters wide. Order by Year.

Hint: title_directors has information about which people directed which shows. title_genres
has information about what genres (up to 3) a particular show belongs to.

Correct results will have 63 rows formatted as:

Title                          Type         Year        Genre
------------------------------ ------------ ----------- --------------------
Untitled Star Trek Project     movie        NULL        Action              
Untitled Star Trek Project     movie        NULL        Adventure           
Untitled Star Trek Project     movie        NULL        Sci-Fi              
Love Birds in Bondage          short        1983        Comedy              
Love Birds in Bondage          short        1983        Drama               
Love Birds in Bondage          short        1983        Short               
My Best Friend''s Birthday     movie        1987        Comedy              
Reservoir Dogs: Sundance Insti video        1991        Drama               
Reservoir Dogs: Sundance Insti video        1991        Short               
Reservoir Dogs                 movie        1992        Crime               
...     
Untitled Quentin Tarantino/196 movie        2019        Crime               
Untitled Quentin Tarantino/196 movie        2019        Drama               
Untitled Quentin Tarantino/196 movie        2019        Thriller            
' + CHAR(10)

GO

USE IMDB

SELECT CAST(title_basics.originalTitle AS char(30)) AS [Title], title_basics.titleType AS [Type], title_basics.startYear AS [Year] , CAST(title_genre.genre AS CHAR(20)) AS [Genre]
FROM title_basics 
	JOIN title_directors 
	ON title_basics.tconst = title_directors.tconst --make sure the title is matched with the proper director
	JOIN name_basics
	ON name_basics.nconst = title_directors.nconst --make sure the name is a match
	JOIN title_genre 
	ON title_basics.tconst = title_genre.tconst --make sure the title key aligns with the genre key 
WHERE name_basics.primaryName = 'Quentin Tarantino' --ensure they are only by Quentin 
ORDER BY [Year]; 

--
GO


GO
PRINT 'CIS 275, Lab Week 3, Question 8  [3pts possible]:
Quentin Tarantino''s popular movies
-----------------------------------
Produce a list of all of Quentin Tarantino''s movies in descending order by rating. Format title as 30 characters
wide. Your results should appear as below (I escaped the apostrophe in the last result).

Hint: title_ratings contains the number of votes and average rating for each show.

Title                          Type         Year        Rating
------------------------------ ------------ ----------- ---------------------------------------
Pulp Fiction                   movie        1994        8.9
Kill Bill: The Whole Bloody Af movie        2011        8.8
Django Unchained               movie        2012        8.4
Inglourious Basterds           movie        2009        8.3
Reservoir Dogs                 movie        1992        8.3
Kill Bill: Vol. 1              movie        2003        8.1
Kill Bill: Vol. 2              movie        2004        8.0
Sin City                       movie        2005        8.0
The Hateful Eight              movie        2015        7.8
Grindhouse                     movie        2007        7.6
Jackie Brown                   movie        1997        7.5
Death Proof                    movie        2007        7.1
Four Rooms                     movie        1995        6.7
My Best Friend''s Birthday     movie        1987        5.7
' + CHAR(10)

GO

USE IMDB

SELECT CAST(title_basics.originalTitle AS char(30)) AS [Title], title_basics.titleType AS [Type], title_basics.startYear AS [Year], title_ratings.averageRating AS [Rating]
FROM title_basics
	JOIN title_directors 
	ON title_basics.tconst = title_directors.tconst --make sure show title is matched to the director key
	JOIN name_basics 
	ON name_basics.nconst = title_directors.nconst
	JOIN title_ratings 
	ON title_basics.tconst = title_ratings.tconst
WHERE name_basics.primaryName = 'Quentin Tarantino'
AND title_basics.titleType = 'movie' 
ORDER BY Rating DESC;

--
GO


GO
PRINT 'CIS 275, Lab Week 3, Question 9  [3pts possible]:
Top 10 SF Series
----------------
Find the 10 most highly rated SF TV series. Include only series with 10000 or more votes.
Format Title using 30 characters.

Hint: Use SELECT DISTINCT genre and SELECT DISTINCT titleType to determine the correct
values to use to match SF TV series.

Correct results will look like this:

Title                          Rating                                  # of Votes
------------------------------ --------------------------------------- -----------
Firefly                        9.1                                     210460
Westworld                      8.9                                     254053
Black Mirror                   8.9                                     202575
The X-Files                    8.7                                     170522
Mystery Science Theater 3000   8.6                                     20614
The Prisoner                   8.6                                     10202
The Venture Bros.              8.6                                     20478
The Handmaid''s Tale           8.6                                     55338
Altered Carbon                 8.5                                     35421
Utopia                         8.5                                     32097
' + CHAR(10)

GO

USE IMDB

SELECT TOP 10  CAST(title_basics.originalTitle AS char(30)) AS [Title], title_ratings.averageRating AS [Rating], title_ratings.numVotes AS [# of Votes]
FROM title_basics
	JOIN title_ratings 
	ON title_basics.tconst = title_ratings.tconst --make sure the titles key matches the ratings key
	JOIN title_genre 
	ON title_basics.tconst = title_genre.tconst --ensure that the title key matches the genres title key
WHERE title_genre.genre = 'Sci-Fi' --make sure their series is SF
AND title_basics.titleType = 'tvSeries' --make sure we only have tvSeries
AND title_ratings.numVotes > 10000 --make sure we have votes over 10000
ORDER BY [Rating] DESC;







--
GO


GO
PRINT 'CIS 275, Lab Week 3, Question 10  [3pts possible]:
David Lynch/Angelo Badalamenti
------------------------------
Use INTERSECT and the title_principals table to find all movies where David Lynch and
Angelo Badalamenti worked together. Include ID and Title, format Title as 20 characters wide, and 
order alphabetically by Title. Don''t bother with title_directors or title_writers, just use 
title_principals.

Correct results will look like this:

ID        Title
--------- ------------------------------
tt0090756 Blue Velvet                   
tt0116922 Lost Highway                  
tt0166896 The Straight Story            
tt0105665 Twin Peaks: Fire Walk with Me 
tt5334704 Twin Peaks: The Missing Pieces
tt0100935 Wild at Heart                 
' + CHAR(10)

GO

USE IMDB

	SELECT title_principals.tconst AS [ID], CAST(title_basics.originalTitle AS char(20)) AS [Title]
	FROM title_principals
	JOIN title_basics 
	ON title_basics.tconst = title_principals.tconst
	JOIN name_basics 
	ON name_basics.nconst = title_principals.nconst
	WHERE name_basics.primaryName = 'David Lynch'
	AND title_basics.titleType = 'movie' --find the movies and titles that star David Lynch
INTERSECT --where the values of the title and tconst are the same merge the result sets
	SELECT title_principals.tconst AS [ID], CAST(title_basics.originalTitle AS char(20)) AS [Title]
	FROM title_principals
	JOIN title_basics 
	ON title_basics.tconst = title_principals.tconst
	JOIN name_basics 
	ON name_basics.nconst = title_principals.nconst
	WHERE name_basics.primaryName = 'Angelo Badalamenti'
	AND title_basics.titleType = 'movie' --find the movies and titles that star Aneglo BadaLamenti
ORDER BY [Title];

	


--
GO



GO
-------------------------------------------------------------------------------------
-- This is an anonymous program block. DO NOT CHANGE OR DELETE.
-------------------------------------------------------------------------------------
BEGIN
    PRINT '|---' + REPLICATE('+----',15) + '|';
    PRINT ' End of CIS275 Lab Week 3' + REPLICATE(' ',50) + CONVERT(CHAR(12),GETDATE(),101);
    PRINT '|---' + REPLICATE('+----',15) + '|';
END;


