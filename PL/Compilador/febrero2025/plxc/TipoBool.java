import java.text.ParseException;

public class TipoBool extends Tipo {
    public static TipoBool instancia = new TipoBool();

    private TipoBool() {
        super(Predefinidos.BOOL, 0, false);
    }

    @Override
    public Objeto generarCodigoMetodo(String metodo, Objeto[] params, int linea) throws Exception {
        return null;
    }

    @Override
    public Objeto generarCodigoInstancia(Instancia instancia, String metodo, Objeto[] params, int linea)
            throws Exception {
        Objeto obj;
        Objeto q;
        Instancia varq;
        Tipo tipo;
        Variable var;
        Etiqueta etq;
        String ettrue, etfalse, etiqueta;
        String checkfalse, checktrue;
        String ttrue,ffalse;
        String ini, fin;
        String terminar;
        switch (metodo) {

            case Metodo.MOSTRAR:

                etfalse = newEtiqueta();
                ettrue = newEtiqueta();
                PLXC.out.println("	if( " + instancia.getIDC() + " == 0 ) goto " + etfalse + ";");// TIMESKIP TO ET1

                // ESCRIBIMOS TRUE:
                PLXC.out.println("  writec 116 ;"); // t
                PLXC.out.println("  writec 114 ;"); // r
                PLXC.out.println("  writec 117 ;"); // u
                PLXC.out.println("  writec 101 ;"); // e
                PLXC.out.println("  writec 10 ;"); // LF nueva linea
                PLXC.out.println("	goto " + ettrue + ";"); // TIMESKIP TO ET2

                // ESCRIBIMOS FALSE:
                PLXC.out.println(etfalse + " :"); // ET1
                PLXC.out.println("	writec 102 ;"); // f
                PLXC.out.println("	writec 97 ;"); // a
                PLXC.out.println("	writec 108 ;"); // l
                PLXC.out.println("	writec 115 ;"); // s
                PLXC.out.println("	writec 101 ;");// e
                PLXC.out.println("	writec 10 ;");// LF NUEVA LINEA

                PLXC.out.println(ettrue + " :"); // ET2
                break;

            case Metodo.ASIGNAR:
                if (!instancia.getMutable()) {
                    throw new ParseException(
                            "No se puede reasignar un valor a la constante <" + instancia.getNombre() + ">", linea);
                }
            case Metodo.CREAR_VARIABLE:

                obj = params[0];

                if (!(obj instanceof Instancia)) {
                    throw new ParseException("<" + obj.getNombre() + "> no es una instancia (literal o variable)",
                            linea);
                }
                tipo = ((Instancia) obj).getTipo();
                if (tipo != this) {
                    throw new ParseException("<" + obj.getNombre() + "> no es de tipo " + getNombre(), linea);
                }

                PLXC.out.println(instancia.getIDC() + " = " + obj.getIDC() + ";");
                return params[0];

            case Metodo.CREAR_LITERAL:
                PLXC.out.println(instancia.getIDC() + " = " + ((Literal) instancia).getValor() + ";");
                return instancia;

            case Metodo.CAST:
                if (!(params[0] instanceof Tipo)) {
                    throw new ParseException(params[0].getNombre() + " no es un tipo", linea);
                }

                switch (params[0].getNombre()) {
                    case Predefinidos.ENTERO:
                        return instancia;
                    case Predefinidos.REAL:
                        var = new Variable(newNombObj(), instancia.getBloque(), false, (Tipo) params[0]);
                        PLXC.out.println(var.getIDC() + " = (float) " + instancia.getIDC() + ";");
                        return var;
                    case Predefinidos.BOOL:
                        break;
                    default:
                        throw new ParseException(
                                "No se puede convertir un " + getNombre() + " a " + params[0].getNombre(), linea);
                }

            case Metodo.AND:
            case Metodo.OR:

                if (params == null) {
                    throw new ParseException("No se pasaron parámetros para " + metodo, linea);
                }

                etq = (Etiqueta) params[0];

                var = new Variable(newNombObj(), instancia.getBloque(), false, this);
                var.generarCodigoMetodo(Metodo.CREAR_VARIABLE, new Objeto[] { instancia }, linea);

                switch (metodo) {
                    case Metodo.AND:
                        PLXC.out.println("if (" + var.getIDC() + " == 0) goto " + etq.getNombre() + ";");
                        break;
                    case Metodo.OR:
                        PLXC.out.println("if (" + var.getIDC() + " == 1) goto " + etq.getNombre() + ";");
                        break;
                }

                return var;

            case Metodo.NOT:
                var = new Variable(newNombObj(), instancia.getBloque(), false, this);

                PLXC.out.println(var.getIDC() + " = 1 - " + instancia.getIDC() + ";");


                return var;
            
            case Metodo.NAND:

                q= params[0];
                if ((params == null) || (params.length != 1) || (!(q instanceof Instancia))) {
                    throw new Error("(" + q.getNombre() + ") nos falta la q en linea:" + linea);
                }
                varq= (Instancia) q;
                if (varq.getTipo() != this) {
                    throw new Error(varq.getNombre() + " no es de tipo " + getNombre());
                }
                var = new Variable(newNombObj(), instancia.getBloque(), false, this);
                ttrue = newEtiqueta();
                ffalse = newEtiqueta();
                //si alguno de los dos es falso entonces es true
                PLXC.out.println("if(" + instancia.getIDC() + "== 0 ) goto " + ttrue + ";");
                PLXC.out.println("if( " + varq.getIDC() + " == 0 ) goto " + ttrue + ";");
                //sino false
                
                PLXC.out.println("	" + var.getIDC() + " = 0 ;");
                PLXC.out.println("	goto " + ffalse + ";"); //TIMESKIP TO ETFALSE

                PLXC.out.println(ttrue + " :"); //ETTRUE
                PLXC.out.println("	" + var.getIDC() + " = 1 ;"); //VERDADERO
                PLXC.out.println(ffalse + " :"); //ETFALSE

            return var;
        
            case Metodo.XOR:

                q= params[0];
                if ((params == null) || (params.length != 1) || (!(q instanceof Instancia))) {
                    throw new Error("(" + q.getNombre() + ") nos falta la q en linea:" + linea);
                }
                varq= (Instancia) q;
                if (varq.getTipo() != this) {
                    throw new Error(varq.getNombre() + " no es de tipo " + getNombre());
                }
                var = new Variable(newNombObj(), instancia.getBloque(), false, this);
                checkfalse = newEtiqueta();
                fin = newEtiqueta();

                PLXC.out.println("if (" + instancia.getIDC() + " == " + varq.getIDC() + ") goto " + checkfalse + ";");
                PLXC.out.println(var.getIDC() + " = 1;");
                PLXC.out.println("goto " + fin + ";");

                PLXC.out.println(checkfalse + " :");
                PLXC.out.println(var.getIDC() + " = 0;");
                
                PLXC.out.println(fin + " :");

                return var;
                

            case Metodo.IMPLICACION:

                //PILLAMOS LA VARIABLE Q:
                q = params[0];
                if ((params == null) || (params.length != 1) || (!(q instanceof Instancia))) {
                    throw new Error("(" + q.getNombre() + ") nos falta la q en linea:" + linea);
                }
                varq= (Instancia) q;
                if (varq.getTipo() != this) {
                    throw new Error(varq.getNombre() + " no es de tipo " + getNombre());
                }
                
                var = new Variable(newNombObj(), instancia.getBloque(), false, this);
                ettrue = newEtiqueta();
                etfalse = newEtiqueta();

                //si P es 0 caso verdadero
                PLXC.out.println("if(" + instancia.getIDC() + "== 0 ) goto " + ettrue + ";");
                //si Q es 1 caso verdadero
                PLXC.out.println("if( " + varq.getIDC() + " != 0 ) goto " + ettrue + ";");
                 //OTHERWISE: FASLO:
                PLXC.out.println("	" + var.getIDC() + " = 0 ;");
                PLXC.out.println("	goto " + etfalse + ";"); //TIMESKIP TO ETFALSE

                PLXC.out.println(ettrue + " :"); //ETTRUE
                PLXC.out.println("	" + var.getIDC() + " = 1 ;"); //VERDADERO
                PLXC.out.println(etfalse + " :"); //ETFALSE

                return var;
            default:
                throw new ParseException("metodo " + metodo + " erroneo para tipo " + getNombre(), linea);

        }
        return null;
    }
}