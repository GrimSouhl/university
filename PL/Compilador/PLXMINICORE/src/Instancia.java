import java.util.Vector;

public abstract class Instancia extends Objeto{
    private final Tipo tipo;

    public Instancia(String nombre, Tipo tipo, int bloque, boolean mutable, int linea) {
        super(nombre, bloque, mutable, linea);  // Llamamos al constructor de la clase base Objeto
        this.tipo = tipo;
    }
    public Tipo getTipo() {
        return tipo;
    }

    public abstract Object generarCodigo() throws Exception;
}

