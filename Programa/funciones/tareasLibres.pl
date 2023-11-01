% Predicado principal para procesar el archivo de texto
mostrar_proyectosPendientes:-
    open('../data/tareas.txt', read, Stream), 
    read_proyectos(Stream),
    close(Stream).

% Predicado para leer y procesar los proyectos del archivo de texto
read_proyectos(Stream) :-
    read_line_to_string(Stream, Line),
    ( Line \= end_of_file ->
        parse_proyecto(Line, Proyecto),
        mostrar_info_proyecto(Proyecto),
        read_proyectos(Stream)
    ; true
    ).

% Predicado para analizar una línea y extraer los datos del proyecto
parse_proyecto(Line, Proyecto) :-
    split_string(Line, ",", ",", Items),
    length(Items, NumItems),
    (NumItems >= 3 ->
        [NombreTarea, Estado, Encargado | Rest] = Items,
        (length(Rest, RestLength), RestLength > 0 ->
            Rest = [Tarea | FechaCierreList],
            atomic_list_concat(FechaCierreList, ",", FechaCierre)
        ; Tarea = "sin tarea", FechaCierre = "sin fecha cierre"),
        (string_lower(Estado, EstadoLower), EstadoLower = "pendiente" -> 
            Proyecto = proyecto(NombreTarea, Estado, Encargado, Tarea, FechaCierre)
        ; Proyecto = invalid)
    ; Proyecto = invalid).

% Función para mostrar la información de un proyecto
mostrar_info_proyecto(Proyecto) :-
    (Proyecto = proyecto(NombreTarea, Estado, Encargado, Tarea, FechaCierre) ->
        write('╭────────────────────────────────────────────────╮'), nl,
        format('         Proyecto: ~w~n', [NombreTarea]),
        write('╰────────────────────────────────────────────────╯'), nl,
        format('  • Estado: ~w~n', [Estado]),
        format('  • Encargado: ~w~n', [Encargado]),
        format('  • Tarea: ~w~n', [Tarea]),
        format('  • Fecha de Cierre: ~w~n~n', [FechaCierre])     
    ; true).
