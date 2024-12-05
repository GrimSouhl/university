package database;
import gualet.*;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BDD {
	
	//Inicializamos las variables con la direccion a la base de datos
	//y el objeto que se una como conexion a la base de datos
	private final String url= "gualet.db";
	private Connection connect;
	
	
	//En el constructor vacio cargamos el driver de conexion y probamos a conectarnos a la base
	//de datos. Si es un exito se muestra por consola, en caso de que no se avisa y si es un problema 
	//con el jar que usamos como driver tambien se avisa
	public BDD() {
		 try {
		        Class.forName("org.sqlite.JDBC");
		        this.connect = DriverManager.getConnection("jdbc:sqlite:" + url);
		        if (connect != null) {
		            System.out.println("Conectado");
		        }
		    } catch (SQLException ex) {
		        System.err.println("No se ha podido conectar a la base de datos\n" + ex.getMessage());
		    } catch (ClassNotFoundException e) {
		        System.err.println("El JAR no está correctamente agregado\n"
		          + e.getMessage());
		    }
	}
	
	//Añadimos un objeto Monedero a la base de datos
	//Este metodo devuelve el monedero como objeto, si devuelve null es que no se ha podido añadir
	public Monedero addMonedero(String usuario, String nombre, Double saldo, String fecha) {
		Monedero monedero_returneado=null;
		String sql= "INSERT INTO monedero(username, saldo, iban, fecha, tipo_monedero, nombre) VALUES (?, ?, ?, ?, ?, ?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			
			pstmt.setString(1, usuario);
			pstmt.setDouble(2, saldo);
			pstmt.setString(3, null);
			pstmt.setString(4, fecha);
			pstmt.setInt(5, 0);
			pstmt.setString(6, nombre);
			pstmt.executeUpdate();
			
			monedero_returneado= new Monedero(nombre, saldo, fecha);
			return monedero_returneado;
		}catch(SQLException e) {
			System.out.println("El monedero "+nombre+" ya existe para "+usuario);
		}
		
		return null;
	}
	
	//Lo mismo que el anterior pero para monedros con valor para el IBAN
	public Monedero addMonedero(String usuario, String nombre, Double saldo, String fecha, String IBAN) {
		Monedero monedero_returneado=null;
		String sql= "INSERT INTO monedero(username, saldo, iban, fecha, tipo_monedero, nombre) VALUES (?, ?, ?, ?, ?, ?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			
			pstmt.setString(1, usuario);
			pstmt.setDouble(2, saldo);
			pstmt.setString(3, IBAN);
			pstmt.setString(4, fecha);
			pstmt.setInt(5, 1);
			pstmt.setString(6, nombre);
			pstmt.executeUpdate();
			
			monedero_returneado= new Monedero(nombre, saldo, IBAN, fecha);
			return monedero_returneado;
		}catch(SQLException e) {
			System.out.println("El monedero "+nombre+" ya existe para "+usuario);
		}
		
		return null;
	}
	
	//Devuelve en una lista todos los monederos asocidos a un usuario
	public List<Monedero> buscarMonederosUsuario(String usuario) {
		List<Monedero> monederos=null;
		
		String sql= "SELECT saldo, iban, fecha, tipo_monedero, nombre FROM monedero WHERE UPPER(username) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, usuario);
			
			ResultSet rs= pstmt.executeQuery();
			monederos= new ArrayList<>();
			while(rs.next()) {
				if(rs.getInt("tipo_monedero")==1) {
					monederos.add(new Monedero(rs.getString("nombre"), rs.getDouble("saldo"), rs.getString("iban"), rs.getString("fecha")));
				}else {
					monederos.add(new Monedero(rs.getString("nombre"), rs.getDouble("saldo"), rs.getString("fecha")));
				}
			}
			
		}catch(SQLException e) {
			System.out.println("Problema al hacer la busqueda");
		}
		
		return monederos;
	}
	
	//Busca un monedero de un usuario por su nombre
	//Devuelve null si no existe o el objeto si existe
	public Monedero buscarMonederoNombre(String usuario, String nombre) {
		Monedero monederos=null;
		
		String sql= "SELECT saldo, iban, fecha, tipo_monedero, nombre FROM monedero WHERE UPPER(username) LIKE UPPER(?) AND UPPER(nombre) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, usuario);
			pstmt.setString(2, nombre);
			
			ResultSet rs= pstmt.executeQuery();
			while(rs.next()) {
				if(rs.getInt("tipo_monedero")==1) {
					monederos= new Monedero(rs.getString("nombre"), rs.getDouble("saldo"), rs.getString("iban"), rs.getString("fecha"));
				}else {
					monederos= new Monedero(rs.getString("nombre"), rs.getDouble("saldo"), rs.getString("fecha"));
				}
			}
			
			
		}catch(SQLException e) {
			System.out.println("Problema al hacer la busqueda");
		}
		
		return monederos;
	}
	
	//Borra un monedero de un usuario por su nombre
	//Devuelve el numero de lineas afectadas
	public int borrarMonedero(String usuario, String nombre) {
		int lineasAfectadas=0;
		String sql= "DELETE FROM monedero WHERE UPPER(username) LIKE UPPER(?) AND UPPER(nombre) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, usuario);
			pstmt.setString(2, nombre);
			lineasAfectadas= pstmt.executeUpdate();
			
			System.out.println("Borrado");
			
		}catch(SQLException e) {
			System.out.println("Problema al hacer el borrado");
		}
		return lineasAfectadas;
	}
	
	//Añade proyecto ahorro a la base de datos
	//Devuelve lo mismo que los anteriores
	public ProyectoAhorro addProyectoAhorro(String usuario, String nombre, Double objetivo, Double saldo, String fechaInicio, String fechaFin) {
		ProyectoAhorro proyecto_returneado=null;
		String sql= "INSERT INTO proyectoAhorro(username, nombre, objetivo, saldo, fechaInicio, fechaFin) VALUES (?, ?, ?, ?, ?, ?)";

		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			
			pstmt.setString(1, usuario);
			pstmt.setString(2, nombre);
			pstmt.setDouble(3, objetivo);
			pstmt.setDouble(4, saldo);
			pstmt.setString(5, fechaInicio);
			pstmt.setString(6, fechaFin);
			pstmt.executeUpdate();
			
			proyecto_returneado= new ProyectoAhorro(nombre, objetivo, saldo, fechaInicio, fechaFin);
			return proyecto_returneado;
		}catch(SQLException e) {
			System.out.println("Ya existe el proyecto ahorro "+nombre+" para el usuario "+usuario);
		}
		
		return null;
	}
	
	//Devuelve una lista de los proyectos Ahorro de un usuario
	public List<ProyectoAhorro> buscarProyectoUsuario(String usuario) {
		List<ProyectoAhorro> proyectos=null;
		
		String sql= "SELECT nombre, objetivo, saldo, fechaInicio, fechaFin FROM proyectoAhorro WHERE UPPER(username) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, usuario);
			
			ResultSet rs= pstmt.executeQuery();
			proyectos= new ArrayList<>();
			while(rs.next()) {
				proyectos.add(new ProyectoAhorro(rs.getString("nombre"), rs.getDouble("objetivo"), rs.getDouble("saldo"), rs.getString("fechaInicio"), rs.getString("fechaFin")));
			}
			
			
		}catch(SQLException e) {
			System.out.println("Problema al hacer la busqueda");
		}
		
		return proyectos;
	}
	
	//Devuelve el proyecto ahorro de un usuari buscando por el nombre
	public ProyectoAhorro buscarProyectoNombre(String usuario, String nombre) {
		ProyectoAhorro proyectos=null;
		
		String sql= "SELECT nombre, objetivo, saldo, fechaInicio, fechaFin FROM proyectoAhorro WHERE UPPER(username) LIKE UPPER(?) AND UPPER(nombre) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, usuario);
			pstmt.setString(2, nombre);
			
			ResultSet rs= pstmt.executeQuery();
			while(rs.next()) {
				proyectos= new ProyectoAhorro(rs.getString("nombre"), rs.getDouble("objetivo"), rs.getDouble("saldo"), rs.getString("fechaInicio"), rs.getString("fechaFin"));
			}
			
			
		}catch(SQLException e) {
			System.out.println("Problema al hacer la busqueda");
		}
		
		return proyectos;
	}
	
	//Devuelve todos los proyectos ahorro que terminan en una fecha concreta
	public List<ProyectoAhorro> buscarProyectoFechaFin(String usuario, String fechaFin) {
		List<ProyectoAhorro> proyectos=null;
		
		String sql= "SELECT nombre, objetivo, saldo, fechaInicio, fechaFin FROM proyectoAhorro WHERE username LIKE ? AND fechaFin LIKE ?";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, usuario);
			pstmt.setString(2, fechaFin);
			
			ResultSet rs= pstmt.executeQuery();
			proyectos= new ArrayList<>();
			while(rs.next()) {
				proyectos.add(new ProyectoAhorro(rs.getString("nombre"), rs.getDouble("objetivo"), rs.getDouble("saldo"), rs.getString("fechaInicio"), rs.getString("fechaFin")));
			}
			
			
		}catch(SQLException e) {
			System.out.println("Problema al hacer la busqueda");
		}
		
		return proyectos;
	}
	
	//Borra un proyecto ahorro de un usuario buscandolo por el nombre
	public int borrarProyectoAhorro(String usuario, String nombre) {
		int lineasAfectadas=0;
		String sql= "DELETE FROM proyectoAhorro WHERE username LIKE ? AND UPPER(nombre) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, usuario);
			pstmt.setString(2, nombre);
			lineasAfectadas= pstmt.executeUpdate();
			
			System.out.println("Borrado");
			
		}catch(SQLException e) {
			System.out.println("Problema al hacer el borrado");
		}
		return lineasAfectadas;
	}
	
	//Update fecha inical ProyectoAhorro
	public int fechaIncialProyectoAhorro(String usuario, String nombre, String fecha) {
		int lineasAfectadas=0;
		String sql= "UPDATE proyectoAhorro SET fechaInicio= ? WHERE UPPER(username) LIKE UPPER(?) AND UPPER(nombre) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, fecha);
			pstmt.setString(2, usuario);
			pstmt.setString(3, nombre);
			lineasAfectadas= pstmt.executeUpdate();
			
			System.out.println("Borrado");
			
		}catch(SQLException e) {
			System.out.println("Problema al hacer el borrado");
		}
		return lineasAfectadas;
	}
	
	//Cambia el saldo de un proyecto ahorro de un usuario al que queramos
	public int cambiarSaldoProyectoAhorro(String usuario, String nombre, double saldo) {
		int lineasAfectadas=0;
		String sql= "UPDATE proyectoAhorro SET saldo = ? WHERE UPPER(username) LIKE UPPER(?) AND UPPER(nombre) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setDouble(1, saldo);
			pstmt.setString(2, usuario);
			pstmt.setString(3, nombre);
			lineasAfectadas=pstmt.executeUpdate();
			
			System.out.println("Actualizado");
			
		}catch(SQLException e) {
			System.out.println("Problema al actualizar");
		}
		return lineasAfectadas;
	}
	
	//Cambia el saldo de un monedero de un usuario
	public int cambiarSaldoMonedero(String usuario, String nombre, double saldo) {
		int lineasAfectadas=0;
		String sql= "UPDATE monedero SET saldo = ? WHERE UPPER(username) LIKE UPPER(?) AND UPPER(nombre) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setDouble(1, saldo);
			pstmt.setString(2, usuario);
			pstmt.setString(3, nombre);
			lineasAfectadas=pstmt.executeUpdate();
			
			System.out.println("Actualizado");
			
		}catch(SQLException e) {
			System.out.println("Problema al cambiar el saldo");
		}
		return lineasAfectadas;
	}
	
	//Añade un usuario a la base de datos, junto a su password, email y si es premiun
	//La contraseña se codifica dentro de este metodo, asi que meterla sin codificar
	//El premiun es int con valores 1 o 0, si se mete otra cosa se rompe
	public Usuario addUsuario(String username, String password,String email, int premium ) {
		Usuario usuario_return=null;
		String sql= "INSERT INTO Usuario(username, password, email, premium) VALUES (?, ?, ?, ?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			boolean premiumB= false;
			if(premium==1) {
				premiumB= true;
			}
			
			usuario_return= new Usuario(username, password, email, premiumB);
			if(usuario_return.getUsername()!=null) {
				pstmt.setString(1, usuario_return.getUsername());
				pstmt.setString(2, usuario_return.getPassword());
				pstmt.setString(3, usuario_return.getEmail());
				pstmt.setInt(4, premium);
				pstmt.executeUpdate();
			}
			return usuario_return;	
		}catch(SQLException e) {
			System.out.println("Usuario ya existe");
		} catch (GualetException e) {
			System.out.println(e.getMessage());
		}
		
		return null;
	}
	
	//Le pasas un usuario y una contraseña sin codificar
	//Este metodo la codifica y comprueba si el usuario ha metido bien su nombre de usuario y contraseña
	//Devuelve null si no
	public Usuario iniciarSesion(String username, String password) {
		Usuario usuarios=null;
		
		String sql= "SELECT username, password, email, premium FROM Usuario WHERE UPPER(username) LIKE UPPER(?) AND password LIKE ?";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			Usuario usuario_aux= new Usuario(username, password);
			if(usuario_aux.getUsername()!=null) {
				pstmt.setString(1, usuario_aux.getUsername());
				pstmt.setString(2, usuario_aux.getPassword());
				
				ResultSet rs= pstmt.executeQuery();
				
				while(rs.next()) {
						usuarios= new Usuario(rs.getString("username"), rs.getString("email"), rs.getBoolean("premium"));
				}
			}
			
			
		}catch(SQLException e) {
			System.out.println("Error al buscar al usuario");
		} catch (GualetException e) {
			// TODO Auto-generated catch block
			System.out.println(e.getMessage());
		}
		
		return usuarios;
	}
	
	//Actualiza la informacion del usuario
	//Devuelve el numero de lineas afectadas, si es igual a cero no se ha actualizado nada
	public int actualizarUsuario(String username, String contraseña, String email, int premium) {
		int lineasAfectadas=0;
		String sql= "UPDATE usuario SET password = ?, email = ?, premium = ? WHERE UPPER(username) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			boolean premiumB= false;
			if(premium== 1) {
				premiumB=true;
			}
			Usuario user_aux= new Usuario(username, contraseña, email, premiumB);
			if(user_aux.getUsername()!=null){
				pstmt.setString(1, user_aux.getPassword());
				pstmt.setString(2, user_aux.getEmail());
				pstmt.setInt(3, premium);
				pstmt.setString(4, user_aux.getUsername());
				lineasAfectadas=pstmt.executeUpdate();
				
				System.out.println("Actualizado");
			}
			
			
		}catch(SQLException e) {
			System.out.println("Error al actualizar el usuario");
		} catch (GualetException e) {
			// TODO Auto-generated catch block
			System.out.println(e.getMessage());
		}
		return lineasAfectadas;
	}
	
	public int actualizarUsuario(String username, String email, int premium) {
		int lineasAfectadas=0;
		String sql= "UPDATE usuario SET email = ?, premium = ? WHERE UPPER(username) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			boolean premiumB= false;
			if(premium== 1) {
				premiumB=true;
			}
			Usuario user_aux= new Usuario(username, email, premiumB);
			if(user_aux.getUsername()!=null){
				pstmt.setString(1, user_aux.getEmail());
				pstmt.setInt(2, premium);
				pstmt.setString(3, user_aux.getUsername());
				lineasAfectadas=pstmt.executeUpdate();
				
				System.out.println("Actualizado");
			}
			
			
		}catch(SQLException e) {
			System.out.println("Error al actualizar el usuario");
		} 
		return lineasAfectadas;
	}
	
	//Busca un usuario por su nombre de usuario
	public Usuario buscarUsuario(String username) {
		Usuario usuarios=null;
		
		String sql= "SELECT username, password, email, premium FROM Usuario WHERE UPPER(username) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, username);
			
			ResultSet rs= pstmt.executeQuery();
			
			while(rs.next()) {
					usuarios= new Usuario(rs.getString("username"), rs.getString("email"), rs.getBoolean("premium"));
			}
			
			
		}catch(SQLException e) {
			System.out.println("Error al hacer la busqueda");
		} 
		
		return usuarios;
	}
	
	//Busca un usuario por su nombre de usuario
	public int borrarUsuario(String username) {
		int lineasAfectadas=0;
		
		String sql= "DELETE FROM usuario WHERE UPPER(username) LIKE UPPER(?)";
			
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, username);
			lineasAfectadas=pstmt.executeUpdate();
				
		}catch(SQLException e) {
			System.out.println("Error al hacer la busqueda");
		} 
			
		return lineasAfectadas;
	}
	
	//Añade transaccion como los otros, hay dos metodos, una para añadir descripcion y otro para no
	//Devuelven los mismo que los otros add
	public Transaccion addTransaccion(String username, String concepto, Double monto, String fecha) {
		Transaccion transaccion_return=null;
		String sql= "INSERT INTO Transaccion(username, concepto, saldo, descripcion, fecha) VALUES (?, ?, ?, ?, ?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			
			pstmt.setString(1, username);
			pstmt.setString(2, concepto);
			pstmt.setDouble(3, monto);
			pstmt.setString(4, "");
			pstmt.setString(5, fecha);
			
			pstmt.executeUpdate();
			
			transaccion_return= new Transaccion(concepto, monto, fecha);
			return transaccion_return;
		}catch(SQLException e) {
			System.out.println("La transaccion con fecha "+fecha+" ya existe para el usuario "+username);
		}
		
		return null;
	}
	
	public Transaccion addTransaccion(String username, String concepto, Double monto, String descripcion,String fecha) {
		Transaccion transaccion_return=null;
		String sql= "INSERT INTO Transaccion(username, concepto, saldo, descripcion, fecha) VALUES (?, ?, ?, ?, ?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			
			pstmt.setString(1, username);
			pstmt.setString(2, concepto);
			pstmt.setDouble(3, monto);
			pstmt.setString(4, descripcion);
			pstmt.setString(5, fecha);
			
			pstmt.executeUpdate();
			
			transaccion_return= new Transaccion(concepto,monto,descripcion,fecha);
			return transaccion_return;
		}catch(SQLException e) {
			System.out.println("La transaccion con fecha "+fecha+" ya existe para el usuario "+username);
		}
		
		return null;
	}

	//Busca en las transacciones por el usuario y la fecha
	//Devuelve los mismo que en las demas
	public Transaccion buscarTransaccion(String username, String fecha) { 
		Transaccion transacciones=null;
		
		String sql= "SELECT concepto, saldo, descripcion, fecha FROM transaccion WHERE UPPER(username) LIKE UPPER(?) AND fecha LIKE ?";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, username);
			pstmt.setString(2, fecha);
			
			ResultSet rs= pstmt.executeQuery();
			while(rs.next()) {
				transacciones= new Transaccion(rs.getString("concepto"), rs.getDouble("saldo"), rs.getString("descripcion"),rs.getString("fecha"));
			}
			
			
		}catch(SQLException e) {
			System.out.println("Error al hacer la busqueda");
		}
		
		return transacciones;
	}
	
	//Busca todas las transacciones de un usuario
	public List<Transaccion> buscarTransaccionUsuario(String username) { 
		List<Transaccion> transacciones=null;
		
		String sql= "SELECT concepto, saldo, descripcion, fecha FROM transaccion WHERE UPPER(username) LIKE UPPER(?)";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, username);
			
			ResultSet rs= pstmt.executeQuery();
			
			transacciones= new ArrayList<>();
			while(rs.next()) {
				transacciones.add(new Transaccion(rs.getString("concepto"), rs.getDouble("saldo"), rs.getString("descripcion"),rs.getString("fecha")));
			}
			
			
		}catch(SQLException e) {
			System.out.println("Error al hacer la busqueda");
		}
		
		return transacciones;
	}

	//Borra una transaccion de un usuario
	public int borrarTransaccion(String username, String concepto, String fecha) { 
		int lineasAfectadas=0;
		
		String sql= "DELETE FROM transaccion WHERE UPPER(concepto) LIKE UPPER(?) AND UPPER(username) LIKE UPPER(?) AND fecha LIKE ?";
		
		try(PreparedStatement pstmt= connect.prepareStatement(sql)){
			pstmt.setString(1, concepto);
			pstmt.setString(2, username);
			pstmt.setString(3, fecha);
			
			lineasAfectadas= pstmt.executeUpdate();
			
			System.out.println("Borrado");
			
		}catch(SQLException e) {
			System.out.println("Error al hacer el borrado");
		}
		return lineasAfectadas;
	}

}
	

