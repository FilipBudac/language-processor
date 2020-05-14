%{
#include <stdio.h>
#include <stdlib.h>

extern int line_count;
extern int token_id;

void yyerror (const char *s);
int yylex();
%}


%token _PREMENNA
%token _ID
%token _NACITAJ
%token _VYPIS
%token _OPAKUJ
%token _JUKAPO
%token _KONST
%token _PLUS
%token _MINUS
%token _MULTIPLY
%token _ASSIGN
%token _EQUAL
%token _NOT_EQUAL
%token _BIGGER_THAN
%token _LESSER_THAN
%token _BIGGER_EQUAL_THAN
%token _LESSER_EQUAL_THAN
%token _UNKNOWN


%union {int num; char id;}
%start PROGRAM

%%

PROGRAM: DEKLARACIE PRIKAZY
 ;
DEKLARACIE: DEKLARACIA DEKLARACIE
 | /**/
 ;
DEKLARACIA: _PREMENNA _ID
 ;
PRIKAZY: PRIKAZ PRIKAZY
 | /**/
 ;
PRIKAZ: _NACITAJ _ID
 | _VYPIS _ID
 | PRIRADENIE
 | _OPAKUJ PODMIENKA PRIKAZY _JUKAPO
 ;
PRIRADENIE: _ID _ASSIGN VYRAZ
 ;
VYRAZ: HODNOTA OPERATOR HODNOTA
 | HODNOTA
 ;
OPERATOR: _PLUS
 | _MINUS
 | _MULTIPLY
 ;
PODMIENKA: HODNOTA KOMPARATOR HODNOTA
 ;
HODNOTA: _ID
 | _KONST
 ;
KOMPARATOR: _LESSER_THAN
 | _BIGGER_THAN
 | _LESSER_EQUAL_THAN
 | _BIGGER_EQUAL_THAN
 | _EQUAL
 | _NOT_EQUAL
 ;

%%

void yyerror (char const *s) {
   fprintf (stderr, "%s \n ", s);
}

int main()
{
//	int ntoken;
//	ntoken = yylex();
//	while(ntoken) {
//		printf("TOKEN -> %d \n", ntoken);
//		ntoken = yylex();
//	}
//
//	while (token_id) {
//		printf("TOKEN -> %d \n", token_id);
//	}

	if (yyparse() == 0) {
		printf("not an syntax error\n");
	} else {
		printf("syntax error %d\n", line_count);
	}

	return 0;
}