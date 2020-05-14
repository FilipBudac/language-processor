flex lexical_analyzer.l

gcc -o main *.c -ly -lfl

bison -v -d syntactic_analyzer.y


{aplha} {sscanf(yytext, "%s", yyval.text); return (_LOAD);}


{newline} { yyterminate(); }
. { printf("unknown character: %s\n", yytext); }


printf("%d %s %d\n", id, yytext, variables_size);