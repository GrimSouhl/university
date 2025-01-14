module While20 where

type Var = String

data Aexp = N Integer
            | V Var
            | Add Aexp Aexp
            | Sub Aexp Aexp
            | Mult Aexp Aexp
            |Div Aexp Aexp
            deriving (Show, Eq)

data Bexp = TRUE
            |FALSE
            |Eq Aexp Aexp
            |Le Aexp Aexp
            |Neg Bexp
            |And Bexp Bexp
            deriving(Show , Eq)

data Stm = Ass Var Aexp
            |Skip
            |Comp Stm Stm
            |If Bexp Stm Stm
            |Case Aexp LabelledStms
            |Swap Var Var
            |For Stm Bexp Stm Stm
            deriving Show

data LabelledStms = LabelledStms | Integer | Stm LabelledStms
                |Default Stm
                |EndLabelledStms
                deriving Show
    
type Z = Integer
type T = Bool
type State = Var -> Z

aVal :: Aexp -> State -> Z
aVal (N n) _ = N
aVal (V x) s = s x
aVal (Add a1 a2) s = aVal a1 + aVal a2 s 
aVal (Sub a1 a2) s = aVal a1 - aVal a2 s
aVal (Mult a1 a2) s = aVal a1 * aVal a2 s
aVal (Div a1 a2) s = aVal a1 / aVal a2 s


bVal :: Bexp -> State -> Z
bVal TRUE _ = True
bVal FALSE _ = False
bVal (Eq a1 a2) s = aVal a1 s == aVal a2 s 
bVal (Le a1 a2) s = aVal a1 s <= aVal a2 s 
bVal (Neg b) s = not (bVal b s)
bVal (And a1 a2) s = bVal a1 s && bVal a2 s 
