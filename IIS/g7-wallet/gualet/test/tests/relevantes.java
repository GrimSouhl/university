package tests;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;

import database.BDD;
import gualet.CambioDeDivisa;
import gualet.ProyectoAhorro;
import gualet.Transaccion;
import gualet.Usuario;

@TestMethodOrder(OrderAnnotation.class)
class relevantes {
	BDD dataBase= new BDD();
	
	@Test
	void cambiarDeEurosAOtraDivisa() {
		CambioDeDivisa div= new CambioDeDivisa();
		Double aux= div.cambiarDivisa(0, 1, 25);
		assertEquals(aux, 30.25);
		aux= div.cambiarDivisa(0, 2, 25);
		assertEquals(aux, 21.5);
		aux= div.cambiarDivisa(0, 3, 25);
		assertEquals(aux, 3310.75);
	}
	
	@Test
	void cambiarDeDivisaPasandoPorEuro() {
		CambioDeDivisa div= new CambioDeDivisa();
		Double aux= div.cambiarDivisa(4, 1, 25);
		assertEquals(aux, 27.5);
		aux= div.cambiarDivisa(9, 2, 25);
		assertEquals(aux, 0.8943427620632279);
		aux= div.cambiarDivisa(2, 3, 25);
		assertEquals(aux, 3849.709302325582);
	}
	
	@Test
	@Order(1)
	void addUsuarioContraseñaBien() {
		Usuario user= dataBase.addUsuario("David", "David123", null, 0);
		assertTrue(user!=null);
	}
	
	@Test
	@Order(2)
	void addUsuarioContraseñaMal() {
		Usuario user= dataBase.addUsuario("David2", "avid", null, 0);
		assertTrue(user==null);
	}
	
	@Test
	@Order(3)
	void addUsuarioRepetido() {
		Usuario user= dataBase.addUsuario("David", "David123", null, 0);
		assertTrue(user==null);
	}
	
	@Test
	@Order(4)
	void iniciarSesionBien() {
		Usuario user= dataBase.iniciarSesion("David", "David123");
		assertTrue(user!=null);
	}
	
	@Test
	@Order(5)
	void iniciarSesionMal() {
		Usuario user= dataBase.iniciarSesion("fafa", "dfada");
		assertTrue(user==null);
	}
	
	@Test
	@Order(6)
	void buscaUsuario() {
		Usuario user= dataBase.buscarUsuario("David");
		assertTrue(user!=null);
	}
	
	@Test
	@Order(7)
	void updateUsuarioSinContraseña() {
		dataBase.addUsuario("David2", "David123", null, 0);
		int lineas= dataBase.actualizarUsuario("David", "david@uma.es", 0);
		assertEquals(lineas, 1);
		Usuario user= dataBase.buscarUsuario("David");
		assertEquals(user.getEmail(), "david@uma.es");
		dataBase.borrarUsuario("David2");
	}
	
	@Test
	@Order(8)
	void updateUsuarioConContraseña() {
		dataBase.addUsuario("David2", "David123", null, 0);
		int lineas= dataBase.actualizarUsuario("David", "Prueba123", "david@uma.es", 0);
		assertEquals(lineas, 1);
		Usuario user= dataBase.iniciarSesion("David", "Prueba123");
		assertTrue(user!=null);
		dataBase.borrarUsuario("David2");
	}
	
	@Test
	@Order(9)
	void updateUsuarioConContraseñaMal() {
		dataBase.addUsuario("David2", "David123", null, 0);
		int lineas= dataBase.actualizarUsuario("David", "rueba", "david@uma.es", 0);
		assertEquals(lineas, 0);
		dataBase.borrarUsuario("David2");
	}
	
	@Test
	@Order(10)
	void addTransaccion() {
		Transaccion tr= dataBase.addTransaccion("David", "Dinero falso", 20.0, "12:12:12");
		assertTrue(tr!=null);
	}
	
	@Test
	@Order(11)
	void addTransaccionDescripcion() {
		Transaccion tr= dataBase.addTransaccion("David", "Dinero falso", 20.0, "Mucho dinero false", "13:13:13");
		assertTrue(tr!=null);
	}
	
	@Test
	@Order(12)
	void addTransaccionRepetida() {
		Transaccion tr= dataBase.addTransaccion("David", "Dinero falso", 20.0, "12:12:12");
		assertTrue(tr==null);
	}
	
	@Test
	@Order(13)
	void buscarTransaccion() {
		Transaccion tr= dataBase.buscarTransaccion("David", "12:12:12");
		assertTrue(tr!=null);
	}
	
	@Test
	@Order(14)
	void buscarTransaccionMal() {
		Transaccion tr= dataBase.buscarTransaccion("David", "14");
		assertTrue(tr==null);
	}
	
	@Test
	@Order(15)
	void buscarTransaccionUsuario() {
		List<Transaccion> trs= dataBase.buscarTransaccionUsuario("David");
		assertEquals(trs.size(), 2);
	}
	
	@Test
	@Order(16)
	void addProyectoAhorro() {
		ProyectoAhorro pr= dataBase.addProyectoAhorro("David", "pro1", 12.0, 1.0, "hoy", "Pasado");
		assertTrue(pr!=null);
	}
	
	@Test
	@Order(17)
	void addProyectoAhorroRepetido() {
		ProyectoAhorro pr= dataBase.addProyectoAhorro("David", "pro1", 12.0, 1.0, "hoy", "Pasado");
		assertTrue(pr==null);
	}
	
	@Test
	@Order(18)
	void buscarProyectoAhorroUsuario() {
		dataBase.addProyectoAhorro("David", "pro2", 12.0, 1.0, "hoy", "Pasado");
		List<ProyectoAhorro> prs= dataBase.buscarProyectoUsuario("David");
		assertTrue(prs.size()==2);
		dataBase.borrarProyectoAhorro("David", "pro2");
	}
	
	@Test
	@Order(19)
	void buscarProyectoAhorroNombre() {
		dataBase.addProyectoAhorro("David", "pro2", 12.0, 1.0, "hoy", "Pasado");
		ProyectoAhorro pr= dataBase.buscarProyectoNombre("David", "pro1");
		assertTrue(pr.getNombre().equals("pro1"));
		dataBase.borrarProyectoAhorro("David", "pro2");
	}
	
	@Test
	@Order(20)
	void buscarProyectoAhorroFechaFin() {
		dataBase.addProyectoAhorro("David", "pro2", 12.0, 1.0, "hoy", "Pasado");
		List<ProyectoAhorro> prs= dataBase.buscarProyectoFechaFin("David", "Pasado");
		assertTrue(prs.size()==2);
		dataBase.borrarProyectoAhorro("David", "pro2");
	}
	
	@AfterAll
	public static void borrarTodo() {
		BDD dataBase= new BDD();
		dataBase.borrarTransaccion("David", "Dinero falso", "12:12:12");
		dataBase.borrarTransaccion("David", "Dinero falso", "13:13:13");
		dataBase.borrarProyectoAhorro("David", "pro1");
		dataBase.borrarUsuario("David");
	}
	
}
