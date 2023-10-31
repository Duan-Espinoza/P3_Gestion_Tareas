% Hechos para tareas asignadas a proyectos
% tarea_asignada(Proyecto, NombreTarea, Persona, Estado).
tarea_asignada('Proyecto1', 'Tarea1', 'Persona1', pendiente).
tarea_asignada('Proyecto1', 'Tarea2', 'Persona2', activa).
tarea_asignada('Proyecto2', 'Tarea3', 'Persona1', pendiente).

% Hechos para tipos de tareas
% tipo_tarea(NombrePersona, TipoTarea).
tipo_tarea('Persona1', requerimientos).
tipo_tarea('Persona1', desarrollo).
tipo_tarea('Persona2', desarrollo).
tipo_tarea('Persona2', qa).
tipo_tarea('Persona3', desarrollo).
tipo_tarea('Persona3', frontend).

% Regla para buscar tareas libres (pendientes)
buscar_tareas_libres(Tarea, Persona) :-
    tarea_asignada(_, Tarea, Persona, pendiente).

% Regla para mostrar tareas libres
mostrar_tareas_libres :-
    write('Tareas libres (pendientes):'), nl,
    tarea_asignada(Proyecto, Tarea, Persona, pendiente),
    write('Proyecto: '), write(Proyecto), nl,
    write('Tarea: '), write(Tarea), nl,
    write('Persona: '), write(Persona), nl, nl,
    fail. 

% Regla para mostrar tareas que una persona podría desarrollar
mostrar_tareas_asignables_a_persona(Persona) :-
    write('Tareas que '), write(Persona), write(' podría desarrollar:'), nl,
    tipo_tarea(Persona, TipoTarea),
    tarea_asignada(Proyecto, Tarea, Persona, pendiente),
    tipo_tarea(Persona, TipoTareaTarea),
    TipoTareaTarea = TipoTarea,
    write('Proyecto: '), write(Proyecto), nl,
    write('Tarea: '), write(Tarea), nl, nl,
    fail.
