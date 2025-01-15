public class NoOperacion extends Instruccion {

    // Constructor
    public NoOperacion(int linea) {
        super(linea);
    }

    // Implementación del método generarCodigo() que no hace nada
    @Override
    public Objeto generarCodigo() throws Exception {
        // Esta instrucción no hace nada, por lo que simplemente retorna null
        return null;
    }
}