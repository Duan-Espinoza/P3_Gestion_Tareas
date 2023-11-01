reemplazar_estado_por_nombre([], _, _, _, []).
reemplazar_estado_por_nombre([H|T], NombreBuscado, Encargado, Tarea, [H2|T2]) :-
    split_string(H, ",", "", [Nombre, Estado, Asignacion | FechaCierreResto]),
    downcase_atom(Nombre, NombreMin),
    downcase_atom(NombreBuscado, NombreBuscadoMin),
    (
        (NombreMin = NombreBuscadoMin, Estado = "pendiente") ->
        (
            atomic_list_concat([Nombre, Estado, Encargado, Tarea | FechaCierreResto], ",", H2)
        );
        (
            atomic_list_concat([Nombre, Estado, Asignacion | FechaCierreResto], ",", H2)
        )
    ),
    reemplazar_estado_por_nombre(T, NombreBuscado, Encargado, Tarea, T2).

% Ejemplo de uso
proyectos_modificados_con_nombre_encargado_y_tarea(NombreBuscado, Encargado, Tarea) :-
    read_file('../data/tareas.txt', Lineas),
    reemplazar_estado_por_nombre(Lineas, NombreBuscado, Encargado, Tarea, LineasModificadas),
    write_file('salida.txt', LineasModificadas).

% Predicados para leer y escribir archivos (sin cambios)
read_file(File, Lines) :-
    open(File, read, Stream),
    read_lines(Stream, Lines),
    close(Stream).

read_lines(Stream, []) :- at_end_of_stream(Stream).
read_lines(Stream, [Line|Lines]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_string(Stream, Line),
    read_lines(Stream, Lines).

write_file(File, Lines) :-
    open(File, write, Stream),
    write_lines(Stream, Lines),
    close(Stream).

write_lines(_, []).
write_lines(Stream, [Line|Lines]) :-
    write(Stream, Line),
    nl(Stream),
    write_lines(Stream, Lines).



