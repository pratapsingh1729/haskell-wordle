module Main where

import qualified Data.Set as Set

goal :: String
goal = "raise"

vocab :: [String]
vocab = ["raise", "tough", "royal", "spine"]

iter :: String -> String
iter guess
  | guess `elem` vocab = zipWith (checkLetter goal) goal guess
  | otherwise = "Not a valid guess!"
  where checkLetter goal goalCh guessCh
          | goalCh == guessCh = 'X'
          | guessCh `elem` goal = 'x'
          | otherwise = '_'

main :: IO ()
main = do
  guess <- getLine
  putStrLn $ iter guess
  return ()
