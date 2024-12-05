package gualet;
import java.util.ArrayList;
import java.util.List;

import database.BDD;

public class Historial{
	private List<Transaccion> t;
	private BDD baseDeDatos;
	
	//Constructor de la clase historial, le pasamos la base de datos que vamos a usar
	public Historial(BDD baseDeDatos){
		this.t= new ArrayList<>();
		this.baseDeDatos= baseDeDatos;
	}
	
	//Se utiliza para añadir a la lista todas las transaccions del usuario
	public void actualizarLista(String username) {
		this.t.clear();
		List<Transaccion> t= baseDeDatos.buscarTransaccionUsuario(username);
		
		if(t!=null) {
			this.t.addAll(t);
		}else {
			System.out.println("No hay nada en la base de datos");
		}
	}
	
	//Se utiliza para añadir una transaccion a lista y a la base de datos
	//Si hubiera algun problema al añadir la transaccion
	//La base de datos devolveria null y no se añadiria a la lista
	public void addTransaccion(String username, String concepto, double monto, String fecha){
		Transaccion aux= baseDeDatos.addTransaccion(username, concepto, monto, fecha);
		
		if(aux!=null) {
			this.t.add(aux);
		}else {
			System.out.println("No se ha podido añadir");
		}
	}
	
	
	//Lo mismo que antes pero con descipcion
	public void addTransaccion(String username, String concepto, double monto, String descripcion, String fecha){
		
		Transaccion aux= baseDeDatos.addTransaccion(username, concepto, monto, descripcion, fecha);
		if(aux!=null) {
			this.t.add(aux);
		}else {
			System.out.println("No se ha podido añadir");
		}
	}
	
	//Se usa para borrar una transaccion
	//La base de datos devuelve el numero de lineas afectadas
	//Si es cero es que no se ha borrado nada
	public void quitarTransaccion(String username, String concepto, String fecha){
		int lineas= baseDeDatos.borrarTransaccion(username, concepto, fecha);
		
		if(lineas>0) {
			System.out.println("Se ha borrado");
		}else {
			System.out.println("No se ha borrado nada");
		}
	}
	
	//Para mostrar las transacciones
	public void verTransaccion(String con){
		for(int i=0; i<t.size(); i++){
			if(this.t.get(i).getConcepto().equalsIgnoreCase(con)){
				System.out.println(this.t.get(i).toString());				
			}
		}
	}
	
	//Para devolver la lista
	public List<Transaccion> getLista(){
		return this.t;
	}
}	
