public class CopiaYLlama extends Instruccion {
    private Instruccion exp;
    private String metodo;
    private Instruccion[] params;

    public CopiaYLlama(int linea, Instruccion exp, String metodo, Instruccion[] params) {
        super(linea);
        this.exp = exp;
        this.metodo = metodo;
        this.params = params;
    }

    @Override
    public Objeto generarCodigo() throws Exception {
        Objeto objParams[] = null;
        Objeto copia;

        // Creamos variable
        Variable obj = (Variable) exp.generarCodigo();

        // La copiamos en otra
        copia = new Variable(Objeto.newNombObj(), obj.getBloque(), obj.getMutable(), obj.getTipo());
        copia.generarCodigoMetodo(Metodo.CREAR_VARIABLE, new Objeto[]{obj}, getLinea());

        if(params != null) {
            objParams = new Objeto[params.length];
            for(int i = 0; i < params.length; i++) {
                objParams[i] = params[i].generarCodigo();
            }
        }


        obj.generarCodigoMetodo(metodo, objParams, getLinea());

        return copia;
    }
}