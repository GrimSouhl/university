module  DataStructures.Set.LinearSet(
    Set,
    empty,
    isEmpty,
    insert,
    member,
    remove,
    union,
    fold,
    size,
    toList
) where

-- Definición del tipo de dato `Set`
newtype Set a = LinearSet [a]
    deriving (Eq, Show)

-- Crea un conjunto vacío
empty :: Set a
empty = LinearSet []

-- Verifica si un conjunto está vacío
isEmpty :: Set a -> Bool
isEmpty (LinearSet xs) = null xs

-- Inserta un elemento en el conjunto si no está ya presente
insert :: (Eq a) => a -> Set a -> Set a
insert x (LinearSet xs)
    | x `elem` xs = LinearSet xs
    | otherwise   = LinearSet (x:xs)

-- Verifica si un elemento pertenece al conjunto
member :: (Eq a) => a -> Set a -> Bool
member x (LinearSet xs) = x `elem` xs

-- Elimina un elemento del conjunto
remove :: (Eq a) => a -> Set a -> Set a
remove x (LinearSet xs) = LinearSet (filter (/= x) xs)

-- Une dos conjuntos
union :: (Eq a) => Set a -> Set a -> Set a
union (LinearSet xs) (LinearSet ys) = LinearSet (xs ++ filter (`notElem` xs) ys)

-- Aplica una función de plegado sobre los elementos del conjunto
fold :: (a -> b -> b) -> b -> Set a -> b
fold f acc (LinearSet xs) = foldr f acc xs

-- Devuelve el número de elementos en el conjunto
size :: Set a -> Int
size (LinearSet xs) = length xs

toList :: Set a -> [a]
toList (LinearSet xs) = xs
