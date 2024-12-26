SELECT users.name, roles.role_name, SUM(orders.total_amount) 
FROM users 
INNER JOIN roles ON users.role_id = roles.id 
LEFT JOIN orders ON users.id = orders.user_id 
WHERE users.name LIKE 'A%' AND orders.total_amount > 100 
GROUP BY users.role_id;

SELECT COUNT(*) AS total_users FROM users WHERE users.active = 1;
    