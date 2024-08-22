![image](https://github.com/user-attachments/assets/0b44eac0-2987-4aaf-9fc1-0c48f8d20566)

---

# MySQL Advanced Database Concepts Guide

## Table of Contents

1. [Introduction](#introduction)
2. [Creating Tables with Constraints](#creating-tables-with-constraints)
   - [Primary Key Constraint](#primary-key-constraint)
   - [Foreign Key Constraint](#foreign-key-constraint)
   - [Unique Constraint](#unique-constraint)
   - [Check Constraint](#check-constraint)
   - [Not Null Constraint](#not-null-constraint)
3. [Optimizing Queries with Indexes](#optimizing-queries-with-indexes)
   - [What is an Index?](#what-is-an-index)
   - [How to Add Indexes](#how-to-add-indexes)
   - [When to Use Indexes](#when-to-use-indexes)
4. [Stored Procedures and Functions](#stored-procedures-and-functions)
   - [What is a Stored Procedure?](#what-is-a-stored-procedure)
   - [How to Create a Stored Procedure](#how-to-create-a-stored-procedure)
   - [What is a Function?](#what-is-a-function)
   - [How to Create a Function](#how-to-create-a-function)
5. [Views in MySQL](#views-in-mysql)
   - [What is a View?](#what-is-a-view)
   - [How to Create a View](#how-to-create-a-view)
   - [Benefits of Using Views](#benefits-of-using-views)
6. [Triggers in MySQL](#triggers-in-mysql)
   - [What is a Trigger?](#what-is-a-trigger)
   - [How to Implement a Trigger](#how-to-implement-a-trigger)
   - [Common Use Cases for Triggers](#common-use-cases-for-triggers)

## Introduction

MySQL is a powerful relational database management system (RDBMS) that supports advanced features like constraints, indexes, stored procedures, functions, views, and triggers. These features allow you to create robust, efficient, and maintainable database systems. This guide will walk you through the key concepts and practical implementations of these features in MySQL.

## Creating Tables with Constraints

Constraints in MySQL are used to enforce rules on the data in a table. They ensure the accuracy and reliability of the data. Common constraints include primary keys, foreign keys, unique constraints, check constraints, and not null constraints.

### Primary Key Constraint

A primary key uniquely identifies each row in a table. It must contain unique values and cannot be NULL.

```sql
CREATE TABLE users (
    user_id INT AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    PRIMARY KEY (user_id)
);
```

### Foreign Key Constraint

A foreign key links two tables together, enforcing referential integrity. It ensures that the value in a column (or a group of columns) matches a value in the primary key of another table.

```sql
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT,
    user_id INT,
    order_date DATE,
    PRIMARY KEY (order_id),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
```

### Unique Constraint

The unique constraint ensures that all values in a column are distinct.

```sql
CREATE TABLE products (
    product_id INT AUTO_INCREMENT,
    product_name VARCHAR(100) UNIQUE,
    price DECIMAL(10, 2),
    PRIMARY KEY (product_id)
);
```

### Check Constraint

The check constraint ensures that all values in a column satisfy a specific condition. (Note: MySQL added support for the `CHECK` constraint starting from version 8.0.16.)

```sql
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    age INT,
    salary DECIMAL(10, 2),
    PRIMARY KEY (employee_id),
    CHECK (age >= 18)
);
```

### Not Null Constraint

The not null constraint ensures that a column cannot have a NULL value.

```sql
CREATE TABLE departments (
    department_id INT AUTO_INCREMENT,
    department_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (department_id)
);
```

## Optimizing Queries with Indexes

### What is an Index?

An index is a database object that improves the speed of data retrieval operations on a table at the cost of additional storage space and maintenance time.

### How to Add Indexes

You can add an index to one or more columns to improve query performance.

```sql
CREATE INDEX idx_user_email ON users(email);
```

This creates an index on the `email` column of the `users` table, speeding up queries that filter or sort by `email`.

### When to Use Indexes

Indexes are particularly useful for:

- Columns frequently used in `WHERE` clauses.
- Columns involved in joins.
- Columns used in sorting (`ORDER BY`).
- Columns used in aggregate functions.

However, excessive indexing can slow down data modification operations like `INSERT`, `UPDATE`, and `DELETE`.

## Stored Procedures and Functions

### What is a Stored Procedure?

A stored procedure is a set of SQL statements that can be stored in the database and executed as a single unit. They can accept input parameters and return results.

### How to Create a Stored Procedure

```sql
DELIMITER //

CREATE PROCEDURE GetUserByEmail(IN user_email VARCHAR(100))
BEGIN
    SELECT * FROM users WHERE email = user_email;
END //

DELIMITER ;
```

You can call this stored procedure using:

```sql
CALL GetUserByEmail('example@example.com');
```

### What is a Function?

A function is similar to a stored procedure but is intended to return a single value. Functions can be used in SQL statements wherever an expression is allowed.

### How to Create a Function

```sql
DELIMITER //

CREATE FUNCTION GetTotalOrders(userId INT) 
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_orders INT;
    SELECT COUNT(*) INTO total_orders FROM orders WHERE user_id = userId;
    RETURN total_orders;
END //

DELIMITER ;
```

You can use this function in a query:

```sql
SELECT GetTotalOrders(1);
```

## Views in MySQL

### What is a View?

A view is a virtual table based on the result set of an SQL query. It does not store data but provides a way to simplify complex queries.

### How to Create a View

```sql
CREATE VIEW UserOrders AS
SELECT users.username, orders.order_id, orders.order_date
FROM users
JOIN orders ON users.user_id = orders.user_id;
```

You can query the view just like a regular table:

```sql
SELECT * FROM UserOrders WHERE username = 'JohnDoe';
```

### Benefits of Using Views

- Simplify complex queries.
- Provide a layer of abstraction.
- Enhance security by restricting access to specific columns or rows.
- Present data in a specific format.

## Triggers in MySQL

### What is a Trigger?

A trigger is a database object that is automatically executed or fired when certain events occur. Triggers can be used to enforce business rules, maintain audit trails, or synchronize tables.

### How to Implement a Trigger

```sql
CREATE TRIGGER BeforeInsertOrder
BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE user_exists INT;
    SELECT COUNT(*) INTO user_exists FROM users WHERE user_id = NEW.user_id;
    IF user_exists = 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'User does not exist';
    END IF;
END;
```

This trigger checks if the `user_id` exists in the `users` table before inserting a new order. If the user doesn't exist, the trigger raises an error.

### Common Use Cases for Triggers

- Enforcing business rules (e.g., preventing negative stock levels).
- Automatically updating related tables.
- Maintaining audit trails (e.g., logging changes to critical data).
- Synchronizing data between tables.

---
