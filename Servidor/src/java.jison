%{
      let contador = 0;
      let errores = [];
%}

%lex
%%

"//".* ;
[/][*][^*]*[*]+([^/*][^*]*[*]+)*[/] ;
\s+ ;

"{"                     return 'SIMBOLO_LLAVE_IZQ';
"}"                     return 'SIMBOLO_LLAVE_DER';
"("                     return 'SIMBOLO_PARENTESIS_IZQ';
")"                     return 'SIMBOLO_PARENTESIS_DER';
"*"                     return 'SIMBOLO_POR';
"/"                     return 'SIMBOLO_ENTRE';
"++"                    return 'SIMBOLO_INCREMENTO';
"--"                    return 'SIMBOLO_DECREMENTO';
"^"                     return 'SIMBOLO_ELEVADO';
"%"                     return 'SIMBOLO_MODULO';
"=="                    return 'SIMBOLO_ESIGUAL';
"!="                    return 'SIMBOLO_NOESIGUAL';
">="                    return 'SIMBOLO_MAYORIGUAL';
"<="                    return 'SIMBOLO_MENORIGUAL';
">"                     return 'SIMBOLO_MAYOR';
"<"                     return 'SIMBOLO_MENOR';
"="                     return 'SIMBOLO_IGUAL';
"+"                     return 'SIMBOLO_MAS';
"-"                     return 'SIMBOLO_MENOS';
"&&"                    return 'SIMBOLO_AND';
"||"                    return 'SIMBOLO_OR';
"!"                     return 'SIMBOLO_NOT';
";"                     return 'SIMBOLO_PUNTOCOMA';
":"                     return 'SIMBOLO_DOSPUNTOS';
","                     return 'SIMBOLO_COMA';

"import"                return 'RESERVADA_IMPORT';
"class"                 return 'RESERVADA_CLASS';
"int"                   return 'RESERVADA_INT';
"double"                return 'RESERVADA_DOUBLE';
"boolean"               return 'RESERVADA_BOOLEAN';
"char"                  return 'RESERVADA_CHAR';
"String"                return 'RESERVADA_STRING';
"void"                  return 'RESERVADA_VOID';
"main"                  return 'RESERVADA_MAIN';
"true"                  return 'RESERVADA_TRUE';
"false"                 return 'RESERVADA_FALSE';
"if"                    return 'RESERVADA_IF';
"else"                  return 'RESERVADA_ELSE';
"switch"                return 'RESERVADA_SWITCH';
"case"                  return 'RESERVADA_CASE';
"default"               return 'RESERVADA_DEFAULT';
"while"                 return 'RESERVADA_WHILE';
"do"                    return 'RESERVADA_DO';
"for"                   return 'RESERVADA_FOR';
"break"                 return 'RESERVADA_BREAK';
"continue"              return 'RESERVADA_CONTINUE';
"return"                return 'RESERVADA_RETURN';
"null"                  return 'RESERVADA_NULL';
"System.out.println"    return 'RESERVADA_PRINT';
"System.out.print"      return 'RESERVADA_PRINT';

[a-zA-Z_][a-zA-Z0-9_]*  return 'IDENTIFICADOR';
"'"([^']|{CE})"'"       return 'CARACTER';
"\""("\\".|[^"\n])*"\""    return 'CADENA';
[0-9]+"."[0-9]+         return 'DECIMAL';
[0-9]+                  return 'ENTERO';

/*errStr = 'Se encontro un error sintactico en la linea: '+(yylineno+1)+"."+lexer.showPosition()+" Se esperaba: "+expected.join(', ') + ". Y se obtuvo: '" + (this.terminals_[symbol] || symbol)+ "'";*/

<<EOF>>                 return 'EOF';
.                       {contador++; errores.push([{"error":"Se encontro el error lexico "+yytext+". En la fila: "+yylloc.first_line+" Y columna: "+yylloc.first_column}]);};

/lex

%left SIMBOLO_AND SIMBOLO_OR
%left UMINUS2
%left SIMBOLO_MAYOR SIMBOLO_MAYORIGUAL SIMBOLO_MENOR SIMBOLO_MENORIGUAL
%left SIMBOLO_ESIGUAL SIMBOLO_NOESIGUAL
%left SIMBOLO_MAS SIMBOLO_MENOS
%left SIMBOLO_POR SIMBOLO_ENTRE
%left SIMBOLO_ELEVADO SIMBOLO_MODULO
%left UMINUS1

%start init

%%

init
    : file EOF
      {
        return {"num_errores":contador, "AST": $1, "errores":errores};
      }
    |EOF
      {
        return "";
      }
    |error_declaration EOF
      {
        return $1
      }
    ;

file
    : imports clases
      {
        $$ = {"imports":$1, "clases":$2 };
      }
    | error_declaration clases
      {
        $$ = {"imports":$1, "clases":$2};
      }
    | clases
      {
        $$ = {"clases":$1};
      }
    
    ;

imports
    : imports import
      {
        $1.push($2); $$ = $1;
      }
    | import
      {
        $$ = [$1];
      }
    ;

import
    : RESERVADA_IMPORT IDENTIFICADOR SIMBOLO_PUNTOCOMA
      {
        $$ = {"tipo":"instruccion_import", "identificador":$2};
      }
    | error_declaration SIMBOLO_PUNTOCOMA
    ;

clases
    : clases class
      {
        $1.push($2); $$ = $1;
      }
    | class
      {
        $$ = [$1];
      }
    | error_declaration class_body
      {
        $$ = [$1];
      }
    ;

class
    : RESERVADA_CLASS IDENTIFICADOR class_body
      {
        $$ = {"tipo":"declaracion_clase", "identificador":$2, "instrucciones":$3};
      }
    | RESERVADA_CLASS IDENTIFICADOR error_declaration
      {
        $$ = $1;
      }
    ;

class_body
    : SIMBOLO_LLAVE_IZQ class_declarations SIMBOLO_LLAVE_DER
      {
        $$ = $2;
      }
    | SIMBOLO_LLAVE_IZQ SIMBOLO_LLAVE_DER
      {
        $$ = "sin_instrucciones";
      }
    | SIMBOLO_LLAVE_IZQ error_declaration SIMBOLO_LLAVE_DER
      {
        $$ = $2;
      }
    ;

class_declarations
    : class_declarations class_declaration
      {
        $1.push($2); $$ = $1;
      }
    | class_declaration
      {
        $$ = [$1];
      }
    ;

class_declaration
    : asignation_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | var_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | function_
      {
        $$ = $1;
      }
    | main_method
      {
        $$ = $1;
      }
    ;

asignation_declaration
    : asignation
      {
        $$ = $1;
      }
    | increment
      {
        $$ = $1;
      }
    | decrement
      {
        $$ = $1;
      }
    ;

increment
    : IDENTIFICADOR SIMBOLO_INCREMENTO
      {
        $$ = {"tipo": "instruccion_incremento", "identificador": $1};
      }
    ;

decrement
    : IDENTIFICADOR SIMBOLO_DECREMENTO
      {
        $$ = {"tipo": "instruccion_decremento", "identificador": $1};
      }
    ;

asignation
    : IDENTIFICADOR SIMBOLO_IGUAL expression
      {
        $$ = {"tipo": "instruccion_asignacion", "identificador": $1, "valor": $3};
      }
    ;

var_declaration
    : tipo_dato var_declarations
      {
        $$ = {"tipo": "declaracion_variable", "tipo_dato": $1, "declaraciones": $2 };
      }
    ;

var_declarations
    : var_declarations SIMBOLO_COMA var_declarationss
      {
        $1.push($3); $$ = $1;
      }
    | var_declarationss
      {
        $$ = [$1];
      }
    ;

var_declarationss
    : IDENTIFICADOR
      {
        $$ = {"identificador":$1};
      }
    | IDENTIFICADOR SIMBOLO_IGUAL expression
      {
        $$ = {"identificador": $1, "valor": $3};
      }
    ;

function_
    : RESERVADA_VOID IDENTIFICADOR parameters function_body
      {
        $$ = {"tipo":"declaracion_metodo", "parametros": $3, "instrucciones": $4};
      }
    | tipo_dato IDENTIFICADOR parameters function_body
      {
        $$ = {"tipo":"declaracion_funcion", "tipo_dato": $1, "parametros": $3, "instrucciones": $4};
      }
    ;

tipo_dato
    : RESERVADA_INT
      {
        $$ = "tipo_int";
      }
    | RESERVADA_DOUBLE
      {
        $$ = "tipo_double";
      }
    | RESERVADA_STRING
      {
        $$ = "tipo_string";
      }
    | RESERVADA_BOOLEAN
      {
        $$ = "tipo_boolean";
      }
    | RESERVADA_CHAR
      {
        $$ = "tipo_char";
      }
    ;

empty_parameters
    : SIMBOLO_PARENTESIS_IZQ SIMBOLO_PARENTESIS_DER
      {
        $$ = null;
      }
    ;

parameters
    : SIMBOLO_PARENTESIS_IZQ params SIMBOLO_PARENTESIS_DER
      {
        $$ = $2;
      }
    | SIMBOLO_PARENTESIS_IZQ SIMBOLO_PARENTESIS_DER
      {
        $$ = "sin_parametros";
      }
    ;

params
    : params SIMBOLO_COMA param
      {
        $1.push($2); $$ = $1;
      }
    | param
      {
        $$ = [$1];
      }
    ;

param
    : tipo_dato IDENTIFICADOR
      {
        $$ = {"tipo_dato": $1, "identificador": $2};
      }
    ;

main_method
    : RESERVADA_VOID RESERVADA_MAIN empty_parameters function_body
      {
        $$ = {"tipo": "declaracion_metodo_main", "instrucciones": $4};
      }
    ;

function_body
    : SIMBOLO_LLAVE_IZQ function_declarations SIMBOLO_LLAVE_DER
      {
        $$ = $2;
      }
    | SIMBOLO_LLAVE_IZQ error_declaration SIMBOLO_LLAVE_DER
      {
        $$ = {"error":"error"};
      }
    | SIMBOLO_LLAVE_IZQ SIMBOLO_LLAVE_DER
      {
        $$ = "sin_instrucciones";
      }
    ;

function_declarations
    : function_declarations function_declaration
      {
        $1.push($2); $$ = $1;
      }
    | function_declaration
      {
        $$ = [$1];
      }
    ;

function_declaration
    : var_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | function_call_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | asignation_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | if_declaration
      {
        $$ = $1;
      }
    | for_declaration
      {
        $$ = $1;
      }
    | while_declaration
      {
        $$ = $1;
      }
    | do_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | switch_declaration
      {
        $$ = $1;
      }
    | print_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | return_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | error_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = {"error":"error"};
      }
    ;

declaration_body
    : SIMBOLO_LLAVE_IZQ declarations SIMBOLO_LLAVE_DER
      {
        $$ = $2;
      }
    | SIMBOLO_LLAVE_IZQ SIMBOLO_LLAVE_DER
      {
        $$ = "sin_instrucciones";
      }
    | SIMBOLO_LLAVE_IZQ error_declaration SIMBOLO_LLAVE_DER
      {
        $$ = $2;
      }
    ;

declarations
    : declarations declaration
      {
        $1.push($2); $$ = $1;
      }
    | declaration
      {
        $$ = [$1];
      }
    ;

declaration
    : var_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | function_call_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | asignation_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | if_declaration
      {
        $$ = $1;
      }
    | for_declaration
      {
        $$ = $1;
      }
    | while_declaration
      {
        $$ = $1;
      }
    | do_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | switch_declaration
      {
        $$ = $1;
      }
    | print_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | return_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    | RESERVADA_CONTINUE SIMBOLO_PUNTOCOMA
      {
        $$ = {"tipo": "instruccion_continue"};
      }
    | RESERVADA_BREAK SIMBOLO_PUNTOCOMA
      {
        $$ = {"tipo": "instruccion_break"};
      }
    | error_declaration SIMBOLO_PUNTOCOMA
      {
        $$ = $1;
      }
    ;

if_declaration
    : RESERVADA_IF condition_declaration declaration_body elif_declaration
      {
        $$ = {"tipo": "instruccion_if_compuesta", "condicion": $2, "instrucciones": $3, "instrucciones_else":$4};
      }
    | RESERVADA_IF condition_declaration declaration_body
      {
        $$ = {"tipo": "instruccion_if", "condicion": $2, "instrucciones": $3}
      }
    ;

elif_declaration
    : RESERVADA_ELSE RESERVADA_IF condition_declaration declaration_body elif_declaration
      {
        let elif = [{"tipo":"instruccion_else_if", "condicion":$3, "instrucciones":$4}]; elif.push($5); $$=elif;
      }
    | RESERVADA_ELSE RESERVADA_IF condition_declaration declaration_body
      {
        $$ = [{"tipo":"instruccion_else_if", "condicion":$3, "instrucciones":$4}]
      }
    | else_declaration
      {
        $$ = [$1];
      }
    ;

else_declaration
    : RESERVADA_ELSE declaration_body
      {
        $$ = {"tipo":"instruccion_else", "instrucciones":$2}
      }
    ;

for_declaration
    : RESERVADA_FOR SIMBOLO_PARENTESIS_IZQ var_declaration SIMBOLO_PUNTOCOMA expression
      SIMBOLO_PUNTOCOMA increment SIMBOLO_PARENTESIS_DER declaration_body
      {
        $$ = {"tipo":"instruccion_for", "variable":$3,"condicion":$5, "cambio":$7};
      }
    | RESERVADA_FOR SIMBOLO_PARENTESIS_IZQ asignation SIMBOLO_PUNTOCOMA expression
      SIMBOLO_PUNTOCOMA increment SIMBOLO_PARENTESIS_DER declaration_body
      {
        $$ = {"tipo":"instruccion_for", "variable":$3,"condicion":$5, "cambio":$7};
      }
    | RESERVADA_FOR SIMBOLO_PARENTESIS_IZQ var_declaration SIMBOLO_PUNTOCOMA expression
      SIMBOLO_PUNTOCOMA decrement SIMBOLO_PARENTESIS_DER declaration_body
      {
        $$ = {"tipo":"instruccion_for", "variable":$3,"condicion":$5, "cambio":$7};
      }
    | RESERVADA_FOR SIMBOLO_PARENTESIS_IZQ asignation SIMBOLO_PUNTOCOMA expression
      SIMBOLO_PUNTOCOMA decrement SIMBOLO_PARENTESIS_DER declaration_body
      {
        $$ = {"tipo":"instruccion_for", "variable":$3,"condicion":$5, "cambio":$7};
      }
    ;

while_declaration
    : RESERVADA_WHILE condition_declaration declaration_body
      {
        $$ = {"tipo":"instruccion_while", "condicion":$2, "instrucciones":$3};
      }
    ;

do_declaration
    : RESERVADA_DO declaration_body RESERVADA_WHILE condition_declaration
      {
        $$ = {"tipo":"instruccion_do_while", "condicion":$4, "instrucciones":$2};
      }
    ;

switch_declaration
    : RESERVADA_SWITCH SIMBOLO_PARENTESIS_IZQ expression SIMBOLO_PARENTESIS_DER switch_body
      {
        $$ = {"tipo":"instruccion_switch", "exprecion_condicion":$3, "casos":$5};
      }
    ;

switch_body
    : SIMBOLO_LLAVE_IZQ cases_declarations SIMBOLO_LLAVE_DER
      {
        $$ = $2
      }
    | SIMBOLO_LLAVE_DER SIMBOLO_LLAVE_DER
      {
        $$ = "sin_casos";
      }
    ;

cases_declarations
    : cases_declarations cases_declaration
      {
        $1.push($2); $$ = $1;
      }
    | cases_declaration
      {
        $$ = [$1];
      }
    ;

cases_declaration
    : RESERVADA_CASE expression SIMBOLO_DOSPUNTOS declarations
      {
        $$ = {"tipo":"switch_case", "expresion_caracteristica":$2, "instrucciones":$4};
      }
    | RESERVADA_DEFAULT SIMBOLO_DOSPUNTOS declarations
      {
        $$ = {"tipo":"switch_default", "instrucciones":$3};
      }
    ;

return_declaration
    :RESERVADA_RETURN expression
      {
        $$ = {"tipo":"instruccion_return", "valor_retornado":$2};
      }
    |RESERVADA_RETURN
      {
        $$ = {"tipo":"instruccion_return"};
      }
    ;

print_declaration
    : RESERVADA_PRINT SIMBOLO_PARENTESIS_IZQ expression SIMBOLO_PARENTESIS_DER
      {
        $$ = {"tipo":"instruccion_print", "expresion_impresa": $3};
      }
    | RESERVADA_PRINT SIMBOLO_PARENTESIS_IZQ SIMBOLO_PARENTESIS_DER
      {
        $$ = {"tipo":"instruccion_print", "expresion_impresa":""};
      }
    ;

condition_declaration
    : SIMBOLO_PARENTESIS_IZQ expression SIMBOLO_PARENTESIS_DER
      {
        $$ = $2;
      }
    ;

expression
    : aritmetic
      {
        $$ = {"expresion":$1};
      }
    ;

aritmetic
    : aritmetic SIMBOLO_MAYOR aritmetic
      {
        $$ = {"operacion":"comparacion_mayor_que_(>)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_MENOR aritmetic
      {
        $$ = {"operacion":"comparacion_menor_que_(<)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_MENORIGUAL aritmetic
      {
        $$ = {"operacion":"comparacion_menor_igual_que_(<=)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_MAYORIGUAL aritmetic
      {
        $$ = {"operacion":"comparacion_mayor_igual_que_(>=)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_ESIGUAL aritmetic
      {
        $$ = {"operacion":"comparacion_igual_(==)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_NOESIGUAL aritmetic
      {
        $$ = {"operacion":"comparacion_no_igual_(!=)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_AND aritmetic
      {
        $$ = {"operacion":"comparacion_AND_(&&)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_OR aritmetic
      {
        $$ = {"operacion":"comparacion_OR_(||)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_MAS aritmetic
      {
        $$ = {"operacion":"comparacion_suma_(+)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_MENOS aritmetic
      {
        $$ = {"operacion":"comparacion_resta_(-)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_POR aritmetic
      {
        $$ = {"operacion":"comparacion_multiplicacion_(*)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_ENTRE aritmetic
      {
        $$ = {"operacion":"comparacion_divicion_(/)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_ELEVADO aritmetic
      {
        $$ = {"operacion":"comparacion_potencia_(^)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | aritmetic SIMBOLO_MODULO aritmetic
      {
        $$ = {"operacion":"comparacion_residuo_(%)","operando_izquierda":$1, "operando_derecha":$3};
      }
    | SIMBOLO_MENOS aritmetic %prec UMINUS1
      {
        $$ = {"operacion":"comparacion_NOT_(!)", "operando":$2};
      }
    | SIMBOLO_NOT aritmetic %prec UMINUS2
      {
        $$ = {"operacion":"comparacion_negacion_(-)","operando":$2};
      }
    | literal
      {
        $$ = $1;
      }
    | SIMBOLO_PARENTESIS_IZQ aritmetic SIMBOLO_PARENTESIS_DER
      {
        $$ = $2;
      }
    ;

function_call_declaration
    : IDENTIFICADOR parameters_data
      {
        $$ = {"tipo":"instruccion_funcion","identificador":$1, "parametros":$2};
      }
    ;

parameters_data
    : SIMBOLO_PARENTESIS_IZQ params_data SIMBOLO_PARENTESIS_DER
      {
        $$ = $2;
      }
    | SIMBOLO_PARENTESIS_IZQ SIMBOLO_PARENTESIS_DER
      {
        $$ = "sin_parametros";
      }
    | SIMBOLO_PARENTESIS_IZQ error_declaration SIMBOLO_PARENTESIS_DER
      {

      }
    ;

params_data
    : params_data SIMBOLO_COMA param_data
      {
        $1.push($3); $$ = $1;
      }
    | param_data
      {
        $$ = [$1];
      }
    ;

param_data
    : expression
      {
        $$ = $1;
      }
    ;

literal
    : integer_literal
      {
        $$ = $1;
      }
    | double_literal
      {
        $$ = $1;
      }
    | boolean_literal
      {
        $$ = $1;
      }
    | string_literal
      {
        $$ = $1;
      }
    | null_literal
      {
        $$ = $1;
      }
    | char_literal
      {
        $$ = $1;
      }
    | function_call_declaration
      {
        $$ = $1;
      }
    | IDENTIFICADOR
      {
        $$ = {"tipo_valor":"identificador", "valor": $1};
      }
    ;

char_literal
    : CARACTER
      {
        $$ = {"tipo_valor":"caracter", "valor": $1};
      }
    ;
integer_literal
    : ENTERO
      {
        $$ = {"tipo_valor":"entero", "valor": Number($1)};
      }
    ;

double_literal
    : DECIMAL
      {
        $$ = {"tipo_valor":"decimal", "valor": Number($1)};
      }
    ;

boolean_literal
    : RESERVADA_TRUE
      {
        $$ = {"tipo_valor":"booleano", "valor": true};
      }
    | RESERVADA_FALSE
      {
        $$ = {"tipo_valor":"booleano", "valor": false};
      }
    ;

string_literal
    : CADENA
      {
        $$ = {"tipo_valor":"cadena", "valor": $1};
      }
    ;

null_literal
    : RESERVADA_NULL
      {
        $$ = {"tipo_valor":"indefinido", "valor": null};
      }
    ;

error_declaration
    : error
      {
        $$ = {"error":"Error_Sintactico"};
      }
    ;
