# smartbusiness-test-task


I implemented this database as a nice way to demonstrate my experience with SQL and RDBMS. This database can be used to manage the core functionalities of an e-commerce store's order management system, providing an organized and efficient structure to handle interactions between customers, products, orders, and addresses. I implemented the database using PostgresQL. THe code and example queries you can find in `order_management_system.sql` file. The diagram describing tables and relations between them is shown below. 

![Screen Shot 2024-12-12 at 1 42 22 PM](https://github.com/user-attachments/assets/40c1b6c5-8461-498f-aef9-648ecfc3a689)

We can track orders like this (for concrete customer)

```
SELECT o.order_id, o.total_price, o.status, o.created_at
FROM orders o
WHERE o.customer_id = 1;
```

The output will be 

```
 order_id | total_price | status  |         created_at         
----------+-------------+---------+----------------------------
        1 |     1249.97 | Pending | 2024-12-12 13:21:18.564942
(1 row)
```

Or in another way (get all the orders)

```
SELECT o.order_id, o.total_price, o.status, c.first_name, c.last_name, c.email
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;
```

which will give us the following result:

```
 order_id | total_price |  status   | first_name | last_name |         email          
----------+-------------+-----------+------------+-----------+------------------------
        1 |     1249.97 | Pending   | John       | Doe       | john.doe@example.com
        2 |      249.98 | Completed | Jane       | Smith     | jane.smith@example.com
(2 rows)
```
