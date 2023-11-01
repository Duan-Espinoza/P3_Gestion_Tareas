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
        atom_number(OpcionAtom, Opcion), Opcion == 1,validaShow ;
        atom_number(OpcionAtom, Opcion), Opcion == 2, agregarTarea;
        atom_number(OpcionAtom, Opcion), Opcion == 3, validaAgregarTareaGes;
        atom_number(OpcionAtom, Opcion), Opcion == 4, write('Develop');
        atom_number(OpcionAtom, Opcion), Opcion == 5, write('Develop');
        atom_number(OpcionAtom, Opcion), Opcion == 6, consult('app.pl'),menu_administrativo;
        nl, write('Error: debe de ingresar una de las opciones mostradas'), nl, mainTareas
    ).

% Funcion para crear una tarea a la BC
agregarTarea:-
    archivo_existe('../data/tareas.txt'),nl,
    write('►Indique el nombre del proyecto al cual se le va abrir una nueva tarea: '),
    read_line(NombreProyectoCodes),
    atom_codes(NombreProyectoAtom, NombreProyectoCodes),
    atom_string(NombreProyectoAtom, NombreProyecto),
    downcase_atom(NombreProyecto, NombreProyectoMinuscula),
    (proyecto_existe(NombreProyectoMinuscula),registrarTarea(NombreProyectoMinuscula),nl,nl,load,mainTareas);
    nl,nl,alerta_NotFound_Proyectos,nl,nl.

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


% Funcion para asignar tarea a persona en un proyecto
validaAgregarTareaGes:-
        %Agrega Tarea
        %Se valida: Vacios Falta: existencias
        write('\nIngrese el nombre del proyecto: '),
        read_line(ProyectoCodes),
        atom_codes(ProyectoAtom, ProyectoCodes),
        atom_string(ProyectoAtom, Proyecto),
        downcase_atom(Proyecto, ProyectoMinuscula),nl,

        write('\nIngrese el nombre de la Persona: '),
        read_line(PersonaCodes),
        atom_codes(PersonaAtom, PersonaCodes),
        atom_string(PersonaAtom, Persona),
        downcase_atom(Persona, PersonaMinuscula),nl,
        
        write('\nIngrese el nombre de la Tarea: '),
        read_line(TareaCodes),
        atom_codes(TareaAtom, TareaCodes),
        atom_string(TareaAtom, Tarea),
        downcase_atom(Tarea, TareasMinuscula),

        consult('agregarTarea.pl'),
        aux_validaAgrega(ProyectoMinuscula,PersonaMinuscula,TareasMinuscula), 
        proyectos_modificados_con_nombre_encargado_y_tarea(ProyectoMinuscula,PersonaMinuscula,TareasMinuscula).
 

aux_validaAgrega(Proyecto,Persona,Tarea):-
    (\+ proyecto_existe(Proyecto),nl,nl,alerta_NotFound_Proyectos,nl,nl,fail);
    (consult('gestionPersonas.pl'),\+ nombre_registrado(Persona),nl,nl,alerta_NotFound_Personas,nl,nl,fail);
    (consult('v_Tareas.pl'),cargar_datos, \+ usuario_tiene_tarea(Persona,Tarea),alerta_SchTarea,nl,nl,fail);
    (\+comprueba_Tareas(Tarea),nl,nl,alerta_1,fail);
    nl,nl,write('Se cumplen los requisitos'),nl,nl.


%       Funcion encargada de verificar datos  para mostrar Tareas

validaShow:-
    archivo_existe('../data/tareas.txt') ->  
    (
        nl,nl,mssg_mostrar_tareas,nl,consult('muestraTareas.pl'),mostrar_proyectos('../data/tareas.txt'),nl,nl,mainTareas
    );nl,nl,alerta_NotFound_Tareas,nl,nl,mainTareas.


%           Seccion de validacione

% Tareas Disponibles
% Entradas: String
% Restricciones: La tarea debe de pertenecer al registro
tareas([requerimientos, disenio, desarrollo, qa, fullstack, frontend, backend, administracion]).
comprueba_Tareas(Palabra) :-
    tareas(Palabras),
    member(Palabra, Palabras). %member comprueba si un elemento pertenece a una lista


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

            ); write('No existe el proyecto'),nl,nl
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

% verifica si un proyecto existe
proyecto_existe(NombreBuscado) :-
    open('../data/proyectos.txt', read, Stream), % Reemplaza 'tu_archivo.txt' con la ruta correcta a tu archivo
    nombre_existe_en_archivo(NombreBuscado, Stream),
    close(Stream).

nombre_existe_en_archivo(NombreBuscado, Stream) :-
    read_line(Stream, Line),
    (Line \== end_of_file ->
        atomic_list_concat(Elements, ',', Line), % Divide la línea en elementos usando la coma como separador
        nth0(0, Elements, Nombre), % Obtiene el primer elemento (nombre)
        (Nombre = NombreBuscado ; nombre_existe_en_archivo(NombreBuscado, Stream))
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

alerta_NotFound_Personas:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  No se encuentran registros de     │'), nl,
    write('             │  Personas                          │'), nl,
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

alerta_SchTarea:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  La persona no tiene esa tarea     │'), nl,
    write('             │  registrada                        │'),nl,
    write('             ╰────────────────────────────────────╯').


alerta_1:-
    nl,nl,
    write('             ╭─────────────────────────────────────────╮'), nl,
    write('             │               ⚠ ALERTA ⚠                │'), nl,
    write('             │                                         │'), nl,
    write('             │  Tarea no es válida                     │'), nl,
    write('             │                                         │'), nl,
    write('             │  Solo se admite:                        │'), nl,
    write('             │              ✔ Requerimientos           │'), nl,
    write('             │              ✔ Disenio                  │'), nl,
    write('             │              ✔ Desarrollo               │'), nl,
    write('             │              ✔ QA                       │'), nl,
    write('             │              ✔ FullStack                │'), nl,
    write('             │              ✔ FrontEnd                 │'), nl,
    write('             │              ✔ BackEnd                  │'), nl,
    write('             │              ✔ Administracion           │'), nl,
    write('             ╰─────────────────────────────────────────╯').

load:-
    write('             ╭─────   Registrando Tarea     ─────╮'), nl,
    write('             │          Guardando datos...       │'), nl,
    write('             ╰───────────────────────────────────╯'), nl.

% Validaciones para Creacion y eliminacion de archivos

eliminar_archivo(NombreArchivo) :-
    atomic_list_concat(['rm', NombreArchivo], ' ', Comando),
    shell(Comando, _).

crear_archivo(NombreArchivo, Contenido) :-
    open(NombreArchivo, write, Stream),
    write(Stream, Contenido),
    close(Stream).

cambiar_nombre_archivo(AntiguoNombre, NuevoNombre) :-
    rename_file(AntiguoNombre, NuevoNombre).