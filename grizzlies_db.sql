-- The 2024-2025 Memphis Grizzlies Database
-- This script creates a fictional database comprised of 9 tables that depicts the 2024-2025 Memphis Grizzlies
-- The Memphis Grizzlies are the NBA franchise located in Memphis, TN, USA.

-- Drop tables if they already exist, in reverse order of creation.
DROP TABLE IF EXISTS Stats;
DROP TABLE IF EXISTS Injuries;
DROP TABLE IF EXISTS Staff_History;
DROP TABLE IF EXISTS Ticket_Sales;
DROP TABLE IF EXISTS Games;
DROP TABLE IF EXISTS Jersey_Sales;
DROP TABLE IF EXISTS Roster;
DROP TABLE IF EXISTS Teams;
DROP TABLE IF EXISTS Coaches;

-- Table 1: Teams
-- Stores a master list of all NBA teams.
CREATE TABLE Teams (
    team_id INT PRIMARY KEY AUTO_INCREMENT,
    team_name VARCHAR(100) NOT NULL,
    team_city VARCHAR(100),
    conference VARCHAR(10),
    division VARCHAR(20),
    founding_year INT,
    playoff_appearances INT,
    championships INT
);

-- Table 2: Coaches
-- Stores biographical information for the Memphis Grizzlies' coaches.
CREATE TABLE Coaches (
    coach_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthdate DATE,
    is_former_player BOOLEAN DEFAULT FALSE
);

