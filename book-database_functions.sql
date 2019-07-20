CREATE TABLE books 
	(
		book_id INT NOT NULL AUTO_INCREMENT,
		title VARCHAR(100),
		author_fname VARCHAR(100),
		author_lname VARCHAR(100),
		released_year INT,
		stock_quantity INT,
		pages INT,
		PRIMARY KEY(book_id)
	);

INSERT INTO books (title, author_fname, author_lname, released_year, stock_quantity, pages)
VALUES
('The Namesake', 'Jhumpa', 'Lahiri', 2003, 32, 291),
('Norse Mythology', 'Neil', 'Gaiman',2016, 43, 304),
('American Gods', 'Neil', 'Gaiman', 2001, 12, 465),
('Interpreter of Maladies', 'Jhumpa', 'Lahiri', 1996, 97, 198),
('A Hologram for the King: A Novel', 'Dave', 'Eggers', 2012, 154, 352),
('The Circle', 'Dave', 'Eggers', 2013, 26, 504),
('The Amazing Adventures of Kavalier & Clay', 'Michael', 'Chabon', 2000, 68, 634),
('Just Kids', 'Patti', 'Smith', 2010, 55, 304),
('A Heartbreaking Work of Staggering Genius', 'Dave', 'Eggers', 2001, 104, 437),
('Coraline', 'Neil', 'Gaiman', 2003, 100, 208),
('What We Talk About When We Talk About Love: Stories', 'Raymond', 'Carver', 1981, 23, 176),
("Where I'm Calling From: Selected Stories", 'Raymond', 'Carver', 1989, 12, 526),
('White Noise', 'Don', 'DeLillo', 1985, 49, 320),
('Cannery Row', 'John', 'Steinbeck', 1945, 95, 181),
('Oblivion: Stories', 'David', 'Foster Wallace', 2004, 172, 329),
('Consider the Lobster', 'David', 'Foster Wallace', 2005, 92, 343);

select * from books;

select CONCAT(author_fname, ' ', author_lname) as one_column_both_names from books;

select CONCAT_WS(' - ', author_fname, author_lname) as with_dash_both_names from books;

select substring ('Hello World', 1, 4);

select substring(title, 1, 10) as 'short title' from books;

select concat(
substring(title, 1,10),
'...'
)as mine
from books;

# first homework udemy SQL

# 1st task

select reverse(upper('Why my cat is so fat?'));

# 2nd task
select
	replace
    (
    concat('I', ' ', 'like', ' ', 'cats'),
    ' ',
    '_'
    );
    
    # 3rd task

select 
	replace(title, ' ','-->') as title
from books;

# task 4

select 
	author_lname as forwards,
    reverse(author_lname) as backwards
from books;

# task 5

select 
upper(concat(author_fname, ' ', author_lname))
from books;

# task 6

select 
	concat(title, ' was released in ', released_year) as rok_wydania
from books;

# task 7

select
	title,
    char_length(title) as num_of_strings
from books;

# task 8

select
	concat(substr(title, 1, 10), '...') as skrót,
	concat(author_lname, ',',author_fname) as man,
    concat(stock_quantity, ' in stock') as quantity
from books;