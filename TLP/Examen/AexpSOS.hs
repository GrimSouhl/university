-- -------------------------------------------------------------------
-- Structural Operational Semantics for Aexp.
-- Examen de Lenguajes de Programación. UMA.
-- 1 de febrero de 2021
--
-- Apellidos, Nombre:
-- -------------------------------------------------------------------

module AexpSOS where

-- En este fichero solo necesitas completar:
--
--   - 1.a la definición semántica de Aexp
--   - 1.b la implementación de la semántica de Aexp
--   - 1.c la implementación de la secuencia de derivación
--
-- No modifiques el resto del código. Puedes probar
-- tu implementación con la función eval, definida al final.

import           While21

-- |----------------------------------------------------------------------
-- | Exercise 1.a
-- |----------------------------------------------------------------------

-- | Define the Structural Operational Semantics of Aexp extended with
--   integer division.

{-

    Completa la definición semántica de Aexp detallando reglas y axiomas
    con judgements de la forma <a,s> = > <a',s>  y  <a,s> => n.

-}

-- Reglas de la semántica:
-- < N n, s > => n
-- < V x, s > => s(x)
-- < a + b, s > => < a, s > => < a', s > => < b, s > => < b', s > => < a' + b', s >
-- < a * b, s > => < a, s > => < a', s > => < b, s > => < b', s > => < a' * b', s >
-- < a - b, s > => < a, s > => < a', s > => < b, s > => < b', s > => < a' - b', s >
-- < a / b, s > => < a, s > => < a', s > => < b, s > => < b', s > => if b' == 0 then Stuck else < a' / b', s >




-- |----------------------------------------------------------------------
-- | Exercise 1.b
-- |----------------------------------------------------------------------

-- | Implement the Structural Operational Semantics for the
-- | evaluation of arithmetic expressions Aexp.

-- | Use the algebraic data type 'AexpConfig' to represent the
-- | configuration of the transition system

data AexpConfig = Redex Aexp State  -- a redex is a reducible expression
                | Stuck Aexp State  -- a stuck is neither reducible nor a value
                | Value Z           -- a value is not reducible; it is in normal form


-- | Define a function 'sosAexp' that given a configuration 'AexpConfig'
-- | evaluates the expression in 'AexpConfig' one step and returns the
-- | next configuration.

sosAexp :: AexpConfig -> AexpConfig
--literal entero
sosAexp (Redex (N n) s) = Value n
--variable segun estado
sosAexp (Redex (V x) s) = Value (s x)
--suma a + b
sosAexp (Redex (Add a b) s) =
  case sosAexp (Redex a s) of
    Redex a' s' -> Redex (Add a' b) s'  
    Value va    -> case sosAexp (Redex b s) of
                    Redex b' s' -> Redex (Add (N va) b') s' 
                    Value vb    -> Value (va + vb)  
--resta
sosAexp (Redex (Sub a b) s)=
  case sosAexp (Redex a s) of
    Redex a' s' -> Redex (Sub a' b) s'
    Value va -> case sosAexp (Redex b s) of
                  Redex b' s' -> Redex (Sub (N va) b') s'
                  Value vb -> Value (va - vb)
--multiplicacion
sosAexp (Redex (Mult a b) s) =
  case sosAexp (Redex a s) of
    Redex a' s' -> Redex (Mult a' b) s'  
    Value va    -> case sosAexp (Redex b s) of
                    Redex b' s' -> Redex (Mult (N va) b') s' 
                    Value vb    -> Value (va * vb) 
--division
sosAexp (Redex (Div a b) s) =
  case sosAexp (Redex a s) of
    Redex a' s' -> Redex (Div a' b) s'  
    Value va    -> case sosAexp (Redex b s) of
                    Redex b' s' -> Redex (Div (N va) b') s' 
                    Value vb    -> if vb == 0
                                   then Stuck (Div (N va) (N vb)) s  
                                   else Value (va `div` vb)  


-- |----------------------------------------------------------------------
-- | Exercise 1.c
-- |----------------------------------------------------------------------

-- | Given the type synonym 'AexpDerivSeq' to represent derivation sequences
-- | of the structural operational semantics for arithmetic expressions 'Aexp':

type AexpDerivSeq = [AexpConfig]

-- | Define a recursive function 'aExpDerivSeq' that given a 'Aexp'
--   expression 'a' and an initial state 's' returns the corresponding
--   derivation sequence:

aExpDerivSeq :: Aexp -> State -> AexpDerivSeq
aExpDerivSeq a s = evalStep (Redex a s) []

evalStep :: AexpConfig -> AexpDerivSeq -> AexpDerivSeq
evalStep (Value n) seq = (Value n) : seq
evalStep (Stuck e s) seq = (Stuck e s) : seq
evalStep redex@(Redex _ _) seq = evalStep (sosAexp redex) (redex : seq)


----------------------------------------------------------------------
-- NO MODIFICAR EL CODIGO DE ABAJO
----------------------------------------------------------------------

eval :: Aexp -> State -> IO()
eval a s = putStrLn $ showAexpDerivSeq ["x", "y", "z"] (aExpDerivSeq a s)
  where
    showAexpDerivSeq vars dseq = unlines (map showConfig dseq)
      where
        showConfig (Value n) = "Final value:\n" ++ show n
        showConfig (Stuck e st) = "Stuck expression:\n" ++ show e ++ "\n" ++ unlines (map (showVal st) vars)
        showConfig (Redex e st) = show e ++ "\n" ++ unlines (map (showVal st) vars)
        showVal st x = " s(" ++ x ++ ")= " ++ show (st x)

-- Tests

-- test your implementation with the examples below, for example:
-- eval exp1 sInit

sInit :: State
sInit "x" = 1
sInit "y" = 2
sInit "z" = 4
sInit  _  = 0

exp1 :: Aexp
exp1 = ( (V "x") `Add` (V "y") ) `Add` (V "z") -- (x + y) + z
--CORRECTO1
exp2 :: Aexp
exp2 =  (V "x") `Add` ( (V "y") `Add` (V "z") ) -- x + (y + z)
--CORRECTO2
exp3 :: Aexp
exp3 = Mult (V "x") (Add (V "y") (Sub (V "z") (N 1))) -- x * (y + (z - 1))
--CORRECTO3
exp4 :: Aexp
exp4 = Mult (Add (V "x") (V "y")) (Sub (N 9) (V "z")) -- (x + y) * (9 - z)
--CORRECTO4
exp5 :: Aexp
exp5 = Div (Mult (V "y") (V "z")) (Add (V "x") (N 1)) -- (y * z) / (x + 1)
--CORRECTO5
exp6 :: Aexp
exp6 = Div (Mult (V "y") (V "z")) (Sub (V "x") (N 1)) -- (y * z) / (x - 1)
--CORRECTO6