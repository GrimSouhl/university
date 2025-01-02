import java.util.Vector;

public abstract class Instancia extends Objeto{
    private final Tipo tipo;

    public Instancia (String nombre, int bloque, boolean mutable, Tipo tipo) {

		super(nombre, bloque, mutable);
		this.tipo = tipo;
	}
	
    public Instancia(String nombre, Tipo tipo, int bloque, boolean flag, int linea) {
        super(nombre, bloque, flag);
        this.tipo = tipo;
    }


    public Tipo getTipo() { return this.tipo; }

    public Objeto generarCodigoMetodo(String metodo,Objeto[] param,int linea) throws Exception{
		return null;
	}
}