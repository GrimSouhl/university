public class ExpVariable extends Instruccion {

    private Variable var;

    public ExpVariable(int linea, Variable var) {

        super(linea);
        this.var= var;

    }

    @Override
    public Objeto generarCodigo() throws Exception {

        return var;

    }

}