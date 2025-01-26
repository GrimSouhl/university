import java.text.ParseException;

public class Etiqueta extends Objeto {

    private boolean etusada;

    public Etiqueta(String nombre, int bloque) {

        super(nombre, bloque, false);

        etusada = false; // no usada apriori
    }

    @Override
    public Objeto generarCodigoMetodo(String metodo, Objeto[] params, int linea) throws Exception {

        switch (metodo) {

            case Metodo.PONER_ETQ:
                if (etusada) {
                    throw new ParseException("Etiqueta <" + getNombre() + ">usada", linea);
                }
                PLXC.out.println(getNombre() + ": ");
                break;
            case Metodo.SALTAR_ETQ:
                PLXC.out.println("goto " + getNombre() + ";");
                break;
            default:
                throw new UnsupportedOperationException(metodo + "no es metodo correcto en etiquetas");
        }

        return null;
    }
}