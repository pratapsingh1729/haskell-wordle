module Main where

import qualified Data.Set as Set
import System.IO (hFlush, stdout)

goal :: String
goal = "knoll"

vocab :: Set.Set String
vocab = Set.fromList ["raise", "tough", "royal", "spine", "klick", "droll", "loyal", "knoll"]

data GuessResult = Correct | Incorrect String | Invalid
instance Show GuessResult where
  show Correct       = "You win!"
  show (Incorrect s) = s
  show Invalid       = "Not a valid guess!"

checkValidGuess :: String -> String -> GuessResult
checkValidGuess goal guess = Incorrect $ go (Set.fromList goal) goal guess
  where
    go goalChars (goalC : goalT) (guessC : guessT)
      | goalC == guessC = 'X' : go (Set.delete guessC goalChars) goalT guessT
      | guessC `elem` goalChars = 'x' : go (Set.delete guessC goalChars) goalT guessT
      | otherwise = '_' : go goalChars goalT guessT
    go _ [] [] = ""
    go _ _ _ = "Err: non-5-letter-word " ++ guess ++ " found in vocab"

checkGuess :: Set.Set String -> String -> String -> GuessResult
checkGuess vocab goal guess
  | guess == goal = Correct
  | guess `elem` vocab = checkValidGuess goal guess
  | otherwise = Invalid

loop :: Integer -> IO ()
loop n = 
  if n > 6
    then do putStrLn "Out of guesses!"
            return ()
    else do putStr $ "Guess " ++ show n ++ ": "
            hFlush stdout
            guess <- getLine
            let res = checkGuess vocab goal guess
            putStrLn $ (++) " Result: " $ show res
            case res of
              Correct -> return ()
              Incorrect s -> loop $ n + 1
              Invalid -> loop n

main :: IO ()
main = loop 1
