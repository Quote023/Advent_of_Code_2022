DROP TABLE IF EXISTS input;
CREATE TABLE input (
  items TEXT
);

.separator " " "\n"
.import "../input.txt" input

CREATE TEMP VIEW letters AS
    WITH RECURSIVE letters(id,side,pos,letter) AS (
        SELECT 1,'L', 1, substr(input.items,1,1) FROM input WHERE ROWID = 1
        UNION ALL
        SELECT
            CASE WHEN pos >= LENGTH(b.items)  THEN l.id + 1 ELSE l.id END,
            CASE WHEN pos < LENGTH(b.items)/2  THEN 'L' ELSE 'R' END,
            CASE WHEN pos >= LENGTH(b.items)  THEN 0 ELSE pos + 1 END,
            CASE WHEN pos >= LENGTH(b.items)  THEN NULL ELSE substr(b.items,pos + 1,1) END
        FROM letters l
        JOIN input b
        ON l.id == b.ROWID
    )
    SELECT  * FROM letters WHERE letter IS NOT NULL;;

CREATE TEMP VIEW priorities AS
    SELECT
        CASE WHEN unicode(l.letter) >= 98 THEN  unicode(l.letter) - 96 ELSE unicode(l.letter) - 38 END as priority
    FROM letters l
    JOIN letters r
    ON l.id = r.id AND l.side != r.side AND l.letter = r.letter
    GROUP BY l.id;

SELECT '1º ',SUM(priority) FROM priorities;

CREATE TEMP VIEW elf_groups AS
SELECT
    ROWID,
    ((ROWID - 1) / 3) + 1 as gr,
    items
FROM input;

CREATE TEMP VIEW letters2 AS
    WITH RECURSIVE letters2(id,gr,pos,letter) AS (
        SELECT 1,b.gr, 1, substr(b.items,1,1) FROM elf_groups b WHERE ROWID = 1
        UNION ALL
        SELECT
            CASE WHEN pos >= LENGTH(b.items)  THEN l.id + 1 ELSE l.id END,
            b.gr,
            CASE WHEN pos >= LENGTH(b.items)  THEN 0 ELSE pos + 1 END,
            CASE WHEN pos >= LENGTH(b.items)  THEN NULL ELSE substr(b.items,pos + 1,1) END
        FROM letters2 l
        JOIN elf_groups b
        ON l.id == b.ROWID
    )
    SELECT  * FROM letters2 WHERE letter IS NOT NULL;

CREATE TEMP VIEW badges AS
    SELECT
        i1.letter,
        CASE WHEN unicode(i1.letter) >= 98 THEN  unicode(i1.letter) - 96 ELSE unicode(i1.letter) - 38 END as priority
    FROM letters2 i1
    JOIN letters2 i2
    JOIN letters2 i3
    ON
        i1.id != i2.id AND i2.id != i3.id AND i1.id != i3.id AND
        i1.gr == i2.gr AND i2.gr == i3.gr AND i1.gr == i3.gr AND
        i1.letter == i2.letter AND i2.letter == i3.letter AND i1.letter == i3.letter
    GROUP BY i1.gr;

select '2º ', SUM(priority) from badges;