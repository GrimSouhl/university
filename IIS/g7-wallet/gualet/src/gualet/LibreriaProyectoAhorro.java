package gualet;

import database.*;

import java.util.ArrayList;
import java.util.List;

public class LibreriaProyectoAhorro {

	//Cremos una lista para guardar los ProyectoAhorro y un objeto de la base de datos
	private List<ProyectoAhorro> proyectos;
	private BDD baseDeDatos;

	//Le pasamos por argumento al constuctor la base de datos a usar
	public LibreriaProyectoAhorro(BDD baseDeDatos) {
		this.baseDeDatos= baseDeDatos;
		proyectos= new ArrayList<>();
	}

	//Si queremos añadir un proyecto, se lo pasamos a la base de datos, la cual devuelve null si hay algun problema
	//En caso de que sea correcto, añadimos el proyecto a la lista
	public void addProyecto(String usuario, String nombre, double objetivo, double saldo, String fechaInicio, String fechaFin) {
		ProyectoAhorro aux= this.baseDeDatos.addProyectoAhorro(usuario, nombre, objetivo, saldo, fechaInicio, fechaFin);

		if(aux!=null) {
			proyectos.add(aux);
		}else {
			System.out.println("No se pudo añadir");
		}
	}
	
	//Actualizamos la lista con los proyecto de ahorro del usuario encontrados en la base de datos
	//Si no hubiera ninguna devuelve null y se avisa
	public void actualizarLista(String usuario) {
		List<ProyectoAhorro> aux= baseDeDatos.buscarProyectoUsuario(usuario);

		if(aux!=null) {
			proyectos.addAll(aux);
		}else {
			System.out.println("No se ha encontrado nada");
		}
	}

	//Le pasamos por parametro el nombre del proyecto ahorro a borra
	//La base de datos en este caso devuelve el numero de rows afectadas por el comando
	//Si es igual a cero es que no se ha borrado nada
	public void borrarProyecto(String usuario, String nombre) {
		int lineasAfectadas= baseDeDatos.borrarProyectoAhorro(usuario, nombre);

		if(lineasAfectadas>0) {
			System.out.println("Se ha borrrado "+nombre+" de la base de datos");
		}else {
			System.out.println("No se ha podido borrar "+nombre+ " de la base de datos (Error/ no existe el nombre)");
		}
	}
	
	public ProyectoAhorro buscarProyecto(String usuario, String nombre) {
		ProyectoAhorro prBuscar= baseDeDatos.buscarProyectoNombre(usuario, nombre);

		if(prBuscar!=null) {
			proyectos.add(prBuscar);
		}else {
			System.out.println("No se ha encontrodo "+nombre+ " en la base de datos (Error/ no existe el nombre)");
		}
		return prBuscar;
	}
	
	
	//Le pasamos el nombre y saldo del proyecto de usuario para cambiarlo
	//Como con borrar, la base de datos devuelve el numero de rows afectadas
	//Si es igual a cero no se ha cambiado ningun saldo
	public void cambiarSaldoProyecto(String usuario, String nombre, double saldo) {
		int lineasAfectadas= baseDeDatos.cambiarSaldoProyectoAhorro(usuario, nombre, saldo);

		if(lineasAfectadas>0) {
			System.out.println("Se pudo cambiar el saldo de "+nombre);
		}else {
			System.out.println("No se ha podido cambiar el saldo de "+nombre+"(Error/ no existe el nombre)");
		}
	}
}
