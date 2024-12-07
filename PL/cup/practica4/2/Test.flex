import java_cup.runtime.*;
%%   
%cup 
%%      
int							{ return new Symbol(sym.INT, yytext() ); }
long						{ return new Symbol(sym.LONG, yytext() ); }
float						{ return new Symbol(sym.FLOAT, yytext() ); }
double						{ return new Symbol(sym.DOUBLE, yytext() ); }
char						{ return new Symbol(sym.CHAR, yytext() ); }
boolean						{ return new Symbol(sym.BOOLEAN, yytext() ); }
[a-zA-Z][a-zA-Z0-9]*		{ return new Symbol(sym.IDENT, yytext() ); }
;				            { return new Symbol(sym.PYC, yytext() ); }
,				            { return new Symbol(sym.COMA, yytext() ); }
.|\n						{  }   
