package GUI;

import java.awt.Color;
import java.awt.Font;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

import database.BDD;
import gualet.Usuario;

public class Inicio_Sesion extends JFrame implements ActionListener{

	private static final long serialVersionUID = 1L;
	
	BDD base = new BDD();
	JFrame frame = new JFrame(); //Definimos la ventana
	
	JPanel panel = new JPanel(); //Definimos el panel donde distribuimos los elementos dentro de la ventana
	
	JLabel Titulo_email = new JLabel("Email:"); //Definimos un titulo para el email
	JLabel Titulo_nombre = new JLabel("Usuario:");
	JLabel Error = new JLabel("Error de inicio de sesion");
	JLabel Titulo_contrasenia = new JLabel("Contraseña:"); 
	JLabel empresa = new JLabel("Gualet-G7.TM");
	JLabel imagen = new JLabel();
	
	JTextField email = new JTextField(20); //Definimos el campo de texto
	JTextField contrasenia = new JTextField(20);
	JTextField nombre = new JTextField(20);
	
	JButton iniciar = new JButton(); //Definimos el boton
	JButton registrar = new JButton();
	JButton olvido = new JButton();
	
	ImageIcon icono = new ImageIcon("simbolo.png");
	ImageIcon principal = new ImageIcon("Inicio.png");
	
	Menu menu = new Menu();
	
	public Inicio_Sesion ()  {
	};
	
	public void crear () {
		//Frame-----------------------------------------------------------------------------------------------------
		frame.setSize(500, 600); //Tamaño de la ventana en pixels
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); //Operacion al intentar cerrar la ventana
		frame.setTitle("Gualet-G7");
		frame.setIconImage(icono.getImage());
		
		//Panel-----------------------------------------------------------------------------------------------------
		frame.add(panel); //Introducimos el panel dentro de la ventana
		panel.setLayout(null); //Establecemos el orden de distribucion del panel
		panel.setBackground(Color.darkGray); //Establecemos el color de fondo panel
		
		//Imagen
		imagen.setIcon(principal);
		imagen.setBounds(75,50,2000,100);
		panel.add(imagen);

		//Label-----------------------------------------------------------------------------------------------------
		Titulo_nombre.setBounds(30, 70, 100, 250); //Establecemos los limites del titulo
		Titulo_nombre.setForeground(Color.white); //Establecemos el color de la fuente
		panel.add(Titulo_nombre); //Añadimos el titulo al panel
		
		Titulo_contrasenia.setBounds(30, 150, 200, 250); 
		Titulo_contrasenia.setForeground(Color.white);
			
		empresa.setBounds(200, 400, 100, 250); 
		empresa.setForeground(Color.BLACK);
		panel.add(empresa); 
		panel.add(Titulo_contrasenia); 
			
		//TextField-----------------------------------------------------------------------------------------------------
		nombre.setBounds(30, 220, 425, 25); //Definimos la posicion y el tamaño del campo de texto
		panel.add(nombre); //Añadimos el campo de texto
			
		contrasenia.setBounds(30, 300, 425, 25);;
		panel.add(contrasenia);
	
		//Button-----------------------------------------------------------------------------------------------------
		iniciar.setBounds(30, 350, 200, 50); //Definimos la posicion y el tamaño del boton
		iniciar.setBackground(Color.red.darker()); //Cambiamos el color del boton
		iniciar.setText("Iniciar sesión"); //Introducimos un titulo dentro del botton
		iniciar.addActionListener(this); //Añadimos las acciones al pulsar
		iniciar.setForeground(Color.white); //Establecemos el color del titulo dentro del boton
		panel.add(iniciar); //Añadimos el boton
			
		registrar.setBounds(255, 350, 200, 50);
		registrar.setBackground(Color.red.darker());
		registrar.setText("Registrarse");
		registrar.addActionListener(this);
		registrar.setForeground(Color.white);
		panel.add(registrar);
		
		olvido.setBounds(30, 420, 425, 25);
		olvido.setBackground(Color.red.darker());
		olvido.setText("¿Olvidaste la contraseña?");
		olvido.addActionListener(this);
		olvido.setForeground(Color.white);
		panel.add(olvido);
		
		frame.setVisible(true); //Hacemos visible la ventana
	}
	
	public void actionPerformed (ActionEvent evento) {
		if(evento.getSource() == iniciar) {
			if(!nombre.getText().equals("") && !contrasenia.getText().equals("")) {
			//añadir metodos para comprobar inicio sesion
				Usuario usu = base.iniciarSesion(nombre.getText(), contrasenia.getText());
				if(usu == null) {
					Error.setBounds(125, 475, 425, 25);
					Error.setText("Error de inicio de sesion");
					Error.setFont(new Font("Arial", Font.BOLD ,20));
					Error.setForeground(Color.white);
					panel.add(Error);
					panel.updateUI();
				}else{
					frame.dispose();
					menu.crearPrincipal(usu,base);
				}
			}else {
				Error.setBounds(110, 475, 425, 25);
				Error.setText("Rellene los campos de texto");
				Error.setFont(new Font("Arial", Font.BOLD ,20));
				Error.setForeground(Color.white);
				panel.add(Error);
				panel.updateUI();
			}
		}else if (evento.getSource() == registrar) {
			if(!nombre.getText().equals("") && !contrasenia.getText().equals("")) {
				//añadir metodos para registrar
				Usuario usu = base.addUsuario(nombre.getText(), contrasenia.getText(), null, 0);
				if(usu == null) {
					Error.setBounds(60, 475, 425, 25);
					Error.setText("Error de registro, usuario ya registrado");
					Error.setFont(new Font("Arial", Font.BOLD ,20));
					Error.setForeground(Color.white);
					panel.add(Error);
					panel.updateUI();
				}else{
					frame.dispose();
					menu.crearPrincipal(usu,base);
				}
			}else {
				Error.setBounds(110, 475, 425, 25);
				Error.setText("Rellene los campos de texto");
				Error.setFont(new Font("Arial", Font.BOLD ,20));
				Error.setForeground(Color.white);
				panel.add(Error);
				panel.updateUI();
			}
			
		}else if (evento.getSource() == olvido)  {
			//añadir metodos para recuperar la contrasenia
		}
	}
}
