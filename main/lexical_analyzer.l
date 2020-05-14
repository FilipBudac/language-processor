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

void print(int id, char *text);
void print_variables();
void check_declaration(int id, char *text);
void evaluate_variable(int id, char *text);

%}

id  [a-zA-Z][a-zA-Z0-9]*
konst [0-9][0-9]*

%%

"premenna" { print(_PREMENNA, yytext); check_declaration(_PREMENNA, yytext); evaluate_variable(_PREMENNA, yytext); return (_PREMENNA);}
"nacitaj" { print(_NACITAJ, yytext); return (_NACITAJ);}
"vypis" { print(_VYPIS, yytext); return (_VYPIS);}
"opakuj" { print(_OPAKUJ, yytext); return (_OPAKUJ);}
"jukapo" { print(_JUKAPO, yytext); return (_JUKAPO);}
{konst} { print(_KONST, yytext); return (_KONST);}
{id} { print(_ID, yytext); check_declaration(_ID, yytext); evaluate_variable(_ID, yytext); return (_ID);}
"+" { print(_PLUS, yytext); return (_PLUS);}
"-" { print(_MINUS, yytext); return (_MINUS);}
"*" { print(_MULTIPLY, yytext); return (_MULTIPLY);}
"=" { print(_ASSIGN, yytext); return (_ASSIGN);}
"==" { print(_EQUAL, yytext); return (_EQUAL);}
"!=" { print(_NOT_EQUAL, yytext); return (_NOT_EQUAL);}
">" { print(_BIGGER_THAN, yytext); return (_BIGGER_THAN);}
"<" { print(_LESSER_THAN, yytext); return (_LESSER_THAN);}
">=" { print(_BIGGER_EQUAL_THAN, yytext); return (_BIGGER_EQUAL_THAN);}
"<=" { print(_LESSER_EQUAL_THAN, yytext); return (_LESSER_EQUAL_THAN);}
[ \t] {}
[ \n] {line_count++;}
. {printf("lexical error, uknown %s \n", yytext);}

%%

void print(int id, char *text)
 {
    // printf("%d %s %d\n", id, yytext, variables_size);
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
            printf("semantic error, variable '%s' hasn't been found \n", text);
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
                    printf("semantic error, variable '%s' already exists\n", text);
                    exit(0);
                }
            }

            strncpy(variables[variables_size], text, strlen(text) + 1);
            variables_size++;

            var_active = 0;
    }

}
