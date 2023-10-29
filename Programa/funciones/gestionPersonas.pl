% Autor: Aarón Piñar Mora
% Fecha: 22/04/2020
% Descripción: Apartado de Gestion de Personas
% Lenguaje: Prolog
% Ejecución: swipl -s gestionPersonas.pl

:- use_module(library(dialect/sicstus), [read_line/1]). % Para leer una linea de texto y que se vea sin las :| 
 
ejecutar(Opcion):-
    Opcion == 1, datosPersona;
    Opcion == 2, true; 
    Opcion == 3, write('\nSerá devuelto al menun principal').

% Funcion encargada de pedir los datos de la persona
% Entradas: Nombre, Puesto, Costo, Reating, Tareas
% Salidas: Recopilacion de los datos de la persona
% Restricciones: Los datos deben de ser validos y no deben de estar vacios

datosPersona:-
    nl, vista_indicacion, nl, 
    write('►Ingrese el nombre de la persona: '),
    read_line(NombreCodes),
    atom_codes(NombreAtom, NombreCodes),
    atom_string(NombreAtom, Nombre),
    downcase_atom(Nombre, NombreMinuscula),
    (
        %valida Vacio
        
        %Valida existencia de la persona
        nombre_existe(NombreMinuscula),nl,alerta_6,nl,datosPersona 
        ;(validaVacio(NombreMinuscula),nl,alerta_5,nl,datosPersona )
        ;write('►Ingrese el puesto de la persona: '),
        read_line(PuestoCodes),
        atom_codes(PuestoAtom, PuestoCodes),
        atom_string(PuestoAtom, Puesto),
        (
            (validaVacio(Puesto),nl,alerta_5,nl,datosPersona);
            downcase_atom(Puesto, PuestoMinuscula),
            comprueba_Tareas(PuestoMinuscula), % Verifica que el puesto sea valido
            write('►Ingrese el costo de la persona: '),
            read_line(CostoCodes),
            atom_codes(CostoAtom, CostoCodes),
            atom_string(CostoAtom, PuestoData),
            (
                (validaVacio(PuestoData),nl,alerta_5,nl,datosPersona) ;
                atom_number(CostoAtom, Costo), % Convierte a numero el string y Verifica que el costo sea un numero
                write('►Ingrese el rating de la persona: '),
                read_line(RatingCodes),
                atom_codes(RatingAtom, RatingCodes),
                atom_string(CostoAtom, RatingData),
                (   
                    (validaVacio(RatingData),nl,alerta_5,nl,datosPersona) ;
                    atom_number(RatingAtom, Rating), % Convierte a numero el string y Verifica que el rating sea un numero
                    write('►Ingrese las tareas de la persona: '),
                    read_line(TareasCodes),
                    atom_codes(TareasAtom, TareasCodes),
                    atom_string(TareasAtom, Tareas),
                    downcase_atom(Tareas, TareasMinuscula),nl,

                    (\+validaVacio(TareasMinuscula)) ->
                        (
                            consult('gestionTareas.pl'),buscar_nombreTarea(TareasMinuscula) ->
                            (
                                % Registra La Persona
                                write('╭────────────────────────────────────────────╮'), nl,
                                format('----       Los datos ingresados son      ----~n╰────────────────────────────────────────────╯~n  ✔ Nombre: ~w~n  ✔ Puesto: ~w~n  ✔ Costo : ₡ ~w~n  ✔ Rating: ~w~n  ✔ Tareas: ~w~n    ', [Nombre, Puesto, Costo, Rating, Tareas]),nl,
                                nl,load,
                                registraPersona(NombreMinuscula,PuestoMinuscula,Costo,Rating,TareasMinuscula),controladorPrincipal_Personas;
                                alerta_3,nl,write(''),nl,datosPersona, nl, controladorPrincipal_Personas
                            ) ;nl,alerta_7,nl,datosPersona
                        ) ; nl,alerta_5,nl,datosPersona
                )
                ;alerta_2,datosPersona
            )
            ;alerta_1,nl,write(''),nl,datosPersona
        )
    ).



