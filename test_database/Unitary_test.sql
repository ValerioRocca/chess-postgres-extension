
DROP INDEX IF EXISTS san_index;
DROP TABLE IF EXISTS games_1 CASCADE;
DROP EXTENSION IF EXISTS chess CASCADE; --<---- to uncomment to run our extension

CREATE EXTENSION chess; --<---- also this has to be uncommented

CREATE TABLE games_1 (
    id SERIAL PRIMARY KEY,
    notation san,
    player VARCHAR(255),
    game_site VARCHAR(255)
);


COPY games_1(notation, player, game_site)
FROM '/home/mcsalazart/Downloads/BDMA/Systems architecture/project/chess-postgres-extension/test_database/csv_games_10.csv' DELIMITER ',' CSV HEADER;




select *
from games_1;

SELECT getBoard(notation, 3)
FROM games_1
WHERE  game_site = 'Palma de Mallorca';

SELECT getFirstMoves(notation, 1)
FROM games_1
WHERE game_site = 'Leningrad';


SELECT count(*)
FROM games_1
WHERE hasOpening(notation, '1.e4 '::san);

SELECT count(*)
FROM games_1
WHERE hasOpening(notation, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7'::san);


SELECT count(*)
from games_1
where hasBoard(notation,'RNBQKBNR/PPPP1PPP/8/8/3P4/8/ppp1pppp/rnbqkbnr w KQkq - 0 1', 200);


CREATE INDEX IF NOT EXISTS san_index ON games_1(notation);

-- Consultas
SET enable_seqscan TO OFF;
SELECT count(*) FROM games_1  WHERE hasOpening(notation, '1.e4 '::san);
SET enable_seqscan TO OFF;
SELECT count(*) FROM games_1 WHERE hasOpening(notation, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7'::san);



