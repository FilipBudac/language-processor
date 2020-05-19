bison -v -d syntactic_analyzer.y

flex lexical_analyzer.l

gcc -o main *.c


