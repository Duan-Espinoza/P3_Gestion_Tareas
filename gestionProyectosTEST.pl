:- dynamic proyecto/5. % Declaración dinámica para permitir la modificación de hechos en tiempo de ejecución

% Inicializador
% Restricciones: Se debe seleccionar alguna de las opciones disponibles
main :-
    write('\nBienvenido a la Gestión de Proyectos'),
    write('\n 1. Registrar un proyecto'),
    write('\n 2. Mostrar proyectos con costos'),
    write('\n 3. Salir'),
    write('\nIngrese una opcion: '),
    read(Opcion),
    ejecutar(Opcion).

ejecutar(Opcion) :-
    Opcion == 1, datosProyecto, main; % Registrar un proyecto y regresar al menú principal
    Opcion == 2, mostrarProyectosConCosto, main; % Mostrar proyectos con costos y regresar al menú principal
    Opcion == 3, write('\nSaliendo del programa'), nl. % Salir del programa

% Función encargada de pedir los datos de un proyecto y guardarlos como hechos
% Entradas: Nombre, Empresa, Presupuesto, FechaInicio, FechaFin
% Salidas: Hechos para el proyecto registrado
% Restricciones: Los datos deben ser válidos y no deben estar vacíos
datosProyecto :-
    write('\nIngrese el nombre del proyecto: '),
    read(Nombre),
    write('\nIngrese el nombre de la empresa: '),
    read(Empresa),
    write('\nIngrese el presupuesto del proyecto: '),
    read(Presupuesto),
    write('\nIngrese la fecha de inicio: '),
    read(FechaInicio),
    write('\nIngrese la fecha de fin: '),
    read(FechaFin),
    assertz(proyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin)), % Agregar el proyecto como hecho dinámico
    write('\nProyecto registrado con éxito.'), nl.

% Función para mostrar información detallada de los proyectos con costos
mostrarProyectosConCosto :-
    write('\nProyectos registrados con costos:'), nl,
    proyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin),
    costo_incurrido_en_proyecto(Nombre, CostoTotal),
    write('Proyecto: '), write(Nombre), nl,
    write('Empresa: '), write(Empresa), nl,
    write('Presupuesto: '), write(Presupuesto), nl,
    write('Fecha de inicio: '), write(FechaInicio), nl,
    write('Fecha de fin: '), write(FechaFin), nl,
    write('Costo total incurrido: '), write(CostoTotal), nl, nl,
    guardarEnArchivo(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin, CostoTotal),
    fail.

% Regla para calcular el costo total incurrido en un proyecto
% Se puede modificar
costo_incurrido_en_proyecto(Proyecto, CostoTotal) :-
    findall(Costo, tarea_asignada(Proyecto, _, _, Costo), Costos),
    sum_list(Costos, CostoTotal).

% Función para guardar información en un archivo de texto
guardarEnArchivo(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin, CostoTotal) :-
    open('proyectos.txt', append, Stream), % Abre el archivo en modo de añadir
    write(Stream, 'Proyecto: '), write(Stream, Nombre), write(Stream, '\n'),
    write(Stream, 'Empresa: '), write(Stream, Empresa), write(Stream, '\n'),
    write(Stream, 'Presupuesto: '), write(Stream, Presupuesto), write(Stream, '\n'),
    write(Stream, 'Fecha de inicio: '), write(Stream, FechaInicio), write(Stream, '\n'),
    write(Stream, 'Fecha de fin: '), write(Stream, FechaFin), write(Stream, '\n'),
    write(Stream, 'Costo total incurrido: '), write(Stream, CostoTotal), write(Stream, '\n\n'),
    close(Stream).
