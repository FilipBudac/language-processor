%{
#include <stdio.h>

typedef struct {
	int a;
} semantic_entry;

extern char *yytext;

#define YYSTYPE semantic_entry

void vypis(YYSTYPE argument);
%}


%token _BEGIN
%token _END
%token _SEMICOLON
%token _P
%token _NUM
%token _LOAD
%token _UNKNOWN


%start PROGRAM

//%union {
//	char text[100];
//}


%%

PROGRAM: _BEGIN PRIKAZY _END {vypis($2);} '\n'
 ;
PRIKAZY: PRIKAZ _SEMICOLON PRIKAZY {$$.a = 1 + $3.a;}
 | /**/ {$$.a = 0;}
 ;
PRIKAZ: _P
 | _NUM
 | _LOAD
 ;

%%

void vypis(YYSTYPE argument)
{
	printf("Program contains %d commands\n", argument.a);
}

int main()
{
	if (0 == yyparse())
	{
		printf("vyraz bol syntakticky spravny\n");
	} else {
		printf("vyraz bol syntakticky nespravny\n");
	}
	return 0;
}