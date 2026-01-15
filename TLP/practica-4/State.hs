-- State.hs - Implementation of State

module State where

type  Var    =  String
type  Z      =  Integer
type  State  =  Var -> Z

updateState :: State -> Var -> Z -> State
updateState s x v = \ y -> if x == y then v else s y

sInit :: State
sInit "x" =  3
sInit _   =  0
