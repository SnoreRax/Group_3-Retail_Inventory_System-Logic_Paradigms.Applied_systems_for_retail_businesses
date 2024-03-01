%Remember to write down notes for each predicate (or in other words 'function')

%Common predicate for reading input (So that stuff doesn't get confusing later)
read_line(Line) :-
    write('Enter: '),
    read(Line).

%Starts system; provides CRUD options
begin :-
    writeln('Welcome to Generic Retails!'), writeln('Options:'), writeln('1. Add Product'), writeln('2. Show Products'),
    writeln('3. Update exisiting products'), writeln('4. Delete existing product'), writeln('5. Exit'),
    read_line(Line),
    format('Option ~w has been chosen.', [Line]).