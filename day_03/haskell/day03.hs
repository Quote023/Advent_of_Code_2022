module Day3 where

type Item = Char
type Pocket = [Item]
type Rucksack = (Pocket,Pocket)

chunkBy :: Int -> [a] -> [[a]]
chunkBy _ [] = []
chunkBy i as = take i as : chunkBy i (drop i as)

splitInHalf :: [a] -> ([a], [a])
splitInHalf xs = splitAt (div (length xs) 2) xs

intersect :: (Eq a) => [a] -> [a] -> [a]
intersect xs ys = [x | x <- xs, any (== x) ys]

unique :: Eq a => [a] -> [a]
unique [] = []
unique (x:xs) = x : unique [y | y <- xs, y /= x]

parseBags :: String -> [Rucksack]
parseBags = map splitInHalf . lines

repeatedItems :: [Rucksack] -> [Item]
repeatedItems = concat . map (unique . uncurry intersect)

priority :: Item -> Int -- 'a' = 97 -> 1 ; 'A' = 65 -> 27
priority c = (fromEnum c) - (if c >= 'a'  then 96 else 38) 

priorities :: [Item] -> Int
priorities = sum . map priority

flattenBag (a,b) = a ++ b

main :: IO ()
main = 
  readFile "../input.txt"
  >>= return . parseBags
  >>= \bags 
    -> print ("1 ",(sum . map priority . repeatedItems $ bags)) 
    >> print ("2 ",(sum . map priority . map (head . foldr1 intersect) . map (map flattenBag) $ chunkBy 3 bags))