-- Table 3: Roster
-- Stores biographical information for the Memphis Grizzlies' players.
CREATE TABLE Roster (
    player_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    birthdate DATE,
    college VARCHAR(100),
    nba_debut_date DATE,
    team_id INT DEFAULT 1, -- This is the Grizzlies' team ID.
    jersey_number INT,
    position VARCHAR(5),
    height_inches INT,
    weight_lbs INT,
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Table 4: Staff_History
-- Tracks coaching roles and changes over time.
-- IMPORTANT: This table shows the mid-season coaching change.
CREATE TABLE Staff_History (
    staff_id INT PRIMARY KEY AUTO_INCREMENT,
    coach_id INT,
    team_id INT DEFAULT 1,
    role VARCHAR(100),
    start_date DATE,
    end_date DATE, -- NULL if this is the coach's current roll.
    FOREIGN KEY (coach_id) REFERENCES Coaches(coach_id),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

-- Table 5: Games
-- Stores data about a select set of scheduled games for the 2024-2025 season.
CREATE TABLE Games (
    game_id INT PRIMARY KEY AUTO_INCREMENT,
    game_date DATETIME,
    home_team_id INT,
    away_team_id INT,
    home_score INT,
    away_score INT,
    season VARCHAR(10) DEFAULT '2024-2025',
    game_type VARCHAR(20), -- Denotes "Regular Season" or "Playoffs".
    FOREIGN KEY (home_team_id) REFERENCES Teams(team_id),
    FOREIGN KEY (away_team_id) REFERENCES Teams(team_id)
);

-- Table 6: Injuries
-- Tracks player injuries over the course of the season.
CREATE TABLE Injuries (
    injury_id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT,
    injury_description VARCHAR(255),
    date_reported DATE,
    status VARCHAR(50), -- E.g., 'Day-to-Day', 'Out'
    FOREIGN KEY (player_id) REFERENCES Roster(player_id)
);

-- Table 7: Stats
-- A junction table connecting players and games to in-game statistics.
CREATE TABLE Stats (
    game_id INT,
    player_id INT,
    minutes_played DECIMAL(4, 1),
    points INT,
    rebounds INT,
    assists INT,
    steals INT,
    blocks INT,
    PRIMARY KEY (game_id, player_id), -- Composite Primary Key
    FOREIGN KEY (game_id) REFERENCES Games(game_id),
    FOREIGN KEY (player_id) REFERENCES Roster(player_id)
);

-- Table 8: Jersey_Sales (NEW)
-- Stores sales of player jerseys.
CREATE TABLE Jersey_Sales (
    sale_id INT PRIMARY KEY AUTO_INCREMENT,
    player_id INT,
    transaction_date DATE,
    jersey_type VARCHAR(50), -- E.g., "Home", "Away", "City"
    size VARCHAR(5), -- E.g., "S", "M", "L", "XL"
    price DECIMAL(6, 2),
    FOREIGN KEY (player_id) REFERENCES Roster(player_id)
);

-- Table 9: Ticket_Sales
-- Stores information about home game ticket sales.
CREATE TABLE Ticket_Sales (
    ticket_sale_id INT PRIMARY KEY AUTO_INCREMENT,
    game_id INT,
    purchase_date DATE,
    section VARCHAR(10), -- E.g., "101A", "205", "Floor"
    quantity INT,
    total_price DECIMAL(8, 2),
    is_giveaway_night BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (game_id) REFERENCES Games(game_id)
);

-- ------------------------------------------------------------------------- --
-- ------------------------ POPULATE DATA (INSERTs) ------------------------ --
-- ------------------------------------------------------------------------- --

-- Populate Teams
INSERT INTO Teams (team_id, team_name, team_city, conference, division, founding_year, playoff_appearances, championships) VALUES
(1, 'Memphis Grizzlies', 'Memphis', 'West', 'Southwest', 1995, 10, 0),
(2, 'Los Angeles Lakers', 'Los Angeles', 'West', 'Pacific', 1947, 62, 17),
(3, 'Boston Celtics', 'Boston', 'East', 'Atlantic', 1946, 60, 18),
(4, 'Oklahoma City Thunder', 'Oklahoma City', 'West', 'Northwest', 1967, 22, 1),
(5, 'Dallas Mavericks', 'Dallas', 'West', 'Southwest', 1980, 25, 1),
(6, 'New Orleans Pelicans', 'New Orleans', 'West', 'Southwest', 2002, 8, 0),
(7, 'Atlanta Hawks', 'Atlanta', 'East', 'Southeast', 1946, 49, 1),
(8, 'Brooklyn Nets', 'Brooklyn', 'East', 'Atlantic', 1967, 23, 0),
(9, 'Charlotte Hornets', 'Charlotte', 'East', 'Southeast', 1988, 10, 0),
(10, 'Chicago Bulls', 'Chicago', 'East', 'Central', 1966, 36, 6),
(11, 'Cleveland Cavaliers', 'Cleveland', 'East', 'Central', 1970, 23, 1),
(12, 'Denver Nuggets', 'Denver', 'West', 'Northwest', 1967, 29, 1),
(13, 'Detroit Pistons', 'Detroit', 'East', 'Central', 1941, 42, 3),
(14, 'Golden State Warriors', 'San Francisco', 'West', 'Pacific', 1946, 37, 7),
(15, 'Houston Rockets', 'Houston', 'West', 'Southwest', 1967, 34, 2),
(16, 'Indiana Pacers', 'Indianapolis', 'East', 'Central', 1967, 27, 0),
(17, 'Los Angeles Clippers', 'Los Angeles', 'West', 'Pacific', 1970, 16, 0),
(18, 'Miami Heat', 'Miami', 'East', 'Southeast', 1988, 24, 3),
(19, 'Milwaukee Bucks', 'Milwaukee', 'East', 'Central', 1968, 36, 2),
(20, 'Minnesota Timberwolves', 'Minneapolis', 'West', 'Northwest', 1989, 12, 0),
(21, 'New York Knicks', 'New York', 'East', 'Atlantic', 1946, 44, 2),
(22, 'Orlando Magic', 'Orlando', 'East', 'Southeast', 1989, 17, 0),
(23, 'Philadelphia 76ers', 'Philadelphia', 'East', 'Atlantic', 1946, 53, 3),
(24, 'Phoenix Suns', 'Phoenix', 'West', 'Pacific', 1968, 33, 0),
(25, 'Portland Trail Blazers', 'Portland', 'West', 'Northwest', 1970, 37, 1),
(26, 'Sacramento Kings', 'Sacramento', 'West', 'Pacific', 1945, 29, 1),
(27, 'San Antonio Spurs', 'San Antonio', 'West', 'Southwest', 1967, 39, 5),
(28, 'Toronto Raptors', 'Toronto', 'East', 'Atlantic', 1995, 13, 1),
(29, 'Utah Jazz', 'Salt Lake City', 'West', 'Northwest', 1974, 31, 0),
(30, 'Washington Wizards', 'Washington, D.C.', 'East', 'Southeast', 1961, 30, 1);

-- Populate Roster
INSERT INTO Roster (first_name, last_name, birthdate, college, nba_debut_date, team_id, jersey_number, position, height_inches, weight_lbs) VALUES
('Ja', 'Morant', '1999-08-10', 'Murray State', '2019-10-23', 1, 12, 'G', 74, 174),
('Jaren', 'Jackson Jr.', '1999-09-15', 'Michigan State', '2018-10-17', 1, 13, 'F-C', 82, 242),
('Desmond', 'Bane', '1998-06-25', 'TCU', '2020-12-23', 1, 22, 'G', 78, 215),
('Marcus', 'Smart', '1994-03-06', 'Oklahoma State', '2014-10-29', 1, 36, 'G', 75, 220),
('Santi', 'Aldama', '2001-01-10', 'Loyola (MD)', '2021-10-20', 1, 7, 'F-C', 84, 215),
('Brandon', 'Clarke', '1996-09-19', 'Gonzaga', '2019-10-23', 1, 15, 'F', 80, 215),
('Zach', 'Edey', '2002-05-14', 'Purdue', '2024-10-22', 1, 14, 'C', 87, 305),
('GG', 'Jackson', '2004-12-17', 'South Carolina', '2023-02-05', 1, 45, 'F', 81, 210),
('Luke', 'Kennard', '1996-06-24', 'Duke', '2017-10-18', 1, 10, 'G', 77, 206),
('John', 'Konchar', '1996-03-22', 'Purdue Fort Wayne', '2019-11-09', 1, 46, 'G', 77, 210),
('Vince', 'Williams Jr.', '2000-08-30', 'VCU', '2021-10-24', 1, 5, 'G-F', 76, 205),
('Scotty', 'Pippen Jr.', '2000-11-10', 'Vanderbilt', '2022-10-19', 1, 1, 'G', 74, 170);

-- Populate Coaches
INSERT INTO Coaches (first_name, last_name, birthdate, is_former_player) VALUES
('Taylor', 'Jenkins', '1984-09-12', false),
('Tuomas', 'Iisalo', '1982-07-29', false),
('Ryan', 'Saunders', '1986-04-28', false),
('Jason', 'March', '1979-02-19', false),
('Anthony', 'Carter', '1975-06-16', true);

-- Populate Staff_History (showing the 2025 coaching change)
INSERT INTO Staff_History (coach_id, role, start_date, end_date) VALUES
((SELECT coach_id FROM Coaches WHERE first_name = 'Taylor' AND last_name = 'Jenkins'), 'Head Coach', '2019-06-11', '2025-03-28'),
((SELECT coach_id FROM Coaches WHERE first_name = 'Tuomas' AND last_name = 'Iisalo'), 'Assistant Coach', '2024-07-07', '2025-03-28'),
((SELECT coach_id FROM Coaches WHERE first_name = 'Tuomas' AND last_name = 'Iisalo'), 'Head Coach', '2025-03-29', NULL),
((SELECT coach_id FROM Coaches WHERE first_name = 'Ryan' AND last_name = 'Saunders'), 'Assistant Coach', '2025-04-05', NULL),
((SELECT coach_id FROM Coaches WHERE first_name = 'Jason' AND last_name = 'March'), 'Assistant Coach', '2024-07-07', NULL),
((SELECT coach_id FROM Coaches WHERE first_name = 'Anthony' AND last_name = 'Carter'), 'Assistant Coach', '2024-07-07', NULL);

-- Populate Games (fictional games for 2024-2025)
INSERT INTO Games (game_date, home_team_id, away_team_id, home_score, away_score, game_type) VALUES
('2025-01-05 19:00:00', 1, 2, 118, 110, 'Regular Season'),
('2025-01-07 20:00:00', 3, 1, 120, 105, 'Regular Season'),
('2025-01-09 19:00:00', 1, 4, 122, 115, 'Regular Season'),
('2025-01-11 19:30:00', 1, 5, 110, 108, 'Regular Season'),
('2025-01-13 21:00:00', 6, 1, 99, 101, 'Regular Season'),
('2025-01-15 19:00:00', 1, 14, 130, 128, 'Regular Season'),
('2025-01-17 20:30:00', 15, 1, 112, 114, 'Regular Season'),
-- Playoffs Start --
('2025-04-20 19:00:00', 1, 4, 115, 110, 'Playoffs'),
('2025-04-22 19:00:00', 1, 4, 100, 108, 'Playoffs'),
('2025-04-25 20:30:00', 4, 1, 112, 119, 'Playoffs');


-- Populate Stats

-- Game 1: Grizzlies (1) vs Lakers (2)
INSERT INTO Stats (game_id, player_id, minutes_played, points, rebounds, assists, steals, blocks) VALUES
(1, (SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), 34.2, 30, 5, 12, 2, 0),
(1, (SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), 32.5, 22, 8, 2, 1, 3),
(1, (SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), 33.0, 18, 6, 4, 1, 0),
(1, (SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), 28.0, 9, 3, 5, 2, 0),
(1, (SELECT player_id FROM Roster WHERE first_name = 'Santi' AND last_name = 'Aldama'), 0, 0, 0, 0, 0, 0),
(1, (SELECT player_id FROM Roster WHERE first_name = 'Brandon' AND last_name = 'Clarke'), 0, 0, 0, 0, 0, 0),
(1, (SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), 15.0, 8, 10, 0, 0, 2),
(1, (SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), 0, 0, 0, 0, 0, 0),
(1, (SELECT player_id FROM Roster WHERE first_name = 'Luke' AND last_name = 'Kennard'), 0, 0, 0, 0, 0, 0),
(1, (SELECT player_id FROM Roster WHERE first_name = 'John' AND last_name = 'Konchar'), 0, 0, 0, 0, 0, 0),
(1, (SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), 22.0, 11, 5, 2, 1, 0),
(1, (SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), 0, 0, 0, 0, 0, 0);

-- Game 2: Celtics (3) vs Grizzlies (1)
INSERT INTO Stats (game_id, player_id, minutes_played, points, rebounds, assists, steals, blocks) VALUES
(2, (SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), 35.0, 24, 4, 8, 1, 0),
(2, (SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), 30.0, 15, 6, 1, 0, 1),
(2, (SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), 36.0, 25, 5, 5, 2, 0),
(2, (SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), 28.0, 10, 4, 6, 3, 0),
(2, (SELECT player_id FROM Roster WHERE first_name = 'Santi' AND last_name = 'Aldama'), 18.0, 8, 5, 1, 0, 1),
(2, (SELECT player_id FROM Roster WHERE first_name = 'Brandon' AND last_name = 'Clarke'), 0, 0, 0, 0, 0, 0),
(2, (SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), 0, 0, 0, 0, 0, 0),
(2, (SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), 0, 0, 0, 0, 0, 0),
(2, (SELECT player_id FROM Roster WHERE first_name = 'Luke' AND last_name = 'Kennard'), 20.0, 12, 2, 2, 0, 0),
(2, (SELECT player_id FROM Roster WHERE first_name = 'John' AND last_name = 'Konchar'), 0, 0, 0, 0, 0, 0),
(2, (SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), 0, 0, 0, 0, 0, 0),
(2, (SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), 0, 0, 0, 0, 0, 0);

-- Game 3: Grizzlies (1) vs Thunder (4)
INSERT INTO Stats (game_id, player_id, minutes_played, points, rebounds, assists, steals, blocks) VALUES
(3, (SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), 36.0, 35, 6, 10, 1, 1),
(3, (SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), 34.0, 28, 9, 2, 2, 4),
(3, (SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), 35.0, 20, 4, 3, 1, 0),
(3, (SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), 30.0, 10, 3, 7, 2, 0),
(3, (SELECT player_id FROM Roster WHERE first_name = 'Santi' AND last_name = 'Aldama'), 22.0, 12, 7, 2, 0, 1),
(3, (SELECT player_id FROM Roster WHERE first_name = 'Brandon' AND last_name = 'Clarke'), 0, 0, 0, 0, 0, 0),
(3, (SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), 0, 0, 0, 0, 0, 0),
(3, (SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), 0, 0, 0, 0, 0, 0),
(3, (SELECT player_id FROM Roster WHERE first_name = 'Luke' AND last_name = 'Kennard'), 0, 0, 0, 0, 0, 0),
(3, (SELECT player_id FROM Roster WHERE first_name = 'John' AND last_name = 'Konchar'), 15.0, 5, 6, 3, 1, 0),
(3, (SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), 0, 0, 0, 0, 0, 0),
(3, (SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), 0, 0, 0, 0, 0, 0);

-- Game 4: Grizzlies (1) vs Mavericks (5)
INSERT INTO Stats (game_id, player_id, minutes_played, points, rebounds, assists, steals, blocks) VALUES
(4, (SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), 33.0, 28, 5, 9, 1, 0),
(4, (SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), 31.0, 20, 7, 1, 1, 2),
(4, (SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), 34.0, 22, 6, 4, 0, 0),
(4, (SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), 0, 0, 0, 0, 0, 0),
(4, (SELECT player_id FROM Roster WHERE first_name = 'Santi' AND last_name = 'Aldama'), 0, 0, 0, 0, 0, 0),
(4, (SELECT player_id FROM Roster WHERE first_name = 'Brandon' AND last_name = 'Clarke'), 0, 0, 0, 0, 0, 0),
(4, (SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), 0, 0, 0, 0, 0, 0),
(4, (SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), 18.0, 15, 4, 0, 0, 1),
(4, (SELECT player_id FROM Roster WHERE first_name = 'Luke' AND last_name = 'Kennard'), 0, 0, 0, 0, 0, 0),
(4, (SELECT player_id FROM Roster WHERE first_name = 'John' AND last_name = 'Konchar'), 0, 0, 0, 0, 0, 0),
(4, (SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), 0, 0, 0, 0, 0, 0),
(4, (SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), 0, 0, 0, 0, 0, 0);

-- Game 5: Pelicans (6) vs Grizzlies (1)
INSERT INTO Stats (game_id, player_id, minutes_played, points, rebounds, assists, steals, blocks) VALUES
(5, (SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), 35.0, 22, 6, 11, 2, 0),
(5, (SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), 32.0, 18, 8, 2, 1, 3),
(5, (SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), 33.0, 19, 5, 3, 1, 0),
(5, (SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), 0, 0, 0, 0, 0, 0),
(5, (SELECT player_id FROM Roster WHERE first_name = 'Santi' AND last_name = 'Aldama'), 0, 0, 0, 0, 0, 0),
(5, (SELECT player_id FROM Roster WHERE first_name = 'Brandon' AND last_name = 'Clarke'), 0, 0, 0, 0, 0, 0),
(5, (SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), 0, 0, 0, 0, 0, 0),
(5, (SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), 0, 0, 0, 0, 0, 0),
(5, (SELECT player_id FROM Roster WHERE first_name = 'Luke' AND last_name = 'Kennard'), 0, 0, 0, 0, 0, 0),
(5, (SELECT player_id FROM Roster WHERE first_name = 'John' AND last_name = 'Konchar'), 0, 0, 0, 0, 0, 0),
(5, (SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), 25.0, 10, 6, 3, 2, 1),
(5, (SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), 0, 0, 0, 0, 0, 0);

-- Game 6: Grizzlies (1) vs Warriors (14)
INSERT INTO Stats (game_id, player_id, minutes_played, points, rebounds, assists, steals, blocks) VALUES
(6, (SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), 37.0, 40, 7, 8, 2, 0),
(6, (SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), 35.0, 25, 10, 2, 1, 2),
(6, (SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), 36.0, 28, 5, 4, 1, 0),
(6, (SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), 30.0, 12, 4, 6, 3, 1),
(6, (SELECT player_id FROM Roster WHERE first_name = 'Santi' AND last_name = 'Aldama'), 0, 0, 0, 0, 0, 0),
(6, (SELECT player_id FROM Roster WHERE first_name = 'Brandon' AND last_name = 'Clarke'), 0, 0, 0, 0, 0, 0),
(6, (SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), 0, 0, 0, 0, 0, 0),
(6, (SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), 0, 0, 0, 0, 0, 0),
(6, (SELECT player_id FROM Roster WHERE first_name = 'Luke' AND last_name = 'Kennard'), 0, 0, 0, 0, 0, 0),
(6, (SELECT player_id FROM Roster WHERE first_name = 'John' AND last_name = 'Konchar'), 0, 0, 0, 0, 0, 0),
(6, (SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), 0, 0, 0, 0, 0, 0),
(6, (SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), 0, 0, 0, 0, 0, 0);

-- Game 7: Rockets (15) vs Grizzlies (1)
INSERT INTO Stats (game_id, player_id, minutes_played, points, rebounds, assists, steals, blocks) VALUES
(7, (SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), 34.0, 29, 5, 9, 1, 0),
(7, (SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), 32.0, 21, 8, 1, 1, 3),
(7, (SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), 33.0, 23, 6, 4, 0, 0),
(7, (SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), 0, 0, 0, 0, 0, 0),
(7, (SELECT player_id FROM Roster WHERE first_name = 'Santi' AND last_name = 'Aldama'), 0, 0, 0, 0, 0, 0),
(7, (SELECT player_id FROM Roster WHERE first_name = 'Brandon' AND last_name = 'Clarke'), 0, 0, 0, 0, 0, 0),
(7, (SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), 16.0, 10, 9, 1, 0, 2),
(7, (SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), 0, 0, 0, 0, 0, 0),
(7, (SELECT player_id FROM Roster WHERE first_name = 'Luke' AND last_name = 'Kennard'), 0, 0, 0, 0, 0, 0),
(7, (SELECT player_id FROM Roster WHERE first_name = 'John' AND last_name = 'Konchar'), 0, 0, 0, 0, 0, 0),
(7, (SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), 0, 0, 0, 0, 0, 0),
(7, (SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), 0, 0, 0, 0, 0, 0);

-- Game 8: Playoffs R1G1 - Grizzlies (1) vs Thunder (4)
INSERT INTO Stats (game_id, player_id, minutes_played, points, rebounds, assists, steals, blocks) VALUES
(8, (SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), 38.0, 32, 6, 10, 2, 0),
(8, (SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), 36.0, 24, 8, 2, 1, 3),
(8, (SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), 37.0, 21, 5, 4, 1, 0),
(8, (SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), 32.0, 12, 5, 7, 2, 1),
(8, (SELECT player_id FROM Roster WHERE first_name = 'Santi' AND last_name = 'Aldama'), 0, 0, 0, 0, 0, 0),
(8, (SELECT player_id FROM Roster WHERE first_name = 'Brandon' AND last_name = 'Clarke'), 0, 0, 0, 0, 0, 0),
(8, (SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), 0, 0, 0, 0, 0, 0),
(8, (SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), 0, 0, 0, 0, 0, 0),
(8, (SELECT player_id FROM Roster WHERE first_name = 'Luke' AND last_name = 'Kennard'), 0, 0, 0, 0, 0, 0),
(8, (SELECT player_id FROM Roster WHERE first_name = 'John' AND last_name = 'Konchar'), 0, 0, 0, 0, 0, 0),
(8, (SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), 25.0, 10, 6, 2, 1, 0),
(8, (SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), 0, 0, 0, 0, 0, 0);

-- Game 9: Playoffs R1G2 - Grizzlies (1) vs Thunder (4)
INSERT INTO Stats (game_id, player_id, minutes_played, points, rebounds, assists, steals, blocks) VALUES
(9, (SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), 39.0, 28, 7, 8, 1, 0),
(9, (SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), 37.0, 19, 7, 1, 0, 2),
(9, (SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), 38.0, 24, 6, 5, 1, 0),
(9, (SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), 33.0, 9, 4, 6, 2, 0),
(9, (SELECT player_id FROM Roster WHERE first_name = 'Santi' AND last_name = 'Aldama'), 0, 0, 0, 0, 0, 0),
(9, (SELECT player_id FROM Roster WHERE first_name = 'Brandon' AND last_name = 'Clarke'), 0, 0, 0, 0, 0, 0),
(9, (SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), 0, 0, 0, 0, 0, 0),
(9, (SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), 0, 0, 0, 0, 0, 0),
(9, (SELECT player_id FROM Roster WHERE first_name = 'Luke' AND last_name = 'Kennard'), 20.0, 8, 2, 2, 0, 0),
(9, (SELECT player_id FROM Roster WHERE first_name = 'John' AND last_name = 'Konchar'), 0, 0, 0, 0, 0, 0),
(9, (SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), 0, 0, 0, 0, 0, 0),
(9, (SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), 0, 0, 0, 0, 0, 0);

-- Game 10: Playoffs R1G3 - Thunder (4) vs Grizzlies (1)
INSERT INTO Stats (game_id, player_id, minutes_played, points, rebounds, assists, steals, blocks) VALUES
(10, (SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), 37.0, 36, 6, 11, 2, 1),
(10, (SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), 36.0, 27, 9, 2, 2, 4),
(10, (SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), 38.0, 22, 5, 4, 1, 0),
(10, (SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), 34.0, 10, 5, 8, 3, 0),
(10, (SELECT player_id FROM Roster WHERE first_name = 'Santi' AND last_name = 'Aldama'), 0, 0, 0, 0, 0, 0),
(10, (SELECT player_id FROM Roster WHERE first_name = 'Brandon' AND last_name = 'Clarke'), 0, 0, 0, 0, 0, 0),
(10, (SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), 0, 0, 0, 0, 0, 0),
(10, (SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), 15.0, 9, 3, 0, 0, 1),
(10, (SELECT player_id FROM Roster WHERE first_name = 'Luke' AND last_name = 'Kennard'), 0, 0, 0, 0, 0, 0),
(10, (SELECT player_id FROM Roster WHERE first_name = 'John' AND last_name = 'Konchar'), 0, 0, 0, 0, 0, 0),
(10, (SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), 0, 0, 0, 0, 0, 0),
(10, (SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), 0, 0, 0, 0, 0, 0);


-- Populate Injuries
INSERT INTO Injuries (player_id, injury_description, date_reported, status) VALUES
((SELECT player_id FROM Roster WHERE first_name = 'Brandon' AND last_name = 'Clarke'), 'Left Achilles Tendon Repair', '2024-10-01', 'Out'),
((SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), 'Right Ankle Sprain', '2025-01-06', 'Day-to-Day'),
((SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), 'Left Toe Soreness', '2025-01-08', 'Questionable');

-- Populate Jersey_Sales
INSERT INTO Jersey_Sales (player_id, transaction_date, jersey_type, size, price) VALUES
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-05', 'Home', 'L', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), '2025-01-05', 'City', 'XL', 139.99),
((SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), '2025-01-06', 'Away', 'M', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), '2025-01-07', 'Home', 'XL', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-08', 'Classic', 'M', 149.99),
((SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), '2025-01-09', 'Home', 'L', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-09', 'Home', 'M', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-09', 'City', 'L', 139.99),
((SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), '2025-01-10', 'Away', 'S', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), '2025-01-10', 'Home', 'L', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), '2025-01-11', 'City', 'M', 139.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-11', 'Home', 'L', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), '2025-01-12', 'Home', 'M', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), '2025-01-12', 'Home', 'XXL', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), '2025-01-13', 'Away', 'L', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-14', 'Away', 'M', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), '2025-01-14', 'Home', 'M', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), '2025-01-15', 'Away', 'L', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-15', 'City', 'M', 139.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-15', 'Home', 'L', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Luke' AND last_name = 'Kennard'), '2025-01-16', 'Home', 'S', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'John' AND last_name = 'Konchar'), '2025-01-16', 'Home', 'L', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Santi' AND last_name = 'Aldama'), '2025-01-17', 'City', 'L', 139.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-17', 'Home', 'M', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), '2025-01-17', 'Home', 'L', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), '2025-01-18', 'Classic', 'XL', 149.99),
((SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), '2025-01-18', 'Away', 'XL', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-18', 'Away', 'S', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'GG' AND last_name = 'Jackson'), '2025-01-18', 'Home', 'M', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), '2025-01-19', 'City', 'M', 139.99),
((SELECT player_id FROM Roster WHERE first_name = 'Marcus' AND last_name = 'Smart'), '2025-01-19', 'Classic', 'L', 149.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-19', 'Home', 'L', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Desmond' AND last_name = 'Bane'), '2025-01-20', 'Home', 'L', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), '2025-01-20', 'Home', 'XL', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-20', 'City', 'L', 139.99),
((SELECT player_id FROM Roster WHERE first_name = 'Zach' AND last_name = 'Edey'), '2025-01-21', 'City', 'L', 139.99),
((SELECT player_id FROM Roster WHERE first_name = 'Vince' AND last_name = 'Williams Jr.'), '2025-01-21', 'Away', 'M', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Ja' AND last_name = 'Morant'), '2025-01-21', 'Home', 'M', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Scotty' AND last_name = 'Pippen Jr.'), '2025-01-22', 'Home', 'S', 129.99),
((SELECT player_id FROM Roster WHERE first_name = 'Jaren' AND last_name = 'Jackson Jr.'), '2025-01-22', 'Away', 'L', 129.99);

