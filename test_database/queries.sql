SELECT getBoard(notation, 3)
FROM games_100
WHERE game_site = 'Palma de Mallorca';

SELECT getBoard(notation, 3)
FROM games_20
WHERE  game_site = 'Palma de Mallorca';

select getBoard(notation, 3)
FROM games_5
WHERE game_site = 'Palma de Mallorca';

select getBoard(notation, 3)
FROM games_1
WHERE  game_site = 'Palma de Mallorca';

SELECT getBoard(notation, 3)
FROM games_100
WHERE game_site = 'Palma de Mallorca';

SELECT getBoard(notation, 3)
FROM games_20
WHERE  game_site = 'Palma de Mallorca';

select getBoard(notation, 3)
FROM games_5
WHERE game_site = 'Palma de Mallorca';

select getBoard(notation, 3)
FROM games_1
WHERE  game_site = 'Palma de Mallorca';

--Query 2
--Return the games played in Leningrad and remove its opening move

SELECT getFirstMoves(notation, 1)
FROM games_100
WHERE game_site = 'Leningrad';

SELECT getFirstMoves(notation, 1)
FROM games_20
WHERE game_site = 'Leningrad';

SELECT getFirstMoves(notation, 1)
FROM games_5
WHERE game_site = 'Leningrad';

SELECT getFirstMoves(notation, 1)
FROM games_1
WHERE game_site = 'Leningrad';

-- Query 3
-- Count the number of games that start with move "1.e4"

SELECT count(*)
FROM games_100
WHERE hasOpening(notation, '1.e4 '::san);

SELECT count(*)
FROM games_20
WHERE hasOpening(notation, '1.e4 '::san);

SELECT count(*)
FROM games_5
WHERE hasOpening(notation, '1.e4 '::san);

SELECT count(*)
FROM games_1
WHERE hasOpening(notation, '1.e4 '::san);


SELECT count(*)
FROM games_100
WHERE hasOpening(notation, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7'::san);

SELECT count(*)
FROM games_20
WHERE hasOpening(notation, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7'::san);

SELECT count(*)
FROM games_5
WHERE hasOpening(notation, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7'::san);

SELECT count(*)
FROM games_1
WHERE hasOpening(notation, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7'::san);



--Query 4

SELECT count(*)
from games_100
where hasBoard(notation,'RNBQKBNR/PPPP1PPP/8/8/3P4/8/ppp1pppp/rnbqkbnr w KQkq - 0 1', 10);

SELECT count(*)
from games_20
where hasBoard(notation,'RNBQKBNR/PPPP1PPP/8/8/3P4/8/ppp1pppp/rnbqkbnr w KQkq - 0 1', 10);

SELECT count(*)
from games_5
where hasBoard(notation,'RNBQKBNR/PPPP1PPP/8/8/3P4/8/ppp1pppp/rnbqkbnr w KQkq - 0 1', 10);

SELECT count(*)
from games_1
where hasBoard(notation,'RNBQKBNR/PPPP1PPP/8/8/3P4/8/ppp1pppp/rnbqkbnr w KQkq - 0 1', 10);



