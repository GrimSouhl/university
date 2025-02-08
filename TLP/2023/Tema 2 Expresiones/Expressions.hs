{-

Programming Languages
Fall 2023

Semantics of Expressions

-}

{-
CheckList 

 1:
 - binVal: OK
 - testBinVal: OK
 - foldBin: OK
 - binVal': OK
 - testBinVal': OK
 - normalize: REPASAR
 - normalize: REPASAR
 - testFunctions: -

 2:
 - fvAexp: OK
 - testFvAexp: OK
 - fvBexp: OK
 - testFvBexp: OK

 3:
 - substAexp : REPASAR
 - testSubAexp: OK
 - substBexp : REPASAR
 - testSubBexp: OK

 4:
 - update: REPASAR
 - testUpdate: OK
 - updates: OK
 - testUpdates: OK

 5:
 - foldAexp: OK
 - aVal': -
 - fvAexp': -
 - substAexp': -
 - testFunctions: -
 - foldBexp: REPASAR
 - bVal': -
 - fvBexp': -
 - substBexp': -
 - testFunctions: -

-}


module Expressions where

import           Aexp
import           Bexp
import           State
import Test.HUnit hiding (State)

-- |----------------------------------------------------------------------
-- | Exercise 1 - Semantics of binary numerals
-- |----------------------------------------------------------------------
-- | Given the algebraic data type 'Bin' for the binary numerals:

data Bit = O
         | I
         deriving (Eq, Show)

data Bin = MSB Bit
         | B Bin Bit
         deriving (Eq, Show)

-- | and the following values of type 'Bin':

zero :: Bin
zero = MSB O

one :: Bin
one = MSB I

three :: Bin
three = B (B (MSB O) I) I

six :: Bin
six = B (B (MSB I) I) O

-- | define a semantic function 'binVal' that associates
-- | a number (in the decimal system) to each binary numeral.

binVal :: Bin -> Z
binVal (MSB O) = 0
binVal (MSB I) = 1
binVal (B a O) = (binVal a) * 2
binVal (B a I) = ((binVal a) * 2) + 1

-- | Test your function with HUnit.

testBinVal :: Test
testBinVal = test ["value of zero"  ~: 0 ~=? binVal zero,
                   "value of one"   ~: 1 ~=? binVal one,
                   "value of three" ~: 3 ~=? binVal three,
                   "value of six"   ~: 6 ~=? binVal six]

-- | Define a function 'foldBin' to fold a value of type 'Bin'

foldBin :: (Bit -> b -> b) -> b -> Bin -> b
foldBin f acc (MSB bit) = f bit acc
foldBin f acc (B bin bit) = f bit (foldBin f acc bin)


-- | and use 'foldBin' to define a function 'binVal''  equivalent to 'binVal'.

binVal' :: Bin -> Integer
binVal' = foldBin (\x acc -> if x == O then acc*2 else acc*2 + 1) 0

-- | Test your function with HUnit.

testBinVal' :: Test
testBinVal' = test ["value of zero"  ~: 0 ~=? binVal' zero,
                   "value of one"   ~: 1 ~=? binVal' one,
                   "value of three" ~: 3 ~=? binVal' three,
                   "value of six"   ~: 6 ~=? binVal' six]

-- | Define a function 'normalize' that given a binary numeral trims leading zeroes.

normalize :: Bin -> Bin
normalize (MSB x) = MSB x
normalize (B bin x) = 
    let trimmed = normalize bin
    in case trimmed of
             MSB O -> MSB x
             _     -> B trimmed x

-- | and use 'foldBin' to define a function 'normalize''  equivalent to 'normalize'.

normalize' :: Bin -> Bin
normalize' = foldBin (\bit acc -> case acc of
                                        MSB O -> MSB bit
                                        _     -> B acc bit) (MSB O)



-- | Test your functions with HUnit.

-- todo

-- |----------------------------------------------------------------------
-- | Exercise 2 - Free variables of expressions
-- |----------------------------------------------------------------------
-- | Define the function 'fvAexp' that computes the set of free variables
-- | occurring in an arithmetic expression. Ensure that each free variable
-- | occurs once in the resulting list.
listMix:: Eq a => [a] -> [a] -> [a]
listMix x y 
        | x == [] || y == [] = x ++ y
        | elem (head x) y = listMix xs y
        | otherwise = listMix xs ((head x):y)
        where
            xs = tail x

fvAexp :: Aexp -> [Var]
fvAexp (N _) = []
fvAexp (V x) = [x]
fvAexp (Add x y) = listMix (fvAexp x) (fvAexp y)
fvAexp (Sub x y) = listMix (fvAexp x) (fvAexp y)
fvAexp (Mult x y) = listMix (fvAexp x) (fvAexp y)


