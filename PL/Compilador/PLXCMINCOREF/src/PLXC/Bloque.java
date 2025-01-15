import java.util.Vector;

public class Bloque extends Instruccion{
	private Vector<Instruccion> instrucciones;
	
	Bloque(int linea) {
		super(linea);
		instrucciones=new Vector<>();
	}

	public void add(Instruccion ins) {
		instrucciones.add(ins);
	}
	@Override
	public Objeto generarCodigo() throws Exception{
		for(Instruccion instruccion : instrucciones) {
			instruccion.generarCodigo();
		}
		return null;
	}
	
}