package GUI;

import gualet.*;
import java.awt.Color;
import java.awt.Font;
import java.awt.TextField;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.IOException;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Date;
import java.util.List;

import javax.swing.ImageIcon;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

import database.BDD;

public class Menu extends JFrame implements ActionListener {

	private static final long serialVersionUID = 1L;
	//Datos Externos
	BDD base;
	Historial historial;
	Usuario user;
	LibreriaProyectoAhorro libp;
	List<ProyectoAhorro> aux;
	//FormateadorFecha
	//Para añadir fecha usar dtf.format(LocalDateTime.now());
	//Para añadir hora a la fecha usar +dtf2.format(LocalDateTime.now())
	DateTimeFormatter dtf = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm:ss");
	DateTimeFormatter dtfHora = DateTimeFormatter.ofPattern("HH:mm:ss");
	DateTimeFormatter dftFecha= DateTimeFormatter.ofPattern("dd/MM/yyyy");

	//Ventana
	JFrame frame = new JFrame(); //Definimos la ventana
	ImageIcon icono = new ImageIcon("simbolo.png"); //Añadimos el icono a al margen de la ventana

	//Panel
	JPanel panel = new JPanel(); //Definimos el panel donde distribuimos los elementos dentro de la ventana

	//Variables auxiliares
	double saldoMostradoAux;
	String nombreCuentaAux;
	Monedero monederoAux;

	//Variables menu
	JButton noticiasTab = new Boton(125, 50, 200, 75,24,"Noticias",Color.red.darker(), Color.white).getBoton();
	JButton estadisticosTab = new Boton(375, 50, 200, 75, 24,"Estadisticos", Color.red.darker(), Color.white).getBoton();
	JButton ahorroTab = new Boton(625, 50, 200, 75, 24,"Ahorro", Color.red.darker(), Color.white).getBoton();
	JButton configuracionTab = new Boton(875, 50, 200, 75, 24,"Configuracion", Color.red.darker(), Color.white).getBoton();

	//Variables Cuenta
	JButton botonOperaciones = new Boton (625, 170, 200, 40, 17, "Operacion",Color.red.darker(),Color.white).getBoton();
	JButton botonCuentas = new Boton (875, 170, 200, 40, 17, "Cuentas",Color.red.darker(),Color.white).getBoton();

	JLabel tituloCuenta = new Titulos(125,140,125,30,20,"Cuenta",Color.red.darker()).getTitulo();
	JLabel tituloSaldo = new Titulos(375,140,125,30,20,"Saldo",Color.red.darker()).getTitulo();
	JLabel tituloIBAN= new Titulos(125, 215, 125, 30, 20, "IBAN", Color.red.darker()).getTitulo();
	JLabel tituloNombreCuentaSeleccionado ;
	JLabel tituloSaldoCuentaSeleccionado ;

	//Variables Operacion
	JButton botonConfirmarOperacion = new Boton (635, 170, 200, 40, 17, "Confirmar",Color.red.darker(),Color.white).getBoton();
	JButton botonCancelarOperacion = new Boton (875, 170, 200, 40, 17, "Cancelar",Color.red.darker(),Color.white).getBoton();

	JTextField campoTextoConceptoOperacion = new JTextField();
	JTextField campoTextoCantidadOperacion = new JTextField();

	//Variables cambio de cuenta
	JButton botonAñadirCuenta = new Boton (625, 170, 200, 40, 17, "Añadir",Color.red.darker(),Color.white).getBoton();
	JButton botonSeleccionarCuenta = new Boton (875, 170, 200, 40, 17, "Seleccionar",Color.red.darker(),Color.white).getBoton();
	JButton botonCancelarCambioCuenta = new Boton (375, 170, 200, 40, 17, "Cancelar",Color.red.darker(),Color.white).getBoton();

	JComboBox<String> selectorCambioCuenta;

	//Variables añadir cuenta
	JButton botonCrearCuenta = new Boton (875, 170, 200, 40, 17, "Confirmar",Color.red.darker(),Color.white).getBoton();

	JTextField campoTextoNombreCuentaNueva = new JTextField();
	JTextField campoTextoSaldoNuevaCuenta = new JTextField();
	JTextField campoTextoIBANNuevaCuenta = new JTextField();

	JLabel tituloError = new Titulos(375, 210, 300, 30, 20, "Error, argumentos no validos", Color.red.darker()).getTitulo();

	//Variables estadisticos
	JButton botonGraficas = new Boton (250, 250, 200, 40, 17, "Graficas ",Color.red.darker(),Color.white).getBoton();
	JButton botonDivisas = new Boton (500, 250, 200, 40, 17, " Divisas ",Color.red.darker(),Color.white).getBoton();
	JButton botonConfirmarDivisa = new Boton (875, 335, 200, 40, 17, "Confirmar",Color.red.darker(),Color.white).getBoton();
	JButton botonIndices= new Boton(750, 250, 200, 40, 17, "Indices Bursatiles", Color.red.darker(), Color.white).getBoton();

	JTextField campoTextoIntroducirCantidadCambioDivisas = new JTextField();

