module State where

type  Var    =  String
type  Z      =  Integer
type  State  =  Var -> Z

sInit :: State
sInit "x" =  3
sInit "z" =  4
sInit _   =  0
