import java.text.ParseException;

public class TipoChar extends Tipo {

    /*
     * ARREGLAR:
     * 
     * >ctd char11.plx.ctd
     * 
     * >ctd charoper1.plx.ctd
     * 
     * 
     * >ctd charoper3.plx.ctd
     * 
     * runtime error
     * >ctd charoper9.plx.ctd
     * 
     * 
     */
    public static final TipoChar instancia = new TipoChar();

    private TipoChar() {
        super(Predefinidos.CARACTER, 0, false);
    }

    private boolean isIntegerLiteral(String value) {
        try {
            int number = Integer.parseInt(value); //Intenta convertir el valor a un entero
            return true; //Si la conversión es exitosa, es un literal entero
        } catch (NumberFormatException e) {
            return false; //Si ocurre una excepción, no es un literal enteroç
        }
    }

    @Override
    public Objeto generarCodigoMetodo(String metodo, Objeto[] params, int linea) throws Exception {
        return null;
    }

    @Override
    public Objeto generarCodigoInstancia(Instancia instancia, String metodo, Objeto[] params, int linea)
            throws Exception {
        Objeto obj;
        Tipo tipo;
        Variable var;
        String etq;

        switch (metodo) {
            case Metodo.MOSTRAR:
                if(instancia.getTipo() != TipoChar.instancia){
                    throw new ParseException( "NO SE PUEDE MOSTRAR",linea);
                }
                PLXC.out.println("printc " + instancia.getIDC() + ";");
                break;

            case Metodo.ASIGNAR:
                if (!instancia.getMutable()) {
                    throw new ParseException(
                            "No se puede reasignar un valor a la constante <" + instancia.getNombre() + ">", linea);
                }

                obj = params[0];

                if (!(obj instanceof Instancia)) {
                    throw new ParseException("<" + obj.getNombre() + "> no es una instancia (literal o variable)",
                            linea);
                }
                tipo = ((Instancia) obj).getTipo();

                // Asignación de char a char
                if (tipo != this) {
                    throw new ParseException("<" + obj.getNombre() + "> no es de tipo " + getNombre(), linea);
                }
                PLXC.out.println(instancia.getIDC() + " = " + obj.getIDC() + ";");
                return params[0];


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
                    var = new Variable(newNombObj(), instancia.getBloque(), false, (Tipo) params[0]);
                    PLXC.out.println(var.getIDC() + " = (int) " + instancia.getIDC() + ";");
                    return var;
                    case Predefinidos.CARACTER:
                        return instancia;
                    default:
                        throw new ParseException(
                                "No se puede convertir un " + getNombre() + " a " + params[0].getNombre(), linea);
                }
                // Operaciones
            case Metodo.SUMA:
            case Metodo.RESTA:
            case Metodo.DIVISION:
            case Metodo.PRODUCTO:

                if (params == null) {
                    throw new ParseException("No se han pasado parámetros para " + metodo, linea);
                }

                obj = params[0];

                if (!(obj instanceof Instancia)) {
                    throw new ParseException("<" + obj.getNombre() + "> no es una instancia (literal o variable)",
                            linea);
                }

                tipo = ((Instancia) obj).getTipo();

                if (tipo != TipoChar.instancia && tipo != TipoInt.instancia) {
                    throw new ParseException("Tipo inválido para operar con " + getNombre(), linea);
                }

                var = new Variable(newNombObj(), instancia.getBloque(), false, TipoInt.instancia);
                PLXC.out.print(var.getIDC() + " = " + instancia.getIDC());

                switch (metodo) {
                    case Metodo.SUMA:
                        PLXC.out.print(" + ");
                        break;
                    case Metodo.RESTA:
                        PLXC.out.print(" - ");
                        break;
                    case Metodo.PRODUCTO:
                        PLXC.out.print(" * ");
                        break;
                    case Metodo.DIVISION:
                        PLXC.out.print(" / ");
                        break;
                }

                PLXC.out.println(obj.getIDC() + ";");

                return var;

            case Metodo.MODULO:
                obj = params[0];

                if (!(obj instanceof Instancia)) {
                    throw new ParseException(obj.getNombre() + " no es una instancia (literal o variable)", linea);
                }

                if (((Instancia) obj).getTipo() != this) {
                    obj = obj.generarCodigoMetodo(Metodo.CAST, new Objeto[] { this }, linea);
                }

                Objeto cociente = instancia.generarCodigoMetodo(Metodo.DIVISION, params, linea); 
                Objeto mult = cociente.generarCodigoMetodo(Metodo.PRODUCTO, params, linea); 
                return instancia.generarCodigoMetodo(Metodo.RESTA, new Objeto[] { mult }, linea); 

            // Relacionales
            case Metodo.IGUAL:
            case Metodo.DISTINTO:
            case Metodo.MENOR:
            case Metodo.MENOR_IGUAL:
            case Metodo.MAYOR:
            case Metodo.MAYOR_IGUAL:
                obj = params[0];

                if (!(obj instanceof Instancia)) {
                    throw new ParseException(obj.getNombre() + " no es una instancia (literal o variable)", linea);
                }

                tipo = ((Instancia) obj).getTipo();
                if (tipo != this && tipo != TipoReal.instancia) {
                    throw new ParseException("Tipo inválido para comparar con " + getNombre(), linea);
                }

                var = new Variable(newNombObj(), instancia.getBloque(), false, TipoBool.instancia);
                PLXC.out.println(var.getIDC() + " = 1;"); // $t0 = 1

                etq = newEtiqueta();
                switch (metodo) {
                    case Metodo.IGUAL:
                        PLXC.out.println("if (" + instancia.getIDC() + " == " + obj.getIDC() + ") goto " + etq + ";");
                        break;
                    case Metodo.DISTINTO:
                        PLXC.out.println("if (" + instancia.getIDC() + " != " + obj.getIDC() + ") goto " + etq + ";"); 
                        break;
                    case Metodo.MENOR:
                        PLXC.out.println("if (" + instancia.getIDC() + " < " + obj.getIDC() + ") goto " + etq + ";"); 
                        break;
                    case Metodo.MENOR_IGUAL:
                        PLXC.out.println("if (" + instancia.getIDC() + " < " + obj.getIDC() + ") goto " + etq + ";"); 
                        PLXC.out.println("if (" + instancia.getIDC() + " == " + obj.getIDC() + ") goto " + etq + ";"); 
                        break;
                    case Metodo.MAYOR:
                        PLXC.out.println("if (" + obj.getIDC() + " < " + instancia.getIDC() + ") goto " + etq + ";"); 
                        break;
                    case Metodo.MAYOR_IGUAL:
                        PLXC.out.println("if (" + obj.getIDC() + " < " + instancia.getIDC() + ") goto " + etq + ";"); 
                        PLXC.out.println("if (" + instancia.getIDC() + " == " + obj.getIDC() + ") goto " + etq + ";"); 
                                                                                                                      
                        break;
                }

                PLXC.out.println(var.getIDC() + " = 0;");
                PLXC.out.println(etq + ":");
                return var;

            default:
                throw new ParseException(metodo + " no reconocido", linea);
        }

        return null;
    }
}