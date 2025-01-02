package postFix;

public class Add extends Operation{
    /*
     * Las clases Add, Dif y Mul serán subclases de Operation y deben redefinir el método
        evaluate(int a1, int a2) de manera que en la primera clase se devuelva la suma de a1 y a2, en
        la segunda la diferencia y en la tercera el producto.
     */
    public int evaluate(int a1, int a2) {
        return a1+a2;
    }
}
