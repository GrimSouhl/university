public class Variable extends Instancia{
    public Variable(String nombre, Tipo tipo, int bloque, boolean mutable){
        super(nombre,tipo,bloque, mutable );
    }

    public Objeto generarCodigoMetodo(String metodo, Objeto[] param, int linea){
        return getTipo().generarCodigoInstancia(this, metodo, param,linea);
    }
}