
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

    public Objeto generarCodigoMetodo(String metodo, Objeto[]params, int linea)throws ParseException{
        switch(metodo) {
            case Metodo.PONER_ETQ:
                if(puesta){
                    throw new ParseException("lAS ETIQUETAS SOLO SE PUEDEN PONER", linea);
                }
                puesta = true;
                PLXC.out.println( getIDC()+":");
                break;
            case Metodo.SALTAR_ETQ:
                if (params == null || params.length == 0) {
                    throw new ParseException("Etiqueta de salto no proporcionada.", linea);
                }
                PLXC.out.println("goto " + params[0].getIDC() + ";");  // Asume un salto simple
                break;

             default:
                throw new ParseException("Metodo no reconocido: " + metodo, linea);
    }
        return null;
    }
        
}
    

