{-# OPTIONS_GHC -w #-}
module WhileParser ( happyParseWhile
                   , parser
                   ) where

import State
import Aexp
import Bexp
import While
import WhileLexer
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn 
	= HappyTerminal (Token)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 ((String, [Var], Stm))
	| HappyAbsSyn5 ([Var])
	| HappyAbsSyn7 (Stm)
	| HappyAbsSyn10 (DecVar)
	| HappyAbsSyn11 (DecProc)
	| HappyAbsSyn12 (Bexp)
	| HappyAbsSyn13 (Aexp)

{- to allow type-synonyms as our monads (likely
 - with explicitly-specified bind and return)
 - in Haskell98, it seems that with
 - /type M a = .../, then /(HappyReduction M)/
 - is not allowed.  But Happy is a
 - code-generator that can just substitute it.
type HappyReduction m = 
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> m HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> m HappyAbsSyn
-}

action_0,
 action_1,
 action_2,
 action_3,
 action_4,
 action_5,
 action_6,
 action_7,
 action_8,
 action_9,
 action_10,
 action_11,
 action_12,
 action_13,
 action_14,
 action_15,
 action_16,
 action_17,
 action_18,
 action_19,
 action_20,
 action_21,
 action_22,
 action_23,
 action_24,
 action_25,
 action_26,
 action_27,
 action_28,
 action_29,
 action_30,
 action_31,
 action_32,
 action_33,
 action_34,
 action_35,
 action_36,
 action_37,
 action_38,
 action_39,
 action_40,
 action_41,
 action_42,
 action_43,
 action_44,
 action_45,
 action_46,
 action_47,
 action_48,
 action_49,
 action_50,
 action_51,
 action_52,
 action_53,
 action_54,
 action_55,
 action_56,
 action_57,
 action_58,
 action_59,
 action_60,
 action_61,
 action_62,
 action_63,
 action_64,
 action_65,
 action_66,
 action_67,
 action_68,
 action_69,
 action_70,
 action_71,
 action_72,
 action_73,
 action_74,
 action_75,
 action_76,
 action_77,
 action_78,
 action_79,
 action_80,
 action_81,
 action_82,
 action_83,
 action_84,
 action_85,
 action_86,
 action_87 :: () => Prelude.Int -> ({-HappyReduction (HappyIdentity) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

happyReduce_1,
 happyReduce_2,
 happyReduce_3,
 happyReduce_4,
 happyReduce_5,
 happyReduce_6,
 happyReduce_7,
 happyReduce_8,
 happyReduce_9,
 happyReduce_10,
 happyReduce_11,
 happyReduce_12,
 happyReduce_13,
 happyReduce_14,
 happyReduce_15,
 happyReduce_16,
 happyReduce_17,
 happyReduce_18,
 happyReduce_19,
 happyReduce_20,
 happyReduce_21,
 happyReduce_22,
 happyReduce_23,
 happyReduce_24,
 happyReduce_25,
 happyReduce_26,
 happyReduce_27,
 happyReduce_28,
 happyReduce_29,
 happyReduce_30,
 happyReduce_31,
 happyReduce_32,
 happyReduce_33,
 happyReduce_34,
 happyReduce_35 :: () => ({-HappyReduction (HappyIdentity) = -}
	   Prelude.Int 
	-> (Token)
	-> HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)
	-> [HappyState (Token) (HappyStk HappyAbsSyn -> [(Token)] -> (HappyIdentity) HappyAbsSyn)] 
	-> HappyStk HappyAbsSyn 
	-> [(Token)] -> (HappyIdentity) HappyAbsSyn)

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,149) ([0,0,1024,0,0,128,512,0,0,0,0,0,128,0,0,16384,0,8192,0,0,32768,0,64,0,0,0,16,24906,0,0,0,0,4096,0,0,128,0,0,0,0,23080,0,0,2885,0,0,0,32,4096,0,0,9088,0,0,0,0,0,8,0,0,0,0,49152,1,0,0,0,0,0,0,0,0,0,32768,34,0,0,4,0,0,0,4,256,0,0,8192,256,0,12344,0,40960,360,0,0,0,0,0,0,0,46160,0,0,2048,8,16384,17,0,8192,37888,194,0,0,0,1792,0,0,11540,0,0,16386,3113,0,0,0,0,9,0,11776,12,0,552,0,0,69,0,40960,8,0,5120,1,0,8832,0,0,64,34088,1,32768,0,0,40961,1556,8192,0,0,1024,0,0,5888,0,0,0,0,0,64,0,0,0,1024,32768,0,0,0,8192,0,552,0,0,0,0,0,7,0,57344,0,0,0,0,0,512,0,0,64,0,0,0,0,0,16384,0,0,0,0,128,2640,3,224,4,0,0,0,16384,0,0,2048,0,0,0,0,0,0,0,0,128,0,0,0,32,0,0,0,0,0,0,0,16384,0,8,12453,0,16384,0,0,0,16,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_happyParseWhile","Program","Outputs","Var_List","Stm_List","Stm","Args","Dec_Vars","Dec_Procs","Bexp","Aexp","NUM","STR","ID","'+'","'-'","'*'","'('","')'","'true'","'false'","'&&'","'!'","'='","'<='","':='","'skip'","';'","'if'","'then'","'else'","'while'","'do'","'begin'","'end'","'var'","'proc'","'is'","'call'","'print'","'program'","','","%eof"]
        bit_start = st Prelude.* 45
        bit_end = (st Prelude.+ 1) Prelude.* 45
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..44]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (43) = happyShift action_2
action_0 (4) = happyGoto action_3
action_0 _ = happyFail (happyExpListPerState 0)

action_1 (43) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 (16) = happyShift action_4
action_2 _ = happyFail (happyExpListPerState 2)

action_3 (45) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 (20) = happyShift action_6
action_4 (5) = happyGoto action_5
action_4 _ = happyReduce_3

action_5 (30) = happyShift action_9
action_5 _ = happyFail (happyExpListPerState 5)

action_6 (16) = happyShift action_8
action_6 (6) = happyGoto action_7
action_6 _ = happyFail (happyExpListPerState 6)

action_7 (21) = happyShift action_19
action_7 (44) = happyShift action_20
action_7 _ = happyFail (happyExpListPerState 7)

action_8 _ = happyReduce_4

action_9 (16) = happyShift action_12
action_9 (29) = happyShift action_13
action_9 (31) = happyShift action_14
action_9 (34) = happyShift action_15
action_9 (36) = happyShift action_16
action_9 (41) = happyShift action_17
action_9 (42) = happyShift action_18
action_9 (7) = happyGoto action_10
action_9 (8) = happyGoto action_11
action_9 _ = happyFail (happyExpListPerState 9)

action_10 _ = happyReduce_1

action_11 (30) = happyShift action_38
action_11 _ = happyReduce_6

action_12 (28) = happyShift action_37
action_12 _ = happyFail (happyExpListPerState 12)

action_13 _ = happyReduce_9

action_14 (14) = happyShift action_23
action_14 (16) = happyShift action_25
action_14 (20) = happyShift action_32
action_14 (22) = happyShift action_33
action_14 (23) = happyShift action_34
action_14 (25) = happyShift action_35
action_14 (12) = happyGoto action_36
action_14 (13) = happyGoto action_31
action_14 _ = happyFail (happyExpListPerState 14)

action_15 (14) = happyShift action_23
action_15 (16) = happyShift action_25
action_15 (20) = happyShift action_32
action_15 (22) = happyShift action_33
action_15 (23) = happyShift action_34
action_15 (25) = happyShift action_35
action_15 (12) = happyGoto action_30
action_15 (13) = happyGoto action_31
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (38) = happyShift action_29
action_16 (10) = happyGoto action_28
action_16 _ = happyReduce_20

action_17 (16) = happyShift action_27
action_17 _ = happyFail (happyExpListPerState 17)

action_18 (14) = happyShift action_23
action_18 (15) = happyShift action_24
action_18 (16) = happyShift action_25
action_18 (20) = happyShift action_26
action_18 (13) = happyGoto action_22
action_18 _ = happyFail (happyExpListPerState 18)

action_19 _ = happyReduce_2

action_20 (16) = happyShift action_21
action_20 _ = happyFail (happyExpListPerState 20)

action_21 _ = happyReduce_5

action_22 (17) = happyShift action_46
action_22 (18) = happyShift action_47
action_22 (19) = happyShift action_48
action_22 _ = happyReduce_13

action_23 _ = happyReduce_30

action_24 _ = happyReduce_14

action_25 _ = happyReduce_31

action_26 (14) = happyShift action_23
action_26 (16) = happyShift action_25
action_26 (20) = happyShift action_26
action_26 (13) = happyGoto action_56
action_26 _ = happyFail (happyExpListPerState 26)

action_27 (20) = happyShift action_55
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (39) = happyShift action_54
action_28 (11) = happyGoto action_53
action_28 _ = happyReduce_22

action_29 (16) = happyShift action_52
action_29 _ = happyFail (happyExpListPerState 29)

action_30 (24) = happyShift action_41
action_30 (35) = happyShift action_51
action_30 _ = happyFail (happyExpListPerState 30)

action_31 (17) = happyShift action_46
action_31 (18) = happyShift action_47
action_31 (19) = happyShift action_48
action_31 (26) = happyShift action_49
action_31 (27) = happyShift action_50
action_31 _ = happyFail (happyExpListPerState 31)

action_32 (14) = happyShift action_23
action_32 (16) = happyShift action_25
action_32 (20) = happyShift action_32
action_32 (22) = happyShift action_33
action_32 (23) = happyShift action_34
action_32 (25) = happyShift action_35
action_32 (12) = happyGoto action_44
action_32 (13) = happyGoto action_45
action_32 _ = happyFail (happyExpListPerState 32)

action_33 _ = happyReduce_23

action_34 _ = happyReduce_24

action_35 (14) = happyShift action_23
action_35 (16) = happyShift action_25
action_35 (20) = happyShift action_32
action_35 (22) = happyShift action_33
action_35 (23) = happyShift action_34
action_35 (25) = happyShift action_35
action_35 (12) = happyGoto action_43
action_35 (13) = happyGoto action_31
action_35 _ = happyFail (happyExpListPerState 35)

action_36 (24) = happyShift action_41
action_36 (32) = happyShift action_42
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (14) = happyShift action_23
action_37 (16) = happyShift action_25
action_37 (20) = happyShift action_26
action_37 (13) = happyGoto action_40
action_37 _ = happyFail (happyExpListPerState 37)

action_38 (16) = happyShift action_12
action_38 (29) = happyShift action_13
action_38 (31) = happyShift action_14
action_38 (34) = happyShift action_15
action_38 (36) = happyShift action_16
action_38 (41) = happyShift action_17
action_38 (42) = happyShift action_18
action_38 (7) = happyGoto action_39
action_38 (8) = happyGoto action_11
action_38 _ = happyFail (happyExpListPerState 38)

action_39 _ = happyReduce_7

action_40 (17) = happyShift action_46
action_40 (18) = happyShift action_47
action_40 (19) = happyShift action_48
action_40 _ = happyReduce_8

action_41 (14) = happyShift action_23
action_41 (16) = happyShift action_25
action_41 (20) = happyShift action_32
action_41 (22) = happyShift action_33
action_41 (23) = happyShift action_34
action_41 (25) = happyShift action_35
action_41 (12) = happyGoto action_71
action_41 (13) = happyGoto action_31
action_41 _ = happyFail (happyExpListPerState 41)

action_42 (16) = happyShift action_12
action_42 (29) = happyShift action_13
action_42 (31) = happyShift action_14
action_42 (34) = happyShift action_15
action_42 (36) = happyShift action_16
action_42 (41) = happyShift action_17
action_42 (42) = happyShift action_18
action_42 (8) = happyGoto action_70
action_42 _ = happyFail (happyExpListPerState 42)

action_43 _ = happyReduce_27

action_44 (21) = happyShift action_69
action_44 (24) = happyShift action_41
action_44 _ = happyFail (happyExpListPerState 44)

action_45 (17) = happyShift action_46
action_45 (18) = happyShift action_47
action_45 (19) = happyShift action_48
action_45 (21) = happyShift action_57
action_45 (26) = happyShift action_49
action_45 (27) = happyShift action_50
action_45 _ = happyFail (happyExpListPerState 45)

action_46 (14) = happyShift action_23
action_46 (16) = happyShift action_25
action_46 (20) = happyShift action_26
action_46 (13) = happyGoto action_68
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (14) = happyShift action_23
action_47 (16) = happyShift action_25
action_47 (20) = happyShift action_26
action_47 (13) = happyGoto action_67
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (14) = happyShift action_23
action_48 (16) = happyShift action_25
action_48 (20) = happyShift action_26
action_48 (13) = happyGoto action_66
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (14) = happyShift action_23
action_49 (16) = happyShift action_25
action_49 (20) = happyShift action_26
action_49 (13) = happyGoto action_65
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (14) = happyShift action_23
action_50 (16) = happyShift action_25
action_50 (20) = happyShift action_26
action_50 (13) = happyGoto action_64
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (16) = happyShift action_12
action_51 (29) = happyShift action_13
action_51 (31) = happyShift action_14
action_51 (34) = happyShift action_15
action_51 (36) = happyShift action_16
action_51 (41) = happyShift action_17
action_51 (42) = happyShift action_18
action_51 (8) = happyGoto action_63
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (28) = happyShift action_62
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (16) = happyShift action_12
action_53 (29) = happyShift action_13
action_53 (31) = happyShift action_14
action_53 (34) = happyShift action_15
action_53 (36) = happyShift action_16
action_53 (41) = happyShift action_17
action_53 (42) = happyShift action_18
action_53 (7) = happyGoto action_61
action_53 (8) = happyGoto action_11
action_53 _ = happyFail (happyExpListPerState 53)

action_54 (16) = happyShift action_60
action_54 _ = happyFail (happyExpListPerState 54)

action_55 (16) = happyShift action_59
action_55 (9) = happyGoto action_58
action_55 _ = happyReduce_18

action_56 (17) = happyShift action_46
action_56 (18) = happyShift action_47
action_56 (19) = happyShift action_48
action_56 (21) = happyShift action_57
action_56 _ = happyFail (happyExpListPerState 56)

action_57 _ = happyReduce_35

action_58 (21) = happyShift action_77
action_58 _ = happyFail (happyExpListPerState 58)

action_59 (44) = happyShift action_76
action_59 _ = happyReduce_17

action_60 (20) = happyShift action_75
action_60 _ = happyFail (happyExpListPerState 60)

action_61 (37) = happyShift action_74
action_61 _ = happyFail (happyExpListPerState 61)

action_62 (14) = happyShift action_23
action_62 (16) = happyShift action_25
action_62 (20) = happyShift action_26
action_62 (13) = happyGoto action_73
action_62 _ = happyFail (happyExpListPerState 62)

action_63 _ = happyReduce_11

action_64 (17) = happyShift action_46
action_64 (18) = happyShift action_47
action_64 (19) = happyShift action_48
action_64 _ = happyReduce_26

action_65 (17) = happyShift action_46
action_65 (18) = happyShift action_47
action_65 (19) = happyShift action_48
action_65 _ = happyReduce_25

action_66 _ = happyReduce_34

action_67 (19) = happyShift action_48
action_67 _ = happyReduce_33

action_68 (19) = happyShift action_48
action_68 _ = happyReduce_32

action_69 _ = happyReduce_29

action_70 (33) = happyShift action_72
action_70 _ = happyFail (happyExpListPerState 70)

action_71 _ = happyReduce_28

action_72 (16) = happyShift action_12
action_72 (29) = happyShift action_13
action_72 (31) = happyShift action_14
action_72 (34) = happyShift action_15
action_72 (36) = happyShift action_16
action_72 (41) = happyShift action_17
action_72 (42) = happyShift action_18
action_72 (8) = happyGoto action_81
action_72 _ = happyFail (happyExpListPerState 72)

action_73 (17) = happyShift action_46
action_73 (18) = happyShift action_47
action_73 (19) = happyShift action_48
action_73 (30) = happyShift action_80
action_73 _ = happyFail (happyExpListPerState 73)

action_74 _ = happyReduce_12

action_75 (16) = happyShift action_59
action_75 (9) = happyGoto action_79
action_75 _ = happyReduce_18

action_76 (16) = happyShift action_59
action_76 (9) = happyGoto action_78
action_76 _ = happyReduce_18

action_77 _ = happyReduce_15

action_78 _ = happyReduce_16

action_79 (21) = happyShift action_83
action_79 _ = happyFail (happyExpListPerState 79)

action_80 (38) = happyShift action_29
action_80 (10) = happyGoto action_82
action_80 _ = happyReduce_20

action_81 _ = happyReduce_10

action_82 _ = happyReduce_19

action_83 (40) = happyShift action_84
action_83 _ = happyFail (happyExpListPerState 83)

action_84 (16) = happyShift action_12
action_84 (29) = happyShift action_13
action_84 (31) = happyShift action_14
action_84 (34) = happyShift action_15
action_84 (36) = happyShift action_16
action_84 (41) = happyShift action_17
action_84 (42) = happyShift action_18
action_84 (8) = happyGoto action_85
action_84 _ = happyFail (happyExpListPerState 84)

action_85 (30) = happyShift action_86
action_85 _ = happyFail (happyExpListPerState 85)

action_86 (39) = happyShift action_54
action_86 (11) = happyGoto action_87
action_86 _ = happyReduce_22

action_87 _ = happyReduce_21

happyReduce_1 = happyReduce 5 4 happyReduction_1
happyReduction_1 ((HappyAbsSyn7  happy_var_5) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_3) `HappyStk`
	(HappyTerminal (IDENTIFIER happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn4
		 ((happy_var_2, reverse happy_var_3, happy_var_5)
	) `HappyStk` happyRest

happyReduce_2 = happySpecReduce_3  5 happyReduction_2
happyReduction_2 _
	(HappyAbsSyn5  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (happy_var_2
	)
happyReduction_2 _ _ _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_0  5 happyReduction_3
happyReduction_3  =  HappyAbsSyn5
		 ([]
	)

happyReduce_4 = happySpecReduce_1  6 happyReduction_4
happyReduction_4 (HappyTerminal (IDENTIFIER happy_var_1))
	 =  HappyAbsSyn5
		 ([happy_var_1]
	)
happyReduction_4 _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_3  6 happyReduction_5
happyReduction_5 (HappyTerminal (IDENTIFIER happy_var_3))
	_
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (happy_var_3:happy_var_1
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_1  7 happyReduction_6
happyReduction_6 (HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (happy_var_1
	)
happyReduction_6 _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_3  7 happyReduction_7
happyReduction_7 (HappyAbsSyn7  happy_var_3)
	_
	(HappyAbsSyn7  happy_var_1)
	 =  HappyAbsSyn7
		 (Comp happy_var_1 happy_var_3
	)
happyReduction_7 _ _ _  = notHappyAtAll 

happyReduce_8 = happySpecReduce_3  8 happyReduction_8
happyReduction_8 (HappyAbsSyn13  happy_var_3)
	_
	(HappyTerminal (IDENTIFIER happy_var_1))
	 =  HappyAbsSyn7
		 (Ass happy_var_1 happy_var_3
	)
happyReduction_8 _ _ _  = notHappyAtAll 

happyReduce_9 = happySpecReduce_1  8 happyReduction_9
happyReduction_9 _
	 =  HappyAbsSyn7
		 (Skip
	)

happyReduce_10 = happyReduce 6 8 happyReduction_10
happyReduction_10 ((HappyAbsSyn7  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (If happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_11 = happyReduce 4 8 happyReduction_11
happyReduction_11 ((HappyAbsSyn7  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn12  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (While happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_12 = happyReduce 5 8 happyReduction_12
happyReduction_12 (_ `HappyStk`
	(HappyAbsSyn7  happy_var_4) `HappyStk`
	(HappyAbsSyn11  happy_var_3) `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Block happy_var_2 happy_var_3 happy_var_4
	) `HappyStk` happyRest

happyReduce_13 = happySpecReduce_2  8 happyReduction_13
happyReduction_13 (HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn7
		 (Print (Exp happy_var_2)
	)
happyReduction_13 _ _  = notHappyAtAll 

happyReduce_14 = happySpecReduce_2  8 happyReduction_14
happyReduction_14 (HappyTerminal (LITERAL_STR happy_var_2))
	_
	 =  HappyAbsSyn7
		 (Print (Str happy_var_2)
	)
happyReduction_14 _ _  = notHappyAtAll 

happyReduce_15 = happyReduce 5 8 happyReduction_15
happyReduction_15 (_ `HappyStk`
	(HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (IDENTIFIER happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Call happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_16 = happySpecReduce_3  9 happyReduction_16
happyReduction_16 (HappyAbsSyn5  happy_var_3)
	_
	(HappyTerminal (IDENTIFIER happy_var_1))
	 =  HappyAbsSyn5
		 (happy_var_1:happy_var_3
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_1  9 happyReduction_17
happyReduction_17 (HappyTerminal (IDENTIFIER happy_var_1))
	 =  HappyAbsSyn5
		 ([happy_var_1]
	)
happyReduction_17 _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_0  9 happyReduction_18
happyReduction_18  =  HappyAbsSyn5
		 ([]
	)

happyReduce_19 = happyReduce 6 10 happyReduction_19
happyReduction_19 ((HappyAbsSyn10  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn13  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (IDENTIFIER happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (Dec happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_20 = happySpecReduce_0  10 happyReduction_20
happyReduction_20  =  HappyAbsSyn10
		 (EndDec
	)

happyReduce_21 = happyReduce 9 11 happyReduction_21
happyReduction_21 ((HappyAbsSyn11  happy_var_9) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_7) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn5  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyTerminal (IDENTIFIER happy_var_2)) `HappyStk`
	_ `HappyStk`
	happyRest)
	 = HappyAbsSyn11
		 (Proc happy_var_2 happy_var_4 happy_var_7 happy_var_9
	) `HappyStk` happyRest

happyReduce_22 = happySpecReduce_0  11 happyReduction_22
happyReduction_22  =  HappyAbsSyn11
		 (EndProc
	)

happyReduce_23 = happySpecReduce_1  12 happyReduction_23
happyReduction_23 _
	 =  HappyAbsSyn12
		 (TRUE
	)

happyReduce_24 = happySpecReduce_1  12 happyReduction_24
happyReduction_24 _
	 =  HappyAbsSyn12
		 (FALSE
	)

happyReduce_25 = happySpecReduce_3  12 happyReduction_25
happyReduction_25 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (Equ happy_var_1 happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  12 happyReduction_26
happyReduction_26 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn12
		 (Leq happy_var_1 happy_var_3
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_2  12 happyReduction_27
happyReduction_27 (HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (Neg happy_var_2
	)
happyReduction_27 _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_3  12 happyReduction_28
happyReduction_28 (HappyAbsSyn12  happy_var_3)
	_
	(HappyAbsSyn12  happy_var_1)
	 =  HappyAbsSyn12
		 (And happy_var_1 happy_var_3
	)
happyReduction_28 _ _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_3  12 happyReduction_29
happyReduction_29 _
	(HappyAbsSyn12  happy_var_2)
	_
	 =  HappyAbsSyn12
		 (happy_var_2
	)
happyReduction_29 _ _ _  = notHappyAtAll 

happyReduce_30 = happySpecReduce_1  13 happyReduction_30
happyReduction_30 (HappyTerminal (LITERAL_INT happy_var_1))
	 =  HappyAbsSyn13
		 (N happy_var_1
	)
happyReduction_30 _  = notHappyAtAll 

happyReduce_31 = happySpecReduce_1  13 happyReduction_31
happyReduction_31 (HappyTerminal (IDENTIFIER happy_var_1))
	 =  HappyAbsSyn13
		 (V happy_var_1
	)
happyReduction_31 _  = notHappyAtAll 

happyReduce_32 = happySpecReduce_3  13 happyReduction_32
happyReduction_32 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (Add happy_var_1 happy_var_3
	)
happyReduction_32 _ _ _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_3  13 happyReduction_33
happyReduction_33 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (Sub happy_var_1 happy_var_3
	)
happyReduction_33 _ _ _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_3  13 happyReduction_34
happyReduction_34 (HappyAbsSyn13  happy_var_3)
	_
	(HappyAbsSyn13  happy_var_1)
	 =  HappyAbsSyn13
		 (Mult happy_var_1 happy_var_3
	)
happyReduction_34 _ _ _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_3  13 happyReduction_35
happyReduction_35 _
	(HappyAbsSyn13  happy_var_2)
	_
	 =  HappyAbsSyn13
		 (happy_var_2
	)
happyReduction_35 _ _ _  = notHappyAtAll 

happyNewToken action sts stk [] =
	action 45 45 notHappyAtAll (HappyState action) sts stk []

happyNewToken action sts stk (tk:tks) =
	let cont i = action i i tk (HappyState action) sts stk tks in
	case tk of {
	LITERAL_INT happy_dollar_dollar -> cont 14;
	LITERAL_STR happy_dollar_dollar -> cont 15;
	IDENTIFIER happy_dollar_dollar -> cont 16;
	PLUS -> cont 17;
	MINUS -> cont 18;
	ASTERISK -> cont 19;
	LPAREN -> cont 20;
	RPAREN -> cont 21;
	LITERAL_TRUE -> cont 22;
	LITERAL_FALSE -> cont 23;
	AMPERSANDS -> cont 24;
	EXCLAMATION -> cont 25;
	EQUALS -> cont 26;
	LESSEQUALS -> cont 27;
	ASSIGN -> cont 28;
	SKIP -> cont 29;
	SEMICOLON -> cont 30;
	IF -> cont 31;
	THEN -> cont 32;
	ELSE -> cont 33;
	WHILE -> cont 34;
	DO -> cont 35;
	BEGIN -> cont 36;
	END -> cont 37;
	VAR -> cont 38;
	PROC -> cont 39;
	IS -> cont 40;
	CALL -> cont 41;
	PRINT -> cont 42;
	PROGRAM -> cont 43;
	COMMA -> cont 44;
	_ -> happyError' ((tk:tks), [])
	}

happyError_ explist 45 tk tks = happyError' (tks, explist)
happyError_ explist _ tk tks = happyError' ((tk:tks), explist)

newtype HappyIdentity a = HappyIdentity a
happyIdentity = HappyIdentity
happyRunIdentity (HappyIdentity a) = a

instance Prelude.Functor HappyIdentity where
    fmap f (HappyIdentity a) = HappyIdentity (f a)

instance Applicative HappyIdentity where
    pure  = HappyIdentity
    (<*>) = ap
instance Prelude.Monad HappyIdentity where
    return = pure
    (HappyIdentity p) >>= q = q p

happyThen :: () => HappyIdentity a -> (a -> HappyIdentity b) -> HappyIdentity b
happyThen = (Prelude.>>=)
happyReturn :: () => a -> HappyIdentity a
happyReturn = (Prelude.return)
happyThen1 m k tks = (Prelude.>>=) m (\a -> k a tks)
happyReturn1 :: () => a -> b -> HappyIdentity a
happyReturn1 = \a tks -> (Prelude.return) a
happyError' :: () => ([(Token)], [Prelude.String]) -> HappyIdentity a
happyError' = HappyIdentity Prelude.. (\(tokens, _) -> happyError tokens)
happyParseWhile tks = happyRunIdentity happySomeParser where
 happySomeParser = happyThen (happyParse action_0 tks) (\x -> case x of {HappyAbsSyn4 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


happyError :: [Token] -> a
happyError _ = error ("Parse error\n")

parser :: FilePath -> IO((String, [Var], Stm))
parser filename = do
  s <- readFile filename
  return $ (happyParseWhile . alexScanTokens) s
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $










































data Happy_IntList = HappyCons Prelude.Int Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action









































indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x Prelude.< y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `Prelude.div` 16)) (bit `Prelude.mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Prelude.Int ->                    -- token number
         Prelude.Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Prelude.- ((1) :: Prelude.Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Prelude.Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n Prelude.- ((1) :: Prelude.Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Prelude.- ((1)::Prelude.Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ((HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