	JLabel tituloDisivaConvertida =  new Titulos(375, 380, 500, 70, 17,"", Color.WHITE).getTitulo();
	JLabel tituloDivisaOrigen = new Titulos(125,320,125,70,17,"Origen: ",Color.WHITE).getTitulo();
	JLabel tituloDivisaDestino= new Titulos(375,320,125,70,17,"Destino: ",Color.WHITE).getTitulo();
	JLabel tituloValorCambioDivisa = new Titulos(625,320,125,70,17,"Valor: ",Color.WHITE).getTitulo();

	String[] arraySeleccionDivisas = {"Euro", "Dolar", "Libra", "Yen", "Franco suizo", "Dolar australiano", "Dolar canadiense", "Corona noregua","Yuan", "Peso mexicano", "Bolivar"} ;
	JComboBox<String> selectorDivisaOrigen = new JComboBox<String>(arraySeleccionDivisas);
	JComboBox<String> selectorDivisaDestino = new JComboBox<String>(arraySeleccionDivisas);


	//Variables noticias
	Noticias noticia = new Noticias();
	URLabel url = new URLabel();

	//Variables ahorro
	String nom ="";

	JButton InicioP = new Boton(125, 250, 200, 40, 17, "Inicio",Color.red.darker(),Color.white).getBoton();
	JButton BorrarP = new Boton (375, 250, 200, 40, 17, "Borrar Proyecto",Color.red.darker(),Color.white).getBoton();
	JButton BuscarP = new Boton (625, 250, 200, 40, 17, "Buscar Proyecto",Color.red.darker(),Color.white).getBoton();
	JButton AnadirP = new Boton (875, 250, 200, 40, 17, "Añadir Proyecto",Color.red.darker(),Color.white).getBoton();
	JButton Confirmaradd = new Boton(875,425,125,40,15, "Confirmar",Color.red.darker(),Color.white).getBoton();
	JButton EditarPboton= new Boton(875,425,125,40,15, "Editar",Color.red.darker(),Color.white).getBoton();
	JButton ConfirmarBorradoP = new Boton(875,335,125,40,15, "Confirmar",Color.red.darker(),Color.white).getBoton();
	JButton ConfirmarBuscarP = new Boton(875,335,125,40,15, "Confirmar",Color.red.darker(),Color.white).getBoton();
	JButton SeleccionarP = new Boton(875,355,200,40,15, "Seleccionar Proyecto",Color.red.darker(),Color.white).getBoton();
	JButton confirmarproyectoselect = new Boton(875,335,200,40,15, "Confirmar",Color.red.darker(),Color.white).getBoton();
	JButton cancelarsaldopa = new Boton(875,500,125,40,15, "Cancelar",Color.red.darker(),Color.white).getBoton();
	JButton ConfirmarEdiP= new Boton(875,425,125,40,15, "Confirmar",Color.red.darker(),Color.white).getBoton();

	JLabel saldoppa= new Titulos(875,340,125,40,15, "Añadir saldo:",Color.white).getTitulo();
	JLabel Vaciopp= new Titulos(450,400,250,70,15, "No hay proyectos de ahorro",Color.white).getTitulo();
	JLabel buscarpp= new Titulos(125,320,250,70,15,"Nombre del Proyecto a buscar:  ",Color.WHITE).getTitulo();
	JLabel errorsaldopa = new Titulos(875,550,500,40,15,"No se han introducido números",Color.WHITE).getTitulo();
	JLabel borrarpp= new Titulos(125,320,250,70,15,"Nombre del Proyecto a borrar:  ",Color.WHITE).getTitulo();
	JLabel noencrontrado = new Titulos(125,320,290,70,15,"No existe un proyecto con ese nombre",Color.WHITE).getTitulo();
	JLabel ppadded1 = new Titulos(450,400,250,70,15,"Proyecto de ahorro agregado.",Color.WHITE).getTitulo();
	JLabel pperroradd1 = new Titulos(450,400,250,70,15,"Error al añadir el proyecto.",Color.WHITE).getTitulo();
	JLabel pperroradd2 = new Titulos(450,450,250,70,15,"Por favor, revise sus datos.",Color.WHITE).getTitulo();
	JLabel exitoborradopp = new Titulos(450,400,350,70,15,"Se ha borrado el proyecto de ahorro con exito.",Color.WHITE).getTitulo();
	JLabel exitoeditarpp = new Titulos(450,400,350,70,15,"Se ha editado el proyecto de ahorro con exito.",Color.WHITE).getTitulo();
	JLabel encontradopp = new Titulos(450,400,250,70,15,"Proyecto de ahorro encontrado.",Color.WHITE).getTitulo();
	JLabel ppadded2 = new Titulos(450,450,250,70,15,"Pulse inicio para ver los detalles.",Color.WHITE).getTitulo();

	JLabel errorFechaProyectoAhorro= new Titulos(450,575,250,70,20, "Fecha introducida mal", Color.white).getTitulo();

	JLabel anyadirpp= new Titulos(125,320,250,70,15,"Nombre del Proyecto:  ",Color.WHITE).getTitulo();
	JLabel objetivo= new Titulos(125,380,250,70,15,"Objetivo del Proyecto:  ",Color.WHITE).getTitulo();
	JLabel saldo = new Titulos(125,440,250,70,15,"Saldo del Proyecto: ",Color.WHITE).getTitulo();
	JLabel fechafin= new Titulos(125,500,250,70,15,"Fecha de Final(DD/MM/YYYY): ",Color.WHITE).getTitulo();
	JLabel fechainipp = new Titulos(125,500,250,70,15,"Fecha: ",Color.WHITE).getTitulo();

