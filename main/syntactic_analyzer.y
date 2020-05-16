%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int line_count;
extern int token_id;
extern char *yytext;
extern int *count;

extern struct Program program;
extern struct Shared shared;
extern int variable_count;

void yyerror (const char *s);
int yylex();

//typedef struct {
//	char *var;
//        char *name;
//        char *name2;
//} semantic_entry;

char *tmp;
char *operator;
char *right_v;

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
		int assign;

		char *name;
		char *var;
		 char *id;
		char *hodnota;
		char *vyraz;
		char konst[100];

		struct Shared* shared;
        } u;
}

%start PROGRAM

%type <u> DEKLARACIA
%type <u> HODNOTA
%type <u> VYRAZ
//%type <u> PRIRADENIE
//%type <u> VYRAZ

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
 	// printf("%s \n", yytext);
 }
 | _OPAKUJ PODMIENKA PRIKAZY _JUKAPO
 ;
PRIRADENIE: _ID {
		 tmp = strdup(yytext);
  		} _ASSIGN VYRAZ
 ;
VYRAZ: HODNOTA OPERATOR HODNOTA
 | HODNOTA
 ;
OPERATOR: _PLUS {
	operator = strdup(yytext);
 }
 | _MINUS
 | _MULTIPLY
 ;
 PODMIENKA: HODNOTA KOMPARATOR HODNOTA
 ;
HODNOTA: _ID {
	 right_v = strdup(yytext);
 }
 | _KONST {
	if (operator == NULL) {
		printf("(INTEGER, %s, t%d) \n", yytext, $1.t_count);
		printf("(:=, t%d, sizeof(Integer), %s) \n", $1.t_count, tmp);
	}

	if (operator != NULL && atoi(yytext) < 0) {
		printf("(INTEGER, %d, t%d) \n", atoi(yytext) * (-1), $1.t_count - 2);
		printf("(-, t%d, t%d) \n", $1.t_count - 2, $1.t_count - 1);
		printf("(%s, %s, t%d, t%d) \n", operator, right_v, $1.t_count - 1, $1.t_count); // tmp
		printf("(:=, t%d, sizeof(Integer), %s) \n", $1.t_count, tmp);

		operator = NULL;
	}

	if (operator != NULL) {
		printf("(INTEGER, %s, t%d) \n", yytext, $1.t_count - 1);
		printf("(%s, %s, t%d, t%d) \n", operator, right_v, $1.t_count - 1, $1.t_count);
		printf("(:=, t%d, sizeof(Integer), %s) \n", $1.t_count, tmp);

		operator = NULL;
	}

	printf("------------------------------- \n");

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