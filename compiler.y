%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
extern char *yytext;
extern int yylineno;
int yyerror_count=0;
void yyerror(const char* s); 
extern int yylex();
int yyparse(void);
extern FILE* yyin;

struct dataType {
    char * id_name;
    int number;
    char * type;
    int line_no;
} symbol_table[100];

int count = 0;

void add(char c) {
    if(c == 'K') {
        symbol_table[count].id_name=strdup(yytext);
        symbol_table[count].line_no=yylineno;
        symbol_table[count].type=strdup("KEYWORD\t");
        count++;
    }
    else if(c == 'I') {
        symbol_table[count].id_name=strdup(yytext);
        symbol_table[count].line_no=yylineno;
        symbol_table[count].type=strdup("IDENTIFIER");
        count++;
    }
    else if(c == 'C') {
        symbol_table[count].id_name=strdup(yytext);
        symbol_table[count].line_no=yylineno;
        symbol_table[count].type=strdup("CONSTANT");
        count++;
    }
    else if(c == 'S') {
        symbol_table[count].id_name=strdup(yytext);
        symbol_table[count].line_no=yylineno;
        symbol_table[count].type=strdup("STRING");
        count++;
    }
    else if(c == 'O') {
        symbol_table[count].id_name=strdup(yytext);
        symbol_table[count].line_no=yylineno;
        symbol_table[count].type=strdup("OPERATOR");
        count++;
    }
}
int countnum = 50;
void addNum(int n) {
    symbol_table[countnum].number=n;
    symbol_table[countnum].line_no=yylineno;
    symbol_table[countnum].type=strdup("CONSTANT\t");
    countnum++;
}


%}

%union{
    int num;
    int result; // Add this line to declare the semantic type
    struct var { 
			char name[20]; 
		}obj;
    char str[30];
}

%token EOL 
%token <obj> IDENTIFIER
%token <obj> IF FOR ENDFOR ELSE ENDIF THEN WHILE TO DO ENDWHILE PRINT ELSEIF SWITCH CASE DEFAULT ENDSWITCH
%token <obj> STRING
%token <obj> ADD SUB MUL DIV LOGICAL_OPERATOR RELATIONAL_OPERATOR 
%token <obj> ASSIGNMENT_OPERATOR 
%token <num> NUMBER 
%type <str> print_statement
%type <num> Operation


%%

program : statements
        ;

statements : statement
           | statements stblock
           ;

stblock: statement
       | EOL
       ;

statement : assignment
          | if_statement
          | while_loop
          | for_loop
          | switch_statement
          | print_statement
          ;

print_statement : PRINT { add('K'); } STRING { add('S'); printf("Output: %s\n",$3.name);}
                ;

assignment: IDENTIFIER { add('I'); } ASSIGNMENT_OPERATOR { add('O'); } idopblock {}
          ;

idopblock: IDENTIFIER
         | Operation
         ;

expression: relational_expression
          | logical_expression
          ;

Operation: NUMBER { addNum($1); $$ = $1;}
         | NUMBER { addNum($1); } ADD { add('O'); } Operation { $$ = $1 + $5; printf("Output: %d\n", $$);}
         | NUMBER { addNum($1); } SUB { add('O'); } Operation { $$ = $1 - $5; printf("Output: %d\n", $$);}
         | NUMBER { addNum($1); } MUL { add('O'); } Operation { $$ = $1 * $5; printf("Output: %d\n", $$);}
         | NUMBER { addNum($1); } DIV { add('O'); } Operation { $$ = $1 / $5; printf("Output: %d\n", $$);}
         ;

relational_expression: operand RELATIONAL_OPERATOR { add('O'); } operand
                    ;

logical_expression: operand LOGICAL_OPERATOR { add('O'); } operand
                ;

operand: IDENTIFIER  { add('I'); }
       | NUMBER  { addNum($1); }
       ;

if_statement: IF { add('K'); } expression THEN { add('K'); } EOL statements endblock
            ;

endblock: ENDIF { add('K'); } 
        | ELSE{ add('K'); } EOL statements ENDIF { add('K'); } 
        | block ELSE{ add('K'); } EOL statements ENDIF { add('K'); }
        ;
      
block: ELSEIF { add('K'); } expression THEN { add('K'); } EOL statements elseifblock
     ;

elseifblock: block
           | EOL
           ;

while_loop: WHILE { add('K'); } expression DO { add('K'); } EOL statements ENDWHILE { add('K'); }
          ;

for_loop: FOR { add('K'); } assignment TO { add('K'); } operand DO { add('K'); } EOL statements ENDFOR { add('K'); }
        ;

switch_statement: SWITCH { add('K'); } operand EOL cblock DEFAULT { add('K'); } EOL statements ENDSWITCH { add('K'); }
                ;

cblock: CASE { add('K'); } operand EOL statements caseblock
      ;  

caseblock: cblock
         | EOL
         ;

%%

int main(int argc, char **argv) {
   if (argc != 2) {
        printf("Usage: %s <input_file>\n", argv[0]);
        return 1;
    }

    FILE *file = fopen(argv[1], "r");
    if (!file) {
        printf("Failed to open the input file.\n");
        return 1;
    }
    printf("\nLexical Analysis executing --> \n\n");
    printf("> ");
    yyin = file;
    yyparse();
    if (yyerror_count == 0) {
        printf("\nSyntax Analysis COMPLETED...\nNo errors found...\n");    
        printf("\nPrinting Symbol table --> \n");
        printf("\nSYMBOL\t\tTYPE\t\tLINE NUMBER \n");
        printf("_____________________________________________\n\n");
        int i=0;
        for(i=0; i<count; i++) {
            if(strcmp(symbol_table[i].id_name, "endwhile")!=0)
                printf("%s\t\t%s\t%d\n", symbol_table[i].id_name, symbol_table[i].type, symbol_table[i].line_no);
            else
                printf("%s\t%s\t%d\n", symbol_table[i].id_name, symbol_table[i].type, symbol_table[i].line_no);
        }
        for(i=50; i<countnum; i++) {
            printf("%d\t\t%s%d\n", symbol_table[i].number, symbol_table[i].type, symbol_table[i].line_no);
        }
    }
    fclose(file);

    return 0;
}

void yyerror(const char* s) {
    yyerror_count++;
    printf("\nError: %s at line %d\n", s, yylineno);
}


