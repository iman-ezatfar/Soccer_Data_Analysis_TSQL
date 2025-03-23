	--Question 1: Average attendance for games where the total goal count was higher than the average total goal
WITH AvgGoalCount AS(
	SELECT
		AVG(total_goal_count) AS Average_Goal_count
	FROM
		[dbo].[matches]
	)
SELECT 
	AVG(attendance) AS Avg_Attendance
FROM
	[dbo].[matches]
WHERE	
	total_goal_count > (SELECT Average_goal_count FROM AvgGoalCount)

---------------------------------------------------------

--Question 2: Referee officiated the most matches and average total number of fouls

WITH sum_fouls AS(
	SELECT COUNT(home_team_fouls) AS home_fouls ,COUNT(away_team_fouls) AS away_fouls
	FROM [dbo].[matches]
)

SELECT TOP(1) referee, AVG(home_team_fouls + away_team_fouls) AS Avg_fouls_both_team
FROM [dbo].[matches]
GROUP BY referee
ORDER BY COUNT(date_GMT) DESC

----------------------------------------------------------

--Question 3: Average goals scored and assists for each position

SELECT
	position, AVG(goals) AS Avg_goals, AVG(assists) AS Avg_assisst
FROM
	[dbo].[players]
GROUP BY
	position
ORDER BY
	Avg_goals DESC, Avg_assisst DESC

------------------------------------------------------------

--Question 4: Compare the average goals scored, corner counts, and possession percentages for home versus away

SELECT
	AVG(home_team_goal_count) AS home_goals, AVG(away_team_goal_count) AS away_goals,
	AVG(home_team_corner_count) AS home_corners, AVG(away_team_corner_count) AS away_corners,
	AVG(home_team_possession) AS home_possession, AVG(away_team_possession) AS away_possession
FROM
	[dbo].[matches]
------------------------------------------------------------

--Question 5: The team with the highest shot accuracy

SELECT
	home_team_name,
	AVG(home_team_shots_on_target*100.0/NULLIF(home_team_shots,0)) AS home_accuracy,
	away_team_name,
	AVG(away_team_shots_on_target*100.0/NULLIF(away_team_shots,0)) AS away_accuracy
FROM
	[dbo].[matches]
GROUP BY
	home_team_name, away_team_name
ORDER BY
	GREATEST(
		AVG(home_team_shots_on_target*100.0/NULLIF(home_team_shots,0)),
		AVG(away_team_shots_on_target*100.0/NULLIF(away_team_shots,0))
		) DESC

------------------------------------------

--Question 6: Top 5 players with the most goals and their total assists

SELECT TOP(5) fullname
FROM [dbo].[players]
GROUP BY fullname
ORDER BY SUM(goals) DESC
-------------------------------------------

--Question 7: Average number of goals scored by home and away teams by season


SELECT  YEAR(date_GMT) AS season, 
		AVG(home_team_goal_count) AS Avg_home_goal,
		AVG(away_team_goal_count) AS Avg_away_goal
FROM [dbo].[matches]
GROUP BY YEAR(date_GMT)
ORDER BY season DESC
