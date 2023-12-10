#include <postgres.h>
#include "utils/builtins.h"
#include "libpq/pqformat.h"
#include "fmgr.h"
#include "access/gin.h"
#include "smallchesslib.h"
#include <string.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

PG_MODULE_MAGIC;

#define DatumGetFenP(X) ((Fen *) DatumGetPointer(X))
#define FenPGetDatum(X) PointerGetDatum(X)
#define PG_GETARG_FEN_P(n) DatumGetFenP(PG_GETARG_DATUM(n))
#define PG_RETURN_FEN_P(x) return FenPGetDatum(x)

#define DatumGetSanP(X) ((San *) DatumGetPointer(X))
#define SanPGetDatum(X) PointerGetDatum(X)
#define PG_GETARG_SAN_P(n) DatumGetSanP(PG_GETARG_DATUM(n))
#define PG_RETURN_SAN_P(x) return SanPGetDatum(x)

typedef struct {
    char* board[8];//max size<90
    char turn[2];
    char rock[5];
    char en_passant[3];
    char half_move[3];
    char full_move[3];
} Fen;

typedef struct {
    char* san;
    int size_of_san;
} San;

bool text_eq(San *san_one, San *san_two);
void is_fen(char *fen);
Fen *fen_constructor(char *fen_char);
San *san_constructor(char *san_char);
char* internal_get_first_moves(const char* PGN, int N);
char* internal_get_board(const char* PGN, int N,int san_size);
bool internal_has_opening(const char* PGNone, const char* PGNtwo);
bool internal_has_board(San *my_san, const char* FEN, int N);
char ** str_matrix_allocation(int rows, int columns);
void free_str_matrix(char **matrix, int rows);
char* get_only_board(SCL_Board board);

PG_FUNCTION_INFO_V1(san_input);
Datum san_input(PG_FUNCTION_ARGS) {
    char *input_str = PG_GETARG_CSTRING(0);
    PG_RETURN_SAN_P(san_constructor(input_str));// Return the san data type
}

PG_FUNCTION_INFO_V1(san_output);
Datum san_output(PG_FUNCTION_ARGS) {
    San *my_san = PG_GETARG_SAN_P(0);
    char *result = (char *)palloc(sizeof(my_san->san)+1);
    strcpy(result, my_san->san);
    PG_FREE_IF_COPY(my_san,0);
    PG_RETURN_CSTRING(result);
}

PG_FUNCTION_INFO_V1(san_eq);
Datum san_eq(PG_FUNCTION_ARGS) {
    PG_RETURN_BOOL(text_eq(PG_GETARG_SAN_P(0),PG_GETARG_SAN_P(1)));
}
PG_FUNCTION_INFO_V1(san_ne);
Datum san_ne(PG_FUNCTION_ARGS) {
    PG_RETURN_BOOL(!text_eq(PG_GETARG_SAN_P(0),PG_GETARG_SAN_P(1)));
}

PG_FUNCTION_INFO_V1(san_lt_2);
Datum san_lt_2(PG_FUNCTION_ARGS) {
    San* san_one = PG_GETARG_SAN_P(0);
    San* san_two = PG_GETARG_SAN_P(1);
    if (strcmp(san_one->san, san_two->san) < 0) {
        PG_RETURN_BOOL(1); // true
    } else {
        PG_RETURN_BOOL(0); // false
    }
}

PG_FUNCTION_INFO_V1(san_le_2);
Datum san_le_2(PG_FUNCTION_ARGS) {
    San* san_one = PG_GETARG_SAN_P(0);
    San* san_two = PG_GETARG_SAN_P(1);
    if (strcmp(san_one->san, san_two->san) <= 0) {
        PG_RETURN_BOOL(1); // true
    } else {
        PG_RETURN_BOOL(0); // false
    }
}

