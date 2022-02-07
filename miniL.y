%{
    #define YY_NO_UNPUT
    #include <stdio.h>
    #include <stdlib.h>
    void yyerror(const char* msg);
%}

%union {
    char* ident_val;
    int num_val;
}

%error-verbose
/* %locations */

%start program

%token <ident_val> IDENT
%token <num_val> NUMBER

%token FUNCTION
%token BEGIN_PARAMS
%token END_PARAMS
%token BEGIN_LOCALS
%token END_LOCALS
%token BEGIN_BODY
%token END_BODY
%token INTEGER
%token ARRAY
%token OF
%token IF
%token THEN
%token ENDIF
%token ELSE
%token WHILE
%token DO
%token IN
%token BEGINLOOP
%token ENDLOOP
%token BREAK
%token CONTINUE
%token READ
%token WRITE

%left AND
%left OR
%right NOT //right?

%token TRUE
%token FALSE
%token RETURN

%left SUB
%left ADD
%left MULT
%left DIV
%left MOD
%left EQ
%left NEQ
%left LT
%left GT
%left LTE
%left GTE

%token L_PAREN
%token R_PAREN
%token L_SQUARE_BRACKET
%token R_SQUARE_BRACKET
%token COLON
%token SEMICOLON
%token COMMA
%left ASSIGN

%%

program: %empty {
    printf("program -> epsilon\n");
} | function program {
    printf("program -> function program\n");
}

function: FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY {
    printf("function -> FUNCTION ident SEMICOLON BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY\n");
}

declarations: %empty {
    printf("declarations -> epsilon\n");
} | declaration SEMICOLON declarations {
    printf("declarations -> declaration SEMICOLON declarations\n");
}

declaration: ident COLON INTEGER {
    printf("declaration -> ident COLON INTEGER\n");
} | ident COLON ARRAY L_SQUARE_BRACKET NUMBER R_SQUARE_BRACKET OF INTEGER {
    printf("declaration -> ident COLON ARRAY L_SQUARE_BRACKET NUMBER %d R_SQUARE_BRACKET OF INTEGER\n", $5);
}



statements: statement SEMICOLON statements {
    printf("statements -> statement SEMICOLON statements\n");
} | statement SEMICOLON {
    printf("statements -> statement SEMICOLON\n");
}

statement: var ASSIGN expressions {
    printf("statement -> var ASSIGN expressions\n");
} | IF boolexp THEN statements elsestatement ENDIF {
    printf("statement -> IF boolexp THEN statements elsestatement ENDIF\n");
} | WHILE boolexp BEGINLOOP statements ENDLOOP {
    printf("statement -> WHILE boolexp BEGINLOOP statements ENDLOOP\n");
} | DO BEGINLOOP statements ENDLOOP WHILE boolexp {
    printf("statement -> DO BEGINLOOP statements ENDLOOP WHILE boolexp\n");
} | READ vars {
    printf("statement -> READ var\n");
} | WRITE vars {
    printf("statement -> WRITE var\n");
} | CONTINUE {
    printf("statement -> CONTINUE\n");
} | BREAK {
    printf("statement -> BREAK\n");
} | RETURN expressions {
    printf("statement -> RETURN expressions\n");
}

elsestatement: %empty {
    printf("elsestatement -> epsilon\n");
} | ELSE statements {
    printf("elsestatement -> ELSE statements\n");
}

boolexp: NOT boolexp {
    printf("boolexp -> NOT boolexp\n");
} | compexp {
    printf("boolexp -> compexp\n");
}

compexp: expression comp expression {
    printf("compexp -> expression comp expression\n");
}

comp: EQ {
    printf("comp -> EQ\n");
} | NEQ {
    printf("comp -> NEQ\n");
} | LT {
    printf("comp -> LT\n");
} | GT {
    printf("comp -> GT\n");
} | LTE {
    printf("comp -> LTE\n");
} | GTE {
    printf("comp -> GTE\n");
}

expressions: %empty {
    printf("expressions -> epsilon\n");
} | expression {
    printf("expressions -> expression\n");
} | expression COMMA expressions {
    printf("expressions -> expression COMMA expressions\n");
}

expression: multexpr {
    printf("expression -> multexpr\n");
} | multexpr ADD expression {
    printf("expression -> multexpr ADD expression\n");
} | multexpr SUB expression {
    printf("expression -> multexpr SUB expression\n");
}


multexpr: term {
    printf("multexpr -> term\n");
} | term MULT multexpr {
    printf("multexpr -> term MULT multexpr\n");
} | term DIV multexpr {
    printf("multexpr -> term DIV multexpr\n");
} | term MOD multexpr {
    printf("multexpr -> term MOD multexpr\n");
}

term: var {
    printf("term -> var\n");
} | NUMBER {
    printf("term -> NUMBER\n");
} | L_PAREN expression R_PAREN {
    printf("term -> L_PAREN expression R_PAREN\n");
} | ident L_PAREN expression R_PAREN {
    printf("term -> ident L_PAREN expressions R_PAREN\n");
}


var: ident {
    printf("var -> ident\n");
} | ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET {
    printf("var -> ident L_SQUARE_BRACKET expression R_SQUARE_BRACKET\n");
}

vars: var {
    printf("vars -> var\n");
} | var COMMA vars {
    printf("vars -> var COMMA vars\n");
}

ident: IDENT {
    printf("ident -> IDENT\n");
} | IDENT COMMA ident {
    printf("ident -> IDENT COMMA ident\n");
}

%%

void yyerror(const char* msg) {
    extern int rowNum;
    extern char* yytext;
    printf("error on line %d at symbol %a\n", rowNum, yytext);
    printf("%s\n", msg);
    exit(1);
}