	String [] arraydeproyectos = new String[10];
	JComboBox<String> seleccionproyectoa;
	String nombrepp;

	JTextField saldopa = new JTextField();
	JTextField IntNombre = new JTextField();
	JTextField IntNombreBus = new JTextField();
	JTextField LibNom = new JTextField();
	JTextField LibObj = new JTextField();
	JTextField Libsal = new JTextField();
	JTextField LibFfin = new JTextField();


	Date date = new Date();

	//Variables indices bursatiles
	JLabel[] titulosTabla;
	JLabel[] valoresTabla;

	//Formatea un double a dos decimales
	 private static DecimalFormat df2 = new DecimalFormat("#.##");


	//Variables configuracion

	JButton botonConfirmarCambiosConfiguracion = new Boton (370, 575, 455, 40, 20, "Confirmar cambios de forma permanente",Color.red.darker(),Color.white).getBoton();

	JLabel tituloCambioContraseñaConfiguracion = new Titulos(125,400,200,30,20, "Contraseña: ",Color.white).getTitulo();
	JLabel tituloCambioEmailConfiguracion = new Titulos(125,300,200,30,20, "Email: ",Color.white).getTitulo();
	JLabel tituloCambioVipConfigracion = new Titulos(125,500,300,30,20, "Estado de subscripcion: ",Color.white).getTitulo();
	JLabel tituloRestriccionesEmailConfiguracion = new Titulos(625,300,400,30,12, "(No todos los correos estan disponibles)",Color.white).getTitulo();
	JLabel tituloRestriccionesContraseñaConfiguracion = new Titulos(625,400,400,30,12, "(La contraseña debe contener al menos una mayúscula y un número)",Color.white).getTitulo();
	JLabel tituloRestriccionVipConfiguracion = new Titulos(625,500,400,30,12, "La subscripcion puede estar activa  o no",Color.white).getTitulo();

	JTextField campoTextoCambioEmailConfiguracion = new JTextField();
	JTextField campoTextoCambioContraseñaConfiguracion = new JTextField();

	String[] arraySeleccionVip = {"No", "Si"} ;
	JComboBox<String> selectorCambioVipConfiguracion = new JComboBox<String>(arraySeleccionVip);


	//Funcion que establece la configuracion inicial del sistema
	public void crearPrincipal(Usuario usu, BDD b) {
		//Asignamos los valores iniciales de la UI
		base = b;
		user = usu;
		historial= new Historial(base);
		libp = new LibreriaProyectoAhorro(base);

		//Comprobamos si el usuario tiene monederos creados para asignarlos a la vista principal de cuentas
		if(!base.buscarMonederosUsuario(user.getUsername()).isEmpty()) {
			monederoAux = base.buscarMonederosUsuario(user.getUsername()).get(0);
			nombreCuentaAux = monederoAux.getNombre();
			saldoMostradoAux = monederoAux.getSaldo();
		}else {
			monederoAux= new Monedero("Cuenta: No seleccionada", 0, "a");
			nombreCuentaAux = "Cuenta: No seleccionada";
			saldoMostradoAux = 0;
		}

		tituloNombreCuentaSeleccionado = new Titulos(125,175,250,30,20, nombreCuentaAux,Color.WHITE).getTitulo();
		tituloSaldoCuentaSeleccionado = new Titulos(375, 175, 250, 30, 20, String.valueOf(saldoMostradoAux) + " €", Color.white).getTitulo();
		addIndicesAJlabel();

		//Ventana
		frame.setSize(1200,700); //Tamaño de la ventana en pixels
		frame.setResizable(false);
		frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE); //Operacion al intentar cerrar la ventana
		frame.setTitle("Gualet-G7");
		frame.setIconImage(icono.getImage());

		//Panel
		panel.setLayout(null);
		panel.setBackground(Color.darkGray);
		frame.add(panel);

		//Botones principales
		noticiasTab.addActionListener(this);
		panel.add(noticiasTab);

		estadisticosTab.addActionListener(this);
		panel.add(estadisticosTab);

		ahorroTab.addActionListener(this);
		panel.add(ahorroTab);

		configuracionTab.addActionListener(this);
		panel.add(configuracionTab);

		//Mostrar Cuenta
		botonOperaciones.addActionListener(this);
		botonCuentas.addActionListener(this);

		//Mostar Opercion
		botonConfirmarOperacion.addActionListener(this);
		botonConfirmarDivisa.addActionListener(this);
		botonCancelarOperacion.addActionListener(this);

		//Mostrar botonCuentas
		botonAñadirCuenta.addActionListener(this);
		botonSeleccionarCuenta.addActionListener(this);
		botonCancelarCambioCuenta.addActionListener(this);

		//botonAñadirCuenta cuenta
		botonCrearCuenta.addActionListener(this);

		//Proyecto Ahorro
		InicioP.addActionListener(this);
		BorrarP.addActionListener(this);
		BuscarP.addActionListener(this);
		AnadirP.addActionListener(this);
		ConfirmarBorradoP.addActionListener(this);
		ConfirmarBuscarP.addActionListener(this);
		Confirmaradd.addActionListener(this);
		EditarPboton.addActionListener(this);
		ConfirmarEdiP.addActionListener(this);
		SeleccionarP.addActionListener(this);
		confirmarproyectoselect.addActionListener(this);
		cancelarsaldopa.addActionListener(this);


