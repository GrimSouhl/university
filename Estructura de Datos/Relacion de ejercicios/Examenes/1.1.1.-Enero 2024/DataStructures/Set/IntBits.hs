module DataStructures.Set.IntBits
  ( IntBits
  , empty
  , isEmpty
  , set
  , delete
  , isElem
  , union
  , intersection
  , difference
  , fromList
  , toList
  , countOnes
  , contains
  , bitwiseOr
  ,orExtended
  ) where

import Data.Bits (Bits, (.|.), (.&.), complement, testBit, setBit, clearBit)
import Data.List (foldl')

newtype IntBits = IB Int deriving (Eq, Show)

empty :: IntBits
empty = IB 0

isEmpty :: IntBits -> Bool
isEmpty (IB bits) = bits == 0

set :: Int -> Int -> Int
set x bits = setBit bits x

delete :: Int -> IntBits -> IntBits
delete x (IB bits) = IB (clearBit bits x)

isElem :: Int -> IntBits -> Bool
isElem x (IB bits) = testBit bits x

union :: IntBits -> IntBits -> IntBits
union (IB bits1) (IB bits2) = IB (bits1 .|. bits2)

intersection :: IntBits -> IntBits -> IntBits
intersection (IB bits1) (IB bits2) = IB (bits1 .&. bits2)

difference :: IntBits -> IntBits -> IntBits
difference (IB bits1) (IB bits2) = IB (bits1 .&. complement bits2)

fromList :: [Int] -> IntBits
fromList = IB . foldl' (flip set) 0

toList :: IntBits -> [Int]
toList (IB bits) = toList' bits 0
  where
    toList' 0 _ = []
    toList' n i
      | testBit n i = i : toList' n (i + 1)
      | otherwise   = toList' n (i + 1)

countOnes :: Int -> Int
countOnes n = count' n
  where 
    count' 0 = 0
    count' x = (x .&. 1) + count' (x `div` 2)

contains :: Int -> Int -> Bool
contains bits x = testBit bits x

bitwiseOr :: Int -> Int -> Int
bitwiseOr = (.|.)

orExtended :: Int -> Int -> Int -> Int -> Int
orExtended b1 b2 cap1 cap2
  | cap1 == cap2 = b1 .|. b2
  | cap1 < cap2  = (b1 * 2^(cap2 - cap1)) .|. b2
  | otherwise    = b1 .|. (b2 * 2^(cap1 - cap2))