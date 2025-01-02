{-# LANGUAGE DeriveFoldable #-}
{-# LANGUAGE DeriveFunctor  #-}

module TwoThreeTree where


data TwoThreeTree a = Empty
                    | Leaf a
                    | Two a (TwoThreeTree a) (TwoThreeTree a)
                    | Three a a (TwoThreeTree a)  (TwoThreeTree a) (TwoThreeTree a)
                   deriving (Show, Functor, Foldable)


tree :: TwoThreeTree Int
tree = Three 1 10
             (Two 2
                  (Leaf 3)
                  (Two 4
                       Empty
                       (Leaf 4)))
             (Three 5 50
                 (Leaf 6)
                 (Leaf 7)
                 (Leaf 8))
             (Two 9
                 (Leaf 10)
                 Empty
             )
