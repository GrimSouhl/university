/**
Palabras que tienen al menos dos vocales seguidas, y terminan en vocal. -> A
Palabras que NO tienen dos vocales seguidas, y terminan en vocal -> B
Palabras que tienen al menos dos vocales seguidas, y terminan en consonante -> C
Palabras que NO tienen dos vocales seguidas, y terminan en consonante -> D
 */

import java.io.FileReader;
import java.io.IOException;

public class cpv {
    
    public static int A=0,B=0,C=0,D=0;

    public static void main(String arg[]) {
        
        if (arg.length>0) {
            try {
                Yylex lex = new Yylex(new FileReader(arg[0]));
                Yytoken yytoken = null;
		while (  (yytoken = lex.yylex()) != null  ) {
                   if(yytoken.getToken() == Yytoken.A){
                    A++;
                   }else if(yytoken.getToken() == Yytoken.B){
                    B++;
                   }else if(yytoken.getToken() == Yytoken.C){
                    C++;
                   }else {
                    D++;
                   }
                }
                System.out.println( "A "+ A);
                System.out.println( "B "+ B);
                System.out.println( "C "+ C);
                System.out.println( "D "+ D);
	    } catch (IOException e) {
	    }
        }
    }
}