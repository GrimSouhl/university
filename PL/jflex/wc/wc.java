
import java.io.FileReader;
import java.io.IOException;

public class wc {

    public static int palabra = 0, lineas = 0, caracteres = 0;

    public static void main(String arg[]) {

        if (arg.length > 0) {
            try {
                Yylex lex = new Yylex(new FileReader(arg[0]));
                Yytoken yytoken = null;
                while ((yytoken = lex.yylex()) != null) {
                    if (yytoken.getToken() == Yytoken.PALABRA) {
                        palabra++;
                        caracteres += yytoken.getLen();
                    }else if(yytoken.getToken() == Yytoken.CARACTER){
                        caracteres++;
                        
                    } else {
                        lineas++;
                        caracteres++;
                    }
                    

                }
                System.out.println(lineas + " " +palabra+" "+ caracteres+" "+ arg[0]);
            

            } catch (IOException e) {
            }
        }
    }
}