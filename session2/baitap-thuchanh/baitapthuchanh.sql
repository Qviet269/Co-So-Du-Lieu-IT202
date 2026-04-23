CREATE DATABASE my_bobbie_db;

USE my_bobbie_db;

CREATE TABLE Persons (
    personId int NOT NULL PRIMARY KEY,
    LastName char(15),
    firtName char(255) 	NOT NULL,
    email char(100) NOT NULL UNIQUE,
	address char(255) NOT NULL,
    city char(255)
    );


CREATE TABLE bobbies (
	id INT NOT NULL PRIMARY KEY,
    name CHAR(100) CHECK(length(name) > 4),
    personId int
);

INSERT INTO bobbies VALUES (1, "CHƠI G", 1)