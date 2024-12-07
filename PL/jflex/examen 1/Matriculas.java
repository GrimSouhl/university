
import java.io.FileReader;
import java.io.IOException;


public class Matriculas {


    public static String cadena;

    public static void main(String arg[]) {
        
        if (arg.length > 0) {
            try {
                Yylex lex = new Yylex(new FileReader(arg[0]));
                Yytoken yytoken = null;
                while ((yytoken = lex.yylex()) != null) {
                   
                    if (yytoken.getToken() == Yytoken.S1) {
                       
                        cadena+=  "S1";

                    }else if(yytoken.getToken() == Yytoken.S2){
                        
                        cadena+=  "S2";
                        
                    } else if(yytoken.getToken() == Yytoken.S3){
                     
                        cadena+=  "S3";
                    }else if(yytoken.getToken() == Yytoken.X){
                        cadena+=  "X";
                    }else if(yytoken.getToken() == Yytoken.COMA){
                        cadena+= ",";
                    }else if(yytoken.getToken() == Yytoken.TAB){
                        cadena+= "\t";
                    }else if(yytoken.getToken() == Yytoken.ESP){
                        cadena+= " ";
                    }else if(yytoken.getToken() == Yytoken.EOLN){
                        cadena+= "\n";
                    }
                    

                }
                System.out.print(cadena);
                
            

            } catch (IOException e) {
            }
        }
    }
}