-- | Test your function with HUnit.

testfvAexp :: Test
testfvAexp = test ["Num lit"  ~: [] ~=? fvAexp (N "4"),
                   "One var"   ~: ["x"] ~=? fvAexp (V "x"),
                   "Two var repeated"   ~: ["x"] ~=? fvAexp (Add (V "x") (V "x")),
                   "Exp with two var" ~: ["x","y"] ~=? fvAexp (Add (V "x") (V "y")),
                   "Exp whit var and lit"   ~: ["x"] ~=? fvAexp (Sub (V "x") (N "4")),
                   "Multiple exp whit var and lit"   ~: ["x", "y", "z"] ~=? fvAexp (Mult (Add (V "x") (N "4")) (Sub (V "y") (V "z")))]

-- | Define the function 'fvBexp' that computes the set of free variables
-- | occurring in a Boolean expression.

fvBexp :: Bexp -> [Var]
fvBexp (Equ x y) = listMix (fvAexp x) (fvAexp y)
fvBexp (Leq x y) = listMix (fvAexp x) (fvAexp y)
fvBexp (Neg x) = fvBexp x
fvBexp (And x y) = listMix (fvBexp x) (fvBexp y)
fvBexp x = []

-- | Test your function with HUnit.

testfvBexp :: Test
testfvBexp = test ["Lit"  ~: [] ~=? fvBexp (TRUE),
                   "Lit"  ~: [] ~=? fvBexp (FALSE),
                   "Equ"  ~: ["x", "y"] ~=? fvBexp (Equ (V "x") (V "y")),
                   "Leq"  ~: ["x","y"] ~=? fvBexp (Leq (V "x") (V "y")),
                   "Neg"  ~: ["x","y"] ~=? fvBexp (Neg (Leq (V "x") (V "y"))),
                   "Leq"  ~: ["x","y"] ~=? fvBexp (And (Leq (V "x") (V "y")) (Equ (V "x") (V "y")))]

-- |----------------------------------------------------------------------
-- | Exercise 3 - Substitution of variables in expressions
-- |----------------------------------------------------------------------
-- | Given the algebraic data type 'Subst' for representing substitutions:

data Subst = Var :->: Aexp

-- | define a function 'substAexp' that takes an arithmetic expression
-- | 'a' and a substitution 'y:->:a0' and returns the substitution a [y:->:a0];
-- | i.e., replaces every occurrence of 'y' in 'a' by 'a0'.

substAexp :: Aexp -> Subst -> Aexp
substAexp (N x) _ = N x
substAexp (V x) (y :->: a0) = if x == y then a0 else V x
substAexp (Add x y) a = Add (substAexp x a) (substAexp y a)
substAexp (Sub x y) a = Sub (substAexp x a) (substAexp y a)
substAexp (Mult x y) a = Mult (substAexp x a) (substAexp y a)

-- | Test your function with HUnit.

testSubAexp :: Test
testSubAexp = test ["Lit" ~: (N "4") ~=? substAexp (N "4") ("x" :->: (N "4")),
                    "Var" ~: (N "4") ~=? substAexp (V "x") ("x" :->: (N "4")),
                    "Add" ~: (Add (V "z") (Add (V "z") (V "y"))) ~=? substAexp (Add (V "x") (Add (V "x") (V "y"))) ("x" :->: (V "z")),
                    "Sub" ~: (Sub (V "z") (Sub (V "z") (V "y"))) ~=? substAexp (Sub (V "x") (Sub (V "x") (V "y"))) ("x" :->: (V "z")),
                    "Mult" ~: (Mult (V "z") (Mult (V "z") (V "y"))) ~=? substAexp (Mult (V "x") (Mult (V "x") (V "y"))) ("x" :->: (V "z"))]

-- | Define a function 'substBexp' that implements substitution for
-- | Boolean expressions.

substBexp :: Bexp -> Subst -> Bexp
substBexp (Neg x) a = Neg (substBexp x a)
substBexp (Equ x y) a = Equ (substAexp x a) (substAexp y a)
substBexp (Leq x y) a = Leq (substAexp x a) (substAexp y a)
substBexp (And x y) a = And (substBexp x a) (substBexp y a)
substBexp (a) _ = a

-- | Test your function with HUnit.

testSubBexp :: Test
testSubBexp = test ["Lit" ~: (TRUE) ~=? substBexp (TRUE) ("x" :->: (N "4")),
                    "Neg" ~: (Neg (Equ (V "z") (N "4"))) ~=? substBexp (Neg (Equ (V "z") (N "4"))) ("x" :->: (N "z")),
                    "Equ" ~: (Equ (V "z") (Add (V "z") (V "y"))) ~=? substBexp (Equ (V "x") (Add (V "x") (V "y"))) ("x" :->: (V "z")),
                    "Sub" ~: (Leq (V "z") (Sub (V "z") (V "y"))) ~=? substBexp (Leq (V "x") (Sub (V "x") (V "y"))) ("x" :->: (V "z")),
                    "Mult" ~: (And (Equ (V "z") (V "y")) (Equ (V "z") (V "y"))) ~=? substBexp (And (Equ (V "z") (V "y")) (Equ (V "x") (V "y"))) ("x" :->: (V "z"))]


