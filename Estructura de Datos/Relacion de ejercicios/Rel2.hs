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


--------------------------------------------------------------------------------------------------------
--4. Define una función , que compruebe si todos los elementos
--de la lista argumento son distintos. Por ejemplo:







--------------------------------------------------------------------------------------------------------
--5. La función predefinida toma un número natural n y un valor x
--y devuelve una lista con el valor x repetido n veces.

---a) Dado que no es posible volver a definir una función predefinida, define usando listas por
--comprensión una función que se comporte como la función predefinida:



--b) Lee y entiende la siguiente propiedad referente a la función :



--c) Comprueba esta propiedad usando QuickCheck (recuerda importar al principio
--de tu programa).





--------------------------------------------------------------------------------------------------------

--6. Usando una lista por comprensión y una función que compruebe si un entero divide a
--otro, define una función que devuelva la lista de divisores naturales de un número
--natural. Por ejemplo:



--Haz las modificaciones necesarias para obtener una nueva función que devuelva los
--divisores (positivos y negativos) de un número entero:








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



--b) Define y comprueba, usando QuickCheck, la siguiente propiedad:
--para x,y,z enteros, con x≠0, y≠0, z≠0, se verifica mcd(z*x, z*y) = |z| mcd(x,y)


--c) A partir de la siguiente propiedad que relaciona el mcd con el mcm (mínimo común múltiplo) de dos
--números
--mcd x y ∙ mcm x y = x ∙ y
---scribe una función que calcule el mcm de dos números. Por ejemplo:
--N--ota: el algoritmo de Euclides para el cálculo del mcd es más eficiente que el que has desarrollado
---e-n este ejercicio.



--------------------------------------------------------------------------------------------------------
--8. Un número natural p es primo si tiene exactamente dos divisores positivos distintos: 1 y p; por
--tanto, 1 no es un número primo.

--a) Define una función para comprobar si un número es primo. Por ejemplo:
