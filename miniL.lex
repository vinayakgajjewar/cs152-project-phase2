   /* cs152-miniL phase1 */
   
%{   
   /* write your C code here for definitions of variables and including headers */
   #include "y.tab.h"
   int rowNum = 1;
   int colNum = 0;
%}

   /* some common rules */
LETTER            [A-Za-z]
DIGIT             [0-9]
WHITESPACE        [\t ]
NEWLINE           [\n]

%%
   /* specific lexer rules in regex */

"function"        return FUNCTION; colNum+=8;
"beginparams"     return BEGIN_PARAMS; colNum+=11;
"endparams"       return END_PARAMS; colNum+=9;
"beginlocals"     return BEGIN_LOCALS; colNum+=11;
"endlocals"       return END_LOCALS; colNum+=9;
"beginbody"       return BEGIN_BODY; colNum+=9;
"endbody"         return END_BODY; colNum+=7;
"integer"         return INTEGER; colNum+=7;
"array"           return ARRAY; colNum+=5;
"of"              return OF; colNum+=2;
"if"              return IF; colNum+=2;
"then"            return THEN; colNum+=4;
"endif"           return ENDIF; colNum+=5;
"else"            return ELSE; colNum+=4;
"while"           return WHILE; colNum+=5;
"do"              return DO; colNum+=2;
"beginloop"       return BEGINLOOP; colNum+=9;
"endloop"         return ENDLOOP; colNum+=7;
"continue"        return CONTINUE; colNum+=8;
"break"           return BREAK; colNum+=5;
"read"            return READ; colNum+=4;
"write"           return WRITE; colNum+=5;
"not"             return NOT; colNum+=3;
"true"            return TRUE; colNum+=4;
"false"           return FALSE; colNum+=5;
"return"          return RETURN; colNum+=6;

":="              return ASSIGN; colNum+=2;
","               return COMMA; colNum++;
"["               return L_SQUARE_BRACKET; colNum++;
"]"               return R_SQUARE_BRACKET; colNum++;
"("               return L_PAREN; colNum++;
")"               return R_PAREN; colNum++;

";"               return SEMICOLON; colNum++;
":"               return COLON; colNum++;


"-"               return SUB; colNum++;
"+"               return ADD; colNum++;
"*"               return MULT; colNum++;
"/"               return DIV; colNum++;
"%"               return MOD; colNum++;
"=="              return EQ; colNum+=2;
"<>"              return NEQ; colNum+=2;
"<"               return LT; colNum++;
">"               return GT; colNum++;
"<="              return LTE; colNum+=2;
">="              return GTE; colNum+=2;


{DIGIT}+ {
    printf("NUMBER %s\n", yytext);
    return NUMBER;
    colNum += yyleng;
}

({DIGIT}+({LETTER}|"_"))* {
  printf("Error at line %d, column %d: identifier \"%s\" must begin with a letter.\n", rowNum, colNum, yytext);
  exit(1);
}
{LETTER}({DIGIT}|{LETTER})*"_" {
  printf("Error at line %d, column %d: identifier \"%s\" cannot end with an underscore.\n", rowNum, colNum, yytext);
  exit(1);
}

{LETTER}({LETTER}|{DIGIT}|"_")*({LETTER}|{DIGIT})* {
    return IDENT;
    printf("IDENT %s\n", yytext);
    colNum += yyleng;
}

{WHITESPACE}+   colNum += yyleng;
{NEWLINE}+      rowNum += yyleng; colNum = 0;

"##".*{NEWLINE}

. {
  printf("Error at line %d, column %d: unrecognized symbol \"%s\" \n", rowNum, colNum, yytext);
  exit(1);
}

%%
int yyparse();
	/* C functions used in lexer */

int main(int argc, char ** argv)
{
   yyparse();
   return 0;
}
