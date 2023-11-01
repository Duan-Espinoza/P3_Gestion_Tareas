:- use_module(library(dialect/sicstus), [read_line/1]). % Para leer una linea de texto y que se vea sin las :| 
:- dynamic proyecto/5.

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
        atom_number(OpcionAtom, Opcion), Opcion == 1,validaShow ;
        atom_number(OpcionAtom, Opcion), Opcion == 2, agregarTarea;
        atom_number(OpcionAtom, Opcion), Opcion == 3, write('Develop');
        atom_number(OpcionAtom, Opcion), Opcion == 4, write('Develop');
        atom_number(OpcionAtom, Opcion), Opcion == 5, write('Develop');
        atom_number(OpcionAtom, Opcion), Opcion == 5, consult('app.pl'), menu_administrativo;
        nl, write('Error: debe de ingresar una de las opciones mostradas'), nl, mainTareas
    ).
% Funcion para asignar tarea a persona en un proyecto

validaAgregarTarea:-
    archivo_existe('../data/proyectos.txt') ->  
    (
      archivo_existe('../data/tareas.txt')->
      (
        %Agrega Tarea
        %Se valida: Vacios Falta: existencias
        write('\nIngrese el nombre del proyecto: '),
        read_line(ProyectoCodes),
        atom_codes(ProyectoAtom, ProyectoCodes),
        atom_string(ProyectoAtom, Proyecto),
        downcase_atom(Proyecto, ProyectoMinuscula),

        validaVacio(ProyectoMinuscula),nl,nl,alerta_invalidInput,nl; 

        write('\nIngrese el nombre de la Persona: '),
        read_line(PersonaCodes),
        atom_codes(PersonaAtom, PersonaCodes),
        atom_string(PersonaAtom, Persona),
        downcase_atom(Persona, PersonaMinuscula),

        validaVacio(Persona),nl,nl,alerta_invalidInput,nl; 


        write('\nIngrese el nombre de la Tarea: '),
        read_line(TareaCodes),
        atom_codes(TareaAtom, TareaCodes),
        atom_string(TareaAtom, Tarea),
        downcase_atom(Tarea, TareaMinuscula),

        validaVacio(Tarea),nl,nl,alerta_invalidInput,nl; 

        write('Funciona')

      );nl,nl,alerta_NotFound_Tareas,nl,nl
    );nl,nl,alerta_NotFound_Proyectos,nl,nl.


%       Funcion encargada de verificar datos  para mostrar Tareas

validaShow:-
    archivo_existe('../data/tareas.txt') ->  
    (
        nl,nl,mssg_mostrar_tareas,nl,consult('muestraTareas.pl'),mostrar_proyectos
    );nl,nl,alerta_NotFound_Tareas,nl,nl,mainTareas.

% Función para agregar una nueva tarea en la base de conocimientos
agregarTarea :-
    write('\nIngrese el nombre del proyecto: '),
    read_line(TareaCodes),
    atom_codes(TareaAtom, TareaCodes),
    atom_string(TareaAtom, Tarea),
    downcase_atom(Tarea, TareasMinuscula),
    buscaProyecto(TareasMinuscula).   %validaciones de archivo y existencias de proyectos
 


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



%           Seccion de validacione

% Predicado para validar que la tarea no sea vacía
validaVacio(Dato) :-
    string_length(Dato, 0).

%   Verificiar si el proyecto existe
buscaProyecto(NombreProyecto) :-
    %Primero valido el dato entrante 
    (archivo_existe('../data/tareas.txt') ->
        archivo_existe('../data/proyectos.txt') ->
        (
            consult('gestionProyectos.pl'),proyecto_existe(NombreProyecto) ->
            (
                registrarTarea(NombreProyecto),
                write('Tarea registrada con éxito'),nl,nl,mainTareas

            ); write('No existe el proyecto'),nl,nl,agregarTarea
        );nl,nl,alerta_NotFound_Proyectos
    ),nl,nl,alerta_NotFound_Tareas,nl.


% Verifica si el archivo existe
archivo_existe(NombreArchivo) :- 
    exists_file(NombreArchivo).


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

alerta_NotFound_Proyectos:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  No se encuentran registros de     │'), nl,
    write('             │  Proyectos                         │'), nl,
    write('             ╰────────────────────────────────────╯').


alerta_invalidInput:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  No se permiten datos vaciós       │'), nl,
    write('             ╰────────────────────────────────────╯').

alerta_Sch:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  Ya existe el proyecto en la BC    │'), nl,
    write('             ╰────────────────────────────────────╯').



