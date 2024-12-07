import java_cup.runtime.*;
%%   
%cup 
%%      
\+    		                { return new Symbol(sym.MAS); }
\-    		                { return new Symbol(sym.MENOS); }
\^    		                { return new Symbol(sym.ELEV); }
=    		                { return new Symbol(sym.ASIG); }
;    		                { return new Symbol(sym.PYC); }
[Xx]    		            { return new Symbol(sym.X); }
0|[1-9][0-9]*				{ return new Symbol(sym.NUMERO, new Integer(yytext()) ); }
.|\n						{  }   
