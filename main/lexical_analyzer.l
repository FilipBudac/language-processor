%{

#define yywrap() (/*CONSTCOND*/1)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "syntactic_analyzer.tab.h"

int line_count = 0;

int variables_size = 0;
int variable_count = 0;

int var_active = 0;
int t_count = 0;

char variables[1000][1000] = {{0}};

void check_declaration(int id, char *text);
void evaluate_variable(int id, char *text);
void yyerror (char const *s);

%}

id  [a-zA-Z][a-zA-Z0-9]*
konst [-]*[0-9][0-9]*

%%

"premenna" {

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
    strcpy(yylval.u.id, yytext);

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

"+" {
    yylval.u.t_count++;

    return (_PLUS);
}
"-" {
    yylval.u.t_count++;

    return (_MINUS);
  }
"*" {
    yylval.u.t_count++;

    return (_MULTIPLY);
}
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
[ \n] { line_count++; }
. { printf("lexical error, uknown %s \n", yytext); }

%%

void evaluate_variable(int id, char *text) {
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


void check_declaration(int id, char *text) {
    if (id == _PREMENNA) {
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
