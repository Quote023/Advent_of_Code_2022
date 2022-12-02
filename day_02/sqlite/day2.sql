DROP TABLE IF EXISTS moves;

CREATE TABLE moves (
  opponent CHAR(1) CHECK( opponent IN ('A','B','C') ),
  you CHAR(1) CHECK( you IN ('X','Y','Z') ) 
);

.separator " " "\n"
.import "../input.txt" moves

WITH points(shapeScore,roundScore) AS (
  SELECT 
    (CASE you WHEN 'X' THEN 1 WHEN 'Y' THEN 2 WHEN 'Z' THEN 3 END) AS shapeScore,
    (CASE opponent 
      WHEN 'A' THEN (CASE you WHEN 'X' THEN 3 WHEN 'Y' THEN 6 ELSE 0 END) 
      WHEN 'B' THEN (CASE you WHEN 'Y' THEN 3 WHEN 'Z' THEN 6 ELSE 0 END) 
      WHEN 'C' THEN (CASE you WHEN 'Z' THEN 3 WHEN 'X' THEN 6 ELSE 0 END) 
    END) AS roundScore  
  FROM moves
)

SELECT '1º', SUM(shapeScore + roundScore) FROM points