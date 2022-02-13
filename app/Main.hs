module Main where

import qualified Data.Set as Set
import System.IO
import Data.List.Split
import Control.Monad.Random
import Data.Char (toLower)

-- number of guesses allowed
nGuesses :: Integer
nGuesses = 6

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

loop :: Set.Set String -> String -> Integer -> IO ()
loop vocab goal n =
  if n > nGuesses
    then do putStrLn $ "Out of guesses! The answer was " ++ goal ++ "."
            return ()
    else do putStr $ "Guess " ++ show n ++ ": "
            hFlush stdout
            res <- fmap (checkGuess vocab goal . map toLower) getLine
            putStrLn $ (++) " Result: " $ show res
            case res of
              Correct     -> return ()
              Incorrect _ -> loop vocab goal $ n + 1
              Invalid     -> loop vocab goal n

parseVocabStr :: Set.Set String -> String -> Set.Set String
parseVocabStr startSet vocabStr =
  foldr f startSet $ words vocabStr
  where f s acc = if length s == 5 then Set.insert (map toLower s) acc else acc

main :: IO ()
main = do
  -- Read in vocab and pick random goal
  -- vocab.txt taken from https://gist.github.com/cfreshman/a03ef2cba789d8cf00c08f767e0fad7b
  ansHandle <- openFile "wordle-answers.txt" ReadMode
  ansStr <- hGetContents ansHandle
  let ansSet = parseVocabStr Set.empty ansStr

  -- https://stackoverflow.com/a/20909776
  n <- getRandomR (0, Set.size ansSet - 1)
  let goal = Set.elemAt n ansSet

  allowedHandle <- openFile "wordle-allowed-guesses.txt" ReadMode
  allowedStr <- hGetContents allowedHandle
  let vocab = parseVocabStr ansSet allowedStr

  -- putStrLn $ "Goal is " ++ goal

  -- play wordle
  putStrLn "----- Command-line Wordle -----\n    X = letter in correct spot\n    x = letter in word but wrong spot\n    _ = letter not in word\n\n"
  loop vocab goal 1
  hClose ansHandle
  hClose allowedHandle
