set search_path to chess_sch, public;
show search_path;

--Table 1: Players
--This table stores essential information about each chess player.

CREATE TABLE Players (
    player_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    current_world_ranking INTEGER UNIQUE NOT NULL,
    total_matches_played INTEGER DEFAULT 0 NOT NULL
);

--Table 2: Matches
--This table records the basic details of each match played during the tournament.

CREATE TABLE Matches (
    match_id SERIAL PRIMARY KEY ,
    player1_id INT NOT NULL,
    player2_id INT NOT NULL,
    match_date DATE NOT NULL,
    match_level VARCHAR(20) NOT NULL,
    winner_id INT,
    FOREIGN KEY (player1_id) REFERENCES Players(player_id),
    FOREIGN KEY (player2_id) REFERENCES Players(player_id),
    FOREIGN KEY (winner_id) REFERENCES Players(player_id)
);


--Table 3: Sponsors
--This table tracks the sponsors supporting the players.

CREATE TABLE Sponsors (
    sponsor_id SERIAL PRIMARY KEY ,
    sponsor_name VARCHAR(100) UNIQUE NOT NULL,
    industry VARCHAR(50) NOT NULL,
    contact_email VARCHAR(100) NOT NULL,
    contact_phone VARCHAR(20) NOT NULL
);  


--Table 4: Player_Sponsors
--This table connects players with their sponsors.


CREATE TABLE Player_Sponsors (
    player_id INTEGER NOT NULL,
    sponsor_id INTEGER NOT NULL,
    sponsorship_amount NUMERIC(10, 2) NOT NULL,
    contract_start_date DATE NOT NULL,
    contract_end_date DATE NOT NULL,
    PRIMARY KEY (player_id, sponsor_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id),
    FOREIGN KEY (sponsor_id) REFERENCES Sponsors(sponsor_id)
);

-- Insert data into the Players table
INSERT INTO Players (first_name, last_name, country, current_world_ranking, total_matches_played)
VALUES 
('Magnus', 'Carlsen', 'Norway', 1, 100),
('Fabiano', 'Caruana', 'USA', 2, 95),
('Ding', 'Liren', 'China', 3, 90),
('Ian', 'Nepomniachtchi', 'Russia', 4, 85),
('Wesley', 'So', 'USA', 5, 80),
('Anish', 'Giri', 'Netherlands', 6, 78),
('Hikaru', 'Nakamura', 'USA', 7, 75),
('Viswanathan', 'Anand', 'India', 8, 120),
('Teimour', 'Radjabov', 'Azerbaijan', 9, 70),
('Levon', 'Aronian', 'Armenia', 10, 72);


-- Insert data into the Sponsors table
INSERT INTO Sponsors (sponsor_name, industry, contact_email, contact_phone)
VALUES 
('TechChess', 'Technology', 'contact@techchess.com', '123-456-7890'),
('MoveMaster', 'Gaming', 'info@movemaster.com', '234-567-8901'),
('ChessKing', 'Sports', 'support@chessking.com', '345-678-9012'),
('SmartMoves', 'AI', 'hello@smartmoves.ai', '456-789-0123'),
('GrandmasterFinance', 'Finance', 'contact@grandmasterfinance.com', '567-890-1234');

-- Insert data into the Matches table
INSERT INTO Matches (player1_id, player2_id, match_date, match_level, winner_id)
VALUES 
(1, 2, '2024-08-01', 'International', 1),
(3, 4, '2024-08-02', 'International', 3),
(5, 6, '2024-08-03', 'National', 5),
(7, 8, '2024-08-04', 'International', 8),
(9, 10, '2024-08-05', 'National', 10),
(1, 3, '2024-08-06', 'International', 1),
(2, 4, '2024-08-07', 'National', 2),
(5, 7, '2024-08-08', 'International', 7),
(6, 8, '2024-08-09', 'National', 8),
(9, 1, '2024-08-10', 'International', 1);


-- Insert data into the Player_Sponsors table
INSERT INTO Player_Sponsors (player_id, sponsor_id, sponsorship_amount, contract_start_date, contract_end_date)
VALUES 
(1, 1, 500000.00, '2023-01-01', '2025-12-31'),
(2, 2, 300000.00, '2023-06-01', '2024-06-01'),
(3, 3, 400000.00, '2024-01-01', '2025-01-01'),
(4, 4, 350000.00, '2023-03-01', '2024-03-01'),
(5, 5, 450000.00, '2023-05-01', '2024-05-01'),
(6, 1, 250000.00, '2024-02-01', '2025-02-01'),
(7, 2, 200000.00, '2023-08-01', '2024-08-01'),
(8, 3, 600000.00, '2023-07-01', '2025-07-01'),
(9, 4, 150000.00, '2023-09-01', '2024-09-01'),
(10, 5, 300000.00, '2024-04-01', '2025-04-01');


select * from Players; 
select * from Matches; 
select * from Sponsors; 
select * from Player_Sponsors ; 

/*
Phase 2: SQL Queries
 
1.  List the match details including the player names (both player1 and player2), match date, and match level for all International matches. */

SELECT 
    concat(p1.first_name,' ',p1.last_name) AS Player_1,
    concat(p2.first_name,' ',p2.last_name) AS Player_2,
    m.match_date,
    m.match_level
FROM Matches m
JOIN Players p1 ON m.player1_id = p1.player_id
JOIN Players p2 ON m.player2_id = p2.player_id
WHERE m.match_level = 'International'; 

-- 2. Extend the contract end date of all sponsors associated with players from the USA by one year.

UPDATE Player_Sponsors ps
SET contract_end_date = contract_end_date + INTERVAL '1 year'
WHERE ps.player_id IN (
    SELECT player_id
    FROM Players
    WHERE country = 'USA'
);


-- 3. List all matches played in August 2024, sorted by the match date in ascending order.

SELECT 
    concat(p1.first_name,' ',p1.last_name) AS player1,
    concat(p2.first_name,' ',p2.last_name) AS player2,
    m.match_date,
    m.match_level
FROM Matches m
JOIN Players p1 ON m.player1_id = p1.player_id
JOIN Players p2 ON m.player2_id = p2.player_id
WHERE m.match_date BETWEEN '2024-08-01' AND '2024-08-31'
ORDER BY m.match_date ASC;

-- 4. Calculate the average sponsorship amount provided by sponsors and display it along with the total number of sponsors. Dispaly with the title Average_Sponsorship  and Total_Sponsors.

SELECT 
    AVG(ps.sponsorship_amount) AS Average_Sponsorship,
    COUNT(DISTINCT ps.sponsor_id) AS Total_Sponsors
FROM Player_Sponsors ps;


-- 5. Show the sponsor names and the total sponsorship amounts they have provided across all players. Sort the result by the total amount in descending order.

SELECT 
	s.sponsor_name,
    SUM(ps.sponsorship_amount) AS Total_Sponsorship
FROM Sponsors s
JOIN Player_Sponsors ps ON s.sponsor_id = ps.sponsor_id
GROUP BY s.sponsor_name
ORDER BY Total_Sponsorship DESC;





