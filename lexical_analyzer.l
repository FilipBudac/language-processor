%{
#define yywrap() (/*CONSTCOND*/1)
#include "syntactic_analyzer.tab.h"

void yyerror (char const *s) {
   fprintf (stderr, "%s\n", s);
}
%}

number      ([0-9])+
aplha       ([a-z])+
%%

[ \t] {}
"begin" {return (_BEGIN);}
"end" {return (_END);}
";" {return (_SEMICOLON);}
"p" {return (_P);}
{aplha} {return (_LOAD);}
{number} {return (_NUM);}
[\n] yyterminate();
. {return (_UNKNOWN);}

%%