PG_FUNCTION_INFO_V1(san_gt_2); // >
Datum san_gt_2(PG_FUNCTION_ARGS) {
    San* san_one = PG_GETARG_SAN_P(0);
    San* san_two = PG_GETARG_SAN_P(1);
    if (strcmp(san_one->san, san_two->san) > 0) {
        PG_RETURN_BOOL(1); // true
    } else {
        PG_RETURN_BOOL(0); // false
    }
}

PG_FUNCTION_INFO_V1(san_ge_2);
Datum san_ge_2(PG_FUNCTION_ARGS) {
    San* san_one = PG_GETARG_SAN_P(0);
    San* san_two = PG_GETARG_SAN_P(1);
    if (strcmp(san_one->san, san_two->san) >= 0) {
        PG_RETURN_BOOL(1); // true
    } else {
        PG_RETURN_BOOL(0); // false
    }
}

PG_FUNCTION_INFO_V1(san_cmp_2);
Datum san_cmp_2(PG_FUNCTION_ARGS) {
    San* san_one = PG_GETARG_SAN_P(0);
    San* san_two = PG_GETARG_SAN_P(1);
    PG_RETURN_INT64(strcmp(san_one->san, san_two->san));
}

PG_FUNCTION_INFO_V1(san_eq_num);
Datum san_eq_num(PG_FUNCTION_ARGS) {
    San* my_san = PG_GETARG_SAN_P(0);
    int input_int = PG_GETARG_INT32(1);
    if (my_san->size_of_san == input_int) {
        PG_RETURN_BOOL(1); // true
    } else {
        PG_RETURN_BOOL(0); // false
    }
}
PG_FUNCTION_INFO_V1(san_ne_num);
Datum san_ne_num(PG_FUNCTION_ARGS) {
    San* my_san = PG_GETARG_SAN_P(0);
    int input_int = PG_GETARG_INT32(1);
    if (my_san->size_of_san != input_int) {
        PG_RETURN_BOOL(1); // true
    } else {
        PG_RETURN_BOOL(0); // false
    }
}

PG_FUNCTION_INFO_V1(san_lt_num);
Datum san_lt_num(PG_FUNCTION_ARGS) {
    San* my_san = PG_GETARG_SAN_P(0);
    int input_int = PG_GETARG_INT32(1);
    if (my_san->size_of_san < input_int) {
        PG_RETURN_BOOL(1); // true
    } else {
        PG_RETURN_BOOL(0); // false
    }
}

PG_FUNCTION_INFO_V1(san_le_num);
Datum san_le_num(PG_FUNCTION_ARGS) {
    San* my_san = PG_GETARG_SAN_P(0);
    int input_int = PG_GETARG_INT32(1);
    if (my_san->size_of_san <= input_int) {
        PG_RETURN_BOOL(1); // true
    } else {
        PG_RETURN_BOOL(0); // false
    }
}

PG_FUNCTION_INFO_V1(san_gt_num); // >
Datum san_gt_num(PG_FUNCTION_ARGS) {
    San* my_san = PG_GETARG_SAN_P(0);
    int input_int = PG_GETARG_INT32(1);
    if (my_san->size_of_san > input_int) {
        PG_RETURN_BOOL(1); // true
    } else {
        PG_RETURN_BOOL(0); // false
    }
}

PG_FUNCTION_INFO_V1(san_ge_num);
Datum san_ge_num(PG_FUNCTION_ARGS) {
    San* my_san = PG_GETARG_SAN_P(0);
    int input_int = PG_GETARG_INT32(1);
    if (my_san->size_of_san >= input_int) {
        PG_RETURN_BOOL(1); // true
    } else {
        PG_RETURN_BOOL(0); // false
    }
}



PG_FUNCTION_INFO_V1(fen_input);
Datum fen_input(PG_FUNCTION_ARGS) {
    char *input_str = PG_GETARG_CSTRING(0);
    Fen *fen = fen_constructor(input_str);
    PG_RETURN_FEN_P(fen);// Return the fen data type
}

