--Query 5
CREATE INDEX IF NOT EXISTS san_index_100 ON games_100(notation);
CREATE INDEX IF NOT EXISTS san_index_20 ON games_20(notation);
CREATE INDEX IF NOT EXISTS san_index_5 ON games_5(notation);
CREATE INDEX IF NOT EXISTS san_index_1 ON games_1(notation);

-- Consultas

SELECT count(*) FROM games_100  WHERE hasOpening(notation, '1.e4 '::san);
SELECT count(*) FROM games_20 WHERE hasOpening(notation, '1.e4 '::san);
SELECT count(*) FROM games_5 WHERE hasOpening(notation, '1.e4 '::san);
SELECT count(*) FROM games_1 WHERE hasOpening(notation, '1.e4 '::san);



-- Consultas
SET enable_seqscan TO OFF;
SELECT count(*) FROM games_100  WHERE hasOpening(notation, '1.e4 '::san);
SET enable_seqscan TO OFF;
SELECT count(*) FROM games_20 WHERE hasOpening(notation, '1.e4 '::san);
SET enable_seqscan TO OFF;
SELECT count(*) FROM games_5 WHERE hasOpening(notation, '1.e4 '::san);
SET enable_seqscan TO OFF;
SELECT count(*) FROM games_1 WHERE hasOpening(notation, '1.e4 '::san);

SET enable_seqscan TO OFF;
SELECT count(*) FROM games_100 WHERE hasOpening(notation, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7'::san);

SET enable_seqscan TO OFF;
SELECT count(*) FROM games_20 WHERE hasOpening(notation, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7'::san);

SET enable_seqscan TO OFF;
SELECT count(*) FROM games_5 WHERE hasOpening(notation, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7'::san);

SET enable_seqscan TO OFF;
SELECT count(*) FROM games_1 WHERE hasOpening(notation, '1. Nf3 Nf6 2. c4 g6 3. Nc3 Bg7'::san);

