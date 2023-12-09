The folder contain the PGN games of 22 professionists.

The "csv_creator".ipynb take those four files as input and create four different .csv tables with the following structure:
- "notation" containing the SAN notation of the game;
- "player" containing the player of the game (between the aforementioned four);
- "game_site" containing the site where the game was hosted.

The biggest file is obtained by repeating 50 times 79,284 games from 22 players.
The other files are downsamplings of it: 50%, 25%, 10%.
