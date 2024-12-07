import java.io*;
import java.util.*;

public class Calculadora{



public static void main(String[]args){
    BufferedReader lee;
    PrintWriter escribe;

    if(args.length > 0){
        lee=new BufferedReader(new FileReader(args[0]));

    }else{
        lee= new BufferedReader(new InputStreamReader(System.in))
    }

    if(args.length>1){
        escribe=new PrintWriter(new FileWriter(args[1]));
    }else{
        escribe=new PrintWriter(System.out);
    }

    String linea;
    while((linea=reader.readLine())!=null){
        linea=linea.trim();
        if(linea.isEmpty()) continue; 
        int resultado=evaluar(linea);   
    }
    lee.close();
    escribe.close();
}

private static int evaluar(String linea){
    
    linea=linea.replaceAll(" ","");
    return calcular(linea,0)[0];
}

private static int[] calcular(String lin,int index){
    int res=0;
    
    
}


}