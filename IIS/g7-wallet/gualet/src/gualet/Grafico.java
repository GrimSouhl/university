package gualet;
import java.awt.Color;

import java.awt.Dimension;
import java.awt.Font;
import java.awt.FontMetrics;
import java.awt.Graphics;
import java.util.List;

import javax.swing.JPanel;
import database.*;

public class Grafico extends JPanel {
	
	private static final long serialVersionUID = 1L;//auto-generado por Eclipse
	private double[] valores; //los valores definen las alturas de las barras
	private String[] transacciones; //num transacciones bajo cada barra
	private String titulo;	//título de la ventana del gráfico
	private Usuario user;
	private BDD dataBase;
	private int cantidadArray;

	//parámetros necesarios para dibujar el gráfico
	public Grafico(String t, Usuario user, BDD dataBase) {
		transacciones = new String[10];
		valores = new double[10];
		titulo = t;
		this.user= user;
		this.dataBase= dataBase;
		cantidadArray=0;
	}
	
	public void getDiezUltimosValores() {
		Historial hist= new Historial(dataBase);
		hist.actualizarLista(user.getUsername());
		List<Transaccion> transaccionesUsuario= hist.getLista();
		cantidadArray= transaccionesUsuario.size();
		int i= 0, j= transaccionesUsuario.size()-1;
		while(i<10 && j>-1) {
			valores[i]= transaccionesUsuario.get(j).getimporte();
			transacciones[i]="#"+(i+1);
			i++;
			j--;
		}
	}
	
	public int datosEnArray() {
		return cantidadArray;
	}
	//Si no hay valores se controla fuera
	//Componentes del gráfico:
	public void paintComponent(Graphics g) {
		super.paintComponent(g);
			
		double valorMIN = 0;
		double valorMAX = 0;
	  
		for (int i = 0; i < valores.length; i++) {
			if (valorMIN > valores[i]) {
				valorMIN = valores[i];
			}
			if (valorMAX < valores[i]) {
				valorMAX = valores[i];
			}
		}
		//el tamaño del gráfico dependerá¡ de los valores en alto y del num movimientos en ancho
		Dimension d = getSize();
		int ancho = d.width;
		int altura = d.height;
		int anchoBarras = ancho / valores.length;
		
		//Defino el color de fondo de la ventana: (Dark gray)
		setBackground(Color.DARK_GRAY);
		
		//Titulo (fuente y tamaño):
		Font fuenteTexto = new Font("Arial", Font.BOLD, 20);
		FontMetrics tamfuenteTexto = g.getFontMetrics(fuenteTexto);
		
		//Etiquetas (fuente y tamaño):
		Font fuenteEtiquetas = new Font("SansSerif", Font.PLAIN, 15);
		FontMetrics tamfuenteEtiquetas = g.getFontMetrics(fuenteEtiquetas);
		
		//Saldos(fuente y tamaño):
		Font fuenteSaldos = new Font("SansSerif", Font.BOLD, 12);
		
		//Posicionamiento Título
		int anchoTitulo = tamfuenteTexto.stringWidth(titulo);
		
		int y = tamfuenteTexto.getAscent(); //en el punto más alto en altura
		int x = (ancho - anchoTitulo) / 2; //en la mitad de la ventana en anchura
		

		g.setFont(fuenteTexto);//según la fuente definida
		g.setColor(Color.white);//defino color título gráfico
		g.drawString(titulo, x, y);//lo represento en la posición definida

		int top = tamfuenteTexto.getHeight()+50; //alto de la cabecera = al de la fuente del título +50 pixels de margen para separar de barras
		int bottom = tamfuenteEtiquetas.getHeight();//alto del pie de gráfico del alto de las etiquetas meses
	  
    
		//para visualizarlo según el tamaño máximo y mínimo escalado a pantalla.
		double escala = (altura - top - bottom) / (valorMAX - valorMIN);
		y = altura - tamfuenteEtiquetas.getDescent();
		g.setFont(fuenteEtiquetas);
		//for para escalar la disposición de las barras al tamaño ventana
		for (int i = 0; i < cantidadArray; i++) {
			int valorX = i * anchoBarras + 1;
			int valorY = top;
			int alto = (int) (valores[i] * escala);
		  
			if (valores[i] >= 0) {
				valorY += (int) ((valorMAX - valores[i]) * escala);
			}else {
				valorY += (int) (valorMAX * escala);
				alto = -alto;
			}
			
			//color barras del gráfico
			g.setColor(Color.red.darker());
			g.fillRect(valorX, valorY, anchoBarras - 2, alto);
			
			//color bordes y etiquetas
			g.setFont(fuenteEtiquetas);//según la fuente definida
			g.setColor(Color.white);
			g.drawRect(valorX, valorY, anchoBarras - 2, alto);
		  
			int anchoEtiquetas = tamfuenteEtiquetas.stringWidth(transacciones[i]);
			x = i * anchoBarras + (anchoBarras - anchoEtiquetas) / 2; //pos:centrado bajo cada barra
			g.drawString(transacciones[i], x, y);
			
			//Para representar los valores de los saldos en cada barra:
			g.setFont(fuenteSaldos);//según la fuente definida
			g.setColor(Color.white);
			g.drawString(Double.toString(valores[i]), valorX, valorY-5); //Double.toString() convierte los valores de los saldos para poder representarlos
			//valorY-5 es para separar 5 pixels hacia arriba de la barra el valor del saldo del mes correspondiente.
		}
		
		
	}
	
}