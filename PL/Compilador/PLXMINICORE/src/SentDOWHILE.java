public class SentDOWHILE extends Instruccion {
    
    private Instruccion cuerpo;  
    private Instruccion condicion;  

    public SentDOWHILE(int linea, Instruccion cuerpo, Instruccion condicion) {
        super(linea);
        this.cuerpo = cuerpo;
        this.condicion = condicion;
    }

    @Override
    public Objeto generarCodigo() throws Exception {
        Objeto oCuerpo = cuerpo.generarCodigo();
        Objeto oCondicion = condicion.generarCodigo();
        Etiqueta inicioCiclo = new Etiqueta(Objeto.newEtiqueta(), oCuerpo.getBloque());
        Etiqueta finCiclo = new Etiqueta(Objeto.newEtiqueta(), oCuerpo.getBloque());
        
        PLXC.out.println(inicioCiclo.getIDC() + ":");
        oCuerpo.generarCodigoMetodo(Metodo.IMPRIMIR, new Objeto[] {oCuerpo});  

        PLXC.out.println("if (" + oCondicion.getIDC() + ") goto " + inicioCiclo.getIDC() + ";");
        PLXC.out.println(finCiclo.getIDC() + ":");
 
        return oCuerpo;  
    }
}