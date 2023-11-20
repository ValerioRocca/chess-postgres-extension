
-- Query 1
-- Return the board at half-move 3 of the games played in Palma de Mallorca

SELECT *
FROM games_100
WHERE get_board(san, 3) AND game_site == 'Palma de Mallorca'

SELECT *
FROM games_20
WHERE get_board(san, 3) AND game_site == 'Palma de Mallorca'

SELECT *
FROM games_5
WHERE get_board(san, 3) AND game_site == 'Palma de Mallorca'

SELECT *
FROM games_1
WHERE get_board(san, 3) AND game_site == 'Palma de Mallorca'

-- Query 2
-- Return the games played in Leningrad and remove its opening move

SELECT get_first_moves(san, 1)
FROM games_100
WHERE game_site == 'Leningrad';

SELECT get_first_moves(san, 1)
FROM games_20
WHERE game_site == 'Leningrad';

SELECT get_first_moves(san, 1)
FROM games_5
WHERE game_site == 'Leningrad';

SELECT get_first_moves(san, 1)
FROM games_1
WHERE game_site == 'Leningrad';

-- Query 3
-- Return the games which 6 first half-moves are the same of the Game of the Century

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_100
WHERE has_opening(san, gotc);

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_20
WHERE has_opening(san, gotc);

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_5
WHERE has_opening(san, gotc);

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_1
WHERE has_opening(san, gotc);

-- Query 4
-- Return the games which contain the in their first 10 half-moves the final board of Kasparov vs. Topalov, Wijk aan Zee 1999

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_100
WHERE has_board(san, '8/P6p/6p1/5p2/5P2/2p3P1/3r3P/2K1k3');

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_20
WHERE has_board(san, '8/P6p/6p1/5p2/5P2/2p3P1/3r3P/2K1k3');

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_5
WHERE has_board(san, '8/P6p/6p1/5p2/5P2/2p3P1/3r3P/2K1k3');

SELECT *, pg_read_file('C:\Users\valer\Desktop\DBSA\project\chess-postgres-extension\test_database\game_of_the_century.txt') AS gotc;
FROM games_1
WHERE has_board(san, '8/P6p/6p1/5p2/5P2/2p3P1/3r3P/2K1k3');


