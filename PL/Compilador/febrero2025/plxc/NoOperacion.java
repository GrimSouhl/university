public class NoOperacion extends Instruccion {

    public NoOperacion(int linea) {
        super(linea);
    }

    @Override
    public Objeto generarCodigo() throws Exception {
        return null;
    }
}