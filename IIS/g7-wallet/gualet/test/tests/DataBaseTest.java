package tests;

import static org.junit.jupiter.api.Assertions.*;

import java.util.List;

import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.MethodOrderer.OrderAnnotation;
import org.junit.jupiter.api.Order;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestMethodOrder;

import database.BDD;
import gualet.Monedero;
import gualet.ProyectoAhorro;
import gualet.Transaccion;
import gualet.Usuario;

@TestMethodOrder(OrderAnnotation.class)
class DataBaseTest {
	BDD dataBase= new BDD();
	
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
	void addMonedero() {
		Monedero mon1= dataBase.addMonedero("David", "mon1", 120.0, "hoy");
		assertTrue(mon1!=null);
	}
	
	@Test
	@Order(11)
	void addMonederoRepetido() {
		Monedero mon1= dataBase.addMonedero("David", "mon1", 120.0, "hoy");
		assertTrue(mon1==null);
	}
	
	@Test
	@Order(12)
	void addMonederoIBAN() {
		Monedero mon1= dataBase.addMonedero("David", "mon3", 120.0, "hoy", "123456");
		assertTrue(mon1!=null);
	}
	
	@Test
	@Order(13)
	void addMonederoIBANMal() {
		Monedero mon1= dataBase.addMonedero("David", "fdsafasd", 120.0, "hoy", "123456");
		assertTrue(mon1==null);
	}
	
	@Test
	@Order(14)
	void buscarMonederoUsuario() {
		List<Monedero> mons= dataBase.buscarMonederosUsuario("David");
		assertEquals(mons.size(), 2);
	}
	
	@Test
	@Order(15)
	void buscarMonederoNombre() {
		Monedero mon= dataBase.buscarMonederoNombre("David", "mon1");
		assertTrue(mon!=null);
	}
	
	@Test
	@Order(16)
	void cambiarSaldoMonedero() {
		int lineas= dataBase.cambiarSaldoMonedero("David", "mon1", 12345);
		assertEquals(lineas, 1);
		assertEquals(dataBase.buscarMonederoNombre("David","mon1").getSaldo(), 12345);
	}
	
	@Test
	@Order(17)
	void addProyectoAhorro() {
		ProyectoAhorro pr= dataBase.addProyectoAhorro("David", "pro1", 12.0, 1.0, "hoy", "Pasado");
		assertTrue(pr!=null);
	}
	
	@Test
	@Order(18)
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
	@Order(18)
	void buscarProyectoAhorroNombre() {
		dataBase.addProyectoAhorro("David", "pro2", 12.0, 1.0, "hoy", "Pasado");
		ProyectoAhorro pr= dataBase.buscarProyectoNombre("David", "pro1");
		assertTrue(pr.getNombre().equals("pro1"));
		dataBase.borrarProyectoAhorro("David", "pro2");
	}
	
	@Test
	@Order(19)
	void buscarProyectoAhorroFechaFin() {
		dataBase.addProyectoAhorro("David", "pro2", 12.0, 1.0, "hoy", "Pasado");
		List<ProyectoAhorro> prs= dataBase.buscarProyectoFechaFin("David", "Pasado");
		assertTrue(prs.size()==2);
		dataBase.borrarProyectoAhorro("David", "pro2");
	}
	
	@Test
	@Order(20)
	void cambiarFechaInicialProyecto() {
		int lineas= dataBase.fechaIncialProyectoAhorro("David", "pro1", "07/06/2021");
		assertTrue(lineas==1);
		ProyectoAhorro pr= dataBase.buscarProyectoNombre("David", "pro1");
		assertTrue(pr.getFechaInicio().equals("07/06/2021"));
	}
	
	@Test
	@Order(21)
	void cambiarSaldoProyecto() {
		int lineas= dataBase.cambiarSaldoProyectoAhorro("David", "pro1", 12345.0);
		assertTrue(lineas==1);
		ProyectoAhorro pr= dataBase.buscarProyectoNombre("David", "pro1");
		assertTrue(pr.getSaldo()==12345);
	}
	
	@Test
	@Order(22)
	void addTransaccion() {
		Transaccion tr= dataBase.addTransaccion("David", "Dinero falso", 20.0, "12:12:12");
		assertTrue(tr!=null);
	}
	
	@Test
	@Order(23)
	void addTransaccionDescripcion() {
		Transaccion tr= dataBase.addTransaccion("David", "Dinero falso", 20.0, "Mucho dinero false", "13:13:13");
		assertTrue(tr!=null);
	}
	
	@Test
	@Order(24)
	void addTransaccionRepetida() {
		Transaccion tr= dataBase.addTransaccion("David", "Dinero falso", 20.0, "12:12:12");
		assertTrue(tr==null);
	}
	
	@Test
	@Order(25)
	void buscarTransaccion() {
		Transaccion tr= dataBase.buscarTransaccion("David", "12:12:12");
		assertTrue(tr!=null);
	}
	
	@Test
	@Order(26)
	void buscarTransaccionMal() {
		Transaccion tr= dataBase.buscarTransaccion("David", "14");
		assertTrue(tr==null);
	}
	
	@Test
	@Order(27)
	void buscarTransaccionUsuario() {
		List<Transaccion> trs= dataBase.buscarTransaccionUsuario("David");
		assertEquals(trs.size(), 2);
	}
	
	@AfterAll
	public static void borrarTodo() {
		BDD dataBase= new BDD();
		dataBase.borrarMonedero("David", "mon1");
		dataBase.borrarMonedero("David", "mon3");
		dataBase.borrarTransaccion("David", "Dinero falso", "12:12:12");
		dataBase.borrarTransaccion("David", "Dinero falso", "13:13:13");
		dataBase.borrarProyectoAhorro("David", "pro1");
		dataBase.borrarUsuario("David");
	}
}
