package gualet;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

import org.jsoup.Jsoup;  
import org.jsoup.nodes.Document;  
import org.jsoup.nodes.Element;  
import org.jsoup.select.Elements; 

public class Noticias {
	
	// Creo lista para guardar los links de cada una de las noticias
	private List<Element> nLista;
	
	// Constructor en el que se inicializa la lista
	public Noticias() {
		nLista= new LinkedList<Element>();
		
	}
	
	// Con este metodo limpiamos la lista de noticias, nos conectamos a la pagina del economista
	// y guardamos todos los links de las noticias que tengan titulo en la lista
	public void refreshNoticias() throws IOException {
		nLista.clear();
		Document doc = Jsoup.connect("https://www.eleconomista.es/mercados-cotizaciones/").get();  
        Elements links = doc.select("a[href]");
        
        for (Element link : links) {  
        	if(link.attr("href").matches("//www.eleconomista.es/mercados-cotizaciones/noticias/.*") && link.text().length()>0 && !link.text().equals("play_arrowVídeo")) {
        		nLista.add(link); 
        	}
        }  
	}
	
	
	// Devuelve el hipervinculo de la noticia
	public String getLink(int i) {
		String link = new String();
		link = nLista.get(i).attr("href");
		return link;
	}
	
	public String getTitular(int i) {
		String titular;
		titular = nLista.get(i).text();
		return titular;
	}
	
	// Devuelve la cantidad de noticias en la lista
	public int getTamList() {
		return nLista.size();
	}
	
	
}