PG_FUNCTION_INFO_V1(fen_output);
Datum fen_output(PG_FUNCTION_ARGS) {
    Fen *fen = PG_GETARG_FEN_P(0);
    char *result = psprintf("%s/%s/%s/%s/%s/%s/%s/%s %s %s %s %s %s", fen->board[0],fen->board[1],fen->board[2],fen->board[3],fen->board[4],fen->board[5]
            ,fen->board[6],fen->board[7],fen->turn,fen->rock,fen->en_passant,fen->half_move,fen->full_move);
    PG_FREE_IF_COPY(fen,0);
    PG_RETURN_CSTRING(result);
}

PG_FUNCTION_INFO_V1(getFirstMoves);
Datum getFirstMoves(PG_FUNCTION_ARGS) {
    San *my_san = PG_GETARG_SAN_P(0); // Get input san pointer
    int input_int = PG_GETARG_INT32(1);
    char *result = internal_get_first_moves(my_san->san, input_int);
    PG_FREE_IF_COPY(my_san, 0);
    PG_RETURN_CSTRING(result);
}

PG_FUNCTION_INFO_V1(getBoard);
Datum getBoard(PG_FUNCTION_ARGS) {
    San *my_san = PG_GETARG_SAN_P(0); // Get input san pointer
    int input_int = PG_GETARG_INT32(1);
    char *result = internal_get_board(my_san->san,input_int, my_san->size_of_san);
    PG_FREE_IF_COPY(my_san, 0);
    PG_RETURN_CSTRING(result);
}

PG_FUNCTION_INFO_V1(hasOpening);
Datum hasOpening(PG_FUNCTION_ARGS) {
    San *my_san_one = PG_GETARG_SAN_P(0); // Get input san pointer
    San *my_san_two = PG_GETARG_SAN_P(1); // Get input san pointer
    bool result = internal_has_opening(my_san_one->san,my_san_two->san);
    free(my_san_one->san);
    free(my_san_two->san);
    PG_FREE_IF_COPY(my_san_one, 0);
    PG_FREE_IF_COPY(my_san_two, 0);
    PG_RETURN_BOOL(result);
}

PG_FUNCTION_INFO_V1(hasBoard);
Datum hasBoard(PG_FUNCTION_ARGS) {
    San *my_san = PG_GETARG_SAN_P(0);
    Fen *fen = PG_GETARG_FEN_P(1); // Get input text as a text pointer
    char *input_fen = (char *)palloc0(sizeof(char)*100);
    int len = 100;//87
    snprintf(input_fen,len,"%s/%s/%s/%s/%s/%s/%s/%s", fen->board[0],fen->board[1],fen->board[2],fen->board[3],fen->board[4],fen->board[5]
            ,fen->board[6],fen->board[7]);
    for(int i=0;i<8;i++){
        free(fen->board[i]);
    }
    int input_int = PG_GETARG_INT32(2);
    bool result = internal_has_board(my_san,input_fen,input_int);
    PG_FREE_IF_COPY(input_fen, 0);
    PG_RETURN_BOOL(result);
}

PG_FUNCTION_INFO_V1(extract_value);
Datum extract_value(PG_FUNCTION_ARGS){
    ereport(INFO,errmsg("inside value"));

    //extract custom data types
    San* my_san = PG_GETARG_SAN_P(0);
    int32 *nkeys = (int32 *)PG_GETARG_POINTER(1);
    nkeys = &my_san->size_of_san;
    Datum* result = (Datum *)palloc0(sizeof(Datum)*my_san->size_of_san);

    SCL_Record record;//Hold record of the game

    char* tempFirstMovesBoard;
    int countHalfMoves = 0;//start the half moves counter at one

    uint8_t squareFrom;
    uint8_t squareTo;
    char promotedPiece;
    uint8_t getMove;
    SCL_recordFromPGN(record, my_san->san);
    SCL_Game *game = (SCL_Game *)palloc0(sizeof(SCL_Game));
    SCL_gameInit(game, 0);
    int first = 1;
    while((countHalfMoves<my_san->size_of_san+1)){//stop when we have verified all the half moves or if we find the board state
        if (first == 0) {
            getMove = SCL_recordGetMove(record, countHalfMoves, &squareFrom, &squareTo, &promotedPiece);
            SCL_gameMakeMove(game, squareFrom, squareTo, promotedPiece);
        }
        if(first == 0){
            countHalfMoves += 1;
        }
        first = 0;
        tempFirstMovesBoard = get_only_board(game->board);//getting the FEN of the board state for every half move played
        result[countHalfMoves] = CStringGetDatum(tempFirstMovesBoard);
        pfree(tempFirstMovesBoard);
    }
    ereport(INFO,errmsg("end value"));
    PG_RETURN_POINTER(result);

}

