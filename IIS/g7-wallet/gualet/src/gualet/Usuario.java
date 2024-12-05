package gualet;

public class Usuario {

	private String username;
	private String password;
	private boolean premium;
	private String email;

	//Constructor para usuario anonimo
	public Usuario(String user, String con) throws GualetException{
		if(validarContraseña(con)) {
			con= encriptarPassword(con);
			this.username = user;
			this.password = con;
			this.premium= false;
			this.email="";
		}else {
			throw new GualetException("Contraseña invalida");
		}
	}

	//Constructor para usuario normal o premium
	public Usuario(String user, String con, String cor, boolean pre) throws GualetException{
		if(validarContraseña(con)) {
			con= encriptarPassword(con);
			this.username = user;
			this.password = con;
			this.premium = pre;
			this.email = cor;
		}else {
			throw new GualetException("Contraseña invalida");
		}
	}

	//Constructor para usuario que inicia sesion
	public Usuario(String user, String cor, boolean pre){
				this.username = user;
				this.password = "";
				this.premium = pre;
				this.email = cor;

		}

	@Override
	public String toString() {
		return "Usuario [username=" + username + ", password=" + password + ", premium=" + premium + ", email=" + email
				+ "]";
	}
		//getters y setters:
	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public boolean isPremium() {
		return premium;
	}

	public void setPremium(boolean premium) {
		this.premium = premium;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getUsername() {
		return username;
	}



	//validar contraseña--
	private boolean validarContraseña(String password){

        boolean ok = true; //si es verdadero
        @SuppressWarnings("unused")
		boolean esmayuscula= false;


        //para ver cuantas mayusculas tiene la contraseña introducida:

        @SuppressWarnings("unused")
		int n= 0;

        for (int i=0;i< password.length(); i++)
        {
        	  if (Character.isUpperCase(password.charAt(i))) {
        	   esmayuscula = true;
           }

        }

        //----------------------------

        if(password.contains(" ")||password.length() > 30||password.contains(".")||password.contains(",")
        		|| !passwordContainsNumber(password)||!esmayuscula) {


        	ok = false;

        }

        	return ok;
	}

	private boolean passwordContainsNumber(String password) {

		boolean ok= false;

		for( int i = 0; i < password.length(); i++ ) {
				if(Character.isDigit( password.charAt( i ) ) ) {
					ok = true;
	            }
	    }

		return ok; //si tiene algun numero devuelve true
	}



	//encriptar contraseÃ±a---
	private String encriptarPassword(String password) {
		char[] ch= separar(password);
		char[] encriptedPassword= new char[ch.length];
		int ascii=0;

		for(int i=0; i<ch.length; i++) {
			ascii= (int) ch[i];
			if(ascii>=97 && ascii<=122) {
				ascii+=9;
				if(ascii>122) {
					ascii= (ascii-122)+97;
				}
			}else if(ascii>=65 && ascii<=90) {
				ascii+=9;
				if(ascii>90) {
					ascii= (ascii-90)+65;
				}
			}else {
				ascii+=9;
				if(ascii>255) {
					ascii= (ascii-255)+30;
				}
			}
			encriptedPassword[i]= (char)ascii;
		}
		String passwordFinal="";
		for(int i=0; i<encriptedPassword.length; i++) {
			passwordFinal+=encriptedPassword[i];
		}
		return passwordFinal;
	}

	private char[] separar(String password) {
		char[] ch = new char[password.length()];

        // Copy character by character into array
        for (int i = 0; i < password.length(); i++) {
            ch[i] = password.charAt(i);
        }

        // Printing content of array
        return ch;
	}

}
