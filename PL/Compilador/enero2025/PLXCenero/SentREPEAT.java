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

        String comienzo = Objeto.newEtiqueta();
        String fin = Objeto.newEtiqueta();
        Objeto expObj;

        // contador
        String contador = Objeto.newNombObj();
        PLXC.out.println(contador + " = 1;");
        // comienzo:
        PLXC.out.println(comienzo + ": ");
        // codigo a comienzo:
        cuerpo.generarCodigo();

        // el num de repeticiones
        expObj = exp.generarCodigo();

        if (!(expObj instanceof Instancia)) {
            throw new ParseException("La expresión del repeat debe ser una instancia (literal o variable)", getLinea());
        }
        // Intentamos convertirlo a int
        if (((Instancia) expObj).getTipo() != TipoInt.instancia) {
            expObj = expObj.generarCodigoMetodo(Metodo.CAST, new Objeto[] { TipoInt.instancia }, getLinea());
        }

        // aumentamos contador
        PLXC.out.println(contador + " = " + contador + " + 1;");

        // si ya se repitio todas sus veces a fin, sino a comienzo
        PLXC.out.println("if (" + expObj.getIDC() + " < " + contador + ") goto " + fin + ";");

        PLXC.out.println("goto " + comienzo + ";");

        // PLXC.out.println("print " + contador.getIDC()+ ";");

        PLXC.out.println(fin + ": ");

        return null;
    }
}