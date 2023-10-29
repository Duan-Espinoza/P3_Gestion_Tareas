:- use_module(library(dialect/sicstus), [read_line/1]). % Para leer una linea de texto y que se vea sin las :| 


% Author: Duan Antonio Espinoza
% 2019079490
% Inicializador
% Restricciones: Se debe seleccionar alguna de las opciones disponibles
mainTareas :-
    write('╭──────────────────────────────────────╮'), nl,
    write('│  Bienvenido a la Gestión de Tareas   │'), nl,
    write('├──────────────────────────────────────┤'), nl,
    write('│ 1. Mostrar todas las tareas          │'), nl,
    write('│ 2. Agregar una nueva tarea           │'), nl,
    write('│ 3. Asignar tarea a persona           │'), nl,
    write('│ 4. Cerrar una tarea                  │'), nl,
    write('│ 5. Buscar tareas libres              │'), nl,
    write('│ 6. Salir                             │'), nl,
    write('╰──────────────────────────────────────╯'), nl,
    write('Ingrese una opción: '),
    read_line(OpcionCodes),
    atom_codes(OpcionAtom, OpcionCodes),
    (
        atom_number(OpcionAtom, Opcion), Opcion == 1, mostrar_datosTareas;
        atom_number(OpcionAtom, Opcion), Opcion == 2, agregarTarea;
        atom_number(OpcionAtom, Opcion), Opcion == 3, write('Develop');
        atom_number(OpcionAtom, Opcion), Opcion == 4, write('Develop');
        atom_number(OpcionAtom, Opcion), Opcion == 5, write('Develop');
        atom_number(OpcionAtom, Opcion), Opcion == 5, consult('app.pl'), menu_administrativo;
        nl, write('Error: debe de ingresar una de las opciones mostradas'), nl, mainTareas
    ).
    

% Función para agregar una nueva tarea en la base de conocimientos
agregarTarea :-
    write('\nIngrese el nombre del proyecto: '),
    read_line(TareaCodes),
    atom_codes(TareaAtom, TareaCodes),
    atom_string(TareaAtom, Tarea),
    downcase_atom(Tarea, TareasMinuscula),
    registrarTarea(TareasMinuscula).   
 


registrarTarea(NombreProyecto) :-
    append('../data/tareas.txt'),
    write(NombreProyecto), 
    write(','), 
    write('Pendiente'),
    write(','),
    write('sin asignar'), 
    write(','),
    write('sin fecha de cierre'), 
    nl,
    told.



% FALTA
% VALIDAR EXISTENCIA DE TAREAS, NO SE PUEDEN REGISTRAR TAREAS QUE YA ESTAN REGISTRADAS EN EL TXT 

%           Seccion de validaciones

% Verifica si el archivo existe
archivo_existe(NombreArchivo) :- 
    exists_file(NombreArchivo).


mostrar_datosTareas:-
    nl,nl,mssg_mostrar_tareas,
    (
        archivo_existe('../data/tareas.txt') ->
        open('../data/tareas.txt', read, Stream),
        mostrar_datos_desde_archivo(Stream),
        close(Stream), mainTareas
        ; alerta_NotFound_Tareas, nl,nl,mainTareas
    ).

mostrar_datos_desde_archivo(Stream) :-
    read_line(Stream, Line),
    (Line \== end_of_file ->
        mostrarTareas(Line),
        mostrar_datos_desde_archivo(Stream)
    ; true
    ).

% Predicado para leer una línea del archivo
read_line(Stream, Line) :-
    read_line_to_string(Stream, Line).


% Predicado para buscar un nombre en el archivo
buscar_nombreTarea(NombreABuscar) :-
    open('../data/tareas.txt', read, Stream),
    buscar_en_archivo(Stream, NombreABuscar),
    close(Stream).

% Predicado para buscar en el archivo
buscar_en_archivo(Stream, NombreABuscar) :-
    read_line(Stream, Line),
    (Line \== end_of_file ->
        atomic_list_concat([NombreTarea, _, _, _], ',', Line), %atomic concatena los elementos de la lista con el separador

        (NombreTarea = NombreABuscar ->
            true
        ; buscar_en_archivo(Stream, NombreABuscar)
        )
    ; false
    ).

%           Seccion de Vistas

% Predicado para formatear y mostrar la línea
mostrarTareas(Line) :-
    atomic_list_concat([NombreTarea, Estado, Encargado, FechaCierre], ',', Line),
    write('╭────────────────────────────────────────────────╮'), nl,
    format('         Información de la Proyecto: ~w~n', [NombreTarea]),
    write('╰────────────────────────────────────────────────╯'), nl,
    format('  • Estado: ~w~n', [Estado]),
    format('  • Encargado: ~w~n', [Encargado]),
    format('  • Fecha de Cierre: ~w~n~n', [FechaCierre]).



mssg_mostrar_tareas:-
    write('╭─────────────────────────────────────────────────────────────────────────────────╮'), nl,
    write('│  MENSAJE: A continuación se mostrará la información de la base de conocimiento  │'), nl,
    write('│           registrada con respecto a las Tareas.                                 │'), nl,
    write('╰─────────────────────────────────────────────────────────────────────────────────╯'), nl.

alerta_NotFound_Tareas:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  No se encuentran registros de     │'), nl,
    write('             │  Tareas                            │'), nl,
    write('             ╰────────────────────────────────────╯').





