package postFix;

public abstract class Operation extends Item {
    /*
     * La clase Operation será también subclase de Item y abstracta, y debe redefinir el método
        isOperation (que devolverá true).
     */

    public boolean isOperation() {
        return true;
    }
}
