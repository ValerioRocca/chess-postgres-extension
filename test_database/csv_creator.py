import csv
import os
import chess.pgn
import pandas as pd
import random


# ---> PART 1: CREATE 100% DB

def extract_game_info(pgn_file_path):
    # Create a list to store game information
    game_info_list = []

    # Get the filename (without extension) from the provided path
    player_name = os.path.splitext(os.path.basename(pgn_file_path))[0]

    # Open the PGN file
    with open(pgn_file_path, 'r') as pgn_file:
        game = chess.pgn.read_game(pgn_file)
        while game is not None:
            # Extract relevant game information
            site = game.headers.get('Site', 'N/A')

            # Initialize a chess board to convert moves to SAN notation
            board = game.board()
            san_moves = []

            # Initialize the move number
            move_number = 1

            for move in game.mainline_moves():
                if board.turn:  # Check if it's a white move
                    san_move = f'{move_number}. {board.san(move)}'
                else:
                    san_move = board.san(move)
                    move_number += 1
                san_moves.append(san_move)
                board.push(move)

            # Join the SAN moves into a single string
            san_moves_str = ' '.join(san_moves)

            game_info_list.append({'notation': san_moves_str, 'player': player_name, 'site': site})

            game = chess.pgn.read_game(pgn_file)

    return game_info_list

def append_game_info_to_csv(game_info, output_csv_file):
    # Check if the output CSV file already exists
    file_exists = os.path.isfile(output_csv_file)

    with open(output_csv_file, 'a', newline='') as csv_file:
        fieldnames = ['notation', 'player', 'site']
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)

        if not file_exists:
            writer.writeheader()

        writer.writerows(game_info)

def process_pgn_file(pgn_file_path, output_csv_file):
    game_info = extract_game_info(pgn_file_path)
    append_game_info_to_csv(game_info, output_csv_file)
    
    
def pgn_iterator(folder_path, output_csv_file):
    
    files = os.listdir(folder_path)
    n = 0
    count = 0
    print("Progress: 0%")
    
    # Obtain number of .pgn files (for progress computation)
    for file in files:
        # Check if the file has a .pgn extension
        if file.endswith('.pgn'):
            n += 1
        
    for file in files:
        # Check if the file has a .pgn extension
        if file.endswith('.pgn'):
            # Construct the full path to the file
            file_path = os.path.join(folder_path, file)
            process_pgn_file(file_path, output_csv_file)
            count += 1
            print(f"Progress: {round(count*100/n,1)}%")

output_csv = 'C:\\Users\\valer\\Desktop\\DBSA\\project\\chess-postgres-extension\\test_database\\csv_games_100.csv'
pgn_path = 'C:\\Users\\valer\\Desktop\\DBSA\\project\\chess-postgres-extension\\test_database'

pgn_iterator(pgn_path, output_csv)

# ---> PART 2: CREATE SMALLER DBs

# Load the CSV file into a DataFrame
df = pd.read_csv('C:\\Users\\valer\\Desktop\\DBSA\\project\\chess-postgres-extension\\test_database\\csv_games_100.csv')

# Calculate the number of rows to remove
n_rows_to_remove_50 = int(len(df) * 0.50)
n_rows_to_remove_25 = int(len(df) * 0.75)
n_rows_to_remove_10 = int(len(df) * 0.90)

# Create a list of random row indices to remove
rows_to_remove_50 = random.sample(range(len(df)), n_rows_to_remove_50)
rows_to_remove_25 = random.sample(range(len(df)), n_rows_to_remove_25)
rows_to_remove_10 = random.sample(range(len(df)), n_rows_to_remove_10)

# Drop the selected rows from the DataFrame
df_50 = df.drop(rows_to_remove_50)
df_25 = df.drop(rows_to_remove_25)
df_10 = df.drop(rows_to_remove_10)

# Save the modified DataFrame to a new CSV file
df_50.to_csv('C:\\Users\\valer\\Desktop\\DBSA\\project\\chess-postgres-extension\\test_database\\csv_games_50.csv', index=False)
df_25.to_csv('C:\\Users\\valer\\Desktop\\DBSA\\project\\chess-postgres-extension\\test_database\\csv_games_25.csv', index=False)
df_10.to_csv('C:\\Users\\valer\\Desktop\\DBSA\\project\\chess-postgres-extension\\test_database\\csv_games_10.csv', index=False)