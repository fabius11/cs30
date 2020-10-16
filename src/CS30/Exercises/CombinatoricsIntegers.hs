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

module CS30.Exercises.CombinatoricsIntegers where
import CS30.Data
import CS30.Exercises.Data (ExerciseType,exerciseType)
import CS30.Exercises.SetBasics.Powerset
import CS30.Exercises.SetBasics.Roster
import CS30.Exercises.SetBasics.SetOps
import CS30.Exercises.SetBasics.SolutionChecker

data CombinEx = CombinEx deriving Show

combinEx :: ExerciseType
combinEx = exerciseType "Combinatorics" "L?.?" "Combinatorics: Integers" 
                        [Node CombinEx] 
                        genQuestion
                        genFeedback
                    where genFeedback _ _ pr = pr

genQuestion :: a -> Exercise -> Exercise
genQuestion _ def = def{ eQuestion = [ FText ]}