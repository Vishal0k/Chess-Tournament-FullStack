

/*
Advanced Queries

1.      Retrieve the names of players along with their total number of matches won, calculated as a percentage of their total matches played.Display the full_name along with  Win_Percentage rounded to 4 decimals */

SELECT
    CONCAT(p.first_name,' ',p.last_name) AS full_name,
    ROUND((SUM
	(CASE 
		WHEN m.winner_id = p.player_id 
			THEN 1 ELSE 0 END) / COUNT(m.player1_id)) * 100, 4) AS Win_Percentage
FROM
    Players p
    JOIN Matches m ON p.player_id = m.player1_id OR p.player_id = m.player2_id
GROUP BY
    p.player_id,p.first_name,p.last_name;

-- 2. Retrieve the match details for matches where the winner's current world ranking is among the top 5 players. Display the match date, winner's name, and the match level.

SELECT 
    m.match_date, 
    CONCAT(p.first_name, ' ', p.last_name) AS winner_name, 
    m.match_level
FROM Matches m
JOIN Players p ON m.winner_id = p.player_id
WHERE p.current_world_ranking <= 5;


-- 3. Find the sponsors who are sponsoring the top 3 players based on their current world ranking. Display the sponsor name and the player's full name an their world ranking .

SELECT 
    s.sponsor_name, 
    CONCAT(p.first_name, ' ', p.last_name) AS player_full_name, 
    p.current_world_ranking
FROM Sponsors s
JOIN Player_Sponsors ps ON s.sponsor_id = ps.sponsor_id
JOIN Players p ON ps.player_id = p.player_id
WHERE p.current_world_ranking <= 3
ORDER BY p.current_world_ranking;

/* 
4. Create a query that retrieves the full names of all players along with a label indicating their performance in the tournament based on their match win percentage. The label should be:

"Excellent" if the player has won more than 75% of their matches.
"Good" if the player has won between 50% and 75% of their matches.
"Average" if the player has won between 25% and 50% of their matches.
"Needs Improvement" if the player has won less than 25% of their matches.
The query should also include the player's total number of matches played and total number of matches won. The calculation for the win percentage should be done using a subquery. */

WITH Player_Performance AS (
    SELECT 
        p.player_id,
        p.first_name,
	    p.last_name,
        COUNT(m.match_id) AS total_matches_played,
        SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) AS total_matches_won,
        (SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) * 100.0 / COUNT(m.match_id)) AS win_percentage
    FROM Players p
    JOIN Matches m ON p.player_id = m.match_id
    GROUP BY p.player_id, p.first_name, p.last_name
)
SELECT 
    CONCAT(pp.first_name, ' ', pp.last_name),
    pp.total_matches_played,
    pp.total_matches_won,
    pp.win_percentage,
    CASE
        WHEN pp.win_percentage > 75 THEN 'Excellent'
        WHEN pp.win_percentage BETWEEN 50 AND 75 THEN 'Good'
        WHEN pp.win_percentage BETWEEN 25 AND 50 THEN 'Average'
        ELSE 'Needs Improvement'
    END AS performance_label
FROM Player_Performance pp;


-- 5. Retrieve the names of players who have never won a match (i.e., they have participated in matches but are not listed as a winner in any match). Display their full name and current world ranking.

SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS full_name, 
    p.current_world_ranking
FROM Players p
WHERE p.player_id IN (
        SELECT DISTINCT player1_id FROM Matches
        UNION
        SELECT DISTINCT player2_id FROM Matches
    )
    AND p.player_id NOT IN (
        SELECT DISTINCT winner_id FROM Matches
    );






