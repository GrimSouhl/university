public class copiavariableYLlama extends Instruccion {

    private Instruccion instruccion;
    private String metodo;
    private Instruccion[] params;

    public copiavariableYLlama(int linea, Instruccion instruccion, String metodo, Instruccion[] params) {
        super(linea);
        this.instruccion = instruccion;
        this.metodo = metodo;
        this.params = params;
    }

    @Override
    public Objeto generarCodigo() throws Exception {

        Objeto objparams[] = null;
        Objeto copiavariable;

        Variable obj = (Variable) instruccion.generarCodigo();

        copiavariable = new Variable(Objeto.newNombObj(), obj.getBloque(), obj.getMutable(), obj.getTipo());
        copiavariable.generarCodigoMetodo(Metodo.CREAR_VARIABLE, new Objeto[] { obj }, getLinea());

        if (params != null) {

            objparams = new Objeto[params.length];

            for (int i = 0; i < params.length; i++) {

                objparams[i] = params[i].generarCodigo();
            }
        }

        obj.generarCodigoMetodo(metodo, objparams, getLinea());

        return copiavariable;// VALOR ANTERIOR
    }
}