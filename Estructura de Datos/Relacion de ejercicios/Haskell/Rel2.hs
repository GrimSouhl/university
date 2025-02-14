import Test.QuickCheck
import Data.List 

--1. Consideremos la declaración
--a) Utilizando la función f que devuelve un nº natural distinto para valor del tipo, define
--directamente una versión alternativa de la relación de orden , y llámala
--Prueba que las dos relaciones de orden son iguales a través de QuickCheck, y la propiedad:

data Direction = North | South | East | West 
                deriving (Eq,  Enum, Show)

(<<) :: Direction -> Direction -> Bool
x << y = fromEnum x <= fromEnum y

prop_orden_equivalente :: Direction -> Direction -> Bool
prop_orden_equivalente x y = (x << y) == (fromEnum x <= fromEnum y)



--b) Elimina la clase en la cláusula de la declaración , y trata de definir
--una instancia de Ord “manualmente” definiendo el operador (<=) a través de la relación anterior
--(<<).

instance Ord Direction where
    a <= b = a << b


prop_orden_manual :: Direction -> Direction -> Bool
prop_orden_manual a b = (a <= b) == (fromEnum a <= fromEnum b)

--------------------------------------------------------------------------------------------------------
--2. Define una función que devuelva en forma de par el
--máximo de una lista y los restantes elementos. Considera dos casos:
--a) El orden en que aparecen los restantes puede ser arbitrario:

maximoYrestoArb :: Ord a => [a] -> (a, [a])
maximoYrestoArb [] = error "Lista vacia"
maximoYrestoArb xs = (maximum xs , delete (maximum xs) xs)


--b) Los restantes deben aparecer en el orden original 

maximoYrestoOrd :: Ord a => [a] -> (a, [a])
maximoYrestoOrd [] = error "Lista vacia"
maximoYrestoOrd xs = (maximum xs , sort(delete (maximum xs) xs))


---orden a pelo:
-- Función principal de ordenamiento por inserción
--insertionSort :: Ord a => [a] -> [a]
--insertionSort [] = []  -- Si la lista está vacía, ya está ordenada
--insertionSort (x:xs) = insert x (insertionSort xs)

-- Función auxiliar que inserta un elemento en su lugar adecuado
--insert :: Ord a => a -> [a] -> [a]
--insert x [] = [x]  -- Si la lista está vacía, simplemente devuelve el elemento
--insert x (y:ys)
--  | x <= y    = x : y : ys  -- Si el elemento es menor o igual a y, lo ponemos delante de y
--  | otherwise = y : insert x ys  -- Si no, lo insertamos en el resto de la lista


--------------------------------------------------------------------------------------------------------
--3. Define una función para repartir los elementos de una lista en dos
--sublistas, asignando los elementos en forma alternada a cada una de las listas y en el mismo orden
--que el original

repartir :: [a] -> [a] -> [a] -> ([a], [a])
repartir [] l1 l2 = (l1, l2)  
repartir (x:xs) l1 l2 = switchrepartir xs (l1++[x]) l2
  where
    switchrepartir [] l1 l2 = (l1, l2) 
    switchrepartir (y:ys) l1 l2 = repartir ys l1 (l2++[y])  
    
--------------------------------------------------------------------------------------------------------
--4. Define una función , que compruebe si todos los elementos
--de la lista argumento son distintos. Por ejemplo:

distintos :: Eq a => [a] -> Bool
distintos [] = True
distintos (x:xs)
            | duplicados x xs = False
            |otherwise = distintos xs
            where
                duplicados _ []=False
                duplicados y (z:zs) 
                                | y==z = True
                                | otherwise = duplicados y zs


--------------------------------------------------------------------------------------------------------
--5. La función predefinida toma un número natural n y un valor x
--y devuelve una lista con el valor x repetido n veces.

---a) Dado que no es posible volver a definir una función predefinida, define usando listas por
--comprensión una función que se comporte como la función predefinida:

--replicate' :: Int -> a -> [a]
--replicate' 0 x = [ ]
--replicate' n x = listarep (n-1) x [x]
--            where 
--                listarep 0 y l1 = l1
--                listarep rep y l1 = listarep (rep-1) y (l1++[y])
replicate' :: Int -> a -> [a]
replicate' n x = [x|_ <- [1..n]]