-- |----------------------------------------------------------------------
-- | Exercise 4 - Update of state
-- |----------------------------------------------------------------------
-- | Given the algebraic data type 'Update' for state updates:

data Update = Var :=>: Z

-- | define a function 'update' that takes a state 's' and an update 'x :=> v'
-- | and returns the updated state 's [x :=> v]'

update :: State -> Update -> State
update s (x :=>: v) = \y -> if y == x then v else s y

-- | Test your function with HUnit.

testUpdate :: Test
testUpdate = test ["update x" ~: 1 ~=? (update sInit ("x" :=>: 1) "x"),
                   "preserve z" ~: 4 ~=? (update sInit ("x" :=>: 1) "z")]

-- | Define a function 'updates' that takes a state 's' and a list of updates
-- | 'us' and returns the updated states resulting from applying the updates
-- | in 'us' from head to tail. For example:
-- |
-- |    updates s ["x" :=>: 1, "y" :=>: 2, "x" :=>: 3]
-- |
-- | returns a state that binds "x" to 3 (the most recent update for "x").

updates :: State -> [Update] -> State
updates = foldl update

-- | Test your function with HUnit.

testUpdates :: Test
testUpdates = test ["multiple updates" ~: 3 ~=? (updates sInit ["x" :=>: 1, "y" :=>: 2, "x" :=>: 3] "x"),
                    "preserve z" ~: 4 ~=? (updates sInit ["x" :=>: 1, "y" :=>: 2, "x" :=>: 3] "z")]

-- |----------------------------------------------------------------------
-- | Exercise 5 - Folding expressions
-- |----------------------------------------------------------------------
-- | Define a function 'foldAexp' to fold an arithmetic expression



foldAexp :: (a -> a -> a) -> (a -> a -> a) -> (a -> a -> a) -> (Var -> a)-> (NumLit -> a) -> Aexp -> a
foldAexp suma mult resta var litNum e = plegar e
    where
        plegar (N numero) = litNum numero
        plegar (V variable) = var variable
        plegar (Add e1 e2) = suma (plegar e1) (plegar e2)
        plegar (Mult e1 e2) = mult (plegar e1) (plegar e2)
        plegar (Sub e1 e2) = resta (plegar e1) (plegar e2)

-- | Use 'foldAexp' to define the functions 'aVal'', 'fvAexp'', and 'substAexp''.

--evalua expresiones aritmeticas
aVal' :: Aexp -> State -> Z
aVal' a s = foldAexp (+) (*) (-) s read a

--
fvAexp' :: Aexp -> [Var]
fvAexp' = foldAexp (++) (++) (++) (:[]) (const []) 

substAexp' :: Aexp -> Subst -> Aexp
substAexp' aex (v :->: a) = foldAexp Sub Mult Add (\x -> if x == v then a else V x) N aex

-- | Test your functions with HUnit.

-- todo

-- | Define a function 'foldBexp' to fold a Boolean expression and use it
-- | to define the functions 'bVal'', 'fvBexp'', and 'substAexp''.

foldBexp :: a -> a -> (a -> a) -> (Aexp -> Aexp -> a) -> (Aexp -> Aexp -> a) -> (a -> a-> a) -> Bexp -> a
foldBexp tt ff fneg feq fle fand = plegar
    where
        plegar TRUE = tt
        plegar FALSE = ff
        plegar (Equ a1 a2) = feq a1 a2
        plegar (Leq a1 a2) = fle a1 a2
        plegar (Neg b1) = fneg (plegar b1)
        plegar (And b1 b2) = fand (plegar b1) (plegar b2)
--data  Bexp  =  TRUE
--            |  FALSE
--            |  Equ Aexp Aexp
 --           |  Leq Aexp Aexp
 --           |  Neg Bexp
 --           |  And Bexp Bexp
 --           deriving (Show, Eq)

bVal' :: Bexp -> State -> Bool
bVal' bex s = foldBexp True False not (\a1 a2 -> (==) (f a1) (f a2)) (\a1 a2 -> f a1 <= f a2) (&&) bex
    where
        f a = aVal' a s

fvBexp' :: Bexp -> [Var]
fvBexp' = undefined

substBexp' :: Bexp -> Subst -> Bexp
substBexp' = undefined

-- | Test your functions with HUnit.

-- todo
