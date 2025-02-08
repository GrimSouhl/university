-- OStream.hs - Implementation of Output Stream

module OStream(OStream,
               nullOutputStream,
               put,
               printOutputStream
               ) where


import           Aexp (NumLit)

newtype OStream = OS [String]

nullOutputStream :: OStream
nullOutputStream = OS []

put :: String -> OStream -> OStream
put x (OS xs) = OS (x:xs)

printOutputStream :: OStream -> IO()
printOutputStream (OS xs) = mapM_ putStr (reverse xs)
