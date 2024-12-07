
%%



%%

\n       {  return new Yytoken(Yytoken.EOLN, yytext()); }

\t       {  return new Yytoken(Yytoken.TAB, yytext()); }

\s       {  return new Yytoken(Yytoken.ESP, yytext()); }

\,       {  return new Yytoken(Yytoken.COMA, yytext()); }

[A-Z]{1,2}[\-]{0,1}[1-9][0-9]{0,5}   { return new Yytoken(Yytoken.S1, yytext()); }

[A-Z]{1,2}[\-]{0,1}[0-9]{0,4}[\-]{0,1}[A-PS-Z]{1,2}  { return new Yytoken(Yytoken.S2, yytext()); }

[0-9]{4}[\-]{0,1}[BCDFGHJKLMNPRSTVWXYZ]{3}   { return new Yytoken(Yytoken.S3, yytext()); }

[0-9A-Z\-]+     { return new Yytoken(Yytoken.X, yytext()); }


.     { return new Yytoken(Yytoken.NADA, yytext());   }