		//Configuracion
		botonConfirmarCambiosConfiguracion.addActionListener(this);

		//Estadisticos
		botonGraficas.addActionListener(this);
		botonDivisas.addActionListener(this);
		botonIndices.addActionListener(this);

		//Indices Bursatiles
		titulosTabla= new JLabel[6];
		titulosTabla[0]= new Titulos(200,325,250,30,20, "Nombre" ,Color.WHITE).getTitulo();
		titulosTabla[1]= new Titulos(350,325,250,30,20, "Precio" ,Color.WHITE).getTitulo();
		titulosTabla[2]= new Titulos(500,325,250,30,20, "VAR.(%)" ,Color.WHITE).getTitulo();
		titulosTabla[3]= new Titulos(650,325,250,30,20, "VAR.(€)" ,Color.WHITE).getTitulo();
		titulosTabla[4]= new Titulos(800,325,250,30,20, "Anterior" ,Color.WHITE).getTitulo();
		titulosTabla[5]= new Titulos(950,325,250,30,20, "Fecha" ,Color.WHITE).getTitulo();

		mostrarConfig();

		frame.setVisible(true); //Hacemos visible la ventana

		mostrarCuenta();

	}

	public void mostrarCuenta () {
		//titulos

		panel.add(tituloCuenta);
		panel.add(tituloSaldo);
		tituloNombreCuentaSeleccionado.setText(monederoAux.getNombre());
		panel.add(tituloNombreCuentaSeleccionado);
		tituloSaldoCuentaSeleccionado.setText(String.valueOf(monederoAux.getSaldo()) + " €");
		panel.add(tituloSaldoCuentaSeleccionado);

		//botones
		if(!base.buscarMonederosUsuario(user.getUsername()).isEmpty()) {
			panel.add(botonOperaciones);
		}
		panel.add(botonCuentas);

		panel.updateUI();
	}

	public void ocultarCuenta () {
		//titulos
		panel.remove(tituloCuenta);
		panel.remove(tituloSaldo);
		panel.remove(tituloNombreCuentaSeleccionado);
		panel.remove(tituloSaldoCuentaSeleccionado);

		//botones
		panel.remove(botonOperaciones);
		panel.remove(botonCuentas);

		panel.updateUI();
	}

	public void mostrarOperacion () {
		//titulos
		tituloCuenta.setText("Concepto");
		panel.add(tituloCuenta);
		panel.add(tituloSaldo);

		//botones
		panel.add(botonConfirmarOperacion);
		panel.add(botonCancelarOperacion);

		//campos de texto
		campoTextoConceptoOperacion.setBounds(125,175,200,30);
		panel.add(campoTextoConceptoOperacion);
		campoTextoCantidadOperacion.setBounds(375,175,200,30);
		panel.add(campoTextoCantidadOperacion);

		panel.updateUI();
	}

	public void ocultarOperacion () {
		//titulos
		tituloCuenta.setText("Cuenta");
		panel.remove(tituloCuenta);
		panel.remove(tituloSaldo);

		//botones
		panel.remove(botonConfirmarOperacion);
		panel.remove(botonCancelarOperacion);

		//campos de texto
		panel.remove(campoTextoConceptoOperacion);
		panel.remove(campoTextoCantidadOperacion);
		campoTextoConceptoOperacion.setText("");
		campoTextoCantidadOperacion.setText("");

		panel.updateUI();
	}

	public void ocultarDivisas() {
		//JComboBox
		panel.remove(selectorDivisaDestino);
		panel.remove(selectorDivisaOrigen);

		//Titulos
		panel.remove(tituloDivisaDestino);
		panel.remove(tituloDivisaOrigen);
		panel.remove(tituloValorCambioDivisa);
		panel.remove(tituloDisivaConvertida);

		//TextBox
		panel.remove(campoTextoIntroducirCantidadCambioDivisas);
		campoTextoIntroducirCantidadCambioDivisas.setText("");

		//Botones
		panel.remove(botonConfirmarDivisa);

		panel.updateUI();
	}

	public void mostrarCuentas () {
		//selector
		String[] NombreCambio = {"Vacio"};
		if (!base.buscarMonederosUsuario(user.getUsername()).isEmpty()){
			NombreCambio = new String[base.buscarMonederosUsuario(user.getUsername()).size()];
			for (int i = 0; i < base.buscarMonederosUsuario(user.getUsername()).size(); i++) {
				NombreCambio[i] = base.buscarMonederosUsuario(user.getUsername()).get(i).getNombre();
			}
		}
		selectorCambioCuenta = new JComboBox<String>(NombreCambio);
		selectorCambioCuenta.setBounds(125, 175, 150, 30);
		selectorCambioCuenta.setSelectedItem(monederoAux.getNombre());
		panel.add(selectorCambioCuenta);

		//botones
		botonCancelarCambioCuenta.setBounds(375, 170, 200, 40);
		panel.add(botonCancelarCambioCuenta);
		panel.add(botonAñadirCuenta);
		if(!base.buscarMonederosUsuario(user.getUsername()).isEmpty()) {
			panel.add(botonSeleccionarCuenta);
		}


		panel.updateUI();
	}

	public void ocultarCuentas () {
		//botones
		panel.remove(botonCancelarCambioCuenta);
		panel.remove(botonAñadirCuenta);
		panel.remove(botonSeleccionarCuenta);

		//selector
		panel.remove(selectorCambioCuenta);

		panel.updateUI();
	}



	public void addCuenta () {
		ocultarTodo();
		ocultarCuenta();
		//campos de texto
		campoTextoNombreCuentaNueva.setBounds(125, 175, 200, 30);
		campoTextoSaldoNuevaCuenta.setBounds(375, 175, 200, 30);
		campoTextoIBANNuevaCuenta.setBounds(125, 250, 200, 30);
		panel.add(campoTextoNombreCuentaNueva);
		panel.add(campoTextoSaldoNuevaCuenta);



		//botones
		botonCancelarCambioCuenta.setBounds(625, 170, 200, 40);
		panel.add(botonCancelarCambioCuenta);
		panel.add(botonCrearCuenta);

		//titulos
		panel.add(tituloCuenta);
		panel.add(tituloSaldo);

		//IBAN si es premium
		if(user.isPremium()) {
			panel.add(campoTextoIBANNuevaCuenta);
			panel.add(tituloIBAN);
		}

		panel.updateUI();

	}

	public void ocultaraddCuenta () {
		//campos de texto
		panel.remove(campoTextoNombreCuentaNueva);
		panel.remove(campoTextoSaldoNuevaCuenta);
		panel.remove(campoTextoIBANNuevaCuenta);
		campoTextoNombreCuentaNueva.setText("");
		campoTextoSaldoNuevaCuenta.setText("");
		campoTextoIBANNuevaCuenta.setText("");

		//botones
		panel.remove(botonCrearCuenta);
		panel.remove(botonCancelarCambioCuenta);

		//titulos
		panel.remove(tituloCuenta);
		panel.remove(tituloSaldo);
		panel.remove(tituloIBAN);

		panel.updateUI();
	}


	public void mostrarConfig () {
		//titulos
		panel.add(tituloCambioContraseñaConfiguracion);
		panel.add(tituloCambioEmailConfiguracion);
		panel.add(tituloCambioVipConfigracion);
		panel.add(tituloRestriccionesEmailConfiguracion);
		panel.add(tituloRestriccionesContraseñaConfiguracion);
		panel.add(tituloRestriccionVipConfiguracion);

		//botones
		panel.add(botonConfirmarCambiosConfiguracion);

		//campos de texto
		campoTextoCambioEmailConfiguracion.setBounds(370,295,200,40);
		campoTextoCambioEmailConfiguracion.setText(user.getEmail());
		panel.add(campoTextoCambioEmailConfiguracion);
		campoTextoCambioContraseñaConfiguracion.setBounds(370,395,200,40);
		campoTextoCambioContraseñaConfiguracion.setText("");
		panel.add(campoTextoCambioContraseñaConfiguracion);

		//selector
		if(user.isPremium()) {
			selectorCambioVipConfiguracion.setSelectedItem("Si");
		}else {
			selectorCambioVipConfiguracion.setSelectedItem("No");
		}
		selectorCambioVipConfiguracion.setBounds(370,495,200,40);
		panel.add(selectorCambioVipConfiguracion);

		panel.updateUI();
	}

	public void mostrarAhorro () {

		panel.add(InicioP);
		panel.add(BorrarP);
		panel.add(BuscarP);
		panel.add(AnadirP);

		aux = base.buscarProyectoUsuario(user.getUsername());

		if(aux.isEmpty()) {


			panel.add(Vaciopp);

		}else {

			panel.add(EditarPboton);

			mostrarPA();
			panel.add(SeleccionarP);


		}
	}

	public void mostrarPA() {

		ProyectoAhorro pa = aux.get(aux.size()-1);

		JLabel Nombr= new Titulos(125,350,500,30,20, "Proyecto Ahorro: " + pa.getNombre() ,Color.white).getTitulo();
		JLabel Fecha= new Titulos(125,400,3000,30,20, "Fecha de Inicio: "+pa.getFechaInicio()+
							"     Fecha de fin: "+ pa.getFechaFin() ,Color.white).getTitulo();

		JLabel Objetivo= new Titulos(125,450,500,30,20, "Objetivo: " +pa.getObjetivo() ,Color.white).getTitulo();
		JLabel Saldo= new Titulos(125,500,500,30,20, "Saldo: "+ pa.getSaldo() ,Color.white).getTitulo();
		panel.add(Nombr);
		panel.add(Fecha);
		panel.add(Objetivo);
		panel.add(Saldo);
		panel.updateUI();
	}

	public void ocultarTodo () {
		panel.removeAll();

		//tabs
		panel.add(estadisticosTab);
		panel.add(noticiasTab);
		panel.add(ahorroTab);
		panel.add(configuracionTab);

		mostrarCuenta();

		panel.updateUI();
	}

	public void ocultarIndices() {
		//Titulos
		for(int i=0; i<valoresTabla.length; i++) {
			panel.remove(valoresTabla[i]);
		}
		for(int i=0; i<titulosTabla.length; i++) {
			panel.remove(titulosTabla[i]);
		}
	}

	public void addIndicesAJlabel() {
		Bolsa bolsa= new Bolsa();
		try {
			bolsa.getBolsa();
		} catch (IOException e) {
			System.out.println(e.getMessage());
		}
		List<String> valores= bolsa.getLista();
		valoresTabla= new JLabel[valores.size()];
		int x=210, y=375;

		for(int i=0; i<valoresTabla.length; i++) {
			if(valores.get(i).substring(0, 1).equals("-")) {
				valoresTabla[i]= new Titulos(x,y,250,30,15, valores.get(i) ,Color.red.darker()).getTitulo();
			}else if(valores.get(i).substring(0, 1).equals("+")) {
				valoresTabla[i]= new Titulos(x,y,250,30,15, valores.get(i) ,Color.green.darker()).getTitulo();
			}else {
				valoresTabla[i]= new Titulos(x,y,250,30,15, valores.get(i) ,Color.WHITE).getTitulo();
			}

			x+=150;
			if(((i+1)%6==0) && i!=0) {
				x=210;
				y+=50;
			}
		}
	}

	public void actionPerformed (ActionEvent evento) {

		if (evento.getSource() == noticiasTab) {

			ocultarTodo();

			try {
				noticia.refreshNoticias();
			} catch (IOException e) {
				System.out.println(e.getMessage());
			}

			int noticiasAMostrar= noticia.getTamList();

			if(noticiasAMostrar>13) {
				noticiasAMostrar=13;
			}

			for(int i=0;i<noticiasAMostrar;i++){
				URLabel not= new URLabel();
				not.setURL(noticia.getLink(i));
				not.setText(noticia.getTitular(i));
				not.setLocation(125, 225+30*i);
				not.setForeground(Color.white);
				not.getFont();
				not.setFont(new Font(not.getFont().getName(), Font.PLAIN, 15));
				panel.add(not);
				panel.updateUI();
			}

		}else if (evento.getSource() == estadisticosTab) {

			ocultarTodo();
			panel.add(botonGraficas);
			panel.add(botonDivisas);
			panel.add(botonIndices);


			panel.updateUI();

		}else if (evento.getSource() == configuracionTab) {

			ocultarTodo();
			mostrarCuenta();
			mostrarConfig();

		}else if (evento.getSource() == ahorroTab) {

            ocultarTodo();
			mostrarCuenta();
			mostrarAhorro();

		}else if(evento.getSource() == botonOperaciones) {

			ocultarCuenta();
			mostrarOperacion();

		}else if (evento.getSource() == botonConfirmarOperacion) {

			if(campoTextoConceptoOperacion.getText().equals("") || campoTextoCantidadOperacion.getText().equals("")) {
				panel.add(tituloError);
			}else{

				if(campoTextoCantidadOperacion.getText().substring(0, 0).equals("-")){
					try {
						monederoAux.quitar_saldo(Double.parseDouble(campoTextoCantidadOperacion.getText()));
					}catch (NumberFormatException e) {
						System.out.println("Mete solo numeros");
					}catch (GualetException e) {
						System.out.println(e.getMessage());
					}
				}else {
					try {
						monederoAux.anadirSaldo(Double.parseDouble(campoTextoCantidadOperacion.getText()));
					} catch (NumberFormatException e) {
						System.out.println("Mete solo numeros");
					}
				}

				historial.addTransaccion(user.getUsername(), campoTextoConceptoOperacion.getText(), Integer.parseInt(campoTextoCantidadOperacion.getText()), dtf.format(LocalDateTime.now()));
				panel.remove(tituloError);

				ocultarOperacion();
				mostrarCuenta();
				panel.updateUI();
			}

		}else if (evento.getSource() == botonCancelarOperacion) {

			panel.remove(tituloError);
			ocultarTodo();
			mostrarCuenta();

		}else if (evento.getSource() == botonCuentas) {

			ocultarCuenta();
			mostrarCuentas();

		}else if(evento.getSource() == botonDivisas) {
			ocultarIndices();
			panel.remove(tituloDisivaConvertida);

			//titulos
			panel.add(tituloDivisaOrigen);
			panel.add(tituloDivisaDestino);
			panel.add(tituloValorCambioDivisa);

			//selectores
			selectorDivisaOrigen.setBounds(200,340,125,30);
			panel.add(selectorDivisaOrigen);
			selectorDivisaDestino.setBounds(450,340,125,30);
			panel.add(selectorDivisaDestino);

			//campo de texto
			campoTextoIntroducirCantidadCambioDivisas.setBounds(700,340,125,30);
			panel.add(campoTextoIntroducirCantidadCambioDivisas);



			panel.add(botonConfirmarDivisa);

			panel.updateUI();

		}else if(evento.getSource() == botonGraficas) {

			DibujarGrafico graphic= new DibujarGrafico(user, base);
			graphic.dibujar();

		}else if (evento.getSource() == botonConfirmarDivisa) {

			CambioDeDivisa d = new CambioDeDivisa();

			double aux= 0;

			try {
				aux= Double.parseDouble(campoTextoIntroducirCantidadCambioDivisas.getText());
				aux = d.cambiarDivisa(selectorDivisaOrigen.getSelectedIndex(), selectorDivisaDestino.getSelectedIndex(), aux);
				tituloDisivaConvertida.setText("Valor del "+selectorDivisaOrigen.getSelectedItem()+" en "+selectorDivisaDestino.getSelectedItem()+" son: "+String.valueOf(df2.format(aux))+" u.m.");
				panel.add(tituloDisivaConvertida);
				panel.updateUI();


			}catch (NumberFormatException e){
				System.out.println("El valor introducido es incorrecto");
				tituloDisivaConvertida = new Titulos(120, 380, 500, 70, 15,"tituloError Introduzca solo numeros", Color.WHITE).getTitulo();
				panel.add(tituloDisivaConvertida);
				panel.updateUI();
			}

		}else if(evento.getSource() == botonAñadirCuenta) {

			ocultarCuentas();
			addCuenta();

		}else if(evento.getSource() == botonCrearCuenta) {

			try {
				if(campoTextoIBANNuevaCuenta.getText().equals("")) {
					monederoAux= base.addMonedero(user.getUsername(), campoTextoNombreCuentaNueva.getText(), Double.parseDouble(campoTextoSaldoNuevaCuenta.getText()), dtf.format(LocalDateTime.now()));
				}else {
					monederoAux= base.addMonedero(user.getUsername(), campoTextoNombreCuentaNueva.getText(), Double.parseDouble(campoTextoSaldoNuevaCuenta.getText()), dtf.format(LocalDateTime.now()), campoTextoIBANNuevaCuenta.getText());
				}
				ocultaraddCuenta();
				mostrarCuenta();
				//panel.remove(botonCancelarCambioCuenta);
				panel.remove(tituloError);
			}catch(NumberFormatException e) {
				System.out.println("Valor no numérico");
				panel.add(tituloError);
				panel.updateUI();
			}

		}else if(evento.getSource() == botonCancelarCambioCuenta) {

			ocultarCuentas();
			ocultaraddCuenta();
			panel.remove(tituloError);
			panel.remove(botonCancelarCambioCuenta);
			mostrarCuenta();

		}else if (evento.getSource() == botonSeleccionarCuenta) {

			panel.remove(botonCancelarCambioCuenta);
			ocultarCuentas();
			monederoAux = base.buscarMonederosUsuario(user.getUsername()).get(selectorCambioCuenta.getSelectedIndex());
			tituloNombreCuentaSeleccionado.setText(monederoAux.getNombre());
			tituloSaldoCuentaSeleccionado.setText(String.valueOf(monederoAux.getSaldo()) + " €");
			selectorCambioCuenta.setSelectedItem(monederoAux.getNombre());
			mostrarCuenta();

		}else if (evento.getSource() == botonConfirmarCambiosConfiguracion) {

			if (campoTextoCambioContraseñaConfiguracion.getText().equals("")) {
				base.actualizarUsuario(user.getUsername(), campoTextoCambioEmailConfiguracion.getText(), selectorCambioVipConfiguracion.getSelectedIndex());
				user = base.buscarUsuario(user.getUsername());
			}else{
				base.actualizarUsuario(user.getUsername(), campoTextoCambioContraseñaConfiguracion.getText(), campoTextoCambioEmailConfiguracion.getText(), selectorCambioVipConfiguracion.getSelectedIndex());
				user = base.buscarUsuario(user.getUsername());
			}

		}else if(evento.getSource() == InicioP) {

			ocultarTodo();
			mostrarCuenta();
			mostrarAhorro();

		}else if(evento.getSource() == BorrarP ) {

			ocultarTodo();
			mostrarCuenta();

			//botones
			panel.add(InicioP);
			panel.add(BorrarP);
			panel.add(BuscarP);
			panel.add(AnadirP);
			panel.add(borrarpp);
			panel.add(ConfirmarBorradoP);

			//campo texto
			IntNombre.setBounds(375,340,450,30);
			IntNombre.setText(nom);
			panel.add(IntNombre);

		}else if(evento.getSource() == BuscarP ) {

			ocultarTodo();
			mostrarCuenta();
			//botones
			panel.add(InicioP);
			panel.add(BorrarP);
			panel.add(BuscarP);
			panel.add(AnadirP);
			panel.add(buscarpp);
			panel.add(ConfirmarBuscarP);

			//campo texto
			IntNombreBus.setBounds(375,340,450,30);
			IntNombreBus.setText(nom);
			panel.add(IntNombreBus);

		}else if(evento.getSource() == AnadirP ) {

			ocultarTodo();
			mostrarCuenta();

			//botones
			panel.add(InicioP);
			panel.add(BorrarP);
			panel.add(BuscarP);
			panel.add(AnadirP);

			panel.add(anyadirpp);
			panel.add(Confirmaradd);


			//titulos
			panel.add(objetivo);
			panel.add(saldo);
			panel.add(fechafin);


			//campo texto
			LibNom.setBounds(375,340,450,30);
			LibNom.setText(nom);
			panel.add(LibNom);

			LibObj.setBounds(375,400,450,30);
			LibObj.setText(nom);
			panel.add(LibObj);

			Libsal.setBounds(375,460,450,30);
			Libsal.setText(nom);
			panel.add(Libsal);

			LibFfin.setBounds(375,520,450,30);
			LibFfin.setText(nom);
			panel.add(LibFfin);


		}else if(evento.getSource() == ConfirmarBorradoP) {

			ocultarTodo();
			mostrarCuenta();

			panel.add(InicioP);
			panel.add(BorrarP);
			panel.add(BuscarP);
			panel.add(AnadirP);

			aux = base.buscarProyectoUsuario(user.getUsername());

			if(aux.isEmpty()) {
				panel.add(noencrontrado);
			}else {
				base.borrarProyectoAhorro(user.getUsername(),IntNombre.getText());
				panel.add(exitoborradopp);
			}

		}else if(evento.getSource() == ConfirmarBuscarP) {

			ocultarTodo();
			mostrarCuenta();

			panel.add(InicioP);
			panel.add(BorrarP);
			panel.add(BuscarP);
			panel.add(AnadirP);

			ProyectoAhorro x = base.buscarProyectoNombre(user.getUsername(), IntNombreBus.getText());

			if(x==null) {

				panel.add(noencrontrado);

			}else {
				ProyectoAhorro buscado= libp.buscarProyecto(user.getUsername(), IntNombreBus.getText() );
				if(aux.contains(buscado) || buscado!=null) {

					aux.remove(buscado);
					aux.add(buscado);

					panel.add(encontradopp);
					panel.add(ppadded2);
				}else {

					panel.add(noencrontrado);
				}
			}

		}else if(evento.getSource() == Confirmaradd) {

			boolean fechaBien= true;

			try {
				dftFecha.parse(LibFfin.getText());

			}catch(DateTimeParseException e) {
				fechaBien= false;
				errorFechaProyectoAhorro.setText("Fecha mal introducida");
				System.out.println("Fecha mal introducida");
			}

			try {
				Double.parseDouble(LibObj.getText());
				Double.parseDouble(Libsal.getText());
			}catch(NumberFormatException e) {
				fechaBien= false;
				errorFechaProyectoAhorro.setText("Introduzca solo numeros");
				System.out.println("No ha introducido numeros");
			}

			if(fechaBien) {
				libp.addProyecto(user.getUsername(), LibNom.getText(), Double.parseDouble(LibObj.getText()), Double.parseDouble(Libsal.getText()), dtf.format(LocalDateTime.now()), LibFfin.getText());


				ocultarTodo();
				mostrarCuenta();
				ocultarTodo();
				mostrarCuenta();

				panel.add(InicioP);
				panel.add(BorrarP);
				panel.add(BuscarP);
				panel.add(AnadirP);
				panel.remove(errorFechaProyectoAhorro);
				panel.add(ppadded1);
			}else {

				panel.add(errorFechaProyectoAhorro);
			}

			panel.updateUI();
		}else if(evento.getSource()==EditarPboton) {

			ocultarTodo();
			mostrarCuenta();
			mostrarPA();
			panel.add(InicioP);
			panel.add(BorrarP);
			panel.add(BuscarP);
			panel.add(AnadirP);

			panel.add(ConfirmarEdiP);
			panel.add(cancelarsaldopa);

			saldopa = new JTextField();
			saldopa.setBounds(875,375,150,30);
			panel.add(saldopa);
			panel.add(saldoppa);

			panel.updateUI();


		}else if(evento.getSource()==ConfirmarEdiP) {

			ocultarTodo();
			mostrarCuenta();

			try {
				Double.parseDouble(saldopa.getText());

				if(!saldopa.getText().equals("")) {
					base.cambiarSaldoProyectoAhorro(user.getUsername(), aux.get(aux.size()-1).getNombre(), aux.get(aux.size()-1).getSaldo()+Double.parseDouble(saldopa.getText()));
					mostrarAhorro();
					panel.remove(errorsaldopa);
				}

			}catch(NumberFormatException e) {
				System.out.println("No se han introducido números");

				EditarPboton.doClick();
				panel.add(errorsaldopa);
			}
			//
			panel.updateUI();


		}else if(evento.getSource()==cancelarsaldopa) {




			ocultarTodo();
			mostrarCuenta();
			mostrarAhorro();


		}else if(evento.getSource()== botonIndices) {
			ocultarDivisas();

			addIndicesAJlabel();
			for(int i=0; i<titulosTabla.length; i++) {
				panel.add(titulosTabla[i]);
			}
			for(int i=0; i<valoresTabla.length; i++) {
				panel.add(valoresTabla[i]);
			}
			panel.updateUI();
		}else if(evento.getSource()==SeleccionarP){

			ocultarTodo();
			mostrarCuenta();

			panel.add(InicioP);
			panel.add(BorrarP);
			panel.add(BuscarP);
			panel.add(AnadirP);
			panel.add(confirmarproyectoselect);


			aux = base.buscarProyectoUsuario(user.getUsername());

			if(aux.isEmpty()) {


				panel.add(Vaciopp);


			}else{

				mostrarPA();

				for(int i=0 ; i<aux.size(); i++) {
					ProyectoAhorro ps = aux.get(i);
					arraydeproyectos[i]= ps.getNombre();
				}

				seleccionproyectoa = new JComboBox<String>(arraydeproyectos);
				seleccionproyectoa.setBounds(875,390,200,40);
				panel.add(seleccionproyectoa);

				int id = seleccionproyectoa.getSelectedIndex();

				nombrepp = arraydeproyectos[id];
				seleccionproyectoa.setSelectedItem(nombrepp);

			}

		}else if(evento.getSource()==confirmarproyectoselect) {

			ocultarTodo();
			mostrarCuenta();
			panel.add(InicioP);
			panel.add(BorrarP);
			panel.add(BuscarP);
			panel.add(AnadirP);

			aux = base.buscarProyectoUsuario(user.getUsername());

			ProyectoAhorro buscado= libp.buscarProyecto(user.getUsername(), nombrepp);

			aux.remove(buscado);
			aux.add(buscado);

			mostrarAhorro();
			panel.updateUI();

		}

	}

}






