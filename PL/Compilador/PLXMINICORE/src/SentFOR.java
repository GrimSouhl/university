public class SentFOR extends Instruccion {

    private Instruccion inicializacion;
    private Instruccion condicion;      
    private Instruccion incremento;     
    private Instruccion cuerpo;          


    public SentFOR(int linea, Instruccion inicializacion, Instruccion condicion, Instruccion incremento, Instruccion cuerpo) {
        super(linea);
        this.inicializacion = inicializacion;
        this.condicion = condicion;
        this.incremento = incremento;
        this.cuerpo = cuerpo;
    }

    @Override
    public Objeto generarCodigo() throws Exception {

        Objeto oInicializacion = inicializacion.generarCodigo();

        Objeto oCondicion = condicion.generarCodigo();
        Objeto oIncremento = incremento.generarCodigo();
  
        Objeto oCuerpo = cuerpo.generarCodigo();
        
        Etiqueta inicioCiclo = new Etiqueta(Objeto.newEtiqueta(), oCuerpo.getBloque());
        Etiqueta finCiclo = new Etiqueta(Objeto.newEtiqueta(), oCuerpo.getBloque());

        PLXC.out.println(inicioCiclo.getIDC() + ":");
        
        oCuerpo.generarCodigoMetodo(Metodo.IMPRIMIR, new Objeto[] { oCuerpo });
        oIncremento.generarCodigoMetodo(Metodo.IMPRIMIR, new Objeto[] { oIncremento });

        PLXC.out.println("if (" + oCondicion.getIDC() + ") goto " + inicioCiclo.getIDC() + ";");
        PLXC.out.println(finCiclo.getIDC() + ":");

        return oCuerpo; 
    }
}