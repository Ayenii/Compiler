/* Compiler Theory and Design
   Duane J. Jarc */

%{
#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <cmath>
using namespace std;
#include "types.h"
#include "listing.h"
#include "symbols.h"
int yylex();
void yyerror(const char* message);
Symbols<Types> symbols;
Types case_return = INT_TYPE;
%}
%define parse.error verbose
%union
{
CharPtr iden;
Types type;
}
%token <iden> IDENTIFIER
%token <type> INT_LITERAL REAL_LITERAL BOOL_LITERAL CASE
ELSE IF ENDIF
%token<type> ADDOP MULOP RELOP ANDOP EXPOP REMOP OROP NOTOP
%token<type> BEGIN_ BOOLEAN END ENDREDUCE FUNCTION INTEGER IS REDUCE RETURNS
%token<type> ENDCASE OTHERS REAL ARROW THEN WHEN
%type <type> type statement_ statement variable parameter reductions expression
binary
relation term factor exponent unary primary case cases
%%
function:
function_header optional_variable body ;
function_header:
FUNCTION IDENTIFIER parameters RETURNS type ';' |
FUNCTION IDENTIFIER RETURNS type ';' |
error ';' ;
optional_variable:
optional_variable variable | %empty
;
variable:
IDENTIFIER ':' type IS statement_
{checkAssignment($3, $5, "Variable Initialization");
if (symbols.find($1, $$))appendError(DUPLICATE_IDENTIFIER, $1);
else
symbols.insert ($1, $3); };
| error ';' {$$ = MISMATCH;};
parameters:
parameter optional_parameter ;
optional_parameter:
optional_parameter ',' parameter | %empty
;
parameter:
IDENTIFIER ':' type {
if (symbols.find ($1, $$))
appendError(DUPLICATE_IDENTIFIER, $1);
else
symbols.insert ($1, $3); };
| error ';' {$$ = MISMATCH;};
type:
INTEGER {$$ = INT_TYPE;} |
REAL {$$ = REAL_TYPE;} |
BOOLEAN {$$ = BOOL_TYPE;} ;
body:
BEGIN_ statement_ END ';' ;
statement_:
statement ';' |
error ';' {$$ = MISMATCH;} ;
statement:
expression
| IF expression THEN statement_ ELSE statement_ ENDIF {$$ = checkIfThen($2,
$4, $6);}
| CASE expression IS cases OTHERS ARROW statement_ ENDCASE {$$ =
checkExpression($2); $$=checkReturns(case_return, $7);};
| REDUCE operator reductions ENDREDUCE {$$ = $3;}
cases :
cases case {case_return = checkCases($2, case_return);};
| %empty {$$=NAN_TYPE;};
case:
WHEN INT_LITERAL ARROW statement_ {$$= $4;};
reductions:
reductions statement_ {$$ = checkArithmetic($1, $2);} |
{$$ = INT_TYPE;} %empty ;
operator:
ADDOP |
MULOP ;
expression:
expression OROP binary {$$ = checkLogical($1, $3);} |
binary ;
binary:
binary ANDOP relation {$$ = checkLogical($1, $3);} |
relation ;
relation:
relation RELOP term {$$ = checkRelational($1, $3);}|
term ;
term:
term ADDOP factor {$$ = checkArithmetic($1, $3);} |
factor ;
factor:
factor MULOP primary {$$ = checkArithmetic($1, $3);} |
factor REMOP exponent {$$ = checkRemainder($1, $3);}|
exponent;
exponent:
unary |
unary EXPOP primary {$$ = checkArithmetic($1, $3);};
unary:
NOTOP primary {$$ = checkNegation($2);}|
primary;
primary:
'(' expression ')' {$$ = $2;} |
INT_LITERAL | REAL_LITERAL | BOOL_LITERAL |
IDENTIFIER {if (!symbols.find($1, $$)) appendError(UNDECLARED, $1);} ;
%%
void yyerror(const char* message)
{
appendError(SYNTAX, message);
}
int main(int argc, char *argv[])
{
firstLine();
yyparse();
lastLine();
return 0;
}
