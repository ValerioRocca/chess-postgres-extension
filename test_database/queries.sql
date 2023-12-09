
-- Query 1
-- Return the board at half-move 3 of the games played in Palma de Mallorca

SELECT *
FROM games_100
WHERE get_board(notation, 3) AND game_site == 'Palma de Mallorca';

SELECT *
FROM games_20
WHERE get_board(notation, 3) AND game_site == 'Palma de Mallorca';

SELECT *
FROM games_5
WHERE get_board(notation, 3) AND game_site == 'Palma de Mallorca';

SELECT *
FROM games_1
WHERE get_board(notation, 3) AND game_site == 'Palma de Mallorca';

-- Query 2
-- Return the games played in Leningrad and remove its opening move

SELECT get_first_moves(notation, 1)
FROM games_100
WHERE game_site == 'Leningrad';

SELECT get_first_moves(notation, 1)
FROM games_20
WHERE game_site == 'Leningrad';

SELECT get_first_moves(san, 1)
FROM games_5
WHERE game_site == 'Leningrad';

SELECT get_first_moves(notation, 1)
FROM games_1
WHERE game_site == 'Leningrad';

-- Query 3
-- Count the number of games that start with move "1.e4"

SELECT count(*)
FROM games_100
WHERE has_opening(notation, '1.e4 '::san);

SELECT count(*)
FROM games_20
WHERE has_opening(notation, '1.e4 '::san);

SELECT count(*)
FROM games_5
WHERE has_opening(notation, '1.e4 '::san);

SELECT count(*)
FROM games_1
WHERE has_opening(notation, '1.e4 '::san);


-- Query 4
-- Count the games which contain the in their first 10 half-moves the described board

SELECT *, count(*)
FROM games_100
WHERE has_board(notation, 'r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1'::fen, 10);

SELECT *, count(*)
FROM games_20
WHERE has_board(notation, 'r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1'::fen, 10);

SELECT *, count(*)
FROM games_5
WHERE has_board(notation, 'r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1'::fen, 10);

SELECT *, count(*)
FROM games_1
WHERE has_board(notation, 'r1bk3r/p2pBpNp/n4n2/1p1NP2P/6P1/3P4/P1P1K3/q5b1'::fen, 10);
