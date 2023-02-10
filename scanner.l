/* Compiler Theory and Design
   Duane J. Jarc */

/* This file contains flex input file */

%{
#include <string>
using namespace std;
#include "types.h"
#include "listing.h"
#include "tokens.h"
%}
%option noyywrap
ws [ \t\r]+
comment ("//"|"--").*\n
line [\n]
id [A-Za-z](_?[A-Za-z0-9])*
digit [0-9]
int {digit}+
real_lit {digit}+\.{digit}*([Ee][+-]?{digit}+)?
punc [\(\),:;]
%%
{ws} { ECHO; }
{comment} { ECHO; nextLine();}
{line} { ECHO; nextLine();}
"<" { ECHO; return(RELOP); }
"+" { ECHO; return(ADDOP); }
"-" { ECHO; return(ADDOP); }
"*" { ECHO; return(MULOP); }
"/" { ECHO; return(MULOP); }
">" { ECHO; return(RELOP); }
"=" { ECHO; return(RELOP); }
"!=" { ECHO; return(RELOP); }
">=" { ECHO; return(RELOP); }
"<=" { ECHO; return(RELOP); }
"=>" { ECHO; return(ARROW); }
"**" { ECHO; return(EXPOP); }
"rem" { ECHO; return(REMOP); }
or { ECHO; return(OROP); }
not { ECHO; return(NOTOP); }
and { ECHO; return(ANDOP); }
begin { ECHO; return(BEGIN_); }
boolean { ECHO; return(BOOLEAN); }
end { ECHO; return(END); }
endreduce { ECHO; return(ENDREDUCE); }
function { ECHO; return(FUNCTION); }
integer { ECHO; return(INTEGER); }
is { ECHO; return(IS); }
reduce { ECHO; return(REDUCE); }
returns { ECHO; return(RETURNS); }
case { ECHO; return(CASE); }
else { ECHO; return(ELSE); }
endcase { ECHO; return(ENDCASE); }
when { ECHO; return(WHEN); }
others { ECHO; return(OTHERS); }
if { ECHO; return(IF); }
then { ECHO; return(THEN); }
endif { ECHO; return(ENDIF); }
real { ECHO; return(REAL); }
true { ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
false { ECHO; yylval.type = BOOL_TYPE; return(BOOL_LITERAL); }
{id} { ECHO; yylval.iden = (CharPtr)malloc(yyleng + 1); strcpy(yylval.iden,
yytext); return(IDENTIFIER);}
{int} { ECHO; yylval.type = INT_TYPE; return(INT_LITERAL); }
{real_lit} { ECHO; yylval.type = REAL_TYPE; return(REAL_LITERAL); }
{punc} { ECHO; return(yytext[0]); }
. { ECHO; appendError(LEXICAL, yytext); }
%%
