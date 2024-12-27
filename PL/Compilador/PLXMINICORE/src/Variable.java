public class Variable extends Instancia{
    
    
    public Variable(String nombre, int bloque, boolean mutable, Tipo tipo) {
		super(nombre,bloque,mutable, tipo);
 	}

     @Override
 	public Objeto generarCodigoMetodo(String metodo, Objeto[] param) throws Exception {
	 	return getTipo().generarCodigoInstancia(this, metodo, param);
	}
}