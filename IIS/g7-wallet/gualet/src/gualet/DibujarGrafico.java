package gualet;

import java.awt.Color;
import java.awt.Image;
import java.awt.Toolkit;
import java.util.Calendar;
import java.util.GregorianCalendar;

import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;

import GUI.Titulos;
import database.BDD;

public class DibujarGrafico {
	
	private Usuario user;
	private BDD dataBase;
	
	
	public DibujarGrafico(Usuario user, BDD dataBase) {
		this.user= user;
		this.dataBase= dataBase;
	}
		
	
	public void dibujar() {
		Calendar fecha = new GregorianCalendar();//creo calendario...
		int anho=fecha.get(Calendar.YEAR);//...para leer el año
		
		JFrame f = new JFrame();//ventana
		f.setSize(800, 600);//tamaño ventana
		f.setBackground(Color.DARK_GRAY);
		JPanel panel= new JPanel();
		panel.setBackground(Color.DARK_GRAY);
		//icono de la ventana:
		Image icono = Toolkit.getDefaultToolkit().getImage("simbolo.png");    
		f.setIconImage(icono); 
		//título de la ventana:
		f.setTitle("Graficas - Movimientos");
		
		JLabel label1= new Titulos(400, 300, 100, 100, 20, "No hay transacciones", Color.white).getTitulo();
		
		Grafico graphic= new Grafico("Ultimas 10 transacciones del a�o "+anho, user, dataBase);
		graphic.getDiezUltimosValores();
		if(graphic.datosEnArray()==0) {
			f.add(panel);
			panel.add(label1);
			
		}else {
			f.getContentPane().add(graphic);
		}
		//paso los valores a ser respresentados en la ventana:
		

		f.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		f.setVisible(true);
		
	}
	
	
}
