
%{

#include "y.tab.h"
#include<stdio.h>
#include<string.h>
extern int yyline;
int yylineno = 1;
extern YYSTYPE yylval;

%}

%%

"//"(.)*[\n]   {/* Ignore single-line comments */ yylineno++; }

"if" { strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return IF; }

"else" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return ELSE; }

"elseif" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return ELSEIF; }

"then" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return THEN ; }

"endif" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return ENDIF; }

"to" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return TO; }

"do" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return DO; }
 
"for" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return FOR; }

"endfor" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return ENDFOR; }

"while" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return WHILE; }

"endwhile" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return ENDWHILE; }

"switch" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return SWITCH; }

"case" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return CASE; }

"endswitch" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return ENDSWITCH; }

"default" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return DEFAULT; }

"print" {  strcpy(yylval.obj.name, (yytext)); printf("Keyword: %s\n", yytext); return PRINT; }

["].*["] {  strcpy(yylval.obj.name, (yytext)); printf("String: %s\n", yytext); return STRING; }

[a-zA-Z_][a-zA-Z_0-9]* {  strcpy(yylval.obj.name, (yytext)); printf("Identifier: %s\n", yytext); return IDENTIFIER; }

= {  strcpy(yylval.obj.name, (yytext));  printf("Assignment Operator: %s\n", yytext);return ASSIGNMENT_OPERATOR; }

"+" {  strcpy(yylval.obj.name, (yytext));  printf("Arithemetic Operator: %s\n", yytext); return ADD; }
"-" {  strcpy(yylval.obj.name, (yytext));  printf("Arithemetic Operator: %s\n", yytext); return SUB; }
"*" {  strcpy(yylval.obj.name, (yytext));  printf("Arithemetic Operator: %s\n", yytext); return MUL; }
"/" {  strcpy(yylval.obj.name, (yytext));  printf("Arithemetic Operator: %s\n", yytext); return DIV; }

(!|&&|\|\|) {  strcpy(yylval.obj.name, (yytext));  printf("Logical Operator: %s\n", yytext);return LOGICAL_OPERATOR; }

(==|!=|<=|>=|<|>) {  strcpy(yylval.obj.name, (yytext)); printf("Relational Operator: %s\n", yytext);return RELATIONAL_OPERATOR; }

[1-9][0-9]*	{ yylval.num = atof(yytext); printf("Number: %s\n", yytext); return NUMBER; }

\n { yylineno++; return EOL; }

[ \t\r] { /* ignore whitespace */ }

. { printf("Syntax error at line %d: %s\n", yylineno, yytext); }
%%

int yywrap(){
    return(1);
}


