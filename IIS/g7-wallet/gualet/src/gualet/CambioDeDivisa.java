package gualet;

public class CambioDeDivisa {
	//Inicializamos la variable con el valor de las divisas con respecto al euro y debajo ponemos cual es cada una
	public final Double[] divisas={1.0, 1.21 , 0.86 , 132.43, 1.10, 1.57, 1.47, 10.03, 7.79, 24.04, 3707313.08};
    /*0 = euro
    1 = dolar
    2 = libra 
    3 = yen
    4 = franco suizo
    5 = dolar australiano
    6 = dolar canadiense
    7 = corona noruego
    8 = yuan
    9 = peso mexicano
    10 = bolivar*/
	
	//Constructor vacio ya que solo nos interesa el metodo para cambiar de divisa
	public CambioDeDivisa() {
	}
	
	//divisaOriginal es el tipo de divisa actual del sado, divisaACambiar es a la que queremos cambiar
	//y el valor es el valor a cambiar
	public double cambiarDivisa(int divisaOriginal, int divisaACambiar, double valor){
		//Si la divisa no esta en euros se pasa a euros
		if(divisaOriginal!=0) {
			valor= valor/divisas[divisaOriginal];
		}
		//Hago la conversion
		valor= valor*divisas[divisaACambiar];
		
		return valor;
	}
	
	//Consultar valor de una divisa con respecto al euro
	public double consultarDouble(int divisa) {
		return divisas[divisa];
	}
	
}
