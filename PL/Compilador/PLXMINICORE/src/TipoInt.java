
import java.text.ParseException;
import jdk.dynalink.linker.MethodTypeConversionStrategy;

public class TipoInt extends Tipo{
    public static final TipoInt instancia = new TipoInt();
    //el construtor es privado para que no se pueda instanciar, y no se cambia
    //solo loo creas una vez, no puede haber dos objetods representando el mismo tipo
    private TipoInt() {
        super(Predefinidos.ENTERO,0,false);
    }

    public Objeto generarCodigoInstancia(Instancia instancia, String metodo, Objeto[] param) throws Exception{
        Instancia par;
        Variable v;
        String et1;

        switch(metodo){

            case Metodo.IMPRIMIR:
                    PLXC.out.println("print "+instancia.getIDC()+";");
                    break;
            case Metodo.ASIGNA:
                if(!instancia.getMutable()){
                    throw new ParseException("("+instancia.getNombre()+") No ess una variable");
                }
            case Metodo.CONSTRUCTOR:
                Objeto p = param[0];
                if(!(p instanceof Instancia)){
                    throw new ParseException("("+p.getNombre()+") dato requerido a la derecha");
                }
                par = (Instancia) p;

                if(par.getTipo()!= this) {
                    par = (Instancia) par.generarCodigoMetodo(Metodo.CAST, new Objeto[]{this},linea);
                }

               PLXC.out.println( instancia.getIDC() + " = "+ par.getIDC()+ ";");
               return param[0];
            case Metodo.CONSTLITERAL:
                PLXC.out.println( instancia.getIDC() + " = " + ((Literal) instancia).getValor());
                return instancia;
            case Metodo.CAST:
                if( (param == null)|| (param.length !=1) || (!param[0] instanceof Tipo)){
                    throw  new ParseExpection ( "La conversion de tipos necesita";)
                }
                switch(param[0].getNombre()){
                    case Predefinidos.ENTERO:
                        return instancia;
                    case Predefinidos.CARACTER:
                        v = new Variable( newNomObj(), instancia.getBloque(),false, (Tipo) param[0]);
                        PLXC.out.println( v.getIDC() + " = " + instancia.getIDC());
                        return v;
                    case Predefinidos.REAL:
                        v = new Variable( newNomObj(), instancia.getBloque(), false, (Tipo) param[0]);
                        PLXC.out.println( v.getIDC() + " = (float) " + instancia.getIDC());
                        return v;
                    case Predefinidos.BOOL:
                        v = new Variable( newNomObj(), instancia.getBloque(),false, TipoBool);
                        et1 = newEtiq();
                        PLXC.out.println( v.getIDC() + " = 1;");
                        PLXC.out.println( "if ("+ instancia.getIDC()+" != 0) goto "+et1+";");
                        PLXC.out.println(v.getIDC()+" = 0;");
                        PLXC.out.println( et1+":");
                        return v;

                    default:
                        
                }
            case Metodo.SUMA:
            case Metodo.RESTA:
            case Metodo.MULT:
            case Metodo.DIVID:
                if((param==null) || (param.length!=1)||(!(param[0] instanceof  ))){
                    throw new ParseException();
                }

                par = (Instancia) param[0];

                if(this!= par.getTipo()){

                }

                switch (metodo) {
                    case Metodo.SUMA:
                        PLXC.out.print("+");

                }
            
            case djkdsbkj

            case Metodo.IGUAL:
            case.Metodo.MAYOR:
            case.Metodo.DIFERENTE:
            case.Metodo.MENOR:
            case.Metodo.MAYORIG:

                    en mayorig pone dos ifs
        }




        return null;
    }

    public Objeto generarCodigoMetodo(String metodo, Objeto[] param) throws Exception{
        return null;
    }
}


