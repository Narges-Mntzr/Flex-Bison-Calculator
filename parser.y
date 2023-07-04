%{
    #include <iostream>
    #include <map>
    #include <cstdio>
    #include <cmath>
    #include <cstring>

    extern int yylex();
    extern int yyparse();
    extern unsigned int cntLine;
    extern FILE *yyin;
    
    void yyerror(const char *s);

    using namespace std;
    map<std::string, float> lookup_table;
    bool hasError = false;
%}

%union {
    float fval;
    char* sval;
}

%token <fval> NUM
%token <sval> VAR
%token ASSIGN PLUS MINUS TIMES DIVIDE POW
%token LPAREN RPAREN SIN COS TAN COT LOG EXP
%token NEWLINE PRINT

%left PLUS MINUS
%left TIMES DIVIDE
%right POW

%type <fval> expression
%start program

%%
program:
    | program statement NEWLINE
    {
        hasError = false;
    }
    ;

statement:
    | VAR ASSIGN expression {
        if(!hasError)
            lookup_table[string($1)] = $3;
    }
    | PRINT LPAREN expression RPAREN {
            if(!hasError)
            {
                cout << $3 << endl;
            }
    }
    ;

expression:
    NUM { $$ = $1; }
    | VAR {
        string name($1);
        if (lookup_table.find(name) == lookup_table.end()) {
            yyerror(("variable '" + name + "' has not been assigned before").c_str());
            hasError = true;
            $$ = 0;
        } 
        else {
            $$ = lookup_table[name];
        }
    }
    | expression PLUS expression { $$ = $1 + $3; }
    | MINUS expression { $$ = -$2; }
    | expression MINUS expression { $$ = $1 - $3; }
    | expression TIMES expression { $$ = $1 * $3; }
    | expression DIVIDE expression { 
        if ($3 == 0) {
            yyerror("Division by zero");
            hasError = true;
        }
        $$ = $1 / $3;
    }
    | expression POW expression { $$ = pow($1, $3); }
    | LPAREN expression RPAREN { $$ = $2; }
    | SIN LPAREN expression RPAREN { $$ = sin($3); }
    | COS LPAREN expression RPAREN { $$ = cos($3); }
    | TAN LPAREN expression RPAREN { $$ = tan($3); }
    | COT LPAREN expression RPAREN { $$ = cos($3) / sin($3); }
    | LOG LPAREN expression RPAREN { $$ = log($3); }
    | EXP LPAREN expression RPAREN { $$ = exp($3); }
    ;
%%

int main(int argc, char* argv[]) {
    FILE *f = fopen(argv[1], "r");
    yyin = f;

    yyparse();
}

void yyerror(const char *s) {
    if (strcmp(s, "syntax error") == 0)
        return;

    cout << "Error at line "  << cntLine << ": " << s << endl;
}
