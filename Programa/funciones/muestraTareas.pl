% Predicado principal para procesar el archivo de texto
mostrar_proyectos(NombreArchivo) :-
    open(NombreArchivo, read, Stream), % Reemplaza 'tu_archivo.txt' con el nombre de tu archivo
    read_proyectos(Stream),
    close(Stream).

% Predicado para leer y procesar los proyectos del archivo de texto
read_proyectos(Stream) :-
    read_line_to_string(Stream, Line),
    ( Line \= end_of_file ->
        split_string(Line, ",", ",", Items),
        parse_proyecto(Items, NombreTarea, Estado, Encargado, Tarea, FechaCierre),
        (Encargado \= "sin asignar" -> mostrar_info_proyecto_asignado(NombreTarea, Estado, Encargado, Tarea, FechaCierre) ; mostrar_info_proyecto_sin_asignar(NombreTarea, Estado, FechaCierre)),
        read_proyectos(Stream)
    ; true
    ).

% Predicado para analizar una línea y extraer los datos del proyecto
parse_proyecto(Items, NombreTarea, Estado, Encargado, Tarea, FechaCierre) :-
    [NombreTarea, Estado, Encargado | Rest] = Items,
    (Rest = ["sin fecha cierre"] ->
        Tarea = "sin tarea",
        FechaCierre = "sin fecha cierre"
    ;
    Rest = [Tarea, "sin fecha cierre"],
    FechaCierre = "sin fecha cierre").

% Función para mostrar la información de una tarea cuando el encargado está asignado
mostrar_info_proyecto_asignado(NombreTarea, Estado, Encargado, Tarea, FechaCierre) :-
    write('╭────────────────────────────────────────────────╮'), nl,
    format('         Proyecto: ~w~n', [NombreTarea]),
    write('╰────────────────────────────────────────────────╯'), nl,
    format('  • Estado: ~w~n', [Estado]),
    format('  • Encargado: ~w~n', [Encargado]),
    format('  • Tarea: ~w~n', [Tarea]),
    format('  • Fecha de Cierre: ~w~n~n', [FechaCierre]).

% Función para mostrar la información de una tarea cuando el encargado es "sin asignar"
mostrar_info_proyecto_sin_asignar(NombreTarea, Estado, FechaCierre) :-
    write('╭────────────────────────────────────────────────╮'), nl,
    format('         Proyecto: ~w~n', [NombreTarea]),
    write('╰────────────────────────────────────────────────╯'), nl,
    format('  • Estado: ~w~n', [Estado]),
    format('  • Encargado: sin asignar~n'),
    format('  • Fecha de Cierre: ~w~n~n', [FechaCierre]).


