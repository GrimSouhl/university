package GUI;

import java.awt.Color;
import java.awt.Font;

import javax.swing.JLabel;

public class Titulos {
	JLabel titulo;
	
	public Titulos (int x, int y, int length, int width, int tam, String text, Color fore) {
		titulo = new JLabel(text);
		titulo.setBounds(x, y, length, width);
		titulo.setForeground(fore);
		titulo.setFont(new Font("Arial", Font.BOLD ,tam));
	}
	
	public JLabel getTitulo () {
		return titulo;
	}
}