-- Populate Ticket_Sales
-- Note: Home game_ids are 1, 3, 4, 6, 8, 9
INSERT INTO Ticket_Sales (game_id, purchase_date, section, quantity, total_price, is_giveaway_night) VALUES
(1, '2025-01-02', '101A', 2, 350.00, true),
(1, '2025-01-03', '215', 4, 480.00, true),
(3, '2025-01-08', '110', 1, 180.00, false),
(4, '2025-01-10', 'Floor', 2, 1200.00, false),
(6, '2025-01-11', '105', 4, 920.00, true),
(8, '2025-04-15', '202', 3, 750.00, true),
(8, '2025-04-16', '112', 2, 550.00, true),
(9, '2025-04-18', '114', 1, 280.00, false),
(1, '2025-01-01', '108', 2, 340.00, true),
(1, '2025-01-02', '205', 2, 240.00, true),
(1, '2025-01-02', '220', 1, 120.00, true),
(1, '2025-01-03', '112', 4, 700.00, true),
(1, '2025-01-04', 'Floor', 2, 1500.00, true),
(1, '2025-01-04', '216', 3, 360.00, true),
(1, '2025-01-05', '101A', 1, 175.00, true),
(3, '2025-01-06', '105', 2, 360.00, false),
(3, '2025-01-07', '210', 4, 440.00, false),
(3, '2025-01-08', '212', 2, 220.00, false),
(3, '2025-01-09', '114', 2, 350.00, false),
(4, '2025-01-08', '115', 1, 160.00, false),
(4, '2025-01-09', '230', 2, 210.00, false),
(4, '2025-01-10', '102', 3, 510.00, false),
(4, '2025-01-11', '201', 4, 420.00, false),
(6, '2025-01-12', '108', 2, 460.00, true),
(6, '2025-01-12', '110', 2, 460.00, true),
(6, '2025-01-13', '208', 1, 130.00, true),
(6, '2025-01-14', 'Floor', 2, 1800.00, true),
(6, '2025-01-14', '228', 4, 520.00, true),
(6, '2025-01-15', '105', 2, 460.00, true),
(8, '2025-04-12', '101A', 2, 560.00, true),
(8, '2025-04-13', '215', 2, 500.00, true),
(8, '2025-04-14', 'Floor', 1, 1100.00, true),
(8, '2025-04-17', '110', 4, 1120.00, true),
(8, '2025-04-18', '205', 1, 250.00, true),
(8, '2025-04-19', '210', 3, 750.00, true),
(9, '2025-04-19', '108', 2, 560.00, false),
(9, '2025-04-20', '220', 2, 500.00, false),
(9, '2025-04-21', '102', 1, 280.00, false),
(9, '2025-04-21', '201', 4, 1000.00, false),
(9, '2025-04-22', 'Floor', 2, 2200.00, false);