CREATE TEMP TABLE tmpElves (
  calories INTEGER
);

.separator " " "\n"
.import "../input.txt" tmpElves

CREATE TEMP VIEW IF NOT EXISTS blank_lines AS SELECT ROWID as line FROM tmpElves where calories = '';
CREATE TEMP VIEW IF NOT EXISTS limits AS SELECT LAG(line,1,0) OVER () as start,line as end FROM blank_line;

DROP TABLE IF EXISTS elves;
CREATE TABLE elves AS
    SELECT limits.start as start, SUM(tmpElves.calories) as calories
    FROM limits
    JOIN tmpElves ON tmpElves.ROWID BETWEEN limits.start and limits.end
    GROUP BY 1 ;


SELECT '1º', MAX(calories) FROM elves;
SELECT '2º', SUM(calories) FROM (SELECT calories FROM elves ORDER BY calories DESC LIMIT 3 );
