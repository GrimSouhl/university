import java_cup.runtime.*;
%%   
%cup 
%%      
\[    		                { return new Symbol(sym.AC); }
\]    		                { return new Symbol(sym.CC); }
,    		                { return new Symbol(sym.COMA); }
0|[1-9][0-9]*				{ return new Symbol(sym.NUMERO, new Integer(yytext())); }
.|\n						{  }   
