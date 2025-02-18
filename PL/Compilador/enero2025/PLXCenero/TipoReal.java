import java.text.ParseException;

public class TipoReal extends Tipo {


    /*
     * 
     * 
     * ARREGLAR:  
                    >ctd  real4.plx.ctd 
     * 
     * 
     * 
     */
    public static final TipoReal instancia = new TipoReal();

    private TipoReal() {
        super(Predefinidos.REAL, 0, false);
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
                PLXC.out.println("print " + instancia.getIDC() + ";");
                break;

            case Metodo.ASIGNAR:
                if (!instancia.getMutable()) {
                    throw new ParseException(
                            "No se puede reasignar un valor a la constante <" + instancia.getNombre() + ">", linea);
                }

            case Metodo.CREAR_VARIABLE:
                obj = params[0];
                if (!(obj instanceof Instancia)) {
                    throw new ParseException("<" + obj.getNombre() + ">no es una instancia (literal o variable)",
                            linea);
                }

                tipo = ((Instancia) obj).getTipo();
                if (tipo != this) {
                    if (tipo.getNombre().equals(Predefinidos.ENTERO) && this.getNombre().equals(Predefinidos.REAL)) {
                        // Convertir int a float si es necesario
                        PLXC.out.println(instancia.getIDC() + " = (float) " + obj.getIDC() + ";");
                    } else {
                        throw new ParseException("<" + obj.getNombre() + "> no es de tipo " + getNombre(), linea);
                    }
                }else{
                    
                    PLXC.out.println(instancia.getIDC() + " = " + obj.getIDC() + ";");
                }

                return params[0];

            case Metodo.CREAR_LITERAL:
                PLXC.out.println(instancia.getIDC() + " = " + ((Literal) instancia).getValor() + ";");
                return instancia;

            case Metodo.CAST:
                if (!(params[0] instanceof Tipo)) {
                    throw new ParseException(params[0].getNombre() + " no es un tipo", linea);
                }

                switch (params[0].getNombre()) {
                    case Predefinidos.REAL:
                        return instancia;
                    case Predefinidos.ENTERO:
                        var = new Variable(newNombObj(), instancia.getBloque(), false, (Tipo) params[0]);
                        PLXC.out.println(var.getIDC() + " = (int) " + instancia.getIDC() + ";");
                        return var;
                    default:
                        throw new ParseException(
                                "No se puede convertir un " + getNombre() + " a " + params[0].getNombre(), linea);
                }
            case Metodo.MODULO:
                obj = params[0];

                if(!(obj instanceof Instancia)) {
                    throw new ParseException(obj.getNombre() + "no es una instancia (literal o variable)", linea);
                }

                if(((Instancia) obj).getTipo() != this) {
                    obj = obj.generarCodigoMetodo(Metodo.CAST, new Objeto[]{this}, linea);
                }

                Objeto cociente = instancia.generarCodigoMetodo(Metodo.DIVISION, params, linea); 
                Objeto mult = cociente.generarCodigoMetodo(Metodo.PRODUCTO, params, linea); 
                return instancia.generarCodigoMetodo(Metodo.RESTA, new Objeto[]{mult}, linea); 

            case Metodo.SUMA:
            case Metodo.RESTA:
            case Metodo.PRODUCTO:
            case Metodo.DIVISION:
                if (params == null) {
                    throw new ParseException("No se han pasado parametros para " + metodo, linea);
                }
                obj = params[0];
                if (!(obj instanceof Instancia)) {
                    throw new ParseException("<" + obj.getNombre() + ">no es una instancia(literal o variable)",
                            linea);
                }
                tipo = ((Instancia) obj).getTipo();
                
                switch(tipo.getNombre()) {
                    case Predefinidos.REAL:
                       break;
                    case Predefinidos.CARACTER:
                        if(!metodo.equals(Metodo.SUMA) && !metodo.equals(Metodo.RESTA)) {
                            throw new ParseException("M3todo " + metodo + " no aplicable entre " + getNombre() + " y " + Predefinidos.CARACTER, linea);
                        }
                    case Predefinidos.ENTERO:
                         var = (Variable) instancia.generarCodigoMetodo(Metodo.CAST, new Objeto[]{TipoInt.instancia}, linea);
                         return var.generarCodigoMetodo(metodo, params, linea);
                    default:
                        throw new ParseException("Tipo invalido para operar con " + getNombre(), linea);
                }

                var = new Variable(newNombObj(), instancia.getBloque(), false, this);
                PLXC.out.print(var.getIDC() + " = " + instancia.getIDC());

                switch (metodo) {
                    case Metodo.SUMA:
                        PLXC.out.print(" +r ");
                        break;
                    case Metodo.RESTA:
                        PLXC.out.print(" -r ");
                        break;
                    case Metodo.PRODUCTO:
                        PLXC.out.print(" *r ");
                        break;
                    case Metodo.DIVISION:
                        PLXC.out.print(" /r ");
                        break;
                }

                PLXC.out.println(obj.getIDC() + ";");
                return var;
                // Relacionales
            case Metodo.IGUAL:
            case Metodo.DISTINTO:
            case Metodo.MENOR:
            case Metodo.MENOR_IGUAL:
            case Metodo.MAYOR:
            case Metodo.MAYOR_IGUAL:
                obj = params[0];

                if(!(obj instanceof Instancia)) {
                    throw new ParseException(obj.getNombre() + "no es una instancia (literal o variable)", linea);
                }

                tipo = ((Instancia) obj).getTipo();
                if(tipo != this && tipo != TipoReal.instancia) {
                    throw new ParseException("Tipo invalido para comparar con " + getNombre(), linea);
                }

                var = new Variable(newNombObj(), instancia.getBloque(), false, TipoBool.instancia);
                PLXC.out.println(var.getIDC() + " = 1;"); 

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