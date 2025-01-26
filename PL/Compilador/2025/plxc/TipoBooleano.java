import java.text.ParseException;

public class TipoBooleano extends Tipo{
	public static final TipoBooleano instancia = new TipoBooleano();
	
	public TipoBooleano() {
		super(Predefinidos.ENTERO, 0, false);
	}

	@Override
    public Objeto generarCodigoMetodo(String metodo, Objeto[] params, int linea) throws Exception {
        return null;
    }

    @Override
    public Objeto generarCodigoInstancia(Instancia instancia, String metodo, Objeto[] params, int linea) throws Exception {
        Objeto obj;
        Tipo tipo;
        Variable var;
        String etq;
        
        switch(metodo) {
            case Metodo.MOSTRAR:
                PLXC.out.println("print " + instancia.getIDC() + ";");
                break;
            case Metodo.ASIGNAR: // a = ....
                if(!instancia.getMutable()) {
                    throw new ParseException("No se puede reasignar un valor a la constante <" + instancia.getNombre() + ">", linea);
                }
                break;  
            case Metodo.CREAR_VARIABLE: 
                obj = params[0];
                
                if(!(obj instanceof Instancia)) {
                    throw new ParseException("<" + obj.getNombre() + "> no es una instancia (literal o variable)", linea);
                }
                
                tipo = ((Instancia) obj).getTipo();
                if(tipo != this) {
                    throw new ParseException("<" + obj.getNombre() + "> no es de tipo " + getNombre(), linea);
                }

                PLXC.out.println(instancia.getIDC() + " = " + obj.getIDC() + ";");
                return params[0];
            case Metodo.CREAR_LITERAL:
                PLXC.out.println(instancia.getIDC() + " = " + ((Literal) instancia).getValor() + ";");
                return instancia;
                
            //Operaciones
            case Metodo.SUMA:
            case Metodo.RESTA:
            case Metodo.PRODUCTO:
            case Metodo.DIVISION:
                if(params == null) {
                    throw new ParseException("No se han pasado parámetros para " + metodo, linea);
                }

                obj = params[0];

                if(!(obj instanceof Instancia)) {
                    throw new ParseException("<" + obj.getNombre() + "> no es una instancia (literal o variable)", linea);
                }

                tipo = ((Instancia) obj).getTipo();

                switch(tipo.getNombre()) {
                    case Predefinidos.REAL:
                        var = (Variable) instancia.generarCodigoMetodo(Metodo.CAST, new Objeto[]{TipoReal.instancia}, linea);
                        return var.generarCodigoMetodo(metodo, params, linea);
                    case Predefinidos.CARACTER:
                        if(!metodo.equals(Metodo.SUMA) && !metodo.equals(Metodo.RESTA)) {
                            throw new ParseException("Método " + metodo + " no aplicable entre " + getNombre() + " y " + Predefinidos.CARACTER, linea);
                        }
                    case Predefinidos.ENTERO:
                        break;
                    default:
                        throw new ParseException("Tipo inválido para operar con " + getNombre(), linea);
                }

                var = new Variable(newNombObj(), instancia.getBloque(), false, this);
				PLXC.out.print(var.getIDC() + " = " + instancia.getIDC());

                switch(metodo) {
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

                if(!(obj instanceof Instancia)) {
                    throw new ParseException(obj.getNombre() + " no es una instancia (literal o variable)", linea);
                }

                if(((Instancia) obj).getTipo() != this) {
                    obj = obj.generarCodigoMetodo(Metodo.CAST, new Objeto[]{this}, linea);
                }

                Objeto cociente = instancia.generarCodigoMetodo(Metodo.DIVISION, params, linea); 
                Objeto mult = cociente.generarCodigoMetodo(Metodo.PRODUCTO, params, linea); 
                return instancia.generarCodigoMetodo(Metodo.RESTA, new Objeto[]{mult}, linea); 
            // Relacionales
            case Metodo.IGUAL:
            case Metodo.DISTINTO:
            case Metodo.MENOR:
            case Metodo.MENOR_IGUAL:
            case Metodo.MAYOR:
            case Metodo.MAYOR_IGUAL:
                obj = params[0];

                if(!(obj instanceof Instancia)) {
                    throw new ParseException(obj.getNombre() + " no es una instancia (literal o variable)", linea);
                }

                tipo = ((Instancia) obj).getTipo();
                if(tipo != this && tipo != TipoInt.instancia) {
                    throw new ParseException("Tipo inválido para comparar con " + getNombre(), linea);
                }

                var = new Variable(newNombObj(), instancia.getBloque(), false, TipoBool.instancia);
                PLXC.out.println(var.getIDC() + " = 1;"); // $t0 = 1

                etq = newEtiqueta();
                switch(metodo) {
                    case Metodo.IGUAL:
                        PLXC.out.println("if (" + instancia.getIDC() + " == " + obj.getIDC() + ") goto " + etq + ";"); // if (a == p) goto L;
                        break;
                    case Metodo.DISTINTO:
                        PLXC.out.println("if (" + instancia.getIDC() + " != " + obj.getIDC() + ") goto " + etq + ";"); // if (a != p) goto L;
                        break;
                    case Metodo.MENOR:
                        PLXC.out.println("if (" + instancia.getIDC() + " < " + obj.getIDC() + ") goto " + etq + ";"); // if (a < p) goto L;
                        break;
                    case Metodo.MENOR_IGUAL:
                        PLXC.out.println("if (" + instancia.getIDC() + " < " + obj.getIDC() + ") goto " + etq + ";"); // if (a < p) goto L;
                        PLXC.out.println("if (" + instancia.getIDC() + " == " + obj.getIDC() + ") goto " + etq + ";"); // if (a == p) goto L;
                        break;
                    case Metodo.MAYOR:
                        PLXC.out.println("if (" + obj.getIDC() + " < " + instancia.getIDC() + ") goto " + etq + ";"); // if (p < a) goto L;
                        break;
                    case Metodo.MAYOR_IGUAL:
                        PLXC.out.println("if (" + obj.getIDC() + " < " + instancia.getIDC() + ") goto " + etq + ";"); // if (p < a) goto L;
                        PLXC.out.println("if (" + instancia.getIDC() + " == " + obj.getIDC() + ") goto " + etq + ";"); // if (a == p) goto L;
                        break;
                }

                PLXC.out.println(var.getIDC() + " = 0;"); // $t0 = 0;

                PLXC.out.println(etq + ":"); // L:

                return var;
            case Metodo.SIGUIENTE:
                PLXC.out.println(instancia.getIDC() + " = " + instancia.getIDC() + " + 1;"); // $t0 = a + 1;

                return instancia;
            case Metodo.ANTERIOR:
                PLXC.out.println(instancia.getIDC() + " = " + instancia.getIDC() + " - 1;"); // $t0 = a - 1;

                return instancia;
            case Metodo.OPUESTO:
                var = new Variable(newNombObj(), instancia.getBloque(), false, this);
                PLXC.out.println(var.getIDC() + " = 0 - " + instancia.getIDC() + ";"); // $t0 = 0 - a;

                return var;
            default:
                throw new ParseException("Método " + metodo + " no permitido para " + getNombre(), linea);
        }

        return null; // Aquí van todos los métodos que no devuelven nada
    }
}