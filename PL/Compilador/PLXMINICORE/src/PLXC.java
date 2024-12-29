import java.io.IOException;
import java.io.PrintStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

public class PLXC {

    // Instancia del lexer (análisis léxico)
    public static PLXC lex;

    // Tabla de símbolos donde se guardan las variables, funciones, etc.
    public static TablaSimbolos ts;

    // Un contador para los objetos generados (por ejemplo, variables temporales)
    public static int numObj = 0;

    // Objeto para manejar la salida generada
    public static PrintStream out;

    // Constructor por defecto
    public PLXC() {
        lex = new PLXC();  
        ts = new TablaSimbolos();  
        out = System.out;  
    }

    public static void initLexer(String input) {
        lex.yyreset(input); 
    }


    public static void analizar() {
        try {
            Parser p = new Parser(lex);
            p.parse(); 
        } catch (Exception e) {
            System.err.println("Error en el análisis: " + e.getMessage());
        }
    }

    public static void imprimirResultado() {
        ts.imprimirTabla();  
    }
    public static void main(String[] args) {
        if (args.length < 1) {
            System.err.println("Debe proporcionar un archivo de entrada.");
            return;
        }

        String archivo = args[0];
        try {
            String input = new String(Files.readAllBytes(Paths.get(archivo)), StandardCharsets.UTF_8);
            initLexer(input); 
            analizar();  
            imprimirResultado();  
        } catch (IOException e) {
            System.err.println("Error al leer el archivo: " + e.getMessage());
        }
    }

    public int getLine() {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'getLine'");
    }
}