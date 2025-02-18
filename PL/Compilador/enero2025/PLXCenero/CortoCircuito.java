public class CortoCircuito extends Instruccion {

    private String metodo;
    private Instruccion in1; 
    private Instruccion in2;
    

    public CortoCircuito(int linea, Instruccion in1, String metodo, Instruccion in2) {

        super(linea);
        this.metodo = metodo;
        this.in1 = in1;
        this.in2 = in2;
    }

    @Override
    public Objeto generarCodigo() throws Exception {
       
        Objeto objA = in1.generarCodigo(); 

        Etiqueta etq = new Etiqueta(Objeto.newEtiqueta(), objA.getBloque());

        Objeto result = objA.generarCodigoMetodo(metodo, new Objeto[]{etq}, getLinea()); 

        Objeto objB = in2.generarCodigo(); 

        result.generarCodigoMetodo(Metodo.CREAR_VARIABLE, new Objeto[]{objB}, getLinea()); 

        etq.generarCodigoMetodo(Metodo.PONER_ETQ, null, getLinea()); 

        return result;
        
    }
}