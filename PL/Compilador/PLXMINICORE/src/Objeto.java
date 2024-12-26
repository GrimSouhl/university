
public abstract class Objeto implements Comparable<Objeto> {

    private String nombre;
    private int bloque;
    private boolean mutable;

    private static int numObj = 0;

    public static String newObj() {
        //fabrica de nombres o variables, como constates literales, $t0...
        String n = new String("$t"+Integer.toString(numObj));
        numObj++;
        return n;
    }

    public Objeto(String nombre, int bloque, boolean mutable) {
        this.nombre = nombre;
        this.bloque = bloque;
        this.mutable = mutable;
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
    public int compareTo(Objeto o) {
        if(o==null){
            throw new NullPointerException("El objeto comparado no puede ser null");
        }
        //comparar por bloques
        int bloqueComparison = Integer.compare(this.bloque,o.bloque);
        if(bloqueComparison !=0){
            return bloqueComparison;
        }
        //si los bloques son iguales,  comparar por nombre
        if(this.nombre ==null && o.nombre !=null){
            return -1;
        }
        if(this.nombre !=null && o.nombre ==null){
            return 1;
        }
        return this.nombre.compareTo(o.nombre);

    }
}
