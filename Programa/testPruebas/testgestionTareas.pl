:- dynamic proyecto/5.

% Definición de cargar_tareas/0
cargar_tareas :-
    open('../data/tareas.txt', read, Stream),
    leer_tareas(Stream),
    close(Stream).


leer_tareas(Stream) :-
    read(Stream, Tarea),
    (
        Tarea == end_of_file -> true;
        assert(Tarea), leer_tareas(Stream)
    ).

% Agregar una tarea
agregar_tarea(Nombre, Estado, Asignaciones, FechaCierre) :-
    assert(proyecto(Nombre, Estado, Asignaciones, FechaCierre)).

% Guardar tareas en el archivo
guardar_tareas :-
    open('../data/tareas.txt', write, Stream),
    forall(proyecto(Nombre, Estado, Asignaciones, FechaCierre),
        (
            format(Stream, '~w,~w,~w,~w~n', [Nombre, Estado, Asignaciones, FechaCierre])
        )
    ),
    close(Stream).

% Asignar tarea a un proyecto existente
asignar_tarea(Nombre, Persona, Tarea) :-
    proyecto(Nombre, Estado, Asignaciones, FechaCierre),
    retract(proyecto(Nombre, Estado, Asignaciones, FechaCierre)),
    append_asignacion(Asignaciones, Persona, Tarea, NuevaAsignaciones),
    assert(proyecto(Nombre, Estado, NuevaAsignaciones, FechaCierre)).

append_asignacion([], Persona, Tarea, [[Persona, Tarea]]).
append_asignacion([[Persona, Tarea] | Resto], Persona, Tarea, [[Persona, Tarea] | Resto]).
append_asignacion([[OtraPersona, OtraTarea] | Resto], Persona, Tarea, [[OtraPersona, OtraTarea] | NuevaResto]) :-
    append_asignacion(Resto, Persona, Tarea, NuevaResto).

% Ejemplo para probarlo
ejemplo :-
    cargar_tareas,
    writeln('Tareas cargadas desde el archivo:'),
    forall(proyecto(Nombre, Estado, Asignaciones, FechaCierre),
           writeln([Nombre, Estado, Asignaciones, FechaCierre])),
    writeln(''),

    writeln('Agregando una nueva tarea...'),
    agregar_tarea('proyecto 8', 'Pendiente', 'sin asignar', 'sin fecha cierre'),

    writeln('Asignando tarea a proyecto 8...'),
    asignar_tarea('proyecto 8', 'Aaron', 'Backend'),

    writeln('Asignando tarea adicional a proyecto 8...'),
    asignar_tarea('proyecto 8', 'Duan', 'FrontEnd'),

    writeln('Guardando las tareas actualizadas en el archivo...'),
    guardar_tareas,
    
    writeln('Tareas guardadas en el archivo:'),
    cargar_tareas,
    forall(proyecto(Nombre, Estado, Asignaciones, FechaCierre),
           writeln([Nombre, Estado, Asignaciones, FechaCierre])),
    writeln('').