PG_FUNCTION_INFO_V1(extract_query);
Datum extract_query(PG_FUNCTION_ARGS){
    ereport(INFO,errmsg("inside query"));
    Datum query = PG_GETARG_DATUM(0);
    int32 *nkeys = (int32 *) PG_GETARG_POINTER(1);
    Datum *board_datum;

    //extract custom data for datum
    char* str_fen = DatumGetCString(DirectFunctionCall1(int4out, query));
    Fen* fen = fen_constructor(str_fen);
    char *board = (char *)palloc0(sizeof(char)*100);
    int len = 100;//87
    snprintf(board,len,"%s/%s/%s/%s/%s/%s/%s/%s", fen->board[0],fen->board[1],fen->board[2],fen->board[3],fen->board[4],fen->board[5],fen->board[6],fen->board[7]);
    board_datum=(Datum *)CStringGetDatum(board);
    nkeys=1;
    ereport(INFO,errmsg("end query"));
    PG_RETURN_POINTER(board);
}

PG_FUNCTION_INFO_V1(compare);
Datum compare(PG_FUNCTION_ARGS){
    ereport(INFO,errmsg("inside compare"));
    //extract custom data type
    char* board_one = PG_GETARG_CSTRING(0);
    char* board_two = PG_GETARG_CSTRING(1);
    int32 result;

    int size_board_one = 0;
    int size_board_two = 0;
    for(int i=0; board_one != '\0'; i++){
        if (isalnum(board_one[i])){
            size_board_one += (int)(board_one[i]);
        }
    }
    for(int i=0; board_two != '\0'; i++){
        if (isalnum(board_two[i])){
            size_board_two += (int)(board_two[i]);
        }
    }
    size_board_one=64-size_board_one;
    size_board_two=64-size_board_two;

    //compare the values
    if (size_board_one<size_board_two) result = -1;
    else if (size_board_one>size_board_two) result = 1;
    else result = 0;
    ereport(INFO,errmsg("end compare"));
    PG_RETURN_INT32(result);
}

PG_FUNCTION_INFO_V1(tri_consistent);
Datum tri_consistent(PG_FUNCTION_ARGS){
    GinTernaryValue *check = (GinTernaryValue *)PG_GETARG_POINTER(0);
    PG_RETURN_BOOL(check[0]);
}

PG_FUNCTION_INFO_V1(consistent);
Datum consistent(PG_FUNCTION_ARGS){
    bool *check = (bool *)PG_GETARG_POINTER(0);
    PG_RETURN_BOOL(check[0]);
}

bool text_eq(San *san_one, San *san_two) {
    int result = strcmp(san_one->san, san_two->san);
    bool areEqual = (result == 0);
    return areEqual;
}

San *san_constructor(char *san_char){
    SCL_Record r;
    SCL_recordFromPGN(r, san_char);
    San *my_san = (San *)palloc0(sizeof(San));
    my_san->size_of_san = (int)SCL_recordLength(r);
    my_san->san = internal_get_first_moves(san_char, my_san->size_of_san);
    return my_san;
}

