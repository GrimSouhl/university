package GUI;


import java.awt.Color;
import java.awt.Image;
import java.awt.Toolkit;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JTextArea;
import javax.swing.JTextField;

public class Asistente extends JFrame{

	//para llamar al asistente otro metodo poner -->  new Asistente();

	private static final long serialVersionUID = 1L;
	private JTextArea ta = new JTextArea(); // are donde colocamos el texto
	private JTextField tf = new JTextField();  // campo de texto
	private JButton b=new JButton(); // el boton
	private JLabel l = new JLabel(); // la etiqueta


	public Asistente(){

		JFrame f = new JFrame();
		f.setDefaultCloseOperation(EXIT_ON_CLOSE);
		f.setVisible(true);
		f.setResizable(false);
		f.setLayout(null);
		f.setSize(400,400);
		f.getContentPane().setBackground(Color.LIGHT_GRAY);
		f.setTitle("Asistente");
		Image icono = Toolkit.getDefaultToolkit().getImage("simbolo.png");
	    f.setIconImage(icono);

		f.add(ta);
		f.add(tf);


		ta.setSize(300,310);
		ta.setLocation(1,1);
		ta.setBackground(Color.darkGray);
		tf.setSize(300,20);
		tf.setLocation(1,320);

		f.add(b);
		l.setText("Enviar");
		b.add(l);

		b.setSize(400,20);
		b.setLocation(300,320);

		b.addActionListener( new ActionListener(){
			public void actionPerformed(ActionEvent e) {
				if(e.getSource()==b) {
					String text = tf.getText().toLowerCase();
					ta.setForeground(Color.RED);
					ta.append("Usuario-->"+text+"\n");
					tf.setText("");
					check(text);
				}
			}
		});
	}

	//---------respuestas:
	public void reply(String s) {

		ta.append("Asistente-->" + s + "\n" );
	}


	//-------------------------------------------

	public void check(String s) {
		if(s.contains("hola")||s.contains("buenas")||s.contains("hello")) {
			reply("Hola :D");
		}else {
			reply("No te entiendo :(");
		}
	}
}
