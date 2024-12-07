import java_cup.runtime.*;
%%   
%cup 
%%      
suma			{ return new Symbol(sym.SUMA, yytext() ); }
resta			{ return new Symbol(sym.RESTA, yytext() ); }
multiplica		{ return new Symbol(sym.MULTIPLICA, yytext() ); }
divide			{ return new Symbol(sym.DIVIDE, yytext() ); }
0|[1-9][0-9]*	        { return new Symbol(sym.NUMERO, new Integer(yytext()) ); }
,			{ return new Symbol(sym.COMA, yytext() ); }
;			{ return new Symbol(sym.PYC, yytext() ); }
\(			{ return new Symbol(sym.AP, yytext() ); }
\)			{ return new Symbol(sym.CP, yytext() ); }
[^]			{  }   
