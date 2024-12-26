
import jdk.dynalink.linker.MethodTypeConversionStrategy;

public class Cortocircuito {
    
    public Cortocircuito (int linea, metodo, e1,e2 ){

            super(linea);
            this.e1 = e1;
            this.metodo=metodo;
            this.e2=e2;
    }

    @Override
    public Objeto generarCodigo(){

        Objeto o1 = e1.generarCodigo();

        Etiqueta destino = new Etiqueta( Objeto.newEtiq(), o1.getBloque())

        Objeto r = o1.generarCodigoMetodo( metodo,new Objeto[] {destino});

        Objeto o2 = e2.generar.Codigo();

        r.generarCodigoMetodo(MethodTypeConversionStrategy.CONSTRUCTORCOPIA, new Objeto[]{o2}, );

        destino.generarCodigoMetodo(Metodos.PONERETIQ,null,getLinea());
        return r;
    }

}
