% Se establece la BC con las reglas con los hechos

% Hechos para proyectos
% Se puede modificar
proyecto('Proyecto1', 'Empresa1', 1000, '01-01-2023', '31-01-2023').
proyecto('Proyecto2', 'Empresa2', 2000, '15-02-2023', '28-02-2023').


% Hechos para tareas asignadas a proyectos
% Se puede modificar
tarea_asignada('Proyecto1', 'Tarea1', 'Persona1', 200).
tarea_asignada('Proyecto1', 'Tarea2', 'Persona2', 300).
tarea_asignada('Proyecto2', 'Tarea3', 'Persona3', 500).


% Regla para calcular el costo total incurrido en un proyecto
% Se puede modificar
costo_incurrido_en_proyecto(Proyecto, CostoTotal) :-
    findall(Costo, tarea_asignada(Proyecto, _, _, Costo), Costos),
    sum_list(Costos, CostoTotal).


% Regla para mostrar información detallada de los proyectos
% Se puede modificar
mostrar_proyectos_con_costo :-
    proyecto(Proyecto, Empresa, Presupuesto, FechaInicio, FechaFin),
    costo_incurrido_en_proyecto(Proyecto, CostoTotal),
    write('Proyecto: '), write(Proyecto), nl,
    write('Empresa: '), write(Empresa), nl,
    write('Presupuesto: '), write(Presupuesto), nl,
    write('Fecha de inicio: '), write(FechaInicio), nl,
    write('Fecha de fin: '), write(FechaFin), nl,
    write('Costo total incurrido: '), write(CostoTotal), nl, nl,
    fail.
