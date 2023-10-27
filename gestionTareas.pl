:- dynamic tarea/6. % Declaración dinámica para permitir la modificación de hechos en tiempo de ejecución

% Duan Antonio Espinoza
% 2019079490
% Inicializador
% Restricciones: Se debe seleccionar alguna de las opciones disponibles
main :-
    write('\nBienvenido a la Gestión de Tareas'),
    write('\n 1. Mostrar todas las tareas'),
    write('\n 2. Agregar una nueva tarea'),
    write('\n 3. Asignar tarea a persona'),
    write('\n 4. Cerrar una tarea'),
    write('\n 5. Buscar tareas libres'),
    write('\n 6. Salir'),
    write('\nIngrese una opción: '),
    read(Opcion),
    ejecutar(Opcion).

ejecutar(Opcion) :-
    Opcion == 1, mostrarTareas, main; % Mostrar todas las tareas y regresar al menú principal
    Opcion == 2, agregarTarea, main; % Agregar una nueva tarea y regresar al menú principal
    Opcion == 3, asignarTarea, main; % Asignar tarea a persona y regresar al menú principal
    Opcion == 4, cerrarTarea, main; % Cerrar una tarea y regresar al menú principal
    Opcion == 5, buscarTareasLibres, main; % Buscar tareas libres y regresar al menú principal
    Opcion == 6, write('\nSaliendo del programa'), nl. % Salir del programa

% Función para mostrar todas las tareas en la base de conocimientos
mostrarTareas :-
    write('\nTodas las tareas registradas:'), nl,
    tarea(Proyecto, Nombre, Tipo, Estado, Asignado, FechaCierre),
    write('Proyecto: '), write(Proyecto), nl,
    write('Nombre de Tarea: '), write(Nombre), nl,
    write('Tipo de Tarea: '), write(Tipo), nl,
    write('Estado: '), write(Estado), nl,
    write('Asignado a: '), write(Asignado), nl,
    write('Fecha de Cierre: '), write(FechaCierre), nl,
    fail. % Continuar mostrando todas las tareas

% Función para agregar una nueva tarea en la base de conocimientos
agregarTarea :-
    write('\nIngrese el nombre del proyecto: '),
    read(Proyecto),
    write('Ingrese el nombre de la tarea: '),
    read(Nombre),
    write('Ingrese el tipo de tarea: '),
    read(Tipo),
    assertz(tarea(Proyecto, Nombre, Tipo, 'Pendiente', 'Sin asignar', 'Sin cerrar')), % Agregar la tarea como hecho dinámico
    write('\nTarea agregada con éxito.'), nl.

% Función para asignar una tarea a una persona y cambiar su estado a "Activa"
asignarTarea :-
    write('\nIngrese el nombre del proyecto: '),
    read(Proyecto),
    write('Ingrese el nombre de la tarea: '),
    read(Nombre),
    write('Ingrese el nombre de la persona asignada: '),
    read(Persona),
    retract(tarea(Proyecto, Nombre, Tipo, 'Pendiente', 'Sin asignar', 'Sin cerrar')),
    assertz(tarea(Proyecto, Nombre, Tipo, 'Activa', Persona, 'Sin cerrar')), % Actualizar el estado y la persona asignada
    write('\nTarea asignada a '), write(Persona), write(' y su estado se ha cambiado a Activa.'), nl.

% Función para cerrar una tarea
cerrarTarea :-
    write('\nIngrese el nombre del proyecto: '),
    read(Proyecto),
    write('Ingrese el nombre de la tarea: '),
    read(Nombre),
    write('Ingrese el día de cierre: '),
    read(Dia),
    write('Ingrese el mes de cierre: '),
    read(Mes),
    write('Ingrese el año de cierre: '),
    read(Anio),
    FechaCierre = Dia-Mes-Anio,
    retract(tarea(Proyecto, Nombre, Tipo, 'Activa', Asignado, 'Sin cerrar')),
    assertz(tarea(Proyecto, Nombre, Tipo, 'Finalizada', Asignado, FechaCierre)), % Actualizar el estado y la fecha de cierre
    write('\nTarea cerrada con éxito el '), write(FechaCierre), write(' y su estado se ha cambiado a Finalizada.'), nl.

% Función para buscar tareas libres (pendientes)
buscarTareasLibres :-
    write('\n 1. Mostrar todas las tareas pendientes'),
    write('\n 2. Buscar tareas libres para una persona'),
    write('\nIngrese una opción: '),
    read(OpcionBuscar),
    (
        OpcionBuscar == 1 -> mostrarTareasPendientes;
        OpcionBuscar == 2 -> buscarTareasLibresPersona
    ).

% Función para mostrar todas las tareas pendientes
mostrarTareasPendientes :-
    write('\nTodas las tareas pendientes:'), nl,
    tarea(Proyecto, Nombre, Tipo, 'Pendiente', 'Sin asignar', FechaCierre),
    write('Proyecto: '), write(Proyecto), nl,
    write('Nombre de Tarea: '), write(Nombre), nl,
    write('Tipo de Tarea: '), write(Tipo), nl,
    write('Estado: Pendiente'), nl,
    write('Fecha de Cierre: '), write(FechaCierre), nl,
    fail. % Continuar mostrando todas las tareas pendientes

% Función para buscar tareas libres para una persona específica
buscarTareasLibresPersona :-
    write('\nIngrese el nombre de la persona: '),
    read(Persona),
    write('\nTareas libres que '), write(Persona), write(' podría realizar:'), nl,
    tarea(Proyecto, Nombre, Tipo, 'Pendiente', 'Sin asignar', FechaCierre),
    tarea(ProyectoPersona, _, _, _, Persona, _),
    Persona \= 'Sin asignar',
    compatible(Tipo, TipoPersona),
    Persona \= 'Sin asignar',
    write('Proyecto: '), write(Proyecto), nl,
    write('Nombre de Tarea: '), write(Nombre), nl,
    write('Tipo de Tarea: '), write(Tipo), nl,
    write('Estado: Pendiente'), nl,
    write('Fecha de Cierre: '), write(FechaCierre), nl,
    fail. % Continuar mostrando todas las tareas pendientes

% Regla para verificar la compatibilidad de tipos de tareas entre la tarea y la persona
% Esta seccion de codigo se puede usar para su validacion correspondiente
compatible(Tipo, TipoPersona) :-
    % Define aquí las reglas de compatibilidad de tipos de tareas, por ejemplo:
    (Tipo = TipoPersona; Tipo = 'TareaUniversal'; TipoPersona = 'TareaUniversal').

% Regla para verificar si una tarea puede ser asignada a una persona
puedeAsignar(Tarea, Persona) :-
    tarea(_, Tarea, TipoTarea, 'Pendiente', 'Sin asignar', _),
    tarea(_, _, _, _, Persona, _),
    compatible(TipoTarea, TipoPersona),
    Persona \= 'Sin asignar'.

