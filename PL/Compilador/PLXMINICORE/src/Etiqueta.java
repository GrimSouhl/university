
import java.text.ParseException;

public class Etiqueta extends Objeto{

    private boolean puesta;

    public Etiqueta(String nombre, int bloque){
        super(nombre,bloque, false);
        puesta=false;
    }

    @Override
    public String getIDC(){
        return getNombre();
    }

    public OBjeto generarCodigoMetodo(String metodo, Objeto[]params, int ){
        switch(metodo) {
            case Metodo.PONERETIQ:
                if(puesta){
                    throw new ParseException("lAS ETIQUETAS SOLO SE PUEDEN PONER");
                }
                puesta = true;
                PLXC.out.println( getIDC()+":");
                break;
            case Metodo.SALTARETIQ:
                PLXC.out.println()Sent;
        }
    }
    
}
