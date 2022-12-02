module Day1 where

import Data.List

chunkBy :: Eq a => a -> [a] -> [[a]]
chunkBy c [] = []
chunkBy c (x:xs)  
  | x == c = [[]] ++ (chunkBy c xs)
  | y:ys <- yss = [x:y] ++ ys
  | otherwise = [x]:yss
    where
      yss = (chunkBy c xs)

parse :: String -> [Integer]
parse = map (sum . map read)  . chunkBy "" . lines
  
main :: IO ()
main =
  readFile "../input.txt"
  >>= return . parse
  >>= return . take 3 . sortBy (flip compare)
  >>= \ top3 -> 
    putStrLn ("1º: " ++ (show $ head top3))
    >> putStrLn ("2º: " ++ (show $ sum top3))
  