%               Sección de Modulos
:- use_module(library(dialect/sicstus), [read_line/1]). % Para leer una linea de texto y que se vea sin las :| 

%               Seccion de vistas

% Vista incial del Programa
vista_main :-
    nl,
    write('╭────────────────────────────────╮'), nl,
    write('│       MENÚ PRINCIPAL           │'), nl,
    write('├────────────────────────────────┤'), nl,
    write('│ 1. Opciones Administrativas    │'), nl,
    write('│ 2. Ayuda                       │'), nl,
    write('│ 5. Salir                       │'), nl,
    write('╰────────────────────────────────╯'), nl,
    write('Ingrese una de las Opciones mostradas: ').

% Vista secundaria, abarca apartado administrativo
vista_administrativo :-
    nl,
    write('╭──────────────────────────────────╮'), nl,
    write('│        MENÚ ADMINISTRATIVO       │'), nl,
    write('├──────────────────────────────────┤'), nl,
    write('│ 1. Gestión de Personas           │'), nl,
    write('│ 2. Gestión de Proyectos          │'), nl,
    write('│ 3. Gestión de Tareas             │'), nl,
    write('│ 4. Recomendar Persona            │'), nl,
    write('│ 5. Estadísticas                  │'), nl,
    write('│ 0. Salir                         │'), nl,
    write('╰──────────────────────────────────╯'), nl,
    write('Ingrese una de las Opciones mostradas: ').

% Vista de ayuda
help:-
    nl,nl,
    write('╭───────────────────────────────────────╮'), nl,
    write('│        SECCIÓN DE AYUDA PARA LA       │'), nl,
    write('├───────────────────────────────────────┤'), nl,
    write('|                                       │'), nl,
    write('│                                       │'), nl,
    write('│ 1. Seleccione una opción ingresando   │'), nl,
    write('│    el número correspondiente y        │'), nl,
    write('│    presione Enter.                    │'), nl,
    write('│                                       │'), nl,
    write('│ 2. Siga las indicaciones del programa │'), nl,
    write('│    para llevar a cabo sus tareas.     │'), nl,
    write('│                                       │'), nl,
    write('│                                       │'), nl,
    write('│ 3. Para volver al menú principal,     │'), nl,
    write('│    seleccione la opción 0 y presione  │'), nl,
    write('│    Enter.                             │'), nl,
    write('│                                       │'), nl,
    write('│                                       │'), nl,
    write('╰───────────────────────────────────────╯'), nl.


alerta_option:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  Opcion No valida                  │'), nl,
    write('             │  Nota: Seleccione una mostrada     │'), nl,
    write('             ╰────────────────────────────────────╯').

% Vista de salida
exit:-
    nl,nl,
    write('╭───────────────────────────────────────╮'), nl,
    write('│ ¡Gracias por usar el programa! Hasta  │'), nl,
    write('│           luego. 😊👋                │'), nl,
    write('╰───────────────────────────────────────╯'), nl.

%               Sección de Controladores
mainPrincipal:-
    vista_main,
    read_line(OpcionCodes),
    atom_codes(OpcionAtom, OpcionCodes),
    (
        atom_number(OpcionAtom, Opcion), Opcion == 1, menu_administrativo;
        atom_number(OpcionAtom, Opcion), Opcion == 2, help;
        atom_number(OpcionAtom, Opcion), Opcion == 3, exit
        ; nl, write('Error: debe de ingresar una de las opciones mostradas'), nl,mainPrincipal
    ).
    
menu_administrativo:-
    vista_administrativo,
    read_line(OpcionCodes),
    atom_codes(OpcionAtom, OpcionCodes),
    (
        atom_number(OpcionAtom, Opcion), Opcion == 0, nl,nl,write('Gracias por usar el programa'); 
        atom_number(OpcionAtom, Opcion), Opcion == 1, consult('gestionPersonas.pl'),controladorPrincipal_Personas;
        atom_number(OpcionAtom, Opcion), Opcion == 2, consult('gestionProyectos.pl'),main_Proyectos;
        atom_number(OpcionAtom, Opcion), Opcion == 3, consult('gestionTareas.pl'),mainTareas;
        atom_number(OpcionAtom, Opcion), Opcion == 4, write('Develop');
        atom_number(OpcionAtom, Opcion), Opcion == 5, write('Develop');
        alerta_option, nl, main_administrativo
    ).


