DROP TABLE IF EXISTS input;
CREATE TABLE input (
  fst TEXT,
  snd TEXT
);

.separator "," "\n"
.import "../input.txt" input

CREATE TEMP VIEW ranges AS
  SELECT
    CAST(SUBSTR(fst,1,INSTR(fst,'-') - 1) AS INT) AS l1,
    CAST(SUBSTR(fst,INSTR(fst,'-') + 1) AS INT) AS r1,
    CAST(SUBSTR(snd,1,INSTR(snd,'-') - 1) AS INT) AS l2,
    CAST(SUBSTR(snd,INSTR(snd,'-') + 1) AS INT) AS r2
  FROM input;

SELECT '1º', COUNT(*) FROM ranges WHERE (l1 >= l2 AND r1 <= r2) OR (l1 <= l2 AND r1 >= r2);
SELECT '2º', COUNT(*)
FROM ranges
WHERE
  (l2 >= l1 AND l2 <= r1) OR
  (r2 >= l1 AND r2 <= r1) OR
  (l1 >= l2 AND l1 <= r2)