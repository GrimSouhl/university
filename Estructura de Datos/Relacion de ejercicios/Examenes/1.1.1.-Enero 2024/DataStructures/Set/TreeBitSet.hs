--Student's name:
--Student's group: 
--Identity number (DNI if Spanish/passport if Erasmus):

module DataStructures.Set.TreeBitSet (
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
makeTree :: Int -> Tree
makeTree capacidad 
--si la capacidad no es válida lanzamos un error
    | not (isValidCapacity capacidad) = error "Capacidad No válida"
--si la capacidad no supera la de un nodo, creamos un nodo con los bits a cero
    | capacidad <= bitsPerLeaf = Leaf 0 
--si supera la de un nodo, creamos un nodo con dos subarboles repartiendo la mitad de la cap
    |otherwise = Node (makeTree mitad) (makeTree mitad)
      where
        mitad =  div capacidad 2


-- | Función para crear un TreeBitSet vacío con la capacidad dada
--data TreeBitSet = TBS Int Tree
empty :: Int -> TreeBitSet
empty capacidad
    | not (isValidCapacity capacidad) = error "capacidad no valida"
    | otherwise = TBS capacidad (makeTree capacidad)

-- | Función para obtener el tamaño de un TreeBitSet
size :: TreeBitSet -> Int
size (TBS cap arbol) = treesize arbol 
  where 
    --hoja
    treesize (Leaf b) = IntBits.countOnes b --contamos los bits 1
    --arbol
    treesize (Node left right) = treesize left + treesize right



-- | Función para obtener la capacidad de un TreeBitSet
capacity :: TreeBitSet -> Int
capacity (TBS cap arbol) = cap


-- | Función para verificar si un TreeBitSet está vacío
isEmpty :: TreeBitSet -> Bool
isEmpty tree 
  | size tree == 0 = True
  |otherwise = False


-- | Función para verificar si un elemento está fuera del rango de un TreeBitSet
outOfRange :: TreeBitSet -> Int -> Bool
outOfRange (TBS cap _ ) elem 
--rango:   0<=X<=cap
    | elem < 0 || elem > cap = True
    |otherwise = False


-- | Función para verificar si un elemento está contenido en un TreeBitSet
contains :: Int -> TreeBitSet -> Bool
contains elem tbs@(TBS cap tree)
--si el arbol esta vacio pues nada
  | size tbs == 0 = False
--si el elemento esta fuera de rango pues nada
  | outOfRange tbs elem = False
--otherwise
  |otherwise = checkelem elem tree cap
    where
      --hoja: si es el elemento entonces true
      checkelem elem (Leaf b) cap = IntBits.contains b elem 
      --arbol: miramos si esta en la derecha o izquierda segun su cap
      checkelem elem (Node left right) cap 
          | elem < (mitad cap) = checkelem elem left (mitad cap)
          |otherwise = checkelem (elem - (mitad cap)) right (mitad cap)
            where
              mitad cap = div cap 2



-- | Función para agregar un elemento a un TreeBitSet
add :: Int -> TreeBitSet -> TreeBitSet
--data TreeBitSet = TBS Int Tree deriving Show
add elem tbs@(TBS cap arbol) 
    |outOfRange tbs elem = error "no cabe el elemento" 
    |contains elem tbs = (TBS cap arbol)
    |otherwise= TBS cap (agregar elem cap arbol)
      where
        agregar elem cap (Leaf b) = Leaf (IntBits.insert elem b)
        agregar elem cap (Node left right) 
          |elem < mitad = Node (agregar elem mitad left) right
          |otherwise = Node left (agregar elem mitad right)
            where
              mitad = cap `div` 2



-- | Función para convertir un TreeBitSet a una lista de elementos

toList :: TreeBitSet -> [Int]
toList tbs@(TBS cap tree)
    | isEmpty tbs = []
    | otherwise = treeToList cap tree 
  where 
    treeToList :: Int -> Tree -> [Int]
    treeToList cap (Leaf b) = filter (IntBits.contains b) [0..bitsPerLeaf-1]
    treeToList cap (Node left right) = treeToList mitad left ++ treeToList mitad right
      where
        mitad = cap `div` 2



-- | Función para realizar la unión de dos TreeBitSets
--misma capacidad
union :: TreeBitSet -> TreeBitSet -> TreeBitSet
union (TBS cap1 arbol1) (TBS cap2 arbol2)
  | not (cap1 == cap2) = error "no tienen la misma capacidad"
  |otherwise = TBS cap1 (unedos arbol1 arbol2)
    where
      unedos (Leaf bit1) (Leaf bit2) = Leaf (IntBits.bitwiseOr bit1 bit2)
      unedos (Node left1 right1) (Node left2 right2) = Node ( unedos left1 left2) (unedos right1 right2)



-- | Función para realizar la unión extendida de dos TreeBitSets
extendedUnion :: TreeBitSet-> TreeBitSet-> TreeBitSet
extendedUnion (TBS cap1 tree1) (TBS cap2 tree2) = TBS (max cap1 cap2) (orex tree1 cap1 tree2 cap2)
  where
    orex (Leaf b1) cap1 (Leaf b2) cap2 = Leaf (IntBits.orExtended b1 b2 cap1 cap2)
    orex (Node left1 right1) cap1 (Node left2 right2) cap2 = 
      Node (orex left1 cap1 left2 cap2) (orex right1 cap1 right2 cap2)

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