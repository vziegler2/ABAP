REPORT z_ob_re_selection_screen_006.
**Standardabfrage
SELECT price,
       COUNT( DISTINCT fldate ) AS flight_dates,
       COUNT( * ) AS entries,
       MIN( price ) AS min,
       MAX( price ) AS max,
       AVG( DISTINCT price ) AS avg,
       SUM( price ) AS sum
FROM sflight AS a
INNER JOIN scarr AS b
ON a~carrid = b~carrid
WHERE price BETWEEN 500 AND 3000 AND
      url LIKE '%www%' AND
      a~carrid IN ('SQ', 'JL', 'LH')
GROUP BY price
HAVING COUNT( * ) > 10
ORDER BY entries DESCENDING, price
INTO TABLE @DATA(it_tab)
UP TO 200 ROWS.