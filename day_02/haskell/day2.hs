module Day2 where

data Shape = Rock | Paper | Scissors deriving (Show,Eq,Enum)
data Status = Won | Draw | Lost deriving (Show)

shapeToPoints :: Shape -> Int
shapeToPoints Rock = 1
shapeToPoints Paper = 2
shapeToPoints Scissors = 3

strongAgainst :: Shape -> Shape
strongAgainst Scissors = Rock
strongAgainst Rock = Paper 
strongAgainst Paper = Scissors 

weakAgainst :: Shape -> Shape
weakAgainst Rock = Scissors
weakAgainst Paper = Rock  
weakAgainst Scissors = Paper  

pairToStatus :: (Shape, Shape) -> Status
pairToStatus (opponent,you)
  | opponent == you = Draw
  | opponent == (strongAgainst you) = Lost
  | otherwise = Won

statusToPoints :: Status -> Int
statusToPoints Won = 6
statusToPoints Draw = 3
statusToPoints Lost = 0

parseShape :: String -> Shape
parseShape "A" = Rock
parseShape "X" = Rock
parseShape "B" = Paper
parseShape "Y" = Paper
parseShape "C" = Scissors
parseShape "Z" = Scissors

toPair :: [b] -> (b, b)
toPair [a,b] = (a,b)

parse :: String -> [(Shape, Shape)]
parse = map (toPair . map parseShape . words) . lines

points :: (Shape, Shape) -> Int
points (a,b) = shapeToPoints b + statusToPoints (pairToStatus (a,b))

totalPoints :: [(Shape, Shape)] -> Int
totalPoints = sum . map points

transform :: (Shape, Shape) -> (Shape,Shape)
transform (a,Rock) = (a,weakAgainst a)
transform (a,Paper) = (a,a)
transform (a,Scissors) = (a, strongAgainst a)

main :: IO ()
main =
  readFile "../input.txt"
  >>= return . parse
  >>= \games 
    -> print (totalPoints $ games)
    >> print (totalPoints $ map transform games)