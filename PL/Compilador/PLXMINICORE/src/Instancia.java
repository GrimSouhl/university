import java.util.Vector;

public abstract class Instancia extends Objeto{
    private final Tipo tipo;

    public Instancia(String nombre, Tipo tipo, int bloque, boolean mutable) {
        super(nombre, bloque, mutable);
        this.tipo = tipo;
    }
    public Tipo getTipo() {
        return tipo;
    }
}

/* */
