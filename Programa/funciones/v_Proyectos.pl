% Función que verifica si un usuario tiene una tarea que comienza con el prefijo dado

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
usuario_tiene_tarea(Usuario, Prefijo) :-
    tareas_usuario(Usuario, Tareas),
    member(Tarea, Tareas),
    sub_atom(Tarea, 0, _, _, Prefijo).

% Predicado para listar las tareas y costos de un usuario
listar_tareas(Usuario, Prefijo) :-
    (tareas_usuario(Usuario, Tareas) ->
        (usuario_tiene_tarea(Usuario, Prefijo) ->
            format("~w tiene una tarea que comienza con ~w registrada.~n", [Usuario, Prefijo]),
            listar_tareas_con_costo(Tareas, Prefijo)
        ;
            format("~w no tiene una tarea que comienza con ~w registrada.~n", [Usuario, Prefijo])
        )
    ;
        format("Usuario ~w no encontrado.~n", [Usuario])
    ).

% Predicado auxiliar para mostrar las tareas con costo que comienzan con un prefijo
listar_tareas_con_costo([], _).
listar_tareas_con_costo([Tarea | Resto], Prefijo) :-
    atomic_list_concat([TipoTarea, Costo], ':', Tarea),
    write('asasdas'),
    write(Costo),
    
    (sub_atom(TipoTarea, 0, _, _, Prefijo) ->
        format("Tarea: ~w, Costo: ~w~n", [TipoTarea, Costo])
    ;
        true % No coincide con el prefijo, omitir la tarea
    ),
    listar_tareas_con_costo(Resto, Prefijo).
