
%%

%xstate MATRICULA


%%


[A-Z]{1,2}[\-]{0,1}[1-9][0-9]{0,5}   { return new Yytoken(Yytoken.S1, yytext()); }

[A-Z]{1,2}[\-]{0,1}[1-9][0-9]{0-3}[\-]{0,1}[A-PS-Z]{1,2}  { return new Yytoken(Yytoken.S2, yytext()); }

