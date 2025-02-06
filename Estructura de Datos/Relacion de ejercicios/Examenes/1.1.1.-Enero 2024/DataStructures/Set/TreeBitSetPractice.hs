--Student's name:
--Student's group: 
--Identity number (DNI if Spanish/passport if Erasmus):

module DataStructures.Set.TreeBitSetPractice (
  TreeBitSet,
  empty,
  size,
  capacity,
  isEmpty,
  contains,
  add,
  toList

  ) where

import Test.QuickCheck
import qualified DataStructures.Set.IntBits as IntBits
import Data.List((\\))


data Tree = Leaf Int | Node Tree Tree deriving Show

data TreeBitSet = TBS Int Tree deriving Show

bitsPerLeaf :: Int
bitsPerLeaf = 64

-- returns true if capacity is 64 * 2^n for some n >= 0
isValidCapacity :: Int -> Bool
isValidCapacity capacity
  | capacity <= 0           = False
  | capacity == bitsPerLeaf = True
  | m == 0                  = isValidCapacity half
  | otherwise               = False
  where
    (half, m) = divMod capacity 2

-- =================================================================

-- | Función para crear un árbol con la capacidad dada
--(1 punto) Implementa la función makeTree, que toma un Int correspondiente a 
--una capacidad válida (64 ⋅ 2n para algún n ≥ 0), y devuelve un Tree de conjuntos 
--de bits con esa capacidad. La función debe crear un árbol perfecto para dicha 
--capacidad, donde todos los conjuntos de bits sean 0. La función debe usar un 
--algoritmo recursivo, que crea una Leaf con conjunto de bits 0 si la capacidad es 
--menor o igual que bitsPerLeaf, o un Node con dos subárboles de la mitad de la 
--capacidad en caso contrario. 
makeTree :: Int -> Tree
makeTree cap
    | cap > bitsPerLeaf = Node (makeTree mitad) (makeTree mitad)
    | otherwise = Leaf 0 
      where 
        mitad = cap `div` 2

-- | Función para crear un TreeBitSet vacío con la capacidad dada
--data TreeBitSet = TBS Int Tree
--(0.25 puntos) Se proporciona ya implementada con los códigos, la 
--función isValidCapacity, que toma un Int como la capacidad de un TreeBitSet y 
--devuelve True si dicha capacidad es 64 ⋅ 2n para algún n ≥ 0, y False en caso 
--contrario. Usando esta función, implementa la función empty, que toma 
--un Int como la capacidad de un TreeBitSet y devuelve un TreeBitSet vacío con 
--esa capacidad. La función debe comprobar si la capacidad es positiva y válida, y 
--usar la función makeTree para crear el árbol de conjuntos de bits. Si la capacidad 
--es negativa o inválida, la función debe lanzar un error con el mensaje “capacity 
--must be positive” o “capacity must be 64 multiplied by a power of 2” 
--respectivamente. 
empty :: Int -> TreeBitSet
empty cap
    | isValidCapacity cap = TBS cap (makeTree cap)
    | cap < 0 = error "apacity must be positive"
    | otherwise = error "capacity must be 64 multiplied by a power of 2"

-- | Función para obtener el tamaño de un TreeBitSet
--(1.25 puntos) Implementa la función size, que toma un TreeBitSet y devuelve 
--el número total de elementos almacenados en el conjunto. La función debe usar 
--una función auxiliar que toma un Tree y devuelve el número total de bits que 
--están puestos a 1 en las hojas del árbol. La función auxiliar puede contar el 
--número de bits que están puestos a 1 en el conjunto de bits de una hoja usando 
--la función IntBits.countOnes. 
--Node Tree Tree 
size :: TreeBitSet -> Int
size (TBS cap tree) = contar tree
  where
    contar (Leaf l) = (IntBits.countOnes l)
    contar (Node left right) = contar left + contar right


-- | Función para obtener la capacidad de un TreeBitSet
--(0.25 puntos) Implementa la función capacity, que toma un TreeBitSet y 
--devuelve la capacidad del conjunto. La función debe simplemente devolver el 
--primer componente del valor TreeBitSet. 
capacity :: TreeBitSet -> Int
capacity (TBS cap tree) = cap

-- | Función para verificar si un TreeBitSet está vacío
--(0.25 puntos) Implementa la función isEmpty, que toma un TreeBitSet y 
--devuelve True si el conjunto está vacío, y False en caso contrario. 
isEmpty :: TreeBitSet -> Bool
isEmpty tb@(TBS cap tree) 
  | size tb == 0 = True 
  |otherwise = False
 

