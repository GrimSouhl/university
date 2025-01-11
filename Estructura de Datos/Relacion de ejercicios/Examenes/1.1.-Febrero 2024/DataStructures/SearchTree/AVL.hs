module DataStructures.SearchTree.AVL
  ( AVL
  , empty
  , isEmpty
  , size
  , insert
  , updateOrInsert    -- <-- necesitamos exportar esto
  , delete
  , search
  , inOrder
  , foldInOrder
  ) where



-- Definición del tipo AVL
data AVL a = Empty
           | Node (AVL a) a (AVL a) Int
           deriving (Show, Eq)

-- Altura de un nodo
height :: AVL a -> Int
height Empty          = 0
height (Node _ _ _ h) = h

-- Calcula el balance de un nodo
balanceFactor :: AVL a -> Int
balanceFactor Empty = 0
balanceFactor (Node left _ right _) = height left - height right

-- Rota a la izquierda
rotateLeft :: AVL a -> AVL a
rotateLeft (Node a p (Node b q c _) _) =
    Node (Node a p b (1 + max (height a) (height b))) q c (1 + max (height b) (height c))
rotateLeft t = t

-- Rota a la derecha
rotateRight :: AVL a -> AVL a
rotateRight (Node (Node a p b _) q c _) =
    Node a p (Node b q c (1 + max (height b) (height c))) (1 + max (height a) (height b))
rotateRight t = t

-- Balancea un árbol AVL
balance :: AVL a -> AVL a
balance t@(Node left p right _)
    | bf > 1 && balanceFactor left >= 0 = rotateRight t
    | bf > 1                            = rotateRight $ Node (rotateLeft left) p right 0
    | bf < -1 && balanceFactor right <= 0 = rotateLeft t
    | bf < -1                            = rotateLeft $ Node left p (rotateRight right) 0
    | otherwise                          = Node left p right (1 + max (height left) (height right))
  where
    bf = balanceFactor t
balance t = t

-- Árbol AVL vacío
empty :: AVL a
empty = Empty

-- Comprueba si un árbol AVL está vacío
isEmpty :: AVL a -> Bool
isEmpty Empty = True
isEmpty _     = False

-- Devuelve el tamaño del árbol AVL
size :: AVL a -> Int
size Empty          = 0
size (Node left _ right _) = 1 + size left + size right

-- Inserta un elemento en el árbol AVL
insert :: (Ord a) => a -> AVL a -> AVL a
insert x Empty = Node Empty x Empty 1
insert x (Node left y right h)
    | x < y     = balance $ Node (insert x left) y right h
    | x > y     = balance $ Node left y (insert x right) h
    | otherwise = Node left x right h

-- Busca un elemento en el árbol AVL
search :: (Ord a) => a -> AVL a -> Maybe a
search _ Empty = Nothing
search x (Node left y right _)
    | x < y     = search x left
    | x > y     = search x right
    | otherwise = Just y

-- Elimina un elemento del árbol AVL
delete :: (Ord a) => a -> AVL a -> AVL a
delete _ Empty = Empty
delete x (Node left y right _)
    | x < y     = balance $ Node (delete x left) y right 0
    | x > y     = balance $ Node left y (delete x right) 0
    | isEmpty left = right
    | isEmpty right = left
    | otherwise = balance $ Node left minRight (delete minRight right) 0
  where
    minRight = findMin right


-- updateOrInsert f x avl
--   f  : cómo actualizar un nodo si ya existe
--   x  : qué valor insertar si no existe
updateOrInsert :: (Ord a) => (a -> a) -> a -> AVL a -> AVL a
updateOrInsert f x Empty =
    -- Si el árbol está vacío, simplemente insertamos x
    Node Empty x Empty 1

updateOrInsert f x (Node left y right h)
    | x < y     = balance (Node (updateOrInsert f x left) y right h)
    | x > y     = balance (Node left y (updateOrInsert f x right) h)
    | otherwise = -- Significa que x == y, así que "actualizamos"
                  Node left (f y) right h


-- Encuentra el valor mínimo de un árbol AVL
findMin :: AVL a -> a
findMin (Node Empty x _ _) = x
findMin (Node left _ _ _)  = findMin left

-- Devuelve los elementos en orden en una lista
inOrder :: AVL a -> [a]
inOrder Empty = []
inOrder (Node left x right _) = inOrder left ++ [x] ++ inOrder right

-- Aplica una función de plegado en orden
foldInOrder :: (a -> b -> b) -> b -> AVL a -> b
foldInOrder _ acc Empty = acc
foldInOrder f acc (Node left x right _) = foldInOrder f (f x (foldInOrder f acc right)) left