--b) Lee y entiende la siguiente propiedad referente a la función :

p_replicate' n x = n >=0 && n<= 1000 ==> length (filter (==x) xs ) == n && length (filter (/=x) xs) ==0
                where xs = replicate' n x


--c) Comprueba esta propiedad usando QuickCheck (recuerda importar al principio
--de tu programa).

--OK, passed 100 tests; 102 discarded.



--------------------------------------------------------------------------------------------------------

--6. Usando una lista por comprensión y una función que compruebe si un entero divide a
--otro, define una función que devuelva la lista de divisores naturales de un número
--natural. Por ejemplo:

divideA :: Int -> Int -> Bool
divideA n x 
        | (x/=0 )&& ((n `mod` x)== 0) = True
        |otherwise = False

divisores ::  Int -> [Int]
divisores n = [x| x <- [1..abs n], divideA n x ]

--Haz las modificaciones necesarias para obtener una nueva función que devuelva los
--divisores (positivos y negativos) de un número entero:

divisores' ::  Int -> [Int]
divisores' n = [x| x <- [-n..n], divideA n x ]


--------------------------------------------------------------------------------------------------------
--7. El máximo común divisor de dos números x e y, denotado con mcd(x,y), es el máximo del conjunto
--formado por los divisores comunes de x e y. Tal máximo existirá si los números x e y no son
--simultáneamente nulos (de lo contrario, todo número natural es divisor común, y no existe el
--máximo del conjunto de divisores comunes). Según esta definición, para el cálculo del mcd(x,y)
--basta considerar divisores positivos con x e y naturales.


--a) Define, usando una lista por comprensión y la función del ejercicio anterior, una
--función que calcule el máximo común divisor de dos números. Por ejemplo:
--Para ello, tomando de entre los divisores de x, los que también son divisores de y tendrás los
---divisores comunes de x e y, por lo que basta que selecciones el elemento máximo de esta lista a
--través, por ejemplo, de la función predefinida que devuelve el mayor elemento de una lista:


divisoresComunes :: Int -> Int -> Int
divisoresComunes x y 
                  |null [z| z <- divisores x, divideA y z] = 0  
                  |otherwise = maximum [z| z <- divisores x, divideA y z]

--b) Define y comprueba, usando QuickCheck, la siguiente propiedad:
--para x,y,z enteros, con x≠0, y≠0, z≠0, se verifica mcd(z*x, z*y) = |z| mcd(x,y)

p_divisoresComunes x y z = ( x/=0 && y/=0 && z/=0 ) ==> divisoresComunes (z*x) (z*y) == ((abs z) * divisoresComunes x y)
--OK, passed 100 tests; 16 discarded.
 
--c) A partir de la siguiente propiedad que relaciona el mcd con el mcm (mínimo común múltiplo) de dos
--números
--mcd x y ∙ mcm x y = x ∙ y
---scribe una función que calcule el mcm de dos números. Por ejemplo:
--N--ota: el algoritmo de Euclides para el cálculo del mcd es más eficiente que el que has desarrollado
---e-n este ejercicio.

mcm :: Int -> Int -> Int
mcm x y 
      |x==0 || y==0 = 0
      |otherwise= (x*y) `div` (divisoresComunes x y)

--------------------------------------------------------------------------------------------------------
--8. Un número natural p es primo si tiene exactamente dos divisores positivos distintos: 1 y p; por
--tanto, 1 no es un número primo.

--a) Define una función para comprobar si un número es primo. Por ejemplo:

esPrimo :: Int -> Bool
esPrimo n = length (divisores n) == 2

--b) Usando una lista por comprensión, define una función que devuelva una lista
--con todos los números primos menores o iguales a un valor dado. Por ejemplo:

primosHasta :: Int -> [Int]
primosHasta n = [x| x <- [1..n], esPrimo x]


--c) Da otra definición (con nombre ) que use la función predefinida en vez
--de la lista por comprensión.

primosHasta' :: Int -> [Int]
primosHasta' n = filter esPrimo [1..n]



--d) Comprueba que las dos funciones que has definido se comportan del mismo modo,
--comprobando con QuickCheck la siguiente propiedad:
--Nota: existen métodos más eficientes para calcular listas de primos, como la Criba de Eratóstenes.

