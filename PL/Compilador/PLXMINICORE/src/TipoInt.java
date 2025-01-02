
import java.text.ParseException;

public class TipoInt extends Tipo{
    public static final TipoInt instancia = new TipoInt();
    private TipoInt() {
        super(Predefinidos.ENTERO,0,false);
    }

   
    public Objeto generarCodigoMetodo(String metodo, Objeto[] param, int linea) throws Exception{
        return null;
    }

    public Objeto generarCodigoInstancia(Instancia instancia, String metodo, Objeto[] param,int linea) throws Exception{
        Instancia par;
        Variable v;
        String et1;

        switch(metodo){

            case Metodo.IMPRIMIR:
                    PLXC.out.println("print "+instancia.getIDC()+";");
                    break;
            case Metodo.ASIGNA:
                if(!instancia.getMutable()){
                    throw new ParseException("("+instancia.getNombre()+") No es una variable", getBloque());
                }
            case Metodo.CONSTRUCTOR:
                Objeto p = param[0];
                if(!(p instanceof Instancia)){
                    throw new ParseException("("+p.getNombre()+") dato requerido a la derecha", getBloque());
                }
                par = (Instancia) p;

                if(par.getTipo()!= this) {
                    par = (Instancia) par.generarCodigoMetodo(Metodo.CAST, new Objeto[]{this}, linea);
                }

               PLXC.out.println( instancia.getIDC() + " = "+ par.getIDC()+ ";");
               return param[0];
            case Metodo.CREAR_LITERAL:
                PLXC.out.println( instancia.getIDC() + " = " + ((Literal) instancia).getValor());
                return instancia;
            case Metodo.CAST:
                if( (param == null)|| (param.length !=1) || (!(param[0] instanceof Tipo))){
                    throw  new ParseException ( "La conversion de tipos necesita", getBloque());
                }
                switch(param[0].getNombre()){
                    case Predefinidos.ENTERO:
                        return instancia;
                    case Predefinidos.CARACTER:
                        v = new Variable( newNombObj(), instancia.getBloque(),false, (Tipo) param[0]);
                        PLXC.out.println( v.getIDC() + " = " + instancia.getIDC());
                        return v;
                    case Predefinidos.REAL:
                        v = new Variable( newNombObj(), instancia.getBloque(), false, (Tipo) param[0]);
                        PLXC.out.println( v.getIDC() + " = (float) " + instancia.getIDC());
                        return v;
                    case Predefinidos.BOOLEANO:
                        v = new Variable( newNombObj(), instancia.getBloque(),false, TipoBool.instancia);
                        et1 = newEtiqueta();
                        PLXC.out.println( v.getIDC() + " = 1;");
                        PLXC.out.println( "if ("+ instancia.getIDC()+" != 0) goto "+et1+";");
                        PLXC.out.println(v.getIDC()+" = 0;");
                        PLXC.out.println( et1+":");
                        return v;

                    default:
                        throw new ParseException("Tipo no soportado para conversión: " + param[0].getNombre(), getBloque());
              
                        
                }
            case Metodo.SUMA:
            case Metodo.RESTA:
            case Metodo.MULT:
            case Metodo.DIVID:
                if((param==null) || (param.length!=1)||(!(param[0] instanceof Instancia))){
                    throw new ParseException("Se esperaba un parámetro de tipo instancia", getBloque());
    
                }

                par = (Instancia) param[0];

                if(this!= par.getTipo()){
                    throw new ParseException("Incompatibilidad de tipos para la operación: " + metodo, getBloque());
                }

                switch (metodo) {
                    case Metodo.SUMA:
                    PLXC.out.println(instancia.getIDC() + " = " + instancia.getIDC() + " + " + par.getIDC() + ";");
                    break;
                    case Metodo.RESTA:
                    PLXC.out.println(instancia.getIDC() + " = " + instancia.getIDC() + " - " + par.getIDC() + ";");
                    break;
                    case Metodo.MULT:
                    PLXC.out.println(instancia.getIDC() + " = " + instancia.getIDC() + " * " + par.getIDC() + ";");
                    break;
                    case Metodo.DIVID:
                    PLXC.out.println(instancia.getIDC() + " = " + instancia.getIDC() + " / " + par.getIDC() + ";");
                    break;
                }

            case Metodo.IGUAL:
            case Metodo.MAYOR:
            case Metodo.DIFERENTE:
            case Metodo.MENOR:
            case Metodo.MAYORIG:
                // Comparación de dos valores de tipo int
                if (param == null || param.length != 1 || !(param[0] instanceof Instancia)) {
                    throw new ParseException("Se esperaba un parámetro de tipo instancia", getBloque());
                }

                par = (Instancia) param[0];

                // Verificar que los tipos coincidan
                if (this != par.getTipo()) {
                    throw new ParseException("Incompatibilidad de tipos para la operación de comparación", getBloque());
                }

                // Generar código de comparación
                    String et2 = newEtiqueta();
                switch (metodo) {
                    case Metodo.IGUAL:
                        PLXC.out.println("if (" + instancia.getIDC() + " == " + par.getIDC() + ") goto " + et2 + ";");
                        break;
                    case Metodo.MAYOR:
                        PLXC.out.println("if (" + instancia.getIDC() + " > " + par.getIDC() + ") goto " + et2 + ";");
                        break;
                    case Metodo.DIFERENTE:
                        PLXC.out.println("if (" + instancia.getIDC() + " != " + par.getIDC() + ") goto " + et2 + ";");
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
             
            
            case Metodo.MODULO:
                if (param == null || param.length != 1 || !(param[0] instanceof Instancia)) {
                    throw new ParseException("Se esperaba un parámetro de tipo instancia para el módulo", getBloque());
                }
                par = (Instancia) param[0];
                if (this != par.getTipo()) {
                    throw new ParseException("Incompatibilidad de tipos para la operación de módulo", getBloque());
                }
                PLXC.out.println(instancia.getIDC() + " = " + instancia.getIDC() + " % " + par.getIDC() + ";");
                return instancia;

            case Metodo.OPUESTO:
                PLXC.out.println(instancia.getIDC() + " = -" + instancia.getIDC() + ";");
                return instancia;

            default:
                throw new ParseException("Método no soportado: " + metodo, getBloque());

        }
        return null;
    }
    
}


