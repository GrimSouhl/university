import java.text.ParseException;

public class Literal extends Instancia{

    private final String valor;
    public Literal( int bloque, Tipo tipo, Object valor) {
        super(Objeto.newObj(), tipo, bloque, false, bloque);
        this.valor = (String) valor;
    }
    public Object getValor(){
        return valor;
    }

    public Objeto generarCodigoMetodo(String metodo, Objeto[] param) throws Exception{
        if(!metodo.equals(Metodo.CREAR_LITERAL)){
            throw new ParseException("Las constantes literales no admiten metodos",PLXC.lex.getLine());
        }
        if(param!=null){
            throw new ParseException("",PLXC.lex.getLine() );
        }
        return getTipo().generarCodigoInstancia(this, metodo, null);
        /// al numero siete no hay que pasarle nada mas, por eso el null, si al num 7 le digo impromete por pantalla no tiene que hacer nada mas
    }
}
