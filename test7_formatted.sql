SELECT e.name,
       e.salary
FROM employees e
WHERE e.salary >
    (SELECT AVG(subquery.salary)
     FROM
       (SELECT DISTINCT salary
        FROM employees emp
        WHERE emp.department_id = e.department_id
          AND emp.salary NOT IN
            (SELECT MAX(inner_emp.salary)
             FROM employees inner_emp
             WHERE inner_emp.department_id = e.department_id ) ) AS subquery);


SELECT *
FROM TABLE_NAME PIVOT (SUM(sales)
                       FOR MONTH IN ('January',
                                     'February',
                                     'March'));


SELECT Question,
       Response,
       COUNT(*) AS COUNT
FROM
  (SELECT 'Q1' AS Question,
          Q1 AS Response
   FROM survey_data
   UNION ALL SELECT 'Q2' AS Question,
                    Q2 AS Response
   FROM survey_data
   UNION ALL SELECT 'Q3' AS Question,
                    Q3 AS Response
   FROM survey_data) AS unpivoted_data
GROUP BY Question,
         Response
ORDER BY Question,
         Response;


SELECT Salesperson,
       [2022] AS Sales_2022,
       [2023] AS Sales_2023
FROM
  (SELECT Salesperson,
          YEAR,
          Sales
   FROM sales_data) AS source_data PIVOT (SUM(Sales)
                                          FOR YEAR IN ([2022],
                                                       [2023])) AS pivot_table;


SELECT Salesperson,
       '2022' AS YEAR,
       Sales_2022 AS Sales
FROM
  (SELECT Salesperson,
          SUM(CASE
                  WHEN YEAR = 2022 THEN Sales
                  ELSE 0
              END) AS Sales_2022,
          SUM(CASE
                  WHEN YEAR = 2023 THEN Sales
                  ELSE 0
              END) AS Sales_2023
   FROM sales_data
   GROUP BY Salesperson) AS pivoted_data
UNION ALL
SELECT Salesperson,
       '2023' AS YEAR,
       Sales_2023 AS Sales
FROM
  (SELECT Salesperson,
          SUM(CASE
                  WHEN YEAR = 2022 THEN Sales
                  ELSE 0
              END) AS Sales_2022,
          SUM(CASE
                  WHEN YEAR = 2023 THEN Sales
                  ELSE 0
              END) AS Sales_2023
   FROM sales_data
   GROUP BY Salesperson) AS pivoted_data;


SELECT Salesperson,
       '2022' AS YEAR,
       Sales_2022 AS Sales
FROM
  (SELECT Salesperson,
          SUM(CASE
                  WHEN YEAR = 2022 THEN Sales
                  ELSE 0
              END) AS Sales_2022,
          SUM(CASE
                  WHEN YEAR = 2023 THEN Sales
                  ELSE 0
              END) AS Sales_2023
   FROM sales_data
   GROUP BY Salesperson) AS pivoted_data
UNION ALL
SELECT Salesperson,
       '2023' AS YEAR,
       Sales_2023 AS Sales
FROM
  (SELECT Salesperson,
          SUM(CASE
                  WHEN YEAR = 2022 THEN Sales
                  ELSE 0
              END) AS Sales_2022,
          SUM(CASE
                  WHEN YEAR = 2023 THEN Sales
                  ELSE 0
              END) AS Sales_2023
   FROM sales_data
   GROUP BY Salesperson) AS pivoted_data;