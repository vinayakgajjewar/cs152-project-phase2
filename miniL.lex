   /* cs152-miniL phase1 */
   
%{   
   /* write your C code here for definitions of variables and including headers */
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

"function"        {printf("FUNCTION\n");colNum+=8;}
"beginparams"     {printf("BEGIN_PARAMS\n");colNum+=11;}
"endparams"       {printf("END_PARAMS\n");colNum+=9;}
"beginlocals"     {printf("BEGIN_LOCALS\n");colNum+=11;}
"endlocals"       {printf("END_LOCALS\n");colNum+=9;}
"beginbody"       {printf("BEGIN_BODY\n");colNum+=9;}
"endbody"         {printf("END_BODY\n");colNum+=7;}
"integer"         {printf("INTEGER\n");colNum+=7;}
"array"           {printf("ARRAY\n");colNum+=5;}
"of"              {printf("OF\n");colNum+=2;}
"if"              {printf("IF\n");colNum+=2;}
"then"            {printf("THEN\n");colNum+=4;}
"endif"           {printf("ENDIF\n");colNum+=5;}
"else"            {printf("ELSE\n");colNum+=4;}
"while"           {printf("WHILE\n");colNum+=5;}
"do"              {printf("DO\n");colNum+=2;}
"beginloop"       {printf("BEGINLOOP\n");colNum+=9;}
"endloop"         {printf("ENDLOOP\n");colNum+=7;}
"continue"        {printf("CONTINUE\n");colNum+=8;}
"break"           {printf("BREAK\n");colNum+=5;}
"read"            {printf("READ\n");colNum+=4;}
"write"           {printf("WRITE\n");colNum+=5;}
"not"             {printf("NOT\n");colNum+=3;}
"true"            {printf("TRUE\n");colNum+=4;}
"false"           {printf("FALSE\n");colNum+=5;}
"return"          {printf("RETURN\n");colNum+=6;}

":="              {printf("ASSIGN\n");colNum+=2;}
","               {printf("COMMA\n");colNum++;}
"["               {printf("L_SQUARE_BRACKET\n");colNum++;}
"]"               {printf("R_SQUARE_BRACKET\n");colNum++;}
"("               {printf("L_PAREN\n");colNum++;}
")"               {printf("R_PAREN\n");colNum++;}

";"               {printf("SEMICOLON\n");colNum++;}
":"               {printf("COLON\n");colNum++;}


"-"               {printf("SUB\n");colNum++;}
"+"               {printf("ADD\n");colNum++;}
"*"               {printf("MULT\n");colNum++;}
"/"               {printf("DIV\n");colNum++;}
"%"               {printf("MOD\n");colNum++;}
"=="              {printf("EQ\n");colNum+=2;}
"<>"              {printf("NEQ\n");colNum+=2;}
"<"               {printf("LT\n");colNum++;}
">"               {printf("GT\n");colNum++;}
"<="              {printf("LTE\n");colNum+=2;}
">="              {printf("GTE\n");colNum+=2;}


{DIGIT}+ {
    printf("NUMBER %s\n", yytext);
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
	/* C functions used in lexer */

int yyparse();

int main(int argc, char ** argv)
{
   yyparse();
   //yylex();

   return 0;
}
