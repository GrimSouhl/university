public class CopiaYLlamaMetodo extends Instruccion{

    private Instruccion e1, param[];
    private String metodo;

    public CopiaYLlamaMetodo(int linea, Instruccion e1,  String metodo, Instruccion[] param) {
		super(linea);
		this.e1=e1;
		this.metodo=metodo;
		this.param=param;
	}
    
    @Override
    public Objeto generarCodigo() throws Exception {
        Objeto oParam[] = null;
        Objeto r;

        Variable o1 = (Variable) e1.generarCodigo();

        r = new Variable( Objeto.newNombObj(), o1.getBloque(),true, o1.getTipo());
        r.generarCodigoMetodo(Metodo.CREAR_VARIABLE, new Objeto[] {o1},getLinea());

        if(param!= null){
            oParam = new Objeto[param.length];

            for( int k= 0; k<param.length; k++){
                oParam[k] = param[k].generarCodigo();
            }
        }

        o1.generarCodigoMetodo(metodo,oParam,getLinea());

            return r;
    }
}
