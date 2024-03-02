%Library is used to access odbc, which is used to access the database
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
    writeln('Welcome to Generic Retails!'), writeln('Options:'), writeln('1. Add Product'), writeln('2. Show Products'),
    writeln('3. Update exisiting products'), writeln('4. Delete existing product'), writeln('5. Exit'),
    read_line(Line),
    format('Option ~w has been chosen.', [Line]), nl,
    choice(Line).

%Option 1 - Add New Product
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
    format('New Data: ~w, ~w, ~w, ~w', [Name, Description, Quantity, Price]), nl,
    add_product(Name, Description, Quantity, Price),
    writeln('New product data successfully added.'), 
    nl, 
    begin.

%Option 2 - Read All Products
choice(2) :-
    writeln('Select product to view (or type "all" to view all)'),
    read_line(Name),
    read_product(Name),
    nl, 
    begin.

%Option 3 - Update Products
choice(3) :-
    writeln('Specify product to update'),
    read_line(Name),
    writeln('Updated Quantity'),
    read_line(Quantity),
    writeln('Updated Price'),
    read_line(Price),
    format('Updated Data: ~w, ~w, ~w', [Name, Quantity, Price]), nl,
    update_product(Name, Quantity, Price),
    writeln('Update complete.'),
    nl,
    begin.

%Option 4 - Delete Products
choice(4) :-
    writeln('Specify product to delete'),
    read_line(Product),
    delete_product(Product),
    writeln('Deletion successful.'),
    nl,
    begin.

%Exit
choice(5) :-
    nl, write('Exiting...'), !.

%Create Function - Uses 4 attributes to send to the SQL Database
add_product(Name, Description, Quantity, Price) :-
    open,
    concat_atom(['INSERT INTO tbl_product VALUES (\'', Name, '\', \'', Description, '\', ', Quantity, ', ', Price, ')'], Query),
    odbc_query(db, Query),
    close.

%Read Function - Reads all entries from SQL Database
read_product('all') :-
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

%Read Function 2 - Reads only specific data entry
read_product(Product) :-
    open,

    concat_atom(['SELECT product_name FROM tbl_product WHERE product_name = \'', Product, '\''], Query1),
    concat_atom(['SELECT product_description FROM tbl_product WHERE product_name = \'', Product, '\''], Query2),
    concat_atom(['SELECT product_quantity FROM tbl_product WHERE product_name = \'', Product, '\''], Query3),
    concat_atom(['SELECT product_price FROM tbl_product WHERE product_name = \'', Product, '\''], Query4),

    findall(RName, odbc_query(db, Query1, row(RName)), Name),
    findall(RDesc, odbc_query(db, Query2, row(RDesc)), Description),
    findall(RQty, odbc_query(db, Query3, row(RQty)), Quantity),
    findall(RPrc, odbc_query(db, Query4, row(RPrc)), Price),

    write('Name         :'), writeln(Name),
    write('Description  :'), writeln(Description),
    write('Quantity     :'), writeln(Quantity),
    write('Price        :'), writeln(Price),
    close.

%Update Function - Updates specific product for both Quantity and Price
update_product(Name, Quantity, Price) :-
  open,
  concat_atom(['UPDATE tbl_product SET product_quantity = ', Quantity, ', product_price = ', Price, ' WHERE product_name = \'', Name, '\''], Query),
  odbc_query(db, Query),
  close.

%Delete Function - Deletes specific products 
delete_product(Name) :-
    open,
    concat_atom(['DELETE FROM tbl_product WHERE product_name = \'', Name, '\''], Query),
    odbc_query(db, Query),
    close.