import java_cup.runtime.*;

%%

%class Lexer
%unicode
%cup
%line
%column

%{
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

// Espacios en blanco
WhiteSpace = [ \t\r\n]

// Identificadores
Ident = [a-zA-Z][a-zA-Z0-9_]*

// Números
Entero = [0-9]+
Real = [0-9]+\.[0-9]+

// Caracteres
Caracter = '.'

%%

// Palabras reservadas
"int"       { return symbol(sym.INT); }
"float"     { return symbol(sym.FLOAT); }
"char"      { return symbol(sym.CHAR); }
"if"        { return symbol(sym.IF); }
"else"      { return symbol(sym.ELSE); }
"while"     { return symbol(sym.WHILE); }
"do"        { return symbol(sym.DO); }
"for"       { return symbol(sym.FOR); }
"print"     { return symbol(sym.PRINT); }
"to"        { return symbol(sym.TO); }
"downto"    { return symbol(sym.DOWNTO); }
"step"      { return symbol(sym.STEP); }

// Operadores
"+"         { return symbol(sym.MAS); }
"-"         { return symbol(sym.MENOS); }
"*"         { return symbol(sym.MULT); }
"/"         { return symbol(sym.DIVID); }
"="         { return symbol(sym.ASIGNA); }
"=="        { return symbol(sym.IGUAL); }
"!="        { return symbol(sym.DIFERENTE); }
"<"         { return symbol(sym.MENOR); }
">"         { return symbol(sym.MAYOR); }
"<="        { return symbol(sym.MENORIG); }
">="        { return symbol(sym.MAYORIG); }
"&&"        { return symbol(sym.YLOG); }
"||"        { return symbol(sym.OLOG); }
"!"         { return symbol(sym.ADMIR); }
"++"        { return symbol(sym.MASMAS); }
"--"        { return symbol(sym.MENOSMENOS); }
"%"         { return symbol(sym.PORCENT); }
"~"         { return symbol(sym.VIRGU); }

// Delimitadores
"{"         { return symbol(sym.A_LLAVE); }
"}"         { return symbol(sym.C_LLAVE); }
"("         { return symbol(sym.AP); }
")"         { return symbol(sym.CP); }
"["         { return symbol(sym.AC); }
"]"         { return symbol(sym.CC); }
";"         { return symbol(sym.PCOMA); }
","         { return symbol(sym.COMA); }

// Literales
{Entero}    { return symbol(sym.ENTERO, Integer.parseInt(yytext())); }
{Real}      { return symbol(sym.REAL, Double.parseDouble(yytext())); }
{Caracter}  { return symbol(sym.CARACTER, yytext().charAt(1)); }
{Ident}     { return symbol(sym.IDENT, yytext()); }

// Ignorar espacios en blanco
{WhiteSpace}    { /* ignore */ }

// Error por defecto
[^]         { throw new Error("Caracter ilegal <"+yytext()+">"); }
