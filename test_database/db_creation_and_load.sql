
DROP TABLE IF EXISTS games_100 CASCADE;
DROP TABLE IF EXISTS games_20 CASCADE;
DROP TABLE IF EXISTS games_5 CASCADE;
DROP TABLE IF EXISTS games_1 CASCADE;
DROP EXTENSION IF EXISTS chess CASCADE; --<---- to uncomment to run our extension

CREATE EXTENSION chess; --<---- also this has to be uncommented



CREATE TABLE games_100 (
    id SERIAL PRIMARY KEY,
    notation san,
    player VARCHAR(255),
    game_site VARCHAR(255)
);

CREATE TABLE games_20 (
    id SERIAL PRIMARY KEY,
    notation san,
    player VARCHAR(255),
    game_site VARCHAR(255)
);

CREATE TABLE games_5 (
    id SERIAL PRIMARY KEY,
    notation san,
    player VARCHAR(255),
    game_site VARCHAR(255)
);

CREATE TABLE games_1 (
    id SERIAL PRIMARY KEY,
    notation san,
    player VARCHAR(255),
    game_site VARCHAR(255)
);

COPY games_100(notation, player, game_site)
FROM '/home/mcsalazart/Downloads/BDMA/Systems architecture/project/test_database/csv_games_100.csv' DELIMITER ',' CSV HEADER;

COPY games_20(notation, player, game_site)
FROM '/home/mcsalazart/Downloads/BDMA/Systems architecture/project/test_database/csv_games_50.csv' DELIMITER ',' CSV HEADER;

COPY games_5(notation, player, game_site)
FROM '/home/mcsalazart/Downloads/BDMA/Systems architecture/project/test_database/csv_games_25.csv' DELIMITER ',' CSV HEADER;

COPY games_1(notation, player, game_site)
FROM '/home/mcsalazart/Downloads/BDMA/Systems architecture/project/test_database/csv_games_10.csv' DELIMITER ',' CSV HEADER;