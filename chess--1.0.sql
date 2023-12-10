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

CREATE OR REPLACE FUNCTION san_lt_2(san, san)
RETURNS BOOLEAN
AS 'MODULE_PATHNAME','san_lt_2'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_le_2(san, san)
RETURNS BOOLEAN
AS 'MODULE_PATHNAME','san_le_2'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_gt_2(san, san)
RETURNS BOOLEAN
AS 'MODULE_PATHNAME','san_gt_2'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_ge_2(san, san)
RETURNS BOOLEAN
AS 'MODULE_PATHNAME','san_ge_2'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_cmp_2(san, san)
RETURNS INTEGER
AS 'MODULE_PATHNAME','san_cmp_2'
LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;



CREATE OR REPLACE FUNCTION san_eq_num(san, int)
    RETURNS boolean
AS 'MODULE_PATHNAME','san_eq_num'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_ne_num(san, int)
    RETURNS boolean
AS 'MODULE_PATHNAME','san_ne_num'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_lt_num(san, int)
    RETURNS BOOLEAN
AS 'MODULE_PATHNAME','san_lt_num'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_le_num(san, int)
    RETURNS BOOLEAN
AS 'MODULE_PATHNAME','san_le_num'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_gt_num(san, int)
    RETURNS BOOLEAN
AS 'MODULE_PATHNAME','san_gt_num'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION san_ge_num(san, int)
    RETURNS BOOLEAN
AS 'MODULE_PATHNAME','san_ge_num'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;



/*
 *FUNCTIONS
 */
CREATE OR REPLACE FUNCTION getFirstMoves(san,int)
    RETURNS cstring
    AS 'MODULE_PATHNAME','getFirstMoves'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION getBoard(san,int)
    RETURNS cstring
    AS 'MODULE_PATHNAME','getBoard'
    LANGUAGE C IMMUTABLE STRICT PARALLEL SAFE;

CREATE OR REPLACE FUNCTION hasOpening(san,san)
    RETURNS boolean
    AS 'MODULE_PATHNAME','hasOpening'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION hasBoard(san,fen,int)
    RETURNS boolean
    AS 'MODULE_PATHNAME','hasBoard'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION compare(internal, internal)
    RETURNS integer
AS 'MODULE_PATHNAME'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION extract_value(internal, internal, internal)
    RETURNS internal
AS 'MODULE_PATHNAME'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION extract_query(internal, internal, internal, internal, internal, internal, internal)
    RETURNS internal
AS 'MODULE_PATHNAME'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION consistent(internal, internal, internal, internal, internal, internal, internal, internal)
    RETURNS internal
AS 'MODULE_PATHNAME'
    LANGUAGE C IMMUTABLE STRICT;

CREATE OR REPLACE FUNCTION tri_consistent(internal, internal, internal, internal, internal, internal, internal)
    RETURNS internal
AS 'MODULE_PATHNAME'
    LANGUAGE C IMMUTABLE STRICT;


CREATE OPERATOR = (
	LEFTARG = san,
	RIGHTARG = san,
	PROCEDURE = san_eq,
	COMMUTATOR = =,
	NEGATOR = <>
);


COMMENT ON OPERATOR =(san, san) IS 'equals?';

CREATE OPERATOR = (
    LEFTARG = san,
    RIGHTARG = int,
    PROCEDURE = san_eq_num,
    COMMUTATOR = =,
    NEGATOR = <>
    );


COMMENT ON OPERATOR =(san, int) IS 'equals?';

CREATE OPERATOR <> (
	LEFTARG = san,
	RIGHTARG = san,
	PROCEDURE = san_ne,
	COMMUTATOR = <>,
	NEGATOR = =
);
COMMENT ON OPERATOR <>(san, san) IS 'not equals?';

CREATE OPERATOR <> (
    LEFTARG = san,
    RIGHTARG = int,
    PROCEDURE = san_ne_num,
    COMMUTATOR = <>,
    NEGATOR = =
    );
COMMENT ON OPERATOR <>(san, int) IS 'not equals?';

CREATE OPERATOR < (
	LEFTARG = san,
	RIGHTARG = san,
	PROCEDURE = san_lt_2,
	COMMUTATOR = > ,
	NEGATOR = >= 
);
COMMENT ON OPERATOR <(san, san) IS 'less-than';

CREATE OPERATOR < (
    LEFTARG = san,
    RIGHTARG = int,
    PROCEDURE = san_lt_num,
    COMMUTATOR = > ,
    NEGATOR = >=
    );
COMMENT ON OPERATOR <(san, int) IS 'less-than';

CREATE OPERATOR <= (
	LEFTARG = san,
	RIGHTARG = san,
	PROCEDURE = san_le_2,
	COMMUTATOR = >= , 
	NEGATOR = > 
);
COMMENT ON OPERATOR <=(san, san) IS 'less-than-or-equal';

CREATE OPERATOR <= (
    LEFTARG = san,
    RIGHTARG = int,
    PROCEDURE = san_le_num,
    COMMUTATOR = >= ,
    NEGATOR = >
    );
COMMENT ON OPERATOR <=(san, int) IS 'less-than-or-equal';

CREATE OPERATOR > (
	LEFTARG = san,
	RIGHTARG = san,
	PROCEDURE = san_gt_2,
	COMMUTATOR = < ,
	NEGATOR = <= 
);
COMMENT ON OPERATOR >(san, san) IS 'greater-than';

CREATE OPERATOR > (
    LEFTARG = san,
    RIGHTARG = int,
    PROCEDURE = san_gt_num,
    COMMUTATOR = < ,
    NEGATOR = <=
    );
COMMENT ON OPERATOR >(san, int) IS 'greater-than';

CREATE OPERATOR >= (
	LEFTARG = san,
	RIGHTARG = san,
	PROCEDURE = san_ge_2,
	COMMUTATOR = <= , 
	NEGATOR = < 
);
COMMENT ON OPERATOR >=(san, san) IS 'greater-than-or-equal';

CREATE OPERATOR >= (
    LEFTARG = san,
    RIGHTARG = int,
    PROCEDURE = san_ge_num,
    COMMUTATOR = <= ,
    NEGATOR = <
    );
COMMENT ON OPERATOR >=(san, int) IS 'greater-than-or-equal';

CREATE OPERATOR CLASS gin_san
    DEFAULT FOR TYPE san USING gin
    AS
    FUNCTION 1 compare(internal, internal),
    FUNCTION 2 extract_value(internal, internal, internal),
    FUNCTION 3 extract_query(internal, internal, internal, internal, internal, internal, internal),
    FUNCTION 4 consistent(internal, internal, internal, internal, internal, internal, internal, internal),
    FUNCTION 6 tri_consistent(internal, internal, internal, internal, internal, internal, internal),
    STORAGE internal;

CREATE OPERATOR CLASS btree_san
DEFAULT FOR TYPE san USING btree
AS
        OPERATOR        1       <  ,
        OPERATOR        2       <= ,
        OPERATOR        3       =  ,
        OPERATOR        4       >= ,
        OPERATOR        5       >  ,
        FUNCTION        1       san_cmp_2(san, san);