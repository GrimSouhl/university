{------------------------------------------------------------------------------
 - Student's name:
 -
 - Student's group:
 -----------------------------------------------------------------------------}

module AVL 
  ( 
    Weight
  , Capacity
  , AVL (..)
  , Bin
  , emptyBin
  , remainingCapacity
  , addObject
  , maxRemainingCapacity
  , height
  , nodeWithHeight
  , node
  , rotateLeft
  , addNewBin
  , addFirst
  , addAll
  , toList
  , linearBinPacking
  , seqToList
  , addAllFold
  ) where

type Capacity = Int
type Weight= Int

data Bin = B Capacity [Weight] 

data AVL = Empty | Node Bin Int Capacity AVL AVL deriving Show

--) (0,5 puntos) Define las siguientes funciones auxiliares: 

--A- emptyBin que dada una capacidad devuelve un cubo vacío con tal capacidad 
emptyBin :: Capacity -> Bin
emptyBin capacity = B capacity []

--B- remainingCapacity que dado un cubo devuelve su capacidad restante 

remainingCapacity :: Bin -> Capacity
remainingCapacity (B capacidad weigh) = capacidad - sum weigh

--C- addObject que dados un cubo y un objeto lo añade al cubo; si el objeto no cabe en el cubo 
--señala un error 
addObject :: Weight -> Bin -> Bin
addObject obj (B capacidad weigh) = 
    if obj <= (capacidad - sum weigh) then (B capacidad (obj:weigh))
    else error "El objeto no cabe en el cubo"


--D maxRemainingCapacity que dado un AVL devuelva su capacidad restante máxima 

maxRemainingCapacity :: AVL -> Capacity
maxRemainingCapacity Empty = 0
maxRemainingCapacity (Node bin _ _ left right)
    = max (remainingCapacity bin) (max(maxRemainingCapacity left) (maxRemainingCapacity right))

--E- height que dado un AVL devuelve su altura

height :: AVL -> Int
height Empty = 0
height (Node bin heigh _ _ _) = heigh 

--b) (0,5 puntos) Define una función nodeWithHeight que tome un cubo, una altura, un AVL (hijo 
--izquierdo) y otro AVL (hijo derecho) y que devuelva un AVL con dicha información, calculando su 
--capacidad restante máxima.
 
nodeWithHeight :: Bin -> Int -> AVL -> AVL -> AVL
nodeWithHeight bin h left right =
  let maxCap = maximum [remainingCapacity bin, maxRemainingCapacity left, maxRemainingCapacity right]
  in Node bin h maxCap left right

--c) (0,5 puntos) Define una función node que tome un cubo, un AVL (hijo izquierdo) y otro AVL (hijo 
---derecho) y que devuelva un AVL con dicha información, calculando su capacidad restante máxima 
--y la correspondiente altura.

node :: Bin -> AVL -> AVL -> AVL
node bin left right = 
  let h= 1+max (height left) (height right)
  in nodeWithHeight bin h left right

--d) (1 punto) Define una función rotateLeft que tome un cubo c, un AVL (hijo izquierdo) L y otro 
--AVL no vacío (hijo derecho) R y que devuelva un AVL creado con dicha información tras aplicar, 
--además, una rotación simple a la izquierda tal como se ve en la siguiente figura (dado que el árbol R 
--no está vacío, se muestran su raíz, x, y sus hijos R1 y R2):

rotateLeft :: Bin -> AVL -> AVL -> AVL
rotateLeft c left (Node x hx mx leftR rightR)=
  let newLeft = node c left leftR
  in node x newLeft rightR
rotatreLeft _ _ Empty = error "El árbol derecho no puede ser vacío"

--e) (1,5 puntos) Define una función addNewBin que tome un cubo y un árbol AVL y que añada un 
--nuevo nodo con dicho cubo al final de la espina derecha del AVL. Para mantener el invariante de los 
--árboles AVL, en cada nodo de la espina derecha, si la altura resultante del hijo derecho es más de una 
--unidad superior a la del hijo izquierdo, habrá que aplicar una rotación simple a la izquierda. 

addNewBin :: Bin -> AVL -> AVL
addNewBin bin Empty = node bin Empty Empty
addNewBin bin (Node root h maxcap left right)=
  let newRight = addNewBin bin right
  in if height newRight > height left + 1
    then rotateLeft root left newRight
    else node root left newRight
 
--f) (2.0 puntos) Define una función addFirst que tome la capacidad de los cubos del problema (W), 
--el peso de un objeto a añadir y un AVL y que añada dicho objeto al primer cubo que pueda albergarlo 
--o añada un nuevo cubo al final de la espina derecha si el nuevo objeto no cabe en ningún cubo. El 
--algoritmo será el siguiente: 
-- Si el AVL está vacío o no cabe en ningún cubo, se añadirá un nuevo nodo con un cubo con el 
--objeto al final de la espina derecha. 
-- En otro caso, si la capacidad restante máxima del hijo izquierdo es mayor o igual al peso del 
--objeto, se añadirá el objeto al primer cubo posible del hijo izquierdo. 
-- En otro caso, si la capacidad restante del cubo en el nodo raíz es mayor o igual al peso del 
--objeto, se añadirá el objeto al cubo en la raíz. 
-- En otro caso, se añadirá el objeto al primer cubo posible del hijo derecho. 

addFirst :: Capacity -> Weight -> AVL -> AVL
addFirst w obj Empty = addNewBin (addObject obj (emptyBin w)) Empty
addFirst w obj (Node bin h maxcap left right) 
  | obj <= maxRemainingCapacity left = node bin (addFirst w obj left) right
  | obj <= remainingCapacity bin = node (addObject obj bin) left right
  | otherwise = node bin left (addFirst w obj right)

--g) (0,75 puntos) Define una función addAll que tome el valor de la capacidad máxima de los cubos 
--(W), una lista de pesos de objetos y que construya un AVL con cubos que contenga todos los objetos 
--de la lista, según se ha descrito anteriormente. 

addAll:: Capacity -> [Weight] -> AVL
addAll w = foldl ( flip (addFirst w)) Empty

--h) (0,75 puntos) Define una función toList que tome un AVL y devuelva una lista de cubos con su 
--recorrido en en-orden.

toList :: AVL -> [Bin]
toList Empty = []
toList (Node bin _ _ left right) =
  toList left ++ [bin] ++ toList right

{-
	SOLO PARA ALUMNOS SIN EVALUACION CONTINUA
  ONLY FOR STUDENTS WITHOUT CONTINUOUS ASSESSMENT
 -}

data Sequence = SEmpty | SNode Bin Sequence deriving Show  

linearBinPacking:: Capacity -> [Weight] -> Sequence
linearBinPacking _ _ = undefined

seqToList:: Sequence -> [Bin]
seqToList _ = undefined

addAllFold:: [Weight] -> Capacity -> AVL 
addAllFold _ _ = undefined



{- No modificar. Do not edit -}

objects :: Bin -> [Weight]
objects (B _ os) = reverse os

  
instance Show Bin where
  show b@(B c os) = "Bin("++show c++","++show (objects b)++")"