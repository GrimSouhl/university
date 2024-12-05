package gualet;

public class Transaccion {
	private String concepto;
	private double importe;
	private String fecha;
	private String descripcion;

	//Inicializamos las variables
	//Dos contructores, uno para cuando el usuario no quiere descripcion y otro para cuando si
	public Transaccion(String concepto, double monto, String fecha){
		this.concepto = concepto;
		this.importe = monto;
		this.fecha = fecha;
	}

	public Transaccion(String concepto, double monto, String fecha, String des){
		this.concepto = concepto;
		this.importe = monto;
		this.fecha = fecha;
		this.descripcion = des;
	}

	//getters y setters
	public String getConcepto() {
		return concepto;
	}

	public double getimporte() {
		return importe;
	}

	public String getFecha() {
		return fecha;
	}

	public String getDescripcion() {
		return descripcion;
	}

	public String toString(){
		return "("+fecha+")"+"Concepto: " + concepto + ". Importe: " +importe+ ".  "+descripcion;
	}
}

