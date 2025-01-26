import java.text.ParseException;

public class TipoInt extends Tipo{
	public static final TipoInt instancia = new TipoInt();
	
	public TipoInt() {
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

            case Metodo.DESPDERECHA:
            case Metodo.DESPIQUIERDA:

                 /*divide el numero de la derecha dos veces por el de la izquierda */
                if(params == null) { throw new ParseException("No se han pasado parámetros para " + metodo, linea); }
                obj = params[0];
                if(!(obj instanceof Instancia)) { 
                    throw new ParseException("<" + obj.getNombre() + "> no es una instancia (literal o variable)", linea); 
                }
                tipo = ((Instancia) obj).getTipo();
                if(tipo!=this){
                    obj = obj.generarCodigoMetodo(Metodo.CAST, new Objeto[]{this}, linea);
                }

                var = new Variable(newNombObj(), instancia.getBloque(), false, this);
                String ini = newEtiqueta();
                String fin = newEtiqueta();
                //inicializamos la variable a 0
                PLXC.out.println(var.getIDC()+" = 0;");

                //inicio:
                PLXC.out.println(ini+": ");
                //si nuestro contador var es igual al num de repeticiones vamos a fin
                PLXC.out.println("if( "+obj.getIDC()+" == "+var.getIDC()+") goto "+fin+";");

                switch(metodo) {

	                case Metodo.DESPDERECHA:
                        //dividimos la instancia(variable) entre dos
	                	PLXC.out.println(instancia.getIDC()+" = "+instancia.getIDC()+"/2;");
                        //y aumentamos nuestro contador en uno
	                	PLXC.out.println(var.getIDC()+" = "+var.getIDC()+" + 1;");

	                	break;
	                
	                case Metodo.DESPIQUIERDA:
                        //multiplicamos la instancia(variable) entre dos
	                	PLXC.out.println(instancia.getIDC()+" = "+instancia.getIDC()+"*2;");
                        //y aumentamos nuestro contador en uno
	                	PLXC.out.println(var.getIDC()+" = "+var.getIDC()+"+1;");

	                	break;

                }
                //volvemos a ini
                PLXC.out.println("goto "+ini+";");
                //finiquitamos
                PLXC.out.println(fin+": ");
                //devolvemos el valor resultado
                return instancia;


            case Metodo.MOSTRAR:
                PLXC.out.println("print " + instancia.getIDC() + ";");
                break;
            case Metodo.ASIGNAR: 
                if(!instancia.getMutable()) {
                    throw new ParseException("No se puede reasignar un valor a la constante <" + instancia.getNombre() + ">", linea);
                } 
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

            case Metodo.CAST:
                if(!(params[0] instanceof Tipo)) {
                    throw new ParseException(params[0].getNombre() + " no es un tipo", linea);
                }

                switch(params[0].getNombre()) {
                    case Predefinidos.ENTERO:
                        return instancia;
                    case Predefinidos.CARACTER:
                        var = new Variable(newNombObj(), instancia.getBloque(), false, (Tipo) params[0]);
                        PLXC.out.println(var.getIDC() + " = " + instancia.getIDC() + ";");
                        return var;
                    case Predefinidos.REAL:
                        var = new Variable(newNombObj(), instancia.getBloque(), false, (Tipo) params[0]);
                        PLXC.out.println(var.getIDC() + " = (float) " + instancia.getIDC() + ";");
                        return var;
                    case Predefinidos.BOOL:
                        var = new Variable(newNombObj(), instancia.getBloque(), false, (Tipo) params[0]);
                        etq = newEtiqueta();
                        PLXC.out.println(var.getIDC() + " = 1;"); 
                        PLXC.out.println("if (" + instancia.getNombre() + " != 0) goto " + etq + ";"); 
                        PLXC.out.println(var.getIDC() + " = 0;"); 
                        PLXC.out.println(etq + ":"); 

                        return var;
                    default:
                        throw new ParseException("No se puede convertir un " + getNombre() + " a " + params[0].getNombre(), linea);
                }
                
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
            case Metodo.SIGUIENTE:
                PLXC.out.println(instancia.getIDC() + " = " + instancia.getIDC() + " + 1;");

                return instancia;
            case Metodo.ANTERIOR:
                PLXC.out.println(instancia.getIDC() + " = " + instancia.getIDC() + " - 1;"); 

                return instancia;
            case Metodo.OPUESTO:
                var = new Variable(newNombObj(), instancia.getBloque(), false, this);
                PLXC.out.println(var.getIDC() + " = 0 - " + instancia.getIDC() + ";"); 

                return var;
            default:
                throw new ParseException("metodo " + metodo + " erroneo para tipo " + getNombre(), linea);
        }

        return null; 
    }
}