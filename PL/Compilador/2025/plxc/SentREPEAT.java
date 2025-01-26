import java.text.ParseException;

public class SentREPEAT extends Instruccion {
    private Instruccion exp, cuerpo;

    public SentREPEAT(int linea, Instruccion exp, Instruccion cuerpo) {
        super(linea);
        this.exp = exp;
        this.cuerpo = cuerpo;
    }

    @Override
    public Objeto generarCodigo() throws Exception {
        Objeto expObj;
        String comienzo = Objeto.newEtiqueta();
        String fin = Objeto.newEtiqueta();

        // contador
        Variable contador = new Variable(Objeto.newNombObj(), 0, true, TipoInt.instancia);

        PLXC.out.println(contador.getIDC() + " = 1;");
        // comienzo:
        PLXC.out.println(comienzo + ": ");
        // el num de repeticiones
        expObj = exp.generarCodigo();

        if (!(expObj instanceof Instancia)) {
            throw new ParseException("La expresión del repeat debe ser una instancia (literal o variable)", getLinea());
        }
        // Intentamos convertirlo a int
        if (((Instancia) expObj).getTipo() != TipoInt.instancia) {
            expObj = expObj.generarCodigoMetodo(Metodo.CAST, new Objeto[]{TipoInt.instancia}, getLinea());
        }

        // codigo a comienzo:
        cuerpo.generarCodigo();
        // aumentamos contador
        PLXC.out.println(contador.getIDC() + " = " + contador.getIDC() + " + 1;");

		
		// si ya se repitio todas sus veces a fin, sino a comienzo
		PLXC.out.println("if (" + expObj.getIDC() + " < " + contador.getIDC() + ") goto " + fin + ";");

        // print the value of contador
        //PLXC.out.println("print " + contador.getIDC() + ";");

        PLXC.out.println("goto " + comienzo + ";");

        PLXC.out.println(fin + ": ");

        return null;
    }
}