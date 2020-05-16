flex lexical_analyzer.l

gcc -o main *.c -ly -lfl

bison -v -d syntactic_analyzer.y


{aplha} {sscanf(yytext, "%s", yyval.text); return (_LOAD);}


{newline} { yyterminate(); }
. { printf("unknown character: %s\n", yytext); }


printf("%d %s %d\n", id, yytext, variables_size);

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




//struct Variable {
//	char name[20];
//	int value;
//	int declared;
//};
//
//struct Variable v1;
//int variable_count = 0;
//
//struct Program {
//	struct Variable variables[100];
//};
//
//struct Program program;


premenna var
premenna var2
premenna var3
nacitaj var
vypis var
vypis var2
var2 = 100
var2 = var + 50
opakuj var < 5
jukapo