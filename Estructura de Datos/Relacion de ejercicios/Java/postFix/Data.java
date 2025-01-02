package postFix;

public class Data extends Item {
    /*
     * La clase Data será subclase de Item y permitirá almacenar un valor entero. Su constructor tomará
        dicho valor. Redefinirá los métodos isData (que devolverá true) y getValue (que devolverá el
        entero que almacena)
     */
    private int value;

    public Data(int value){
        this.value = value;
    }


}
