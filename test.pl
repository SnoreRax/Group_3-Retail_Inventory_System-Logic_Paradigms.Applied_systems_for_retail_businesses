%Remember to write down notes for each predicate (or in other words 'function')
:- use_module(library(odbc)).

%Use these to use the database server
open :- odbc_connect('prolog_database', _, [alias(db)]).
close :- odbc_disconnect(db).

%Common predicate for reading input (So that stuff doesn't get confusing later)
read_line(Line) :-
    write('Enter '),
    read(Line).

%Starts system; provides CRUD options
begin :-
    repeat,
    writeln('Welcome to Generic Retails!'), writeln('Options:'), writeln('1. Add Product'), writeln('2. Show Products'),
    writeln('3. Update exisiting products'), writeln('4. Delete existing product'), writeln('5. Exit'),
    read_line(Line),
    format('Option ~w has been chosen.', [Line]), nl,
    choice(Line).

%Create Function
choice(1) :-
    writeln('Please enter the following Details:'),
    writeln('Name of Product'),
    read_line(Name),
    writeln('Description of Product (List only its category)'),
    read_line(Description),
    writeln('Amount of Product in storage'),
    read_line(Quantity),
    writeln('Price of product'),
    read_line(Price),
    add_product(Name, Description, Quantity, Price),
    writeln('New product data successfully added.'), nl.

%Read Function
choice(2) :-
    read_product,
    nl.

%Update Function
choice(3) :-
    write('Bye now').

%Delete Function
choice(4) :-
    write('Okay').

%Exit
choice(5) :-
    nl, write('Exiting...'), !.

add_product(Name, Description, Quantity, Price) :-
    open,
    concat_atom(['INSERT INTO tbl_product VALUES (\'', Name, '\', \'', Description, '\', ', Quantity, ', ', Price, ')'], Query),
    odbc_query(db, Query),
    close.

read_product :-
    open,
    findall(RName, odbc_query(db, 'SELECT product_name FROM tbl_product', row(RName)), Name),
    findall(RDesc, odbc_query(db, 'SELECT product_description FROM tbl_product', row(RDesc)), Description),
    findall(RQty, odbc_query(db, 'SELECT product_quantity FROM tbl_product', row(RQty)), Quantity),
    findall(RPrc, odbc_query(db, 'SELECT product_price FROM tbl_product', row(RPrc)), Price),
    write('Name         :'), writeln(Name),
    write('Description  :'), writeln(Description),
    write('Quantity     :'), writeln(Quantity),
    write('Price        :'), writeln(Price),
    close.