% Guarda los datos de la persona en un archivo
% Entradas: Nombre, Puesto, Costo, Reating, Tareas
% Salidas: Archivo con los datos de la persona
% Restricciones: El archivo debe de existir
registraPersona(Nombre,Puesto,Costo,Reating,Tareas) :-   %Ejemplo: registraPersona('personas.txt', 'Juan', 'Gerente', 5000, 4.5).
    append('../data/personas.txt'), % Abre el archivo en modo escritura
    downcase_atom(Nombre, NombreMinuscula),
    downcase_atom(Puesto, PuestoMinuscula),
    downcase_atom(Tareas, TareasMinuscula),
    write(NombreMinuscula),
    write(","),
    write(PuestoMinuscula),
    write(","),
    write(Costo),
    write(","),
    write(Reating),
    write(","),
    write(TareasMinuscula),
    nl,
    told.  % Cierra el archivo

% Funcion encargada de pedir las tareas de la persona
% Entradas: [], Tareas %% Una lista vacia y la lista de tareas que servira como res
% Salidas: Lista de tareas
% Restricciones: Las tareas deben de ser validas y no deben de estar vacias
obtener_tareas(TareasActuales, TareasFinales) :-
    write('►Ingrese una tarea (o "fin" para finalizar): '),
    read_line(TareasCodes),
    atom_codes(TareasAtom, TareasCodes),
    atom_string(TareasAtom, Tareas),
    downcase_atom(Tareas, TareasMinuscula),
    (TareasMinuscula = 'fin' ->
        TareasFinales = TareasActuales
    ; 
        append(TareasActuales, [Tareas], NuevasTareas),
        obtener_tareas(NuevasTareas, TareasFinales)
    ).

% Validaciones


% Predicado para validar que la tarea no sea vacía
validaVacio(Dato) :-
    string_length(Dato, 0).
% Tareas Disponibles
% Entradas: String
% Restricciones: La tarea debe de pertenecer al registro
tareas([requerimientos, disenio, desarrollo, qa, fullstack, frontend, backend, administracion]).
comprueba_Tareas(Palabra) :-
    tareas(Palabras),
    member(Palabra, Palabras). %member comprueba si un elemento pertenece a una lista

% Comprueba que sea numero
% Entradas: Valor
% Restricciones: El valor debe de ser un numero
es_numero(Valor) :- number(Valor).

% Predicado para leer una línea desde el archivo
read_line(Stream, Line) :-
    read_line_to_string(Stream, LineStr),
    (LineStr \== end_of_file -> 
        atomic_list_concat(LineList, ',', LineStr), % Separa la línea por comas
        Line = LineList ;    
        Line = end_of_file 
    ).

% Predicado para imprimir el contenido del archivo en el formato deseado
imprimir_Personas:-
    nl,nl,mssg_mostrar,
    (
        archivo_existe('../data/personas.txt') ->
        open('../data/personas.txt', read, Stream),
        leer_y_mostrar_lineas(Stream),
        close(Stream), controladorPrincipal_Personas;
        alerta_4,controladorPrincipal_Personas
    ).

leer_y_mostrar_lineas(Stream) :-
    read_line(Stream, Line),
    (Line \== end_of_file ->
        mostrar_informacion(Line),
        leer_y_mostrar_lineas(Stream)
    ; true
    ).

% Predicado para mostrar la información en el formato deseado
mostrar_informacion([Nombre, Puesto, Costo, Rating, Tipo]) :-
    write('╭────────────────────────────────────────────────╮'), nl,
    format('         Información de la Persona: ~w~n', [Nombre]),
    write('╰────────────────────────────────────────────────╯'), nl,
    format('  • Puesto:             ~w~n', [Puesto]),
    format('  • Costo por Tarea:    ₡ ~w~n', [Costo]),
    format('  • Rating:             ★ ~w~n', [Rating]),
    format('  • Tipo de Tareas:     ~w~n', [Tipo]),
    nl. % Línea en blanco entre registros

% Verifica si el archivo existe
archivo_existe(NombreArchivo) :- 
    exists_file(NombreArchivo).


