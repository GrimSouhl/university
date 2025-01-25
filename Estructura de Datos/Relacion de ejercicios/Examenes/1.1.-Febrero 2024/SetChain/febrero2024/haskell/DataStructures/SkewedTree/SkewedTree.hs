-- Student's name:
-- Student's group:
-- Identity number (DNI if Spanish/passport if Erasmus):

module DataStructures.SkewedTree.SkewedTree where

data SimpleBST a = Empty | Node (SimpleBST a) a (SimpleBST a) deriving Show

-- Example 1. A skewed BST
bst1 = Node (Node Empty 30 (Node (Node (Node Empty 20 Empty) 18 Empty) 25 Empty)) 15 Empty

-- Example 2. A non-skewed BST
bst2 = Node (Node Empty 30 (Node (Node (Node Empty 20 Empty) 18 (Node Empty 17 Empty)) 25 Empty)) 15 Empty

-- * Exercise k)
invPreOrder :: SimpleBST a -> [a]
invPreOrder = undefined

-- * Exercise l)
skewed :: (Ord a) => [a] -> Bool
skewed = undefined

{-
  *DataStructures.SkewedTree.SkewedTree> invPreOrder bst1
  [20,18,25,30,15]
  *DataStructures.SkewedTree.SkewedTree> invPreOrder bst2
  [17,20,18,25,30,15]
  *DataStructures.SkewedTree.SkewedTree> skewed (invPreOrder bst1)
  True
  *DataStructures.SkewedTree.SkewedTree> skewed (invPreOrder bst2)
  False
-}
