import java.text.ParseException;
import java.util.*;

public class TablaSimbolos {
    private final Map<Integer,Map<String,Objeto>> tabla;

    public TablaSimbolos(){
        tabla = new HashMap<>();
    } 

    public void insertarObjeto(Objeto obj){
        
        Integer bloque = Integer.valueOf(obj.getBloque());
        Map<String,Objeto> subtabla = tabla.get(bloque);
        if(subtabla == null) {
            Map<String, Objeto> st = new HashMap<>();
            st.put(obj.getNombre(),obj);
            tabla.put(bloque, st);
        }else{
            subtabla.put(obj.getNombre(),obj);
        }
    }
//busca el objeto por su nombre en cualquier bloque
    public Objeto buscar(String nombre) {
    if (nombre == null) {
        throw new IllegalArgumentException("El nombre del objeto no puede ser null");
    }

    for (int bloque = tabla.size(); bloque >= 0; bloque--) {
        Map<String, Objeto> subtabla = tabla.get(bloque);
        if (subtabla != null && subtabla.containsKey(nombre)) {
            return subtabla.get(nombre); 
        }
    }
    return null; //Si no se encuentra el objeto
}

//borra un objeto por su nombre y bloque
    public Objeto borrarObjeto(String nombre, int bloque){
        Map<String,Objeto> suTabla = tabla.get(bloque);
        if(suTabla  !=null){
            Objeto eliminado = suTabla.remove(nombre);
            if(eliminado !=null){
                return eliminado;
            }
        }
        return null;
    }

    public void eliminarBloque(int bloque){
        tabla.remove(bloque);
    }

    public Variable declararVariable(int linea, Variable v) throws Exception{
            
        Objeto obj = buscar(v.getNombre());

        if(obj!=null &&obj.getBloque() ==v.getBloque()){
            throw new ParseException("Variable <"+ v.getNombre()+"> ya declarada en el mismo bloque", linea);
        }
        insertarObjeto(v);

        return v;
    }


    public void borrarBloque(int bloque){
        tabla.remove(bloque);
    }

    @Override
    public String toString(){
        return tabla.toString();
    }

}

