% Predicado para reemplazar el estado por "ACTIVO" solo para proyectos con un nombre específico
reemplazar_estado_por_nombre([], _, []).
reemplazar_estado_por_nombre([H|T], NombreBuscado, [H2|T2]) :-
    split_string(H, ",", "", [Nombre, Estado, Asignacion, FechaCierre]),
    downcase_atom(Nombre, NombreMin),
    downcase_atom(NombreBuscado, NombreBuscadoMin),
    (NombreMin = NombreBuscadoMin ->
        EstadoModificado = "activo";
        EstadoModificado = Estado
    ),
    string_concat(Nombre, ",", NombreConcat),
    string_concat(NombreConcat, EstadoModificado, NuevaFila),
    string_concat(NuevaFila, ",", NuevaFila2),
    string_concat(NuevaFila2, Asignacion, NuevaFila3),
    string_concat(NuevaFila3, ",", NuevaFila4),
    string_concat(NuevaFila4, FechaCierre, H2),
    reemplazar_estado_por_nombre(T, NombreBuscado, T2).

% Ejemplo de uso
proyectos_modificados_con_nombre(NombreBuscado) :-
    read_file('../data/tareas.txt', Lineas),
    reemplazar_estado_por_nombre(Lineas, NombreBuscado, LineasModificadas),
    write_file('salida.txt', LineasModificadas).

% Predicados para leer y escribir archivos (sin cambios)
read_file(File, Lines) :-
    open(File, read, Stream),
    read_lines(Stream, Lines),
    close(Stream).

read_lines(Stream, []) :-
    at_end_of_stream(Stream).

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

% Validaciones para Creacion y eliminacion de archivos

eliminar_archivo(NombreArchivo) :-
    atomic_list_concat(['rm', NombreArchivo], ' ', Comando),
    shell(Comando, _).

crear_archivo(NombreArchivo, Contenido) :-
    open(NombreArchivo, write, Stream),
    write(Stream, Contenido),
    close(Stream).

cambiar_nombre_archivo(AntiguoNombre, NuevoNombre) :-
    rename_file(AntiguoNombre, NuevoNombre).
