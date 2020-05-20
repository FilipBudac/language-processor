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

char variables[1000][1000];

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
    yylval.u.n_count += 2;
    yylval.u.l1_count++;

    return (_OPAKUJ);
}
"jukapo" {
    yylval.u.j_count += 1;
    yylval.u.l2_count++;

    if (yylval.u.l1_count == yylval.u.l2_count){
        yylval.u.l1_count = 0;
        yylval.u.l2_count = 0;
    }

     return (_JUKAPO);
}
{id} {
    check_declaration(_ID, yytext);
    evaluate_variable(_ID, yytext);

    return (_ID);
}
{konst} {
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
"==" { yylval.u.t_count++; return (_EQUAL); }
"!=" { yylval.u.t_count++; return (_NOT_EQUAL); }
">" { yylval.u.t_count++; return (_BIGGER_THAN); }
"<" { yylval.u.t_count++; return (_LESSER_THAN); }
">=" { yylval.u.t_count++; return (_BIGGER_EQUAL_THAN); }
"<=" { yylval.u.t_count++; return (_LESSER_EQUAL_THAN); }
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
            printf("semantic error, variable '%s' hasn't been found \n", text);
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
                    printf("semantic error, variable '%s' already exists\n", text);
                    exit(0);
                }
            }

            strncpy(variables[variables_size], text, strlen(text) + 1);
            variables_size++;

            variable_count++;
            var_active = 0;
    }

}
