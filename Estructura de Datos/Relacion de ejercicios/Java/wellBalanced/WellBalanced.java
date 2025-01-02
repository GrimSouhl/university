/*. 
2.-Java. Escribe un programa Java que tome como argumento una cadena de caracteres y que escriba
por pantalla si ésta está equilibrada (usa el algoritmo descrito en el problema anterior) 
*/

package wellBalanced;
import dataStructures.stack.*;
public class WellBalanced {
private final static String OPEN_PARENTHESES ="{[(";
private final static String CLOSED_PARENTHESES = "}])";
public static void main(String [] args) {

    Stack<Character> stack = new ArrayStack<>();
    String exp = args[0];
    if(wellBalanced(exp, stack)){
        System.out.println("La expresión está equilibrada");
    }else{
        System.out.println("La expresión NO está equilibrada");
    }

}
public static boolean wellBalanced(String exp, Stack<Character> stack) {
    boolean bool = true;
    for(int i=0; i<exp.length();i++){
        char c = exp.charAt(i);
        if(isOpenParentheses(c)){
            stack.push(c);
        }else if( isClosedParentheses(c)){
            if(match(stack.top(), c)){
                stack.pop();
            }else{
                return false;
            }
        }
    } 
    if(!stack.isEmpty()){
        bool = false;
    }

    return bool;
}
public static boolean isOpenParentheses(char c) {
return OPEN_PARENTHESES.indexOf(new Character(c).toString()) >= 0;
}
public static boolean isClosedParentheses(char c) {
 return CLOSED_PARENTHESES.indexOf(new Character(c).toString()) >= 0;
}
public static boolean match(char x, char y) {
 return OPEN_PARENTHESES.indexOf(new Character(x).toString()) ==
CLOSED_PARENTHESES.indexOf(new Character(y).toString());
}
}