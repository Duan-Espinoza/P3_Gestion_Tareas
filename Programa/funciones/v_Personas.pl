:- discontiguous buscar_proyecto/1.
% Función para cargar el contenido del archivo en una lista de listas
load_file_content(FilePath, Rows) :-
    open(FilePath, read, File),
    read_file(File, Rows),
    close(File).

% Función auxiliar para leer el archivo línea por línea y dividir en elementos
read_file(File, []) :-
    at_end_of_stream(File), !.
read_file(File, [Line | Rest]) :-
    read_line_to_string(File, LineStr),
    split_string(LineStr, ",", " ,", Line),
    read_file(File, Rest).

runV:-
    write_header,
    buscar_proyecto('all').
% Función auxiliar para mostrar el encabezado
write_header :-
    write('╭────────────────────────────────────────────────────────────────╮'), nl,
    write('---     Proyectos en los que Empleados estan relacionado      -----'), nl,
    write('╰────────────────────────────────────────────────────────────────╯'), nl.

% Función para buscar proyectos por la persona asignada y mostrarlos en el formato deseado
buscar_proyecto(PersonaAsignada) :-
    PersonaAsignada == 'all',  % Verifica si se proporciona 'all'
    load_file_content('../data/tareas.txt', Rows),
    find_and_display_all(Rows).

% Función auxiliar para mostrar todos los proyectos cuyo segundo elemento no sea 'sin asignar'
find_and_display_all([]).
find_and_display_all([[Nombre, Estado, Persona, Tarea, Fecha | _] | Rest]) :-
    Estado \= 'sin asignar',  % Verifica si el estado no es 'sin asignar'
    format('  • Proyecto:             ~w~n', [Nombre]),
    format('  • Estado:               ~w~n', [Estado]),
    format('  • Encargado:          ★ ~w~n', [Persona]),
    format('  • Tarea:                ~w~n', [Tarea]),
    format('  • Fecha de Cierre:  ~w~n', [Fecha]), nl,
    find_and_display_all(Rest).
find_and_display_all([_ | Rest]) :-
    find_and_display_all(Rest).


% Ejemplo de uso
% Llama a buscar_proyecto con la persona asignada que quieres buscar, por ejemplo, "hansol"
% y mostrará los proyectos asignados a esa persona en el formato deseado.
