%{
// vyhodnotia sa najskor terminaly a postupne sa potom zacnu neterminaly smerom navrh

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int line_count;
extern char *yytext;

char *tmp;
char *operator;
char *right_v;

char *comparator;
char* v_left;
char* v_right;
char *right_konst_s;

int current_count = 0;
int n_current_count = 0;

void yyerror (const char *s);
int yylex();

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
		int n_count;
		int c_count;
		int c_count_l;
		int c_count_r;
		int j_count;

		char* v_left;
		char* v_right;
		char* v_condition;
        } u;
}

%start PROGRAM

%type <u> DEKLARACIA
%type <u> HODNOTA
%type <u> VYRAZ
%type <u> PRIRADENIE
%type <u> PRIKAZ
%type <u> PODMIENKA
%type <u> KOMPARATOR


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
 }
 | _OPAKUJ {
 	n_current_count = $1.n_count;
// 	printf("(NAVESTIE, n%d) \n", n_current_count - 1);
 } PODMIENKA {
	if (v_left != NULL && v_right != NULL) {
		if (atoi(v_left) != 0 && atoi(v_right) != 0) {
			printf("(INTEGER, %s, t%d) \n", v_left, current_count - 2);
			printf("(INTEGER, %s, t%d) \n", v_right, current_count - 1);
 			printf("(NAVESTIE, n%d) \n", n_current_count - 1);

			printf("(%s, t%d, t%d, t%d) \n", comparator, current_count - 2, current_count - 1, current_count);
//			printf("(JUMPT, t%d, n%d) \n", current_count, n_current_count - 1);
			printf("(JUMPF, t%d, n%d) \n", current_count, n_current_count);
		} else if (atoi(v_left) == 0 && atoi(v_right) != 0) {
			printf("(INTEGER, %s, t%d) \n", v_right, current_count - 1);
 			printf("(NAVESTIE, n%d) \n", n_current_count - 1);

			printf("(%s, %s, t%d, t%d) \n", comparator, v_left, current_count - 1, current_count);
//			printf("(JUMPT, t%d, n%d) \n", current_count, n_current_count - 1);
			printf("(JUMPF, t%d, n%d) \n", current_count, n_current_count);
		} else if (atoi(v_left) != 0 && atoi(v_right) == 0) {
			printf("(INTEGER, %s, t%d) \n", v_left, current_count - 1);
 			printf("(NAVESTIE, n%d) \n", n_current_count - 1);

			printf("(%s, t%d, %s, t%d) \n", comparator, current_count - 1, v_right, current_count);
//			printf("(JUMPT, t%d, n%d) \n", current_count, n_current_count - 1);
			printf("(JUMPF, t%d, n%d) \n", current_count, n_current_count);
		} else if (atoi(v_left) == 0 && atoi(v_right) == 0) {
		 	printf("(NAVESTIE, n%d) \n", n_current_count - 1);

			printf("(%s, %s, %s, t%d) \n", comparator, v_left, v_right, current_count);
//			printf("(JUMPT, t%d, n%d) \n", current_count, n_current_count - 1);
			printf("(JUMPF, t%d, n%d) \n", current_count, n_current_count);
		}
	}

} PRIKAZY {

 } _JUKAPO {
 	printf("(JUMP, n%d)\n", (n_current_count - 1) - ($7.j_count - 1) * 2);
 	printf("(NAVESTIE, n%d)\n", n_current_count - ($7.j_count - 1) * 2);
 }
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
 | _MINUS {
	operator = strdup(yytext);
 }
 | _MULTIPLY {
        operator = strdup(yytext);
 }
 ;
 PODMIENKA: HODNOTA {
 	if ($1.v_condition != NULL) {
 	 	v_left = strdup($1.v_condition);
 	}
 } KOMPARATOR HODNOTA {
 	if ($4.v_condition != NULL) {
		v_right = strdup($4.v_condition);
	}
 }
 ;
HODNOTA: _ID {
	 right_v = strdup(yytext);
	 $$.v_condition = strdup(yytext);
 }
 | _KONST {
 	$$.v_condition = strdup(yytext);
	current_count = $1.t_count;

	if (operator == NULL) {
		right_konst_s = strdup(yytext);
	}

	if (operator != NULL && atoi(yytext) < 0) {
		right_konst_s = strdup(yytext);
	}

	if (operator != NULL) {
		right_konst_s = strdup(yytext);
	}
 }
 ;

KOMPARATOR: _LESSER_THAN { comparator = strdup(yytext); }
 | _BIGGER_THAN { comparator = strdup(yytext); }
 | _LESSER_EQUAL_THAN { comparator = strdup(yytext); }
 | _BIGGER_EQUAL_THAN { comparator = strdup(yytext); }
 | _EQUAL { comparator = strdup(yytext); }
 | _NOT_EQUAL { comparator = strdup(yytext); }
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