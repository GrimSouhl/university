module SUT (suma) where

suma :: Num a => [a] -> a
suma []     = 0
suma (x:xs) = x +  suma xs
