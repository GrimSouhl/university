public class SentSelectFrom extends Instruccion {

    private Variable var;
    //etiquetas:
    private String startTag, finalTag, defaultTag, preStartTag, nextDefaultTag;
    //instrucciones:
    private Instruccion from, to, step, df, body;
    //first o last?:
    private boolean first;

    public SentSelectFrom(int linea, Variable var, boolean first, Instruccion from, Instruccion to, Instruccion step, Instruccion df) {
       
        super(linea);
       
        this.var = var;
        this.first = first;
        this.from = from;
        this.to = to;
        this.step = step;
        this.df = df;
        this.body = null;
        
        this.startTag = Objeto.newEtiqueta();
        this.defaultTag = Objeto.newEtiqueta();
    }


    public String getStartTag() { return this.startTag; }
    public String getDefaultTag() { return this.defaultTag; }

    public void setBody(Instruccion i) { this.body = i; }
    public void setPreStartTag(String etq) { this.preStartTag = etq; }
    public void setNextDefaultTag(String etq) { this.nextDefaultTag = etq; }
    public void setFinalTag(String etq) { this.finalTag = etq; }
  


    @Override
    public Objeto generarCodigo() throws Exception {

        Objeto oFrom = from.generarCodigo();
        Objeto oTo = to.generarCodigo();
        Objeto oStep = step.generarCodigo();
        Objeto oDefault = df.generarCodigo();

        //obtenemos el valor inicial:
        if(first) { 
            PLXC.out.println(var.getIDC() + "=" + oFrom.getIDC() + "-" + oStep.getIDC() + ";");
        } else {
             PLXC.out.println(var.getIDC() + " = " + oTo.getIDC() + " + " + oStep.getIDC() + ";");  
        }

        //el comienzo  'startTag:'
        PLXC.out.println(startTag + ":");

        if(first) {
            PLXC.out.println(var.getIDC() + "=" + var.getIDC() + "+" + oStep.getIDC() + ";");
        } else {
            PLXC.out.println(var.getIDC() + "=" + var.getIDC() + "-" + oStep.getIDC() + ";");
        }

        if(first) {
            if(preStartTag == null) {
                PLXC.out.println("if (" + oTo.getIDC() + " < " + var.getIDC() + ") goto " + defaultTag + ";"); 
            } else {
                PLXC.out.println("if (" + oTo.getIDC() + " < " + var.getIDC() + ") goto " + preStartTag + ";");
            }
        } else {
            if(preStartTag == null) {
                PLXC.out.println("if (" + var.getIDC() + " < " + oTo.getIDC() + ") goto " + defaultTag + ";"); 
            } else {
                PLXC.out.println("if (" + var.getIDC() + " < " + oTo.getIDC() + ") goto " + preStartTag + ";");
            }
        }
        Objeto bodyObj = body.generarCodigo();

        if(bodyObj != null) {
            
            PLXC.out.println("if (" + bodyObj.getIDC() + " == 1) goto " + finalTag + ";");
        }

        PLXC.out.println("goto " + startTag + ";");

        PLXC.out.println(defaultTag + ":");
        PLXC.out.println(var.getIDC() + " = " + oDefault.getIDC() + ";");
        if(nextDefaultTag == null) {
            PLXC.out.println("goto " + finalTag + ";");
        } else {
            PLXC.out.println("goto " + nextDefaultTag + ";");
        }

        if(preStartTag == null) {
            PLXC.out.println(finalTag + ":"); 
        }
        
        return null;
    }
}