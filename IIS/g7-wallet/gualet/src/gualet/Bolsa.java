package gualet;

import java.io.IOException;
import java.util.LinkedList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;


public class Bolsa {
	
	//1: Nombre 2:Precio 3:Var.(%) 4:Var.(€) 5:Precio anterior 6:Fecha
    List<String> bolsa;
	
	public Bolsa() {
		bolsa= new LinkedList<>();
	}
	
	
	//Se conecta y descarga el html de la url
	//De la cual busca las tablas y le devuelva la primera a otra variable
	//Con esta variable podemos conseguir todos los valores de cada row de la tabla
	public void getBolsa() throws IOException {
		String url = "https://www.eleconomista.es/indices-mundiales/";
        Document doc = Jsoup.connect(url).get();
       
        Element tableElement = doc.select("table").first();

        Elements tableRowElements = tableElement.select(":not(thead) tr");

        for (int i = 0; i < tableRowElements.size(); i++) {
            Element row = tableRowElements.get(i);
            Elements rowItems = row.select("td");
            for (int j = 0; j < rowItems.size(); j++) {
                if(!rowItems.get(j).text().equals("")) {
                    bolsa.add(rowItems.get(j).text());
                }
            }
        }

	}
	
	
	//Muestra los valores de cada row de la tabla
	public void mostrar() {
		int i=0;
		while(i<bolsa.size()) {
			System.out.print(bolsa.get(i).toString());
			System.out.print(" - Precio: "+bolsa.get(i+1).toString());
			System.out.print(" - VAR.(%): "+bolsa.get(i+2).toString());
			System.out.print(" - VAR.(€): "+bolsa.get(i+3).toString());
			System.out.print(" - Anterior: "+bolsa.get(i+4).toString());
			System.out.print(" - Fecha: "+bolsa.get(i+5).toString());
			System.out.println("\n");
			i = i +6;
		}
	}
	
	public List<String> getLista() {
		return bolsa;
	}
}
