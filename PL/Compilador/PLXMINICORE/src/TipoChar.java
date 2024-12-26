public class TipoChar extends Tipo {
    public static final TipoChar instancia = new TipoChar();
    
    private TipoChar() {
        super(Predefinidos.CARACTER, 0, false);
    }

    public Objeto generarCodigoInstancia(Instancia instancia, String metodo, Objeto[] param) throws Exception {
        return null;
    }

    public Objeto generarCodigoMetodo(String metodo, Objeto[] param) throws Exception {
        return null;
    }
}


//imprimir pone printc