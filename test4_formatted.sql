
SELECT e.employee_id,
       e.employee_name,
       d.department_name
FROM employees e
INNER JOIN departments d ON e.department_id = d.department_id;


SELECT p.project_id,
       p.project_name,
       e.employee_name
FROM projects p
INNER JOIN employees e ON p.project_lead = e.employee_id;