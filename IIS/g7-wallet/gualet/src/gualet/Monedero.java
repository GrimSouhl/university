package gualet;

public class Monedero {
	private String nombre;
	private double saldo;
	private String fecha;
	private String IBAN;
	private boolean tipo_monedero;

	//Dos constructores, el primero para saldos sin cuenta bancaria y el segundo para los que
	//tienen una cuenta bancaria asociadas
	public Monedero(String nombre, double sal, String fecha2){
		this.nombre= nombre;
		this.saldo = sal;
		this.fecha = fecha2;
		tipo_monedero = false;
	}

	public Monedero(String nombre, double sal, String IB, String fec){
		this.nombre= nombre;
		this.saldo = sal;
		this.fecha = fec;
		this.tipo_monedero = true;
		this.IBAN = IB;
	}
	
	//Getter y setters para las distintas variables
	public String getNombre() {
		return nombre;
	}

	public double getSaldo() {
		return saldo;
	}

	public String getIBAN() {
		return IBAN;
	}

	public void setIBAN(String iBAN) {
		IBAN = iBAN;
	}

	public String getFecha() {
		return fecha;
	}

	public void setSaldo(double sal) {
		this.saldo = sal;
	}

	public void anadirSaldo(double ingreso){
		this.saldo += ingreso;
	}
	
	public boolean getTipoMonedero() {
		return this.tipo_monedero;
	}
	
	//Si queremos quitar saldo de un monedero, comprobamos que al quitarlo no se quede en numeros rojos
	public void quitar_saldo(double retirada) throws GualetException {

		if(this.saldo>=retirada) {
			double n = this.saldo - retirada;
			setSaldo(n);
		}else{
			throw new GualetException("No hay saldo suficiente");
            //Ya no Rip excepcion
		}
	}
	
	@Override
	public String toString() {
		String aux= "";
		if(tipo_monedero) {
			aux= nombre+". Saldo: "+saldo+". Fecha de creacion; "+fecha+". IBAN: "+IBAN+".";
		}else {
			aux= nombre+". Saldo: "+saldo+". Fecha de creacion; "+fecha+".";
		}
		return aux;
	}
}
