package postFix;

import java.util.Stack;

public class PostFix {
    /*
     * Escribe un programa PostFix que incluya una función de clase, static int evaluate(Item[]
        exprList) que toma un array de Items que representa una expresión posfija y la evalúa. Una
        expresión ejemplo puede ser:
        Item [] sample = {
                            new Data(5),
                            new Data(6),
                            new Data(2),
                            new Dif(),
                            new Data(3),
                            new Mul(),
                            new Add() };
     */

     public static int evaluate(Item[] exprList){
            Stack stack= new Stack();
            
            for(int i=0; i<exprList.length;i++){
                if(exprList[i].isData()){
                    stack.push(exprList[i]);
                }else{
                    Operation op = (Operation) exprList[i];
                    int a2 = ((Data) stack.pop()).getValue();
                    int a1 = ((Data) stack.pop()).getValue();
                    stack.push(new Data(op.evaluate(a1,a2)));
                }
            }
        return ((Data) stack.pop()).getValue(); 
     }
}
