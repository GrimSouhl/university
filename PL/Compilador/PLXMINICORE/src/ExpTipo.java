public class ExpTipo extends Objeto {
    private Tipo tipo; // El tipo asociado (e.g., int, float)

    // Constructor
    public ExpTipo(String nombre, int bloque, boolean mutable, Tipo tipo, int linea) {
        super(nombre, bloque, mutable, linea);
        this.tipo = tipo;
    }

    // Obtener el tipo
    public Tipo getTipo() {
        return tipo;
    }

    // Implementación del método abstracto generarCodigoMetodo
    @Override
    public Object generarCodigoMetodo(String metodo, Objeto[] param) throws Exception {
        switch (metodo) {
            case Metodo.CAST:
                // Maneja la conversión de tipos si es necesario
                return "Casting a tipo " + tipo.toString();
            default:
                throw new UnsupportedOperationException("Metodo no soportado: " + metodo);
        }
    }

    public String generarCodigo() {
        return tipo.toString(); // Generar el código asociado al tipo
    }
}