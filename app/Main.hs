module Main where

import qualified Data.Set as Set

goal :: String
goal = "knoll"

vocab :: Set.Set String
vocab = Set.fromList ["raise", "tough", "royal", "spine", "klick", "droll", "loyal"]

checkValidGuess :: String -> String -> String
checkValidGuess goal guess = go (Set.fromList goal) goal guess
  where 
    go goalChars (goalC : goalT) (guessC : guessT)
      | goalC == guessC = 'X' : go (Set.delete guessC goalChars) goalT guessT
      | guessC `elem` goalChars = 'x' : go (Set.delete guessC goalChars) goalT guessT
      | otherwise = '_' : go goalChars goalT guessT
    go _ [] [] = ""
    go _ _ _ = "Err: non-5-letter-word " ++ guess ++ " found in vocab"


checkGuess :: String -> String -> String
checkGuess goal guess
  | guess == goal = "You win!"
  | guess `elem` vocab = checkValidGuess goal guess
  | otherwise = "Not a valid guess!"

main :: IO ()
main = do
  guess <- getLine
  putStrLn $ checkGuess goal guess
  return ()
