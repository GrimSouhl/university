public class SentWHILE extends Instruccion {

    private Instruccion condicion; 
    private Instruccion cuerpo;     

    public SentWHILE(int linea, Instruccion condicion, Instruccion cuerpo) {
        super(linea);
        this.condicion = condicion;
        this.cuerpo = cuerpo;
    }

    @Override
    public Objeto generarCodigo() throws Exception {

        Objeto oCondicion = condicion.generarCodigo();
        Etiqueta etiquetaInicio = new Etiqueta(Objeto.newEtiqueta(), oCondicion.getBloque());
        Etiqueta etiquetaFin = new Etiqueta(Objeto.newEtiqueta(), oCondicion.getBloque());

        PLXC.out.println(etiquetaInicio.getIDC() + ":");
        PLXC.out.println("if (" + oCondicion.getIDC() + ") goto " + etiquetaFin.getIDC() + ";");

        Objeto oCuerpo = cuerpo.generarCodigo();
        PLXC.out.println("goto " + etiquetaInicio.getIDC() + ";");
        PLXC.out.println(etiquetaFin.getIDC() + ":");

        return oCuerpo;  
    }
}