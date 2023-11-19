
-- Query 1
-- Return the board at half-move 3 of the games played in Palma de Mallorca

HAVING game_site == 'Palma de Mallorca'
SELECT *
FROM games_100
WHERE getBoard(san, 3)

HAVING game_site == 'Palma de Mallorca'
SELECT *
FROM games_20
WHERE getBoard(san, 3)

HAVING game_site == 'Palma de Mallorca'
SELECT *
FROM games_5
WHERE getBoard(san, 3)

HAVING game_site == 'Palma de Mallorca'
SELECT *
FROM games_1
WHERE getBoard(san, 3)

-- Query 2
-- Return the games played in Leningrad and remove its opening move

HAVING game_site == 'Leningrad'
SELECT *
FROM games_100
WHERE getFirstMoves(san, 1);

HAVING game_site == 'Leningrad'
SELECT *
FROM games_20
WHERE getFirstMoves(san, 1);

HAVING game_site == 'Leningrad'
SELECT *
FROM games_5
WHERE getFirstMoves(san, 1);

HAVING game_site == 'Leningrad'
SELECT *
FROM games_1
WHERE getFirstMoves(san, 1);

-- Query 3
-- Return the games which 6 first moves are the same of the Game of the Century

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_100
WHERE hasOpening(san, gotc);

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_20
WHERE hasOpening(san, gotc);

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_5
WHERE hasOpening(san, gotc);

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_1
WHERE hasOpening(san, gotc);

-- Query 4
-- Return the games which contain the in their first 10 half-moves the final board of Kasparov vs. Topalov, Wijk aan Zee 1999

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_100
WHERE hasBoard(san, '8/P6p/6p1/5p2/5P2/2p3P1/3r3P/2K1k3');

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_20
WHERE hasBoard(san, '8/P6p/6p1/5p2/5P2/2p3P1/3r3P/2K1k3');

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_5
WHERE hasBoard(san, '8/P6p/6p1/5p2/5P2/2p3P1/3r3P/2K1k3');

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_1
WHERE hasBoard(san, '8/P6p/6p1/5p2/5P2/2p3P1/3r3P/2K1k3');


