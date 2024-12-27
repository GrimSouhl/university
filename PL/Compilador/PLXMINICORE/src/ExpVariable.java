public class ExpVariable extends Instancia {
    private Variable var;

    public ExpVariable(String nombre, Tipo tipo, int bloque, boolean mutable, Variable var, int linea) {
        super(nombre, tipo, bloque, mutable, linea);  //Llamada al constructor de Instancia, que llama a Objeto
        this.var = var;
    }

    @Override
    public Objeto generarCodigo() throws Exception {
        return var; //Retorna la variable como objeto generado
    }

    @Override
    public Object generarCodigoMetodo(String metodo, Objeto[] param) throws Exception {
        switch (metodo) {
            case Metodo.CREAR_VARIABLE:
                return "Creando variable: " + var.getNombre();
            default:
                throw new UnsupportedOperationException("Metodo no soportado: " + metodo);
        }
    }
}