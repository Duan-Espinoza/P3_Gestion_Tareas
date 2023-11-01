%Funcion que verifica si un usuario tiene una tarea que comienza con el prefijo dado

% Predicado para cargar los datos desde el archivo
cargar_datos :-
    open('../data/personas.txt', read, Stream),
    leer_lineas(Stream),
    close(Stream).

% Predicado para leer las líneas del archivo
leer_lineas(Stream) :-
    read_line_to_string(Stream, Linea),
    (Linea = end_of_file ; procesar_linea(Linea), leer_lineas(Stream)).

% Predicado para procesar una línea y almacenar los datos
procesar_linea(Linea) :-
    atomic_list_concat([Nombre, Puesto, Experiencia | Tareas], ',', Linea),
    assert(tareas_usuario(Nombre, Tareas)).

% Predicado para verificar si un usuario tiene una tarea que comienza con el prefijo dado
usuario_tiene_tarea(Usuario, Prefijo) :- %Esta se usa
    tareas_usuario(Usuario, Tareas),
    member(Tarea, Tareas),
    sub_atom(Tarea, 0, _, _, Prefijo).


% Predicado para listar las tareas y costos de un usuario
listar_tareas(Usuario, Prefijo) :-
    (tareas_usuario(Usuario, _) ->
        (usuario_tiene_tarea(Usuario, Prefijo) ->
            format("~w tiene una tarea que comienza con ~w registrada.~n", [Usuario, Prefijo])
        ;
            format("~w no tiene una tarea que comienza con ~w registrada.~n", [Usuario, Prefijo])
        )
    ;
        format("Usuario ~w no encontrado.~n", [Usuario])
    ).

% Predicado auxiliar para mostrar las tareas y costos
listar_tareas_aux([]).
listar_tareas_aux([Tarea | Resto]) :-
    atomic_list_concat([TipoTarea, Costo], ':', Tarea),
    format("~w: ~w~n", [TipoTarea, Costo]),
    listar_tareas_aux(Resto).
