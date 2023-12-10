--sudo -u postgres psql chess

DROP TABLE IF EXISTS games_100;


DROP EXTENSION IF EXISTS chess;-- <---- to uncomment to run our extension
CREATE EXTENSION chess;-- <---- also this has to be uncommented


CREATE TABLE games_100 (
    id SERIAL PRIMARY KEY,
    notation san,
    player VARCHAR(255),
    game_site VARCHAR(255)
);

COPY games_100(notation, player, game_site)
FROM '/home/nb/Desktop/DBSA/chess-postgres-extension/csv_games_10.csv'
DELIMITER ',' CSV HEADER;

--Basics

select *
from games_100;

select count(*)
from games_100;

/*

SELECT getBoard(notation, 3)
FROM games_100
WHERE game_site = 'Palma de Mallorca';

SELECT getFirstMoves(notation, 1)
FROM games_100
WHERE game_site = 'Leningrad';

SELECT count(*)
FROM games_100
WHERE hasOpening(notation, '1.e4 '::san);

select hasBoard(notation,'RNBQKBNR/PPPP1PPP/8/8/3P4/8/ppp1pppp/rnbqkbnr w KQkq - 0 1'::fen, 200)
from games_100;

select *
from games_100
where hasBoard(notation,'RNBQKBNR/PPPP1PPP/8/8/3P4/8/ppp1pppp/rnbqkbnr w KQkq - 0 1'::fen, 200);


DROP INDEX IF EXISTS san_index;
CREATE INDEX san_index ON games_1(notation) ;

SET enable_seqscan = off;
explain 
SELECT count(*)
FROM games_1
WHERE hasOpening(notation, '1.e4 '::san);
*/