-- | Función para verificar si un elemento está fuera del rango de un TreeBitSet
--(0.25 puntos) Implementa la función outOfRange, que toma un TreeBitSet y 
--un Int como un elemento, y devuelve True si el elemento está fuera del rango del 
--conjunto, y False en caso contrario. La función debe comprobar si el elemento es 
--negativo o mayor o igual que la capacidad del conjunto. 
--data Tree = Leaf Int | Node Tree Tree deriving Show
--data TreeBitSet = TBS Int Tree deriving Show
outOfRange :: TreeBitSet -> Int -> Bool
outOfRange (TBS cap tree) elem 
    | elem > cap || elem < 0  = True
    |otherwise = False 


-- | Función para verificar si un elemento está contenido en un TreeBitSet
--(1.25 puntos) Implementa la función contains, que toma un Int como un 
--elemento y un TreeBitSet como un conjunto, y devuelve True si el conjunto 
--contiene el elemento, y False en cualquier otro caso. Si el elemento está dentro 
--de la capacidad del conjunto, la función debe debe usar una función auxiliar que 
--toma un Tree, un Int como un elemento, y un Int como la capacidad del árbol, y 
--devuelve True si el árbol contiene el elemento, y False en caso contrario. La 
--función auxiliar debe recorrer el subárbol izquierdo o derecho dependiendo de la 
--posición del elemento en el rango. Una vez que se llega a una hoja, la función 
--debe usar la función IntBits.contains para comprobar si el bit correspondiente al 
--elemento está puesto en el conjunto de bits. 
contains :: Int -> TreeBitSet -> Bool
contains elem t@(TBS cap tree)
    | outOfRange t elem = False
    | otherwise = esta elem cap tree 


esta :: Int -> Int -> Tree -> Bool 
esta elem cap (Leaf l) = IntBits.contains elem l
esta elem cap (Node left right)
    | elem > mitad = esta elem mitad right   
    | otherwise = esta elem mitad left
      where 
        mitad = cap `div` 2



-- | Función para agregar un elemento a un TreeBitSet
--(1.25 puntos) Implementa la función add, que toma un Int como un elemento y 
--un TreeBitSet como un conjunto, y devuelve un nuevo TreeBitSet obtenido 
--después de agregar el nuevo elemento al conjunto de bits en árbol proporcionado. 
---La función debe comprobar si el elemento proporcionado está fuera del rango del 
--conjunto y lanzar un error con el mensaje “element is out of range” si ese es el 
---caso. De lo contrario, la función debe usar una función auxiliar recursiva que toma 
--un Tree, un Int como un elemento, y un Int como la capacidad del árbol, y 
--devuelve el nuevo Tree. La función auxiliar debe recorrer el subárbol izquierdo o 
--derecho dependiendo de la posición del elemento en el rango. Una vez que se 
--llega a una hoja, la función debe usar la función IntBits.set para poner a 1 el bit 
--correspondiente al elemento en el conjunto de bits. 
add :: Int -> TreeBitSet -> TreeBitSet
--data TreeBitSet = TBS Int Tree deriving Show
add elem t@(TBS cap tree) 
    | outOfRange t elem = error "fuera de rango"
    | contains elem t = t
    | otherwise = (TBS cap (metercoso cap elem tree)) 

metercoso :: Int -> Int -> Tree -> Tree
metercoso cap elem (Leaf l) = (Leaf (IntBits.set l elem))
metercoso cap elem (Node left right)
    | cap < mitad = metercoso mitad elem left
    | otherwise = metercoso mitad elem right
      where
        mitad = cap `div` 2

-- | Función para convertir un TreeBitSet a una lista de elementos
--(1.25 puntos) Implementa la función toList que toma un TreeBitSet y devuelve 
--una lista con los elementos en el conjunto. La función debe usar una función 
--auxiliar recursiva que toma un Tree y un Int como la capacidad del árbol, y 
--devuelve una lista con los elementos en el árbol. La función auxiliar debe recorrer 
--los subárboles izquierdo y derecho. Una vez que se llega a una hoja, la función 
--debe usar la función IntBits.contains para obtener una lista con los elementos en 
--el conjunto de bits.

toList :: TreeBitSet -> [Int]
toList t@(TBS cap tree)
    | isEmpty t  = []
    | otherwise = lista cap tree 

lista :: Int -> Tree -> [Int]
lista cap (Leaf l) = filter (IntBits.contains l) [0..bitsPerLeaf-1] 
lista cap (Node left right) = (lista mitad left) ++ (lista mitad right)
  where 
    mitad = cap `div` 2


