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
node bin left right = nodeWithHeight bin (1 + max (height left) (height right)) left right

rotateLeft :: Bin -> AVL -> AVL -> AVL
rotateLeft _ _ _ = undefined

addNewBin :: Bin -> AVL -> AVL
addNewBin _ _ = undefined
 
addFirst :: Capacity -> Weight -> AVL -> AVL
addFirst _ _ _ = undefined

addAll:: Capacity -> [Weight] -> AVL
addAll _ _ = undefined

toList :: AVL -> [Bin]
toList _ = undefined

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