
import java.io.FileReader;
import java.io.IOException;


public class srt {



    public static void main(String arg[]) {

        if (arg.length > 0) {
            try {
                Yylex lex = new Yylex(new FileReader(arg[0]));
                Yytoken yytoken = null;
                while ((yytoken = lex.yylex()) != null) {
                   
                    if (yytoken.getToken() == Yytoken.S1) {
                       
                        
                    }else if(yytoken.getToken() == Yytoken.SUBTITULO){
                        subtitulo++;
                        lineas++;
                        
                    } else if(yytoken.getToken() == Yytoken.EOLN){
                        lineas++;
                    }else{
                        String regex = "[\\-\\-\\>]";
                        String[] canontime = yytoken.getSubs().split(regex);
                        //System.out.println(Arrays.toString(canontime));
                        int t1=0;
                        int t2= 0;

                        regex = "[:,]";
                       
                        String[] aux = canontime[0].strip().split(regex);
                        //System.out.println(Arrays.toString(aux));
                        t1= Integer.parseInt(aux[0])*3600+Integer.parseInt(aux[1])*60+ Integer.parseInt(aux[2]);
                        String[] aux2 = canontime[3].strip().split(regex);  
                        //System.out.println(Arrays.toString(aux2));  
                        t2= Integer.parseInt(aux2[0])*3600+Integer.parseInt(aux2[1])*60+ Integer.parseInt(aux2[2]);
                        
                        segundos += (t2-t1); 
                        
                    }
                    

                }
                System.out.println("NUM_SUBTITULOS "+subtitulo);
                System.out.println("TIEMPO_TOTAL "+segundos);
                System.out.println("NUM_LINEAS "+lineas);
                System.out.println("NUM_PALABRAS "+palabra);
            

            } catch (IOException e) {
            }
        }
    }
}

