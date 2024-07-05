Lexical Analyzer and Syntax Analyzer for a pseudocode compiler

Steps to run the code

1.   flex comp.l
2.   bison -d compiler.y
3.   gcc lex.yy.c y.tab.c -o myparser
4.   ./parser
