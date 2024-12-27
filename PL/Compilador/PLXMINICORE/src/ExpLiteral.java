public class ExpLiteral extends Instancia {
    
    private Literal l;

    public ExpLiteral(int linea, Literal l){
        super(l.getNombre(), l.getTipo(), l.getBloque(), true, linea);  
        this.l = l;
    }
    @Override
    public Objeto generarCodigo() throws Exception {
        //Generar código para devolver un objeto que representa el literal
        Objeto resultado = new Objeto(l.getValor(), getLinea(), true);
        return resultado;
    }

    @Override
    public Objeto generarCodigoMetodo(String metodo, Objeto[] params) throws Exception {
        switch (metodo) {
            case Metodo.CREAR_LITERAL:
                return generarCodigo();  
            case Metodo.IMPRIMIR:
                //Si se llama a imprimir, genera el código de impresión
                Objeto resultado = generarCodigo();
                resultado.generarCodigoMetodo(Metodo.IMPRIMIR, new Objeto[] { resultado });
                return resultado;
            default:
                throw new UnsupportedOperationException("Metodo no soportado: " + metodo);
        }
    }

}
