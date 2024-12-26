public abstract class Tipo extends Objeto{

    public static final class Predefinidos{
        public static final String ENTERO = "$int";
        public static final String BOOLEANO = "$bool";
        public static final String CARACTER = "$char";
        public static final String REAL = "$float";
    }

    public Tipo(String nombre, int bloque, boolean mutable) {
        super(nombre, bloque, mutable);
    }

    public abstract Objeto generarCodigoInstancia(Instancia instancia, String metodo, Objeto[] param) throws Exception ;
}
