package gualet;

public class ProyectoAhorro {

	private String nombre;
	private double objetivo;
	private double saldo;
	private String fechaInicio;
	private String fechaFin;
	
	//Inicializamos las variables
	public ProyectoAhorro(String nombre, double objetivo, double saldo, String fechaInicio, String fechaFin ) {
		this.nombre= nombre;
		this.objetivo= objetivo;
		this.saldo= saldo;
		this.fechaFin= fechaFin;
		this.fechaInicio= fechaInicio;
	}
	
	//getter y setter para las distintas variables
	public void modificarSaldo(double saldo) {
		this.saldo= saldo;	
	}
	
	
	public String getFechaFin() {
		return fechaFin;
	}
	
	
	public String getFechaInicio() {
		return fechaInicio;
	}
	
	public double getObjetivo() {
		return objetivo;
	}

	public double getSaldo() {
		return saldo;
	}
	
	public String getNombre() {
		return nombre;
	}
	
	@Override
	//Cambio salida
	public String toString() {
		return "Nombre: "+nombre+" Obj: "+objetivo+" Saldo: "+saldo+"("+fechaInicio+"-"+fechaFin+")";
	}
}
