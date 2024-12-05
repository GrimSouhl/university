package tests;
import static org.junit.jupiter.api.Assertions.*;

import java.io.IOException;

import org.junit.jupiter.api.Test;

import gualet.*;

class tests {

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
	void bolsaBuscaIndices() {
		Bolsa bolsa= new Bolsa();
		try {
			bolsa.getBolsa();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		assertFalse(bolsa.getLista().isEmpty());
	}
	
	@Test
	void crearUsuarioContraseñaBien() {
		Usuario user=null;
		try {
			user= new Usuario("David", "David123", "prueba@uma,es", false);
		} catch (GualetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		assertEquals(user.getUsername(), "David");
	}
	
	@Test
	void crearUsuarioContraseñaMal() {
		Exception exception= assertThrows(GualetException.class, ()->new Usuario("David","estaContrseñaEstaMal", "prueba@uma.es", false));
		assertEquals("Contraseña invalida", exception.getMessage());
	}
	
	@Test
	void EncriptarContraseña() {
		Usuario user=null;
		try {
			user= new Usuario("David", "David123", "prueba@uma,es", false);
		} catch (GualetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		assertEquals("Mjfrm:;<", user.getPassword());
	}
	
	@Test
	void CrearMonedero() {
		Monedero mon= new Monedero("mon1", 12, "Hoy");
		assertEquals("mon1", mon.getNombre());
	}
	
	@Test
	void addSaldo() {
		Monedero mon= new Monedero("mon1", 12, "Hoy");
		mon.anadirSaldo(5);
		assertEquals(17, mon.getSaldo());
	}
	
	@Test
	void quitarSaldoCorrecto() {
		Monedero mon= new Monedero("mon1", 12, "Hoy");
		try {
			mon.quitar_saldo(5);
		} catch (GualetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		assertEquals(7, mon.getSaldo());
	}
	
	@Test
	void quitarSaldoErroneo() {
		Monedero mon= new Monedero("mon1", 12, "Hoy");
		Exception exception= assertThrows(GualetException.class, ()->mon.quitar_saldo(13));
		assertEquals("No hay saldo suficiente", exception.getMessage());
	}
	
	@Test
	void buscarNoticias() {
		Noticias not= new Noticias();
		try {
			not.refreshNoticias();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		assertTrue(not.getTamList()>0);
	}
}
