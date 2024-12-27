import java.util.Vector;

public abstract class Instancia extends Objeto{
    private final Tipo tipo;

    public Instancia (String nombre, int bloque, boolean mutable, Tipo tipo) {

		super(nombre, bloque, mutable);
		this.tipo = tipo;
	}

	public Instancia(String nombre, Tipo tipo2, int bloque, boolean mutable, int linea) {
        //TODO Auto-generated constructor stub
    }

    public Tipo getTipo() { return this.tipo; }
}