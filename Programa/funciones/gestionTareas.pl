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
        atom_number(OpcionAtom, Opcion), Opcion == 1, write('Develop');
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