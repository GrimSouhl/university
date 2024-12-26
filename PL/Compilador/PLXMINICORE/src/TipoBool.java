public class TipoBool extends Tipo {
    public static final TipoBool instancia = new TipoBool();
    
    private TipoBool() {
        super(Predefinidos.BOOLEANO, 0, false);
    }

    public Objeto generarCodigoInstancia(Instancia instancia, String metodo, Objeto[] param) throws Exception {
        return null;
    }

    public Objeto generarCodigoMetodo(String metodo, Objeto[] param) throws Exception {
        return null;
    }
}