% Predicado para verificar si un nombre existe en el archivo
nombre_existe(NombreBuscado) :-
    open('../data/personas.txt', read, Stream),
    nombre_existe_en_archivo(NombreBuscado, Stream),
    close(Stream).

nombre_existe_en_archivo(NombreBuscado, Stream) :-
    read_line(Stream, Line),
    (Line \== end_of_file ->
        Line = [Nombre | _], % Obtiene el primer elemento (nombre) de la línea
        (Nombre = NombreBuscado ; nombre_existe_en_archivo(NombreBuscado, Stream))
    ; false
    ).


%                   Seccion de Vistas 

vistaPrincipal_Personas:-
    nl,nl,
    write('╭──────────────────────────────────╮'), nl,
    write('│     MENÚ GESTION DE PERSONAS     │'), nl,
    write('├──────────────────────────────────┤'), nl,
    write('│ 1. Agregar Persona               │'), nl,
    write('│ 2. Mostrar Personas              │'), nl,
    write('│ 0. Volver                        │'), nl,
    write('╰──────────────────────────────────╯'), nl,
    write('Ingrese una de las Opciones mostradas: ').

vista_indicacion:-
    nl,nl,
    write('╭─────────────────────────────────────────────────────────────────────╮'), nl,
    write('│  MENSAJE: A continuación rellene la información que se le solicita  │'), nl,
    write('│           para crear una Persona en la base de conocimiento.        │'), nl,
    write('╰─────────────────────────────────────────────────────────────────────╯'), nl.

mssg_mostrar:-
    write('╭─────────────────────────────────────────────────────────────────────────────────╮'), nl,
    write('│  MENSAJE: A continuación se mostrará la información de la base de conocimiento  │'), nl,
    write('│           registrada con respecto a las personas.                               │'), nl,
    write('╰─────────────────────────────────────────────────────────────────────────────────╯'), nl.
    

alerta_1:-
    nl,nl,
    write('             ╭─────────────────────────────────────────╮'), nl,
    write('             │               ⚠ ALERTA ⚠                │'), nl,
    write('             │                                         │'), nl,
    write('             │  Puesto no es válido                    │'), nl,
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


alerta_2:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  Costo no es válido                │'), nl,
    write('             │  Nota: Debe de ser un numeró       │'), nl,
    write('             ╰────────────────────────────────────╯').

alerta_3:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  La Tarea indicada es invalida     │'), nl,
    write('             │  Nota: Debe de ser una existente   │'), nl,
    write('             ╰────────────────────────────────────╯').

alerta_4:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  No se encuentran registros de     │'), nl,
    write('             │  Personas                          │'), nl,
    write('             ╰────────────────────────────────────╯').

alerta_5:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  No se permiten datos vaciós       │'), nl,
    write('             ╰────────────────────────────────────╯').

alerta_6:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  Ya hay registros relacionados     │'), nl,
    write('             ╰────────────────────────────────────╯').

alerta_7:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  Debe de indicar una tarea que se  │'), nl,
    write('             │  encuentre registrada              │'), nl,
    write('             ╰────────────────────────────────────╯').
load:-
    write('             ╭─────   Registrando persona   ─────╮'), nl,
    write('             │          Guardando datos...       │'), nl,
    write('             ╰───────────────────────────────────╯'), nl.


%                   Seccion de Controladores

% Funcion encargada de mostrar el menu principal
% Inicializador 
% Restricciones: Se debe de seleccionar alguna de las opciones disponibles
controladorPrincipal_Personas:-
    vistaPrincipal_Personas,
    read_line(OpcionCodes),
    atom_codes(OpcionAtom, OpcionCodes),
    (
        atom_number(OpcionAtom, Opcion), Opcion == 1, datosPersona;
        atom_number(OpcionAtom, Opcion), Opcion == 2, imprimir_Personas;
        atom_number(OpcionAtom, Opcion), Opcion == 0, consult('app.pl'), menu_administrativo;
        nl,write('La opcion ingresada no es valida'),nl,write(''),nl,controladorPrincipal_Personas
    ).