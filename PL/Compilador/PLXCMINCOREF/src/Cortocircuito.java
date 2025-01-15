
public class Cortocircuito extends Instruccion{

    private Instruccion e1, e2;
    private String metodo;
    
    public Cortocircuito (int linea, String metodo, Instruccion e1, Instruccion e2 ){

            super(linea);
            this.e1 = e1;
            this.metodo=metodo;
            this.e2=e2;
    }

    @Override
    public Objeto generarCodigo() throws Exception{

        Objeto o1 = e1.generarCodigo();

        Etiqueta destino = new Etiqueta( Objeto.newEtiqueta(), o1.getBloque());

        Objeto r = (Objeto) o1.generarCodigoMetodo( metodo,new Objeto[] {destino}, getLinea());

        Objeto o2 = e2.generarCodigo();

        r.generarCodigoMetodo(Metodo.CREAR_VARIABLE, new Objeto[]{o2} , getLinea());

        destino.generarCodigoMetodo(Metodo.PONER_ETQ,null,getLinea());
        
        return r;
    }

}
