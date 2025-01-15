public class SentIF extends Instruccion {

    private Instruccion condicion;  
    private Instruccion cuerpoIf;   
    private Instruccion cuerpoElse;  

    public SentIF(int linea, Instruccion condicion, Instruccion cuerpoIf, Instruccion cuerpoElse) {
        super(linea);
        this.condicion = condicion;
        this.cuerpoIf = cuerpoIf;
        this.cuerpoElse = cuerpoElse;
    }

    @Override
    public Objeto generarCodigo() throws Exception {
 
        Objeto oCondicion = condicion.generarCodigo();
        
        Etiqueta etiquetaElse = null;
        Etiqueta etiquetaFin = new Etiqueta(Objeto.newNombObj(), oCondicion.getBloque());

        if (cuerpoElse != null) {
            etiquetaElse = new Etiqueta(Objeto.newNombObj(), oCondicion.getBloque());
        }

        PLXC.out.println("if (" + oCondicion.getIDC() + ") goto " + etiquetaFin.getIDC() + ";");
        Objeto oCuerpoIf = cuerpoIf.generarCodigo();
        PLXC.out.println(etiquetaFin.getIDC() + ":");

        if (cuerpoElse != null) {
            PLXC.out.println("goto " + etiquetaElse.getIDC() + ";");
            PLXC.out.println(etiquetaElse.getIDC() + ":");
            cuerpoElse.generarCodigo();
        }

        return oCuerpoIf; 
    }
}