{-Combinatorics: Integer Problems
Conceived by Sean
Your program should generate basic counting problems about integers, involving digit
placement, divisibility, summing the digits, and perhaps more of your choosing.
The general syntax looks like &quot;How many ____ integers are there such that ____ ?&quot; Here are
some examples:
Here are some examples:
● How many 5 digit positive integers are there such that it is divisible by 3, and that 9 is a
digit? (divisibility, digit placement)
● How many 6 digit positive integers are there such that the sum of the digits is at most
51? (summing the digits)
● How many 4 digit positive integers are there such that all digits are different? (custom
condition)
The numbers and problem-specific words used should be chosen dynamically, but be
careful that the problems are coherent when the pieces are put together.
The user should input an integer solution for any of these problems. Keep in mind that
combinatorics solutions explode as the parameters grow, so don&#39;t let them get too big.
The user&#39;s answer should simply be checked for equality against the integer solution.
As extra challenge, consider generating problems about positive rational numbers (i.e
any number of the form a/b, where a and b are positive integers).-}

{-# LANGUAGE TemplateHaskell #-}
module CS30.Exercises.CombinatoricsIntegers where
import           CS30.Data
import           CS30.Exercises.Data
import           Data.Aeson as JSON
import           Data.Aeson.TH
import qualified Data.Map as Map
import Debug.Trace


data CombinEx = CombinEx deriving Show
$(deriveJSON defaultOptions ''CombinEx)

combinEx :: ExerciseType
combinEx = exerciseType "Combinatorics" "L?.?" "Combinatorics: Integers" 
                        combins
                        genQuestion
                        genFeedback
                        
{- summing digits -}

-- To Do
solve :: String
solve = "56"  -- This is ok if the sum of digits is equal to 51, not "at most 51".

solveSum :: Int -> Int -> String
solveSum n sum_upperbound = show $ length $ [num | num <- (generateNDigitIntegers n), computeSumOfDigits(num) <= sum_upperbound]

-- Generate N-digit positive integers
generateNDigitIntegers :: Int -> [Int]
generateNDigitIntegers n = [smallest .. largest] 
                           where
                             smallest = 10 ^ (n - 1)
                             largest  = 10 ^ n - 1

-- Compute the sum of digits
computeSumOfDigits :: Int -> Int
computeSumOfDigits n = computeSumOfDigitsHelper n 0

computeSumOfDigitsHelper :: Int -> Int -> Int
computeSumOfDigitsHelper n curr_sum
  | n < 10     = curr_sum + n
  | otherwise  = computeSumOfDigitsHelper n' (curr_sum + digit)
  where
    (n', digit) = divMod n 10


{- divisibility -}

-- Find how many x-digit numbers are divisible by y
numXDivisibleByY :: Int -> Int -> Int
numXDivisibleByY x y =
  let firstTerm = findFirstTerm x y
      lastTerm = 10 ^ x - 1
  in (floor $ fromIntegral $ (lastTerm - firstTerm) `div` y) + 1

-- Find the first x-digit number that is divisible by y
findFirstTerm :: Int -> Int -> Int
findFirstTerm x y
  | smallest `mod` y == 0           = smallest
  | otherwise                       = smallest + (y - smallest `mod` y)
  where
    smallest = 10 ^ (x - 1)

genDivisibility :: (Int, Int) -> ChoiceTree ([Field], String)
genDivisibility (numDigit, divisor) = nodes[([FText $ "How many " ++ show numDigit ++ " digit positive integers are there such that it is divisible by "
  ++ show divisor ++ "?"], (show $ numXDivisibleByY numDigit divisor))]

{- custom condition -}

-- returns true if all elements in a list are unique
allUnique :: (Eq a) => [a] -> Bool
allUnique lst = case lst of
  [] -> True
  (x:xs) -> (notElem x xs) && allUnique xs

-- num digits -> num that have unique digits
solveUnique :: Int -> Int
solveUnique n = length ([lst | lst <- filter allUnique (map digits (generateNDigitIntegers n))])

-- breaks an integer into a list of its digits
digits :: Int -> [Int]
digits 0 = []
digits n = mod n 10 : digits (div n 10)

-- generates a question about the uniqueness of an n digit integer
genUnique :: Int -> ChoiceTree ([Field], String)
genUnique n = nodes [([FText $ "How many " ++ show n ++ " digit positive numbers are there such that all digits are different?"]
                    , (show $ solveUnique n))]

combins :: [ChoiceTree ([Field], String)]
combins = (map genUnique [2..9]) ++
         (map (genDivisibility) [(numDigit, divisor) | numDigit <- [1..10], divisor <- [2..1000]]) ++ 
         [ nodes [ ([FText "How many 6 digit positive integers are there such that the sum of the digits is at most 51?"], (solveSum 6 51))]
         , nodes [ ([FText "How many 3 digit positive integers are there such that the sum of the digits is at most 10?"], (solveSum 3 10))]]


genQuestion:: ([Field],a) -> Exercise -> Exercise
genQuestion (quer, _solution) ex 
 = ex{ eQuestion = [ FText $"How many "] ++ quer ++ [FFieldMath "answer"]}


genFeedback :: ([Field],String) -> Map.Map String String -> ProblemResponse -> ProblemResponse
genFeedback (_q, sol) mStrs rsp
  = trace ("genFeedback " ++ show mStrs) $
    case Map.lookup "answer" mStrs of 
      Just v -> if v == sol then markCorrect $ rsp{prFeedback= [FText ("You entered " ++ show v)], prTimeToRead=60}
                else markWrong $ rsp{prFeedback= [FText ("You entered " ++ show v)], prTimeToRead=60}
      Nothing -> error "Answer field expected."
