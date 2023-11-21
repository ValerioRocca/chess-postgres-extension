/*
* I/O
*/

CREATE OR REPLACE FUNCTION san_input(cstring)
    RETURNS san
    AS 'MODULE_PATHNAME'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_output(san)
    RETURNS cstring
    AS 'MODULE_PATHNAME'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION fen_input(cstring)
    RETURNS fen
    AS 'MODULE_PATHNAME'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION fen_output(fen)
    RETURNS cstring
    AS 'MODULE_PATHNAME'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

/*
* DATA TYPES
*/
CREATE TYPE san (
    internallength = 850,
    input = san_input,
    output = san_output);

CREATE TYPE fen (
    internallength = 850,
    input = fen_input,
    output = fen_output);

/*
* operators
*/

CREATE OR REPLACE FUNCTION san_eq(san, san)
    RETURNS boolean
    AS 'MODULE_PATHNAME','san_eq'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_ne(san, san)
    RETURNS boolean
    AS 'MODULE_PATHNAME','san_ne'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_get(san, san)
    RETURNS boolean
    AS 'MODULE_PATHNAME','san_get'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_gt(san, san)
    RETURNS boolean
    AS 'MODULE_PATHNAME','san_gt'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_lt(san, san)
    RETURNS boolean
    AS 'MODULE_PATHNAME','san_lt'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_let(san, san)
    RETURNS boolean
    AS 'MODULE_PATHNAME','san_let'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

--operator for two san
CREATE OPERATOR = (
    LEFTARG = san, RIGHTARG = san,
    PROCEDURE = san_eq,
    COMMUTATOR = =, NEGATOR = <>
    );

CREATE OPERATOR <> (
    LEFTARG = san, RIGHTARG = san,
    PROCEDURE = san_ne,
    COMMUTATOR = <>, NEGATOR = =
    );

CREATE OPERATOR <= (
    LEFTARG = san, RIGHTARG = san,
    PROCEDURE = san_let,
    COMMUTATOR = <=, NEGATOR = >
    );

CREATE OPERATOR >= (
    LEFTARG = san, RIGHTARG = san,
    PROCEDURE = san_get,
    COMMUTATOR = >=, NEGATOR = <
    );    


CREATE OPERATOR < (
    LEFTARG = san, RIGHTARG = san,
    PROCEDURE = san_lt,
    COMMUTATOR = <, NEGATOR = >=
    );

CREATE OPERATOR > (
    LEFTARG = san, RIGHTARG = san,
    PROCEDURE = san_gt,
    COMMUTATOR = >, NEGATOR = <=
    );    
/*
 *FUNCTIONS
 */
CREATE OR REPLACE FUNCTION get_first_moves(san,int)
    RETURNS cstring
    AS 'MODULE_PATHNAME','get_first_moves'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION get_board(san,int)
    RETURNS cstring
    AS 'MODULE_PATHNAME','get_board'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION has_opening(san,san)
    RETURNS boolean
    AS 'MODULE_PATHNAME','has_opening'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION has_board(san,fen,int)
    RETURNS boolean
    AS 'MODULE_PATHNAME','has_board'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;
