
public class ListaVar extends Bloque{
	private Tipo tipo;
	
	ListaVar(int linea, Tipo tipo) {
		super(linea);
		this.tipo=tipo;
	}

	public Tipo getTipo() {
		return tipo;
	}

}