-- | Función para realizar la unión de dos TreeBitSets
--misma capacidad
--(1.5 puntos) Implementa la función union, que toma dos TreeBitSets como 
--conjuntos, y devuelve un nuevo TreeBitSet obtenido después de calcular la unión 
--de los dos conjuntos. La función debe comprobar si los dos conjuntos tienen la 
--misma capacidad y lanzar un error con el mensaje “sets have different capacities” 
--si no es así. De lo contrario, la función debe usar una función auxiliar recursiva 
--que toma dos Trees y devuelve el nuevo Tree. La función auxiliar debe recorrer los 
--subárboles izquierdo y derecho. Una vez que se llega a una hoja, la función debe 
--usar la función IntBits.or para calcular la unión de los dos conjuntos de bits. La 
--función debe construir su resultado recorriendo directamente los árboles de los 
--dos conjuntos, y no convirtiendo los conjuntos en listas u otra estructura de datos 
--y luego de vuelta a árboles. 
union :: TreeBitSet -> TreeBitSet -> TreeBitSet
union t1@(TBS cap1 tree1) t2@(TBS cap2 tree2)
    | cap1 /= cap2 = error "sets have different capacities"
    | otherwise = (TBS cap1 (uniriguales tree1 tree2)) 
      where
        uniriguales (Leaf l1) (Leaf l2) = (Leaf (IntBits.bitwiseOr l1 l2))
        uniriguales (Node left1 right1) (Node left2 right2) = (Node (uniriguales left1 left2) (uniriguales right1 right2))


-- | Función para realizar la unión extendida de dos TreeBitSets
-- (1.5 puntos) Implementa la función extendedUnion, que toma dos TreeBitSets 
--como conjuntos, y devuelve un nuevo TreeBitSet obtenido después de calcular la 
--unión de los dos conjuntos. La función debe ser capaz de calcular la unión de 
--ambos conjuntos incluso si sus capacidades son diferentes. La función debe 
--construir su resultado recorriendo directamente los árboles de los dos conjuntos, y 
----no convirtiendo los conjuntos en listas u otra estructura de datos y luego de 
--vuelta a árboles.

extendedUnion :: TreeBitSet-> TreeBitSet-> TreeBitSet
extendedUnion (TBS c1 t1) (TBS c2 t2) 
    | c1 > c2 = (TBS c1 (ordifrees t1 c1 t2 c2))

ordifrees :: Tree -> Int -> Tree -> Int -> Tree
ordifrees (Leaf l1) c1 (Leaf l2) c2 = (Leaf (IntBits.orExtended l1 l2 c1 c2))
ordifrees (Node l1 r1) c1 (Node l2 r2) c2 = ( Node (ordifrees l1 mitad1 l2 mitad2) (ordifrees r1 mitad1 r2 mitad2) )
      where 
         mitad1 = c1 `div` 2
         mitad2 = c2 `div` 2


-- =========================================

instance Arbitrary TreeBitSet where
    arbitrary = do
        exponent <- chooseInt (0, 2)
        let capacity = bitsPerLeaf * 2^exponent
        elements <- listOf (chooseInt (0, capacity-1))
        return (foldr add (empty capacity) elements)
            where
                chooseInt :: (Int, Int ) -> Gen Int 
                chooseInt (x,y) = choose (x,y)        

instance Eq TreeBitSet where
  tbs1 == tbs2 = toInts tbs1 == toInts tbs2
    where
      toInts (TBS _ t) = reverse . dropWhile (==0) . reverse $ toInts' t
      toInts' (Leaf b) = [b]
      toInts' (Node lt rt) = toInts' lt ++ toInts' rt

-- =========================================


validExponent e = e >= 0 && e <= 5

validElement e (TBS c t) = e >= 0 && e < c

-- Axioms for basic set of operations
ax1 e = validExponent e ==> isEmpty emptySet
  where emptySet = empty (64*2^e)

ax2 x s = validElement x s ==> not (isEmpty (add x s))

ax3 e x = validExponent e ==> not (contains x emptySet)
  where emptySet = empty (64*2^e)

ax4 x y s = validElement y s ==> contains x (add y s) == (x==y) || contains x s

ax5 e = validExponent e ==> size emptySet == 0
  where emptySet = empty (64*2^e)

ax6 x s = contains x s  ==> size (add x s) == size s
ax7 x s = validElement x s && not (contains x s) ==> size (add x s) == 1 + size s

ax11 e = validExponent e ==> null (toList emptySet)
  where emptySet = empty (64*2^e)

ax12 x s = contains x s  ==> toList (add x s) == toList s

ax13 x s = validElement x s && not (contains x s) ==> x `elem` xs && (xs \\ [x]) `sameElements` toList s
  where
    xs = toList (add x s)
    sameElements xs ys = null (xs \\ ys) && null (ys \\ xs)


type Elem = Int

setAxioms = do
  quickCheck (ax1 :: Int -> Property)
  quickCheck (ax2 :: Elem -> TreeBitSet -> Property)
  quickCheck (ax3 :: Int -> Elem -> Property)
  quickCheck (ax4 :: Elem -> Elem -> TreeBitSet -> Property)
  quickCheck (ax5 :: Int -> Property)
  quickCheck (ax6 :: Elem -> TreeBitSet -> Property)
  quickCheck (ax7 :: Elem -> TreeBitSet -> Property)
  quickCheck (ax11 :: Int -> Property)
  quickCheck (ax12 :: Elem -> TreeBitSet -> Property)
  quickCheck (ax13 :: Elem -> TreeBitSet -> Property)