CREATE DATABASE IF NOT EXISTS school;
USE school;

CREATE TABLE IF NOT EXISTS students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  age INT,
  class VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS teachers (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  subject VARCHAR(100)
);

INSERT INTO students (name, age, class) VALUES
('Alice', 14, '8A'),
('Bob', 15, '9B'),
('Charlie', 13, '7A');

INSERT INTO teachers (name, subject) VALUES
('Mr. Ravi', 'Math'),
('Ms. Priya', 'Science');
