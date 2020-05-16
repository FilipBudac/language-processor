%{

#define yywrap() (/*CONSTCOND*/1)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntactic_analyzer.tab.h"

int line_count = 0;
int token_id;

int variables_size = 0;
char variables[1000][1000] = {{0}};

int var_active = 0;
int t_count = 0;


void print(int id, char *text);
void print_variables();
void check_declaration(int id, char *text);
void evaluate_variable(int id, char *text);
void yyerror (char const *s);

struct Variable {
	char name[20];
	int value;
	int declared;
};

int variable_count = 0;

struct Program {
	struct Variable variables[100];
};

struct Shared {
	char line[1000];
	char variable_name[100];
};

struct Program program;
struct Shared shared;

void add_variable(char *argument, char *argument2, struct Program program);

%}

id  [a-zA-Z][a-zA-Z0-9]*
konst [-]*[0-9][0-9]*

%%

"premenna" {
    yylval.u.name = yytext;
    yylval.u.shared = (struct Shared *)malloc(sizeof(struct Shared));

    check_declaration(_PREMENNA, yytext);
    evaluate_variable(_PREMENNA, yytext);

    return (_PREMENNA);
}
"nacitaj" {
     return (_NACITAJ);
}
"vypis" {
     return (_VYPIS);
}
"opakuj" {
     return (_OPAKUJ);
}
"jukapo" {
     return (_JUKAPO);
}
{id} {
    yylval.u.id = yytext;

    check_declaration(_ID, yytext);
    evaluate_variable(_ID, yytext);

    return (_ID);
}
{konst} {

     strcpy(yylval.u.konst, yytext);

     if (atoi(yytext) < 0) {
        yylval.u.t_count += 2;
     } else {
        yylval.u.t_count++;
     }

     return (_KONST);
}

"+" { yylval.u.t_count++; print(_PLUS, yytext); return (_PLUS); }
"-" { yylval.u.t_count++; print(_MINUS, yytext); return (_MINUS); }
"*" { yylval.u.t_count++; print(_MULTIPLY, yytext); return (_MULTIPLY); }
"=" {
    return (_ASSIGN);
}
"==" { return (_EQUAL); }
"!=" { return (_NOT_EQUAL); }
">" { return (_BIGGER_THAN); }
"<" { return (_LESSER_THAN); }
">=" { return (_BIGGER_EQUAL_THAN); }
"<=" { return (_LESSER_EQUAL_THAN); }
[ \t] {}
[ \n] {line_count++;}
. { printf("lexical error, uknown %s \n", yytext); }

%%

void add_variable(char *argument, char *argument2, struct Program program) {

	printf("%s \n", argument);

	strcpy(program.variables[variable_count].name, argument);
	program.variables[variable_count].declared = 1;

	for (int i = 0; i <= variable_count; i++) {
		printf("name: %s \n", program.variables[i].name);
		if (program.variables[i].declared) {
			printf("declared \n");
		}
	}

	variable_count++;
}

void print(int id, char *text)
 {
   //   printf("%d %s \n", id, yytext);
}

void evaluate_variable(int id, char *text)
 {
    if (id == _ID && !var_active) {
        int i = 0;
        int found = 0;
        while (*variables[i]) {
            int ret = strcmp(variables[i++], text);

            if (ret == 0) {
                found = 1;
            }
        }
        if (!found) {
            //printf("semantic error, variable '%s' hasn't been found \n", text);
            yyerror("semantic error, variable hasn't been declared");
            exit(0);
        }
    }
}

void print_variables()
{
    for (int i = 0; i < variables_size; i++) {
        printf("%s \n", variables[variables_size]);
    }
}

void check_declaration(int id, char *text)
{
    if (id == _PREMENNA)
    {
            var_active = 1;
    }

    if (id == _ID && var_active) {
            int i = 0;
            while (*variables[i]) {
                int ret = strcmp(variables[i++], text);

                if (ret == 0) {
                    // printf("semantic error, variable '%s' already exists\n", text);
                    yyerror("semantic error, redeclared variable");
                    exit(0);
                }
            }

            strncpy(variables[variables_size], text, strlen(text) + 1);
            variables_size++;

            variable_count++;
            var_active = 0;
    }

}