p1_primos x = primosHasta x == primosHasta' x
--OK, passed 100 tests.


--------------------------------------------------------------------------------------------------------
--9. La conjetura de Goldbach fue formulada por Christian Goldbach en 1742 en una célebre carta a
--Euler. Es uno de los problemas abiertos (no resuelto) más antiguo de las Matemáticas y dice:
--Todo número par mayor que 2 puede escribirse como la suma de dos primos.
--Los dos primos no tienen que ser distintos. La conjetura ha sido comprobada con programas de
--ordenador para todos los pares menores a 1018, pero no ha podido ser demostrada. El objetivo de
--este ejercicio es comprobarla con Haskell.

--a) Usando una lista por comprensión y las funciones del ejercicio anterior, define una función
--que tome como parámetro un entero n y devuelva una lista de tuplas con todos los pares de primos
--que suman n. Por ejemplo:
--(observa que los pares no aparecen duplicados: por ejemplo, el par (29,11) no aparece en la lista
--anterior).

pares :: Int -> [(Int,Int)]
pares n = [(x,y)| x<- primosHasta n, y<- primosHasta n, x+y==n , x<=y]


--b) Define una función que tome como parámetro un entero n y devuelva si n es un
--entero par mayor que 2 y además existe al menos una pareja de primos que sume n. Por ejemplo:
--Para resolver este apartado puedes utilizar la función predefinida , que
--toma una lista y devuelve si es vacía:

goldbach :: Int -> Bool
goldbach n =  n>2 && even n && not(null (pares n))


--c)Para comprobar la conjetura, define una función que tome como parámetro
--un entero n y que devuelva si para todos los números pares mayores que 2 y menores o
--iguales a n se cumple la conjetura. Por ejemplo: 
--Ayuda: usa listas por comprensión y la función predefinida que toma
--una lista de booleanos y devuelve si todos son ciertos.

goldbachHasta :: Int -> Bool
goldbachHasta n = and [ (goldbach x) | x <- [3..n], even x]



--d)Existe una forma más débil de la conjetura, llamada Conjetura débil de Goldbach (CDG): todo impar
--mayor que 5 es suma de tres números primos. Si n es impar >5, entonces n-3 es par >2, y según la
--CG, es suma de dos primos, de donde por ser 3 un primo, n será suma de tres primos; de aquí que
--CG asegure CDG; sin embargo, CDG tampoco ha sido demostrada hasta la fecha. Define una nueva
--función para comprobar esta forma de la conjetura.

goldbachDebilHasta :: Int -> Bool
goldbachDebilHasta n = and [ (goldbach3 x) | x <- [6..n]]
          where
            goldbach3 n =  n>5 && odd n && not(null([(x,y,z)| x<- primosHasta n, y<- primosHasta n,z<- primosHasta n, x+y+z==n , x<=y,y<=z]))


--------------------------------------------------------------------------------------------------------
--10. Los factores propios de un número x son los divisores naturales de x estrictamente menores a x. Un
---número natural es perfecto si coincide con la suma de sus factores propios.
--a) Escribe una función para comprobar si un número es perfecto. Por ejemplo:

esPerfecto :: Int -> Bool
esPerfecto n = n == sum (divisoress n)
            where
              divisoress n = [x| x<-[1..n], n `mod`x==0 , x/=n] 


--b) Escribe otra función que devuelva una lista con los números perfectos menores o iguales a un valor
--dado. Por ejemplo:

perfectosMenoresQue :: Int -> [Int]
perfectosMenoresQue n = [ x | x <- [1..n], esPerfecto x]

--------------------------------------------------------------------------------------------------------
--11. La función predefinida toma un número natural y una lista , y devuelve una lista con los
--primeros elementos de .
--a) Dado que no es posible volver a definir una función predefinida, completa la siguiente definición
--para que la función se comporte como la función predefinida :

--take' :: Int -> [a] -> [a]
--take' 0 _ = []
--take' _ [] = []
--take' n (x:xs)= x: take' (n-1) xs

take' :: Int -> [a] -> [a]
take' n xs = [ x | (p,x) <- zip[0..n-1] xs]

