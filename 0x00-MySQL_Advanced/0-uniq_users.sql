-- Creates a table users
CREATE TABLE IF NOT EXISTS users (
    id INT NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    name VARCHAR(255),
    PRIMARY KEY (id)
);
