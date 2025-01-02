module WellBalanced where 
import DataStructures.Stack.LinearStack
import Test.QuickCheck


--1. Haskell. Escribe una función que permita determinar si una cadena de caracteres está bien
--balanceada o equilibrada en lo que se refiere a los paréntesis, corchetes y llaves que contiene. El
--resto de caracteres en la cadena no se tendrán en cuenta. Por ejemplo la cadena
--"v(hg(jij)hags{ss[dd]dd})" está balanceada correctamente pero no así la cadena
---"ff(h([sds)sds]ss)hags".
---Para solucionar este problema, se utilizará una pila, de forma que, cada vez que aparezca un
--signo de apertura en la cadena dada, éste se introducirá en la pila y, cada vez que aparezca un signo
--de cierre en la entrada, se extraerá la cima de la pila, comprobando que éste corresponde con el
--signo de apertura correspondiente. Si al finalizar de recorrer la cadena la pila está vacía entonces la
--expresión estará equilibrada.
wellBalanced :: String -> Bool
wellBalanced xs = wellBalanced' xs s where s = empty

wellBalanced' :: String -> Stack Char -> Bool
wellBalanced' [] s = isEmpty s
wellBalanced' (x:xs) s | isOpen x = wellBalanced' xs (push x s)
                       | isClose x = if isEmpty s  then False 
                                        else if pareja x (top s) then wellBalanced' xs (pop s)
                                        else False
                       | otherwise = wellBalanced' xs s

isOpen :: Char -> Bool
isOpen x | x== '(' || x== '[' || x== '{' = True
         | otherwise = False

isClose :: Char -> Bool
isClose x| x== ')' || x==']' || x=='}' = True
         | otherwise = False

pareja :: Char -> Char -> Bool
pareja x y | x == ')' && y == '(' = True
           | x == ']' && y == '[' = True
           | x == '}' && y == '{' = True
           | otherwise = False