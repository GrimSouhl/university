import java.text.ParseException;

public class TipoBool extends Tipo {
    public static final TipoBool instancia = new TipoBool();
    
    private TipoBool() {
        super(Predefinidos.BOOLEANO, 0, false);  
    }

    @Override
    public Objeto generarCodigoInstancia(Instancia instancia, String metodo, Objeto[] param) throws Exception {
        Instancia par;
        Variable v;
        String et1;

        switch (metodo) {
            case Metodo.IMPRIMIR:
                PLXC.out.println("print " + instancia.getIDC() + ";");
                break;

            case Metodo.ASIGNA:
                if (!instancia.getMutable()) {
                    throw new ParseException("La variable " + instancia.getNombre() + " no es mutable", getBloque());
                }
                PLXC.out.println(instancia.getIDC() + " = " + param[0].getIDC() + ";");
                break;

            case Metodo.CONSTRUCTOR:
                Objeto p = param[0];
                if (!(p instanceof Instancia)) {
                    throw new ParseException("Se esperaba una instancia a la derecha", getBloque());
                }
                par = (Instancia) p;

                if (par.getTipo() != this) {
                    par = (Instancia) par.generarCodigoMetodo(Metodo.CAST, new Objeto[]{this});
                }

                PLXC.out.println(instancia.getIDC() + " = " + par.getIDC() + ";");
                return param[0];

            case Metodo.CREAR_LITERAL:
                PLXC.out.println(instancia.getIDC() + " = " + ((Literal) instancia).getValor() + ";");
                return instancia;

            case Metodo.CAST:
                if (param == null || param.length != 1 || !(param[0] instanceof Tipo)) {
                    throw new ParseException("La conversión de tipos requiere un parámetro válido", getBloque());
                }

                switch (param[0].getNombre()) {
                    case Predefinidos.ENTERO:
                        v = new Variable(newNombObj(), instancia.getBloque(), false, (Tipo) param[0]);
                        PLXC.out.println(v.getIDC() + " = (" + Predefinidos.ENTERO + ") " + instancia.getIDC() + ";");
                        return v;
                    case Predefinidos.REAL:
                        v = new Variable(newNombObj(), instancia.getBloque(), false, (Tipo) param[0]);
                        PLXC.out.println(v.getIDC() + " = (" + Predefinidos.REAL + ") " + instancia.getIDC() + ";");
                        return v;
                    case Predefinidos.CARACTER:
                        v = new Variable(newNombObj(), instancia.getBloque(), false, (Tipo) param[0]);
                        PLXC.out.println(v.getIDC() + " = (" + Predefinidos.CARACTER + ") " + instancia.getIDC() + ";");
                        return v;
                    case Predefinidos.BOOLEANO:
                        return instancia; // El tipo ya es correcto.
                    default:
                        throw new ParseException("Tipo no soportado para conversión: " + param[0].getNombre(), getBloque());
                }

            case Metodo.SUMA:
            case Metodo.RESTA:
            case Metodo.MULT:
            case Metodo.DIVID:
                throw new ParseException("Operaciones aritméticas no están permitidas para tipo booleano", getBloque());

            case Metodo.OPUESTO:
                // El opuesto lógico (NOT) para un booleano
                PLXC.out.println(instancia.getIDC() + " = !" + instancia.getIDC() + ";");
                return instancia;

            case Metodo.IGUAL:
            case Metodo.DIFERENTE:
            case Metodo.MAYOR:
            case Metodo.MENOR:
            case Metodo.MAYORIG:
                if (param == null || param.length != 1 || !(param[0] instanceof Instancia)) {
                    throw new ParseException("Se esperaba un parámetro de tipo instancia para la comparación", getBloque());
                }

                par = (Instancia) param[0];

                if (this != par.getTipo()) {
                    throw new ParseException("Incompatibilidad de tipos para la operación de comparación", getBloque());
                }

                String et2 = newEtiqueta();
                switch (metodo) {
                    case Metodo.IGUAL:
                        PLXC.out.println("if (" + instancia.getIDC() + " == " + par.getIDC() + ") goto " + et2 + ";");
                        break;
                    case Metodo.DIFERENTE:
                        PLXC.out.println("if (" + instancia.getIDC() + " != " + par.getIDC() + ") goto " + et2 + ";");
                        break;
                    case Metodo.MAYOR:
                        PLXC.out.println("if (" + instancia.getIDC() + " > " + par.getIDC() + ") goto " + et2 + ";");
                        break;
                    case Metodo.MENOR:
                        PLXC.out.println("if (" + instancia.getIDC() + " < " + par.getIDC() + ") goto " + et2 + ";");
                        break;
                    case Metodo.MAYORIG:
                        PLXC.out.println("if (" + instancia.getIDC() + " >= " + par.getIDC() + ") goto " + et2 + ";");
                        break;
                }

                PLXC.out.println(instancia.getIDC() + " = 0;");
                PLXC.out.println("goto " + et2 + ";");
                PLXC.out.println(et2 + ":");
                return instancia;

            case Metodo.YLOG:
                if (param == null || param.length != 1 || !(param[0] instanceof Instancia)) {
                    throw new ParseException("Se esperaba un parámetro para la operación lógica AND", getBloque());
                }

                par = (Instancia) param[0];
                PLXC.out.println(instancia.getIDC() + " = " + instancia.getIDC() + " && " + par.getIDC() + ";");
                return instancia;

            case Metodo.OLOG:
                if (param == null || param.length != 1 || !(param[0] instanceof Instancia)) {
                    throw new ParseException("Se esperaba un parámetro para la operación lógica OR", getBloque());
                }

                par = (Instancia) param[0];
                PLXC.out.println(instancia.getIDC() + " = " + instancia.getIDC() + " || " + par.getIDC() + ";");
                return instancia;

            case Metodo.NLOG:
                PLXC.out.println(instancia.getIDC() + " = !" + instancia.getIDC() + ";");
                return instancia;

            default:
                throw new ParseException("Método no soportado: " + metodo, getBloque());
        }

        return null;
    }

    @Override
    public Objeto generarCodigoMetodo(String metodo, Objeto[] param) throws Exception {
        return null;  // Si no necesitas un comportamiento diferente, deja este método vacío
    }
}
