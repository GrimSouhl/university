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


emptyBin :: Capacity -> Bin
emptyBin _ = B 0 []

remainingCapacity :: Bin -> Capacity
remainingCapacity (B cap _) = cap

addObject :: Weight -> Bin -> Bin
addObject obj (B cap obs) = if obj <= cap 
                             then B (cap - obj) (obj:obs)
                             else error "Object too heavy for the bin"

maxRemainingCapacity :: AVL -> Capacity
maxRemainingCapacity Empty = 0
maxRemainingCapacity (Node _ _ cap _ _) = cap

height :: AVL -> Int
height Empty = 0
height (Node _ h _ _ _) = h
 
nodeWithHeight :: Bin -> Int -> AVL -> AVL -> AVL
nodeWithHeight b h left right = Node b h capMax left right
  where
    capMax = maximum [ remainingCapacity b
                     , maxRemainingCapacity left
                     , maxRemainingCapacity right
                     ]


node :: Bin -> AVL -> AVL -> AVL
node b left right = nodeWithHeight b h left right
  where
    h = 1 + max (height left) (height right)

rotateLeft :: Bin -> AVL -> AVL -> AVL
rotateLeft _ _ Empty = error "rotateLeft: right subtree is Empty"
rotateLeft c l (Node x _ _ r1 r2) = node x (node c l r1) r2

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