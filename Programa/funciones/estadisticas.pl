% :- dynamic proyecto/5. % Definir dinámicamente un hecho para representar cada proyecto.
% :- dynamic tarea/4. % Definir dinámicamente un hecho para representar cada tarea.

% Funcionalidad de estadisticas
% Duan Antonio Espinoza
% Proyecto 3

% Se cargan automáticamente los proyectos y tareas desde los archivos
:- [gestionProyectos].
:- [gestionTareas].

% Estatus financiero de un proyecto
estatus_financiero(NombreProyecto, Estatus) :-
    findall(Costo, tarea(NombreProyecto, _, _, Costo), Costos),
    sum_list(Costos, TotalCostoTareas),
    proyecto(NombreProyecto, _, Presupuesto, _, _),
    (Presupuesto =:= TotalCostoTareas -> Estatus = 'Tablas';
     Presupuesto < TotalCostoTareas -> Estatus = 'Sobre costo';
     Presupuesto > TotalCostoTareas -> Estatus = 'Bajo costo').

% Calcular estatus financiero para todos los proyectos
calcular_estatus_financiero_proyectos :-
    findall(NombreProyecto, proyecto(NombreProyecto, _, _, _, _), Proyectos),
    calcular_estatus_financiero_proyectos(Proyectos).

calcular_estatus_financiero_proyectos([]).
calcular_estatus_financiero_proyectos([NombreProyecto|RestoProyectos]) :-
    estatus_financiero(NombreProyecto, Estatus),
    write('Proyecto: '), write(NombreProyecto), write(', Estatus financiero: '), write(Estatus), nl,
    calcular_estatus_financiero_proyectos(RestoProyectos).

% Tipo de cierre de un proyecto
tipo_cierre_proyecto(NombreProyecto, Tipo) :-
    proyecto(NombreProyecto, _, _, FechaCierre, _),
    findall(FechaMaximaCierreTarea, tarea(NombreProyecto, _, _, FechaMaximaCierreTarea), FechasMaximas),
    max_list(FechasMaximas, MaxFechaMaximaCierre),
    (FechaCierre >= MaxFechaMaximaCierre -> Tipo = 'Al día';
     FechaCierre < MaxFechaMaximaCierre -> Tipo = 'Tardía').

% Calcular tipo de cierre para todos los proyectos
calcular_tipo_cierre_proyectos :-
    findall(NombreProyecto, proyecto(NombreProyecto, _, _, _, _), Proyectos),
    calcular_tipo_cierre_proyectos(Proyectos).

calcular_tipo_cierre_proyectos([]).
calcular_tipo_cierre_proyectos([NombreProyecto|RestoProyectos]) :-
    tipo_cierre_proyecto(NombreProyecto, Tipo),
    write('Proyecto: '), write(NombreProyecto), write(', Tipo de cierre: '), write(Tipo), nl,
    calcular_tipo_cierre_proyectos(RestoProyectos).

% Calcular cantidad de tareas por persona
calcular_cantidad_tareas_por_persona :-
    findall(Persona, tarea(_, Persona, _, _), Personas),
    list_to_set(Personas, PersonasUnicas), % Elimina duplicados
    calcular_cantidad_tareas(PersonasUnicas).

calcular_cantidad_tareas([]).
calcular_cantidad_tareas([Persona|RestoPersonas]) :-
    findall(NombreTarea, tarea(_, Persona, NombreTarea, _), Tareas),
    length(Tareas, CantidadTareas),
    write('Persona: '), write(Persona), write(', Cantidad de tareas: '), write(CantidadTareas), nl,
    calcular_cantidad_tareas(RestoPersonas).
