%{
    #include <iostream>
	#include "parser.tab.h"

    using namespace std;

    extern void yyerror(const char *s);
    unsigned int cntLine = 1;
%}

%option noyywrap

%%
"print"  {return PRINT;}
"=" {return ASSIGN;}
"+" {return PLUS;}
"-" {return MINUS;}
"*" {return TIMES;}
"/" {return DIVIDE;}
"^" {return POW;}
"(" {return LPAREN;}
")" {return RPAREN;}
"sin"  {return SIN;}
"cos"  {return COS;}
"tan"  {return TAN;}
"cot"  {return COT;}
"log"  {return LOG;}
"exp"  {return EXP;}
[0-9]+[A-Za-z][A-Za-z0-9_]* { yyerror("invalid variable name "); }
([0-9]*[.])?[0-9]+ {yylval.fval = atof(yytext); return NUM; }
[A-Za-z][A-Za-z0-9_]* { yylval.sval=strdup(yytext);return VAR; }
[ ]        
"\n" {cntLine++; return NEWLINE;}
. { yyerror((string("invalid character: ") + yytext).c_str()); }
%%