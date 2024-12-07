%%
%%

[a-zA-Z]*[aeiouAEIOU]{2}|[a-zA-Z]*[aeiouAEIOU]{2}[a-zA-Z]*[aeiouAEIOU] { return new Yytoken( Yytoken.A); }

[a-zA-Z]*[aeiouAEIOU]{2}[a-zA-Z]+  { return new Yytoken(Yytoken.C); }

[a-zA-Z]*[aeiouAEIOU]   { return new Yytoken(Yytoken.B); }

[a-zA-Z]+  {return new Yytoken(Yytoken.D); }

\n {}
. {}
