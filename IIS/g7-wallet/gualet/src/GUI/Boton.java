package GUI;

import java.awt.Color;
import java.awt.Font;

import javax.swing.JButton;

public class Boton {
	JButton boton = new JButton();
	
	public Boton (int x, int y, int length, int width, int tam, String text, Color back, Color fore) {
		boton.setBounds(x,y,length,width);
		boton.setBackground(back);
		boton.setForeground(fore);
		boton.setText(text);
		boton.setFont(new Font("Arial", Font.BOLD ,tam));
	}
	
	public JButton getBoton() {
		return boton;
	}
	
}
