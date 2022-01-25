module Main where

import qualified Data.Set as Set
import System.IO (hFlush, stdout)

goal :: String
goal = "knoll"

vocab :: Set.Set String
vocab = Set.fromList ["raise", "tough", "royal", "spine", "klick", "droll", "loyal", "knoll"]

checkValidGuess :: String -> String -> String
checkValidGuess goal guess = go (Set.fromList goal) goal guess
  where
    go goalChars (goalC : goalT) (guessC : guessT)
      | goalC == guessC = 'X' : go (Set.delete guessC goalChars) goalT guessT
      | guessC `elem` goalChars = 'x' : go (Set.delete guessC goalChars) goalT guessT
      | otherwise = '_' : go goalChars goalT guessT
    go _ [] [] = ""
    go _ _ _ = "Err: non-5-letter-word " ++ guess ++ " found in vocab"

checkGuess :: Set.Set String -> String -> String -> String
checkGuess vocab goal guess
  | guess == goal = "You win!"
  | guess `elem` vocab = checkValidGuess goal guess
  | otherwise = "Not a valid guess!"

loop :: Integer -> IO ()
loop n = 
  if n > 6
    then do putStrLn "Out of guesses!"
            return ()
    else do putStr $ "Guess " ++ show n ++ ": "
            hFlush stdout
            guess <- getLine
            putStrLn $ " Result: " ++ checkGuess vocab goal guess
            loop (n + 1)

main :: IO ()
main = loop 1
