
public abstract class Objeto implements Comparable<Objeto> {

    private String nombre;
    private int bloque;
    private boolean mutable;
    private int linea;
    private static int numObj = 0;
    private static int numEtq = 0;

    public static String newNombObj() {
		String n = "$t" + numObj;
		numObj++;
		return n;
	}

	public static String newEtiqueta() {
		String etq = "L" + numEtq;
		numEtq++;
		return etq;
	}

    public Objeto (String nombre, int bloque, boolean mutable) {
		this.nombre = nombre;
		this.bloque = bloque;
		this.mutable = mutable;
	}

    public int getLinea(){
        return linea;
    }
    public String getNombre() {
        return nombre;
    }

    public int getBloque() {
        return bloque;
    }

    public boolean getMutable() {
        return mutable;
    }
//cada objeto de mi programa tiene un identificador de codigo, o sea puede haber variables con el mismo nombre, 
//para que no se pisen le damos un numero de bloque, o sea es como una ID
    public String getIDC() {
		return nombre+"$"+Integer.toString(bloque);
	}

//esto llama al metodo tipo int para que escriba la suma , la resta o lo que sea
    public abstract Object generarCodigoMetodo(String metodo, Objeto[] param) throws Exception;

    @Override
    public int compareTo(Objeto obj) {
        if(obj == null) {
            throw new NullPointerException("El objeto con el que se intenta comparar es nulo");
        }

        if(this.bloque == obj.bloque) {
            return this.nombre.compareTo(obj.nombre);
        } else {
            return this.bloque - obj.bloque;
        }
    }
}
