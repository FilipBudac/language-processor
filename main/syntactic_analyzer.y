%{
// vyhodnotia sa najskor spodne listy a postupne sa potom zacnu prikazy smerom navrh [pre kazdy riadok

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int line_count;
extern char *yytext;

int yylex();

char *tmp;
char *operator;
char *right_v;

char *right_konst_s;
int current_count = 0;

void yyerror (const char *s);

%}


%token <u> _PREMENNA
%token <u> _ID
%token <u> _NACITAJ
%token <u> _VYPIS
%token <u> _OPAKUJ
%token <u> _JUKAPO
%token <u> _KONST
%token <u> _PLUS "+"
%token <u> _MINUS "-"
%token <u> _MULTIPLY "*"
%token <u> _ASSIGN "="
%token <u> _EQUAL "=="
%token <u> _NOT_EQUAL "!="
%token <u> _BIGGER_THAN ">"
%token <u> _LESSER_THAN "<"
%token <u> _BIGGER_EQUAL_THAN ">="
%token <u> _LESSER_EQUAL_THAN "<="
%token _UNKNOWN



%union {
	struct {
		int t_count;

		char *name;
		char id[100];
		char konst[100];
        } u;
}

%start PROGRAM

%type <u> DEKLARACIA
%type <u> HODNOTA
%type <u> VYRAZ
%type <u> PRIRADENIE

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
PRIKAZ: _NACITAJ _ID {
	 printf("(WRITE, %s) \n", yytext);
 }
 | _VYPIS _ID {
 	 printf("(READ, %s) \n", yytext);
 }
 | PRIRADENIE {
	printf("(PRIRADENIE) \n");

	if (operator == NULL && right_konst_s == NULL) {
		printf("(:=, %s, sizeof(Integer), %s) \n", right_v, tmp);

		right_v = NULL;
		tmp = NULL;
	}

	if (operator == NULL && right_konst_s != NULL) {
		printf("(INTEGER, %s, t%d) \n", right_konst_s, current_count);
		printf("(:=, t%d, sizeof(Integer), %s) \n", current_count, tmp);

		right_konst_s = NULL;
		tmp = NULL;
	}

	if (operator != NULL && atoi(right_konst_s) < 0) {
		printf("(INTEGER, %d, t%d) \n", atoi(right_konst_s) * (-1), current_count - 2);
		printf("(-, t%d, t%d) \n", current_count - 2, current_count - 1);
		printf("(%s, %s, t%d, t%d) \n", operator, right_v, current_count - 1, current_count); // tmp
		printf("(:=, t%d, sizeof(Integer), %s) \n", current_count, tmp);

		operator = NULL;
		right_konst_s = NULL;
		tmp = NULL;
	}

	if (operator != NULL) {
		printf("(INTEGER, %s, t%d) \n", right_konst_s, current_count - 1);
		printf("(%s, %s, t%d, t%d) \n", operator, right_v, current_count - 1, current_count);
		printf("(:=, t%d, sizeof(Integer), %s) \n", current_count, tmp);

		operator = NULL;
		right_konst_s = NULL;
		tmp = NULL;
	}

	printf("------------------------------- \n");
 }
 | _OPAKUJ PODMIENKA PRIKAZY _JUKAPO
 ;
PRIRADENIE: _ID {
		 tmp = strdup(yytext);
  		} _ASSIGN VYRAZ
 ;
VYRAZ: HODNOTA OPERATOR HODNOTA {  }
 | HODNOTA
 ;
OPERATOR: _PLUS {
	operator = strdup(yytext);
 }
 | _MINUS {
	operator = strdup(yytext);
 }
 | _MULTIPLY {
        operator = strdup(yytext);
 }
 ;
 PODMIENKA: HODNOTA KOMPARATOR HODNOTA
 ;
HODNOTA: _ID {
	 right_v = strdup(yytext);
 }
 | _KONST {
	if (operator == NULL) {
		right_konst_s = strdup(yytext);
		current_count = $1.t_count;
	}

	if (operator != NULL && atoi(yytext) < 0) {
		right_konst_s = strdup(yytext);
		current_count = $1.t_count;
	}

	if (operator != NULL) {
		right_konst_s = strdup(yytext);
		current_count = $1.t_count;
	}
 }
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

int main() {
	if (yyparse() == 0) {
		yyerror("not an syntax error");
		// printf("not an syntax error\n");
	} else {
		yyerror("syntax error");
		// printf("syntax error %d\n", line_count);
	}

	return 0;
}