Fen *fen_constructor(char *fen_char){
    is_fen(fen_char);
    Fen *my_fen = palloc0(sizeof(Fen)+1);
    const char delimiters[] = " /";
    char *token;
    int count = 0;

    // Get the first token
    token = strtok(fen_char, delimiters);
    // Keep printing tokens until no more tokens are available
    while (token != NULL && count <= 12) {
        if(count <= 7){
            my_fen->board[count] = (char*)malloc(sizeof(token)+1);
            strcpy(my_fen->board[count],token);
        }
        switch(count) {
            case 8:
                strcpy(my_fen->turn,token);
                //my_fen->turn = (strcmp(token, "b") == 0);//black 0 white 1
                break;
            case 9:
                strcpy(my_fen->rock,token);
                break;
            case 10:
                strcpy(my_fen->en_passant,token);
                break;
            case 11:
                strcpy(my_fen->half_move,token);
                //my_fen->half_move = atoi(token);
                break;
            case 12:
                strcpy(my_fen->full_move,token);
                //my_fen->full_move = atoi(token);
                break;
        }
        // Get the next token
        token = strtok(NULL, delimiters);
        count += 1;
    }

    return my_fen;
}

char ** str_matrix_allocation(int rows, int columns){
    char **result;
    // Allocate memory for rows
    result = (char **)palloc(rows * sizeof(char *));
    for (int i = 0; i < rows; i++) {
        result[i] = (char *)palloc(columns * sizeof(char));
    }
    return result;
}

void free_str_matrix(char **matrix, int rows){
    for (int i = 0; i < rows; i++) {
        //pfree(matrix[i]);
    }
    //pfree(matrix);
}

char* internal_get_first_moves(const char* PGN, int N){
    if(N<0){N=0;}//Negative numbers do not make sense
    int hMovesRemaining = N % 2;
    int fullMoves = (N / 2) + hMovesRemaining;//Moves to take into account
    if (hMovesRemaining == 0) { hMovesRemaining = 2; }//Number of half moves to take into account for the last move to account for

    //char firstMoves[N+fullMoves][7];//list of moves (Move #, half move white, half move black)
    char **firstMoves = str_matrix_allocation(N+fullMoves,7);//list of moves (Move #, half move white, half move black)
    char* firstMovesSolution = (char*)malloc(((N+fullMoves)*7) * sizeof(char)+1);
    strcpy(firstMovesSolution, "");//Copy empty stream into the char* to remove unwanted artifacts

    if(N>0) {//only if we need at least one half-move
        size_t length = strlen(PGN);
        char *PGNcopy = (char*)palloc(length+1);
        strcpy(PGNcopy, PGN);//copy the const PGN so whe can modify it

        const char *separators = " .";//separators are " " and ".", so the notation accepted are {1. e3 E5 2. a3 ...} and {1.e3 E5 2.a3 ...}
        char strFullMoves[10];
        sprintf(strFullMoves, "%d", fullMoves);//string containing the move where we are stopping, converted to string

        char *strToken = strtok(PGNcopy, separators);//recuperating the first character before a point or a space
        int finalMove = strcmp(strToken, strFullMoves);

        char period[] = ".";
        char space[] = " ";
        int count = 0;
        while (strToken != NULL &&
               hMovesRemaining > 0) {//stop when we read all the PGN or we read all the half moves we needed
            strcpy(firstMoves[count], strToken);//adding Move number to the list
            strcat(firstMoves[count], period);//adding point after the move number to return in PGN notation

            strToken = strtok(NULL, separators);//recuperating the first half move
            if (strToken != NULL) {
                count += 1;
                strcpy(firstMoves[count], strToken);//adding First half move to the list
                strcat(firstMoves[count], space);//adding space between two half moves
                if (finalMove == 0) {//if we have arrived at the last move
                    hMovesRemaining -= 1;//remove a half move
                }

                if (hMovesRemaining >= 1) {//verify that we still have half moves left to copy
                    strToken = strtok(NULL, separators);//recuperating the second half move
                    if (strToken != NULL) {
                        count += 1;
                        strcpy(firstMoves[count], strToken);//adding Second half move to the list
                        strcat(firstMoves[count], space);//adding space between second half move and next move number

                        if (finalMove == 0) {//if we have arrived at the last move
                            hMovesRemaining -= 1;//remove a half move
                        } else {
                            strToken = strtok(NULL, separators);//recuperating the next Move number
                            finalMove = strcmp(strToken,
                                               strFullMoves);//compare the next move number with the one where we should stop
                            count += 1;//+3 in total because we have (move number, first half move, second half move)
                        }
                    }
                }
            }
        }
        for (int i = 0; i < count + 1; i++) {//iteration to concatenate the list of move numbers and half moves into a single string
            strcat(firstMovesSolution, firstMoves[i]);
        }
        //pfree(PGNcopy);
    }
    free_str_matrix(firstMoves,N+fullMoves);
    return firstMovesSolution;
}

char* get_only_board(SCL_Board board){
    char* solution;
    solution = (char*)palloc(85 * sizeof(char));
    strcpy(solution, "");
    int t = SCL_boardToFEN(board, solution);
    strcpy(solution, board);
    char* parseSolution = (char*)palloc0(85 * sizeof(char));
    strcpy(parseSolution, "");
    int count = 0;
    char strcount[2];
    char temp[2];
    for(int i=0; i<8; i++){
        count = 0;
        for(int k = i*8; k<(i+1)*8; k++){
            sprintf(temp, "%c", solution[k]);
            if (strcmp(temp, ".")==0){
                count++;
            }
            else{
                if (count>0){
                    sprintf(strcount, "%d", count);
                    strcat(parseSolution, strcount);
                    count = 0;
                }
                strcat(parseSolution, temp);

            }
        }
        if (count>0){
            sprintf(strcount, "%d", count);
            strcat(parseSolution, strcount);

        }
        if(i<7){
            strcat(parseSolution, "/");

        }

    }
    //pfree(solution);
    return parseSolution;
}

char* internal_get_board(const char* PGN, int N, int san_size){
    if(san_size < N){
        N = san_size;
    }
    char turn[3], moves[5], bits[10], castling[6], en_passant[3];
    char cols[8][2] = {"a","b","c","d","e","f","g","h"};
    strcpy(turn,"");//Copy empty stream into the char to remove unwanted artifacts
    strcpy(moves,"");
    strcpy(bits,"");
    strcpy(castling," ");
    strcpy(en_passant,"");

    int castling_count = 0;
    int square_num = 0;

    SCL_Record record;//Hold record of the game
    char* firstMoves = internal_get_first_moves(PGN,N);
    SCL_recordFromPGN(record, firstMoves);
    SCL_Board board;//Holds state of the board
    SCL_boardInit(board);
    uint16_t halfMoves = (uint16_t) N;
    SCL_recordApply(record, board, halfMoves);//Applies the record of moves one after another on a board
    char *parseSolution = get_only_board(board);
    uint8_t white_turn =  SCL_boardWhitesTurn(board);
    if (white_turn == 0) {//Holds playing color (0 = white)
        sprintf(turn, " w");
    } else {
        sprintf(turn, " b");
    }
    sprintf(moves, " %d %d", board[66], (int) floor(board[65] / 2));//half moves since the last capture or pawn advanced and number of full moves
    strcat(parseSolution, turn);//Writes which color has to play
    sprintf(bits,"%x",board[64]);
    if('f' == bits[3]){
        castling_count += 1;
        strcat(castling, "K");
    }
    if('f' == bits[2]){
        castling_count += 1;
        strcat(castling, "Q");
    }
    if('f' == bits[1]){
        castling_count += 1;
        strcat(castling, "k");
    }
    if('f' == bits[0]){
        castling_count += 1;
        strcat(castling, "q");
    }
    if(castling_count == 0){
        strcat(castling, "-");
    }
    if('f' != bits[7]){
        square_num = bits[7] - '0';
        if(white_turn == 0) {
            sprintf(en_passant, " %s3",cols[square_num]);
        }else{
            sprintf(en_passant, " %s6",cols[square_num]);
        }
    }else{
        strcpy(en_passant," -");
    }
    if(castling_count == 0){
        strcat(castling, "-");
    }
    strcat(parseSolution, castling);//Writes the castlings
    strcat(parseSolution, en_passant);//Writes the en passant target square
    strcat(parseSolution, moves);//Writes half moves since the last capture or pawn advanced and number of full moves
    //pfree(firstMoves);
    return parseSolution;
}

bool internal_has_opening(const char* PGNone, const char* PGNtwo){
    bool solution = true;

    size_t lengthOne = strlen(PGNone);
    char *PGNoneCopy = (char*)palloc(lengthOne+1);
    strcpy(PGNoneCopy, PGNone);//copy the const PGN so whe can modify it
    char* pointerOne = NULL;

    size_t lengthTwo = strlen(PGNtwo);
    char *PGNtwoCopy = (char*)palloc(lengthTwo+1);
    strcpy(PGNtwoCopy, PGNtwo);//copy the const PGN so whe can modify it
    char* pointerTwo = NULL;

    const char *separators = " .";//separators are " " and ".", so the notation accepted are {1. e3 E5 2. a3 ...} and {1.e3 E5 2.a3 ...}

    char *strTokenOne = strtok_r(PGNoneCopy, separators,&pointerOne);//recuperating the first character before a point or a space
    char *strTokenTwo = strtok_r(PGNtwoCopy, separators,&pointerTwo);//recuperating the first character before a point or a space
    while (strTokenOne != NULL && strTokenTwo != NULL && solution) {//stop when we read all the PGN or we read all the half moves we needed
        if(strcmp(strTokenOne, strTokenTwo) != 0) {//compare the next move number with the one where we should stop
            solution = false;
        }
        strTokenOne = strtok_r(NULL, separators, &pointerOne);//recuperating the next character before a point or a space
        strTokenTwo = strtok_r(NULL, separators, &pointerTwo);//recuperating the next character before a point or a space
    }
    if(strTokenOne == NULL && strTokenTwo != NULL && solution){//if the chess game we are looking into finishes before the reference chess game
        solution = false;
    }
    return solution;
}

bool internal_has_board(San *my_san, const char* FEN, int N){
    SCL_Record record;//Hold record of the game
    SCL_Game *game;
    char* firstMoves;
    uint16_t halfMoves;
    char* tempFirstMovesBoard;

    bool solution = true;
    int countHalfMoves = 0;//start the half moves counter at one
    int found = 1;//found the game state is false by default

    uint8_t squareFrom;
    uint8_t squareTo;
    char promotedPiece;
    uint8_t getMove;
    SCL_recordFromPGN(record, my_san->san);
    game = (SCL_Game *)palloc0(sizeof(SCL_Game));
    SCL_gameInit(game, 0);
    int first = 1;
    while((countHalfMoves<N+1 && found != 0 && countHalfMoves<my_san->size_of_san+1)){//stop when we have verified all the half moves or if we find the board state
        if (first == 0) {
            getMove = SCL_recordGetMove(record, countHalfMoves, &squareFrom, &squareTo, &promotedPiece);
            SCL_gameMakeMove(game, squareFrom, squareTo, promotedPiece);
        }
        if(first == 0){
            countHalfMoves += 1;
        }
        first = 0;
        tempFirstMovesBoard = get_only_board(game->board);//getting the FEN of the board state for every half move played
        found = strcmp(tempFirstMovesBoard, FEN);
        pfree(tempFirstMovesBoard);
    }
    if(((countHalfMoves == N+1 || countHalfMoves == my_san->size_of_san+1) && found != 0) || N<0){//verify if we have found the board state or if we have finished iterating without finding anything
        solution = false;
    }
    return solution;
}

void is_fen(char *fen){
    SCL_Board board;
    if(SCL_boardFromFEN(board,fen) == 0){
        ereport(ERROR,
                (errcode(ERRCODE_INVALID_PARAMETER_VALUE),
                        errmsg("Invalid fen input: %s", fen)));
    }
}