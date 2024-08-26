

/*
Phase 4 : Creating Views
1.  Create a view named PlayerRankings that lists all players with their full name (first name and last name combined), country, and current world ranking, sorted by their world ranking in ascending order. */

CREATE VIEW PlayerRankings AS
SELECT 
    CONCAT(first_name, ' ', last_name) AS full_name,
    country,
    current_world_ranking
FROM Players
ORDER BY current_world_ranking ASC;

-- 2. Create a view named MatchResults that shows the details of each match, including the match date, the names of the players (both player1 and player2), and the name of the winner. If the match is yet to be completed, the winner should be displayed as 'TBD'.

CREATE VIEW MatchResults AS
SELECT 
    m.match_date,
    CONCAT(p1.first_name, ' ', p1.last_name) AS player1_name,
    CONCAT(p2.first_name, ' ', p2.last_name) AS player2_name,
    CASE
        WHEN m.winner_id IS NULL THEN 'TBD'
        ELSE CONCAT(pw.first_name, ' ', pw.last_name)
    END AS winner_name
FROM Matches m
JOIN Players p1 ON m.player1_id = p1.player_id
JOIN Players p2 ON m.player2_id = p2.player_id
LEFT JOIN Players pw ON m.winner_id = pw.player_id;


-- 3. Create a view named SponsorSummary that shows each sponsor's name, the total number of players they sponsor, and the total amount of sponsorship provided by them.

CREATE VIEW SponsorSummary AS
SELECT 
    s.sponsor_name,
    COUNT(sp.player_id) AS total_players_sponsored,
    SUM(sp.sponsorship_amount) AS total_sponsorship_amount
FROM Sponsors s
JOIN Player_Sponsors sp ON s.sponsor_id = sp.sponsor_id
GROUP BY s.sponsor_name;


-- 4. Create a view named ActiveSponsorships that lists the active sponsorships (where the contract end date is in the future). The view should include the player’s full name, sponsor name, and sponsorship amount. Ensure the view allows updates to the sponsorship amount.

CREATE OR REPLACE VIEW ActiveSponsorships AS
SELECT 
    CONCAT(p.first_name, ' ', p.last_name) AS full_name,
    s.sponsor_name,
    sp.sponsorship_amount
FROM Player_Sponsors sp
JOIN Players p ON sp.player_id = p.player_id
JOIN Sponsors s ON sp.sponsor_id = s.sponsor_id
WHERE sp.contract_end_date > CURRENT_DATE;


/* 5. Create a view named PlayerPerformanceSummary that provides a detailed summary of each player's performance in the chess tournament. The view should include the following columns:

Player Name: Full name of the player (concatenation of first_name and last_name).
Total Matches Played: The total number of matches the player has participated in.
Total Wins: The total number of matches the player has won.
Win Percentage: The percentage of matches won by the player.
Best Match Level: The highest level (either "International" or "National") where the player has won the most matches. If the player has an equal number of wins at both levels, the view should return "Balanced".
Ensure that the view accounts for players who have not won any matches by returning NULL for the Total Wins and Win Percentage columns, and appropriately handles the Best Match Level logic.

*/

CREATE VIEW PlayerPerformanceSummary AS
WITH Player_Performance AS (
    SELECT 
        p.player_id,
        CONCAT(p.first_name, ' ', p.last_name) AS 'player_name',
        COUNT(m.match_id) AS total_matches_played,
        SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) AS total_wins,
        ROUND((SUM(CASE WHEN m.winner_id = p.player_id THEN 1 ELSE 0 END) * 100.0 / COUNT(m.match_id)), 2) AS win_percentage
    FROM Players p
    LEFT JOIN Matches m ON p.player_id = m.player1_id OR p.player_id = m.player2_id
    GROUP BY p.player_id, p.first_name, p.last_name
),
Best_Match_Level AS (
    SELECT 
        p.player_id,
        CASE
            WHEN COALESCE(SUM(CASE WHEN m.match_level = 'International' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) > 
                 COALESCE(SUM(CASE WHEN m.match_level = 'National' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) THEN 'International'
            WHEN COALESCE(SUM(CASE WHEN m.match_level = 'International' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) < 
                 COALESCE(SUM(CASE WHEN m.match_level = 'National' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) THEN 'National'
            WHEN COALESCE(SUM(CASE WHEN m.match_level = 'International' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) = 
                 COALESCE(SUM(CASE WHEN m.match_level = 'National' AND m.winner_id = p.player_id THEN 1 ELSE 0 END), 0) THEN 'Balanced'
            ELSE NULL
        END AS best_match_level
    FROM Players p
    LEFT JOIN Matches m ON p.player_id = m.winner_id
    GROUP BY p.player_id
)
SELECT 
    pp.player_name,
    pp.total_matches_played,
    pp.total_wins,
    pp.win_percentage,
    bml.best_match_level
FROM Player_Performance pp
LEFT JOIN Best_Match_Level bml ON pp.player_id = bml.player_id;