--b) La función predefinida toma un número natural y una lista , y devuelve la lista que se
--obtiene al eliminar los primeros elementos de . Completa la siguiente definición
--para que la función se comporte como la función predefinida :
--Escribe y comprueba con QuickCheck la siguiente propiedad: para cualquier ≥0 y cualquier lista ,
--si concatenamos la lista con la lista , obtenemos la lista original .

--drop' :: Int -> [a] -> [a]
--drop' 0 xs = xs
--drop' _ [] = []
--drop' n (x:xs) = drop' (n-1) xs

drop' :: Int -> [a] -> [a]
drop' n xs = [x | (p,x)<- zip[1..length xs] xs, p>n]



--------------------------------------------------------------------------------------------------------
--12. La función predefinida
--toma una lista de listas y devuelve la lista que se obtiene al concatenar todos sus elementos:
--Dado que no es posible volver a definir una función predefinida, define usando foldr una función
--que se comporte como la predefinida.
--Ayuda: observa que el resultado se puede calcular con la siguiente expresión:
--donde el operador predefinido concatena dos listas.

concat' :: [[a]] -> [a]
concat'  = foldr (++) []



--b) Da ahora una definición alternativa usando listas por comprensión. Usa para ello dos
--generadores; el primero extraerá cada lista de la lista de listas argumento; el segundo extraerá los
--elementos de las listas extraídas por el primer generador.

concat'' :: [[a]] -> [a]
concat'' xss = [x | xs <- xss, x <- xs]


--------------------------------------------------------------------------------------------------------
--13. Las funciones predefinidas and ,tail  y zip han sido explicadas en el tema 2. Analiza y entiende
--qué hace la siguiente función:

desconocida :: (Ord a) => [a] -> Bool
desconocida xs = and [x <= y | (x,y) <- zip xs (tail xs)]
--comprueba si todos sus elementos estan ordenados de forma creciente




--------------------------------------------------------------------------------------------------------
--14. La función predefinida takeWhile :: (a -> Bool) -> [a] -> [a] 
--devuelve el prefijo más largo con los elementos de una lista (2º argumento) que cumplen una
--condición (1er argumento). Por ejemplo:
--ya que el 11 es el primer elemento que no es par. Otro ejemplo de uso es:
--ya que 6 es el primer elemento de la lista mayor o igual a 5. Para los mismos argumentos, la función
--suprime el prefijo que devuelve. Por ejemplo:
--a) Usando estas funciones, define una función que tome un elemento x y una lista xs que ya
--está ordenada ascendentemente (asume que esta precondición se cumple), y que devuelva la lista
--ordenada que se obtiene al insertar x en su posición adecuada dentro de xs. Por ejemplo:

inserta :: Ord a => a -> [a] -> [a]
inserta x xs = takeWhile (<x) xs ++[x] ++ dropWhile (<x) xs

--a)Sin usar ninguna función auxiliar, define directamente y en forma recursiva la función

inserta' :: Ord a => a -> [a] -> [a]
inserta' x [] = [x]
inserta' x (y:ys)
                |x<y = x:y:ys
                |otherwise = y : inserta' x ys


--c) Lee, entiende y comprueba con QuickCheck la siguiente propiedad referente a la función :

p1_inserta x xs = desconocida xs ==> desconocida ( inserta x xs)
--OK, passed 100 tests; 0 discarded.

--d) Podemos utilizar la función que hemos definido para ordenar ascendentemente una lista
---desordenada. Por ejemplo, si quisiéramos ordenar la lista , podríamos hacerlo evaluando
--la expresión:
--Razona por qué funciona este algoritmo para ordenar una lista.

--porque va insertando los elementos en la lista de forma ordenada y la lista resultante es la lista ordenada

--e) Usando la función foldr y la función inserta , define una función ordena que tome una lista de
--valores y la devuelva ordenada. Por ejemplo:

ordena :: Ord a => [a] -> [a]
ordena xs = foldr inserta [] xs
--la funcion inserta coloca el valor que le oasamos en su posicion ordenada, si vamos metiendolos todos uno por uno los colocamos ordenados.

--f)Define y comprueba con QuickCheck la siguiente propiedad:
-- para cualquier lista xs, ordena xs es una lista ordenada.

p_ordena xs = desconocida (ordena xs)
--OK, passed 100 tests; 0 discarded.
