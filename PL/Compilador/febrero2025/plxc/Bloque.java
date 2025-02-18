import java.util.Vector;

public class Bloque extends Instruccion{

	//INSTRUCCIONES:
	private Vector<Instruccion> instrucciones;
	
	Bloque(int linea) {
		super(linea);
		instrucciones=new Vector<>();
	}

	public void add(Instruccion instruction) {
		instrucciones.add(instruction);
	}
	@Override
	public Objeto generarCodigo() throws Exception{
		for(Instruccion instruccion : instrucciones) {
			instruccion.generarCodigo();
		}
		return null;
	}
	
}