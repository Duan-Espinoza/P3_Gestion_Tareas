%                   Seccion de Vistas 
:- use_module(library(dialect/sicstus), [read_line/1]). % Para leer una linea de texto y que se vea sin las :| 
:- discontiguous read_line/2.
 %                  Seccion Vistas
vistaPrincipal_Proyectos:-
    nl,nl,
    write('╭──────────────────────────────────╮'), nl,
    write('│     MENÚ GESTION DE PROYECTOS    │'), nl,
    write('├──────────────────────────────────┤'), nl,
    write('│ 1. Agregar Proyecto              │'), nl,
    write('│ 2. Mostrar Proyectos             │'), nl,
    write('│ 0. Volver                        │'), nl,
    write('╰──────────────────────────────────╯'), nl,
    write('Ingrese una de las Opciones mostradas: ').

alerta_messageProyectos:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  Formato Fecha no valid            │'), nl,
    write('             │  Nota: Debe de ser dd/mm/aaaa      │'), nl,
    write('             │  Fecha inicio debe ser mayor       │'), nl,
    write('             ╰────────────────────────────────────╯').

alerta_messageProyectos2:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  Formato  no valid                 │'), nl,
    write('             │  Nota: Presupuesto debe ser numeró │'), nl,
    write('             ╰────────────────────────────────────╯').

alerta_messageProyectos3:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  Error: Proyecto ya existe         │'), nl,
    write('             ╰────────────────────────────────────╯').
alerta_messageProyectos4:-
    nl,nl,
    write('             ╭────────────────────────────────────╮'), nl,
    write('             │           ⚠ ALERTA ⚠               │'), nl,
    write('             │  No se encuentran registros de     │'), nl,
    write('             │  Proyectos                         │'), nl,
    write('             ╰────────────────────────────────────╯').
loadProyecto:-
    write('             ╭─────   Registrando proyecto   ─────╮'), nl,
    write('             │          Guardando datos...        │'), nl,
    write('             ╰────────────────────────────────────╯'), nl.

mssg_mostrarProyectos:-
    write('╭─────────────────────────────────────────────────────────────────────────────────╮'), nl,
    write('│  MENSAJE: A continuación se mostrará la información de la base de conocimiento  │'), nl,
    write('│           registrada con respecto a las proyectos.                              │'), nl,
    write('╰─────────────────────────────────────────────────────────────────────────────────╯'), nl.
    

vista_indicacionProyectos:-
    nl,nl,
    write('╭─────────────────────────────────────────────────────────────────────╮'), nl,
    write('│  MENSAJE: A continuación rellene la información que se le solicita  │'), nl,
    write('│           para crear un Proyecto en la base de conocimiento.        │'), nl,
    write('╰─────────────────────────────────────────────────────────────────────╯'), nl.

%                   Controladores

main_Proyectos:-
    vistaPrincipal_Proyectos,
    read_line(OpcionCodes),
    atom_codes(OpcionAtom, OpcionCodes),
    atom_string(OpcionAtom, Opcion),
    (
        Opcion = "1", pideData;
        Opcion = "2", mostrar_datos;
        Opcion = "0", write('develop')
    ).


pideData:-
    nl,vista_indicacionProyectos,
    write('►Ingrese el nombre del Proyecto: '),
    read_line(NombreCodes),
    atom_codes(NombreAtom, NombreCodes),
    atom_string(NombreAtom, Nombre),
    downcase_atom(Nombre, NombreMinuscula),
    (
        proyecto_existe(NombreMinuscula) -> write(''), alerta_messageProyectos3,nl, pideData;
        write('►Ingrese el nombre de la Empresa: '),
        read_line(EmpresaCodes),
        atom_codes(EmpresaAtom, EmpresaCodes),
        atom_string(EmpresaAtom, Empresa),
        downcase_atom(Empresa, EmpresaMinuscula),

        write('►Ingrese el Presupuesto: '),
        read_line(PresupuestoCodes),
        atom_codes(PresupuestoAtom, PresupuestoCodes),
        (
            atom_number(PresupuestoAtom, Presupuesto),
            write('►Ingrese la Fecha de Inicio: '),
            read_line(FechaInicioCodes),
            atom_codes(FechaInicioAtom, FechaInicioCodes),
            atom_string(FechaInicioAtom, FechaInicio),
            (
                fecha_valida(FechaInicio) -> 
                write('►Ingrese la Fecha de Fin: '),
                read_line(FechaFinCodes),
                atom_codes(FechaFinAtom, FechaFinCodes),
                atom_string(FechaFinAtom, FechaFin),
                (
                    fecha_valida(FechaFin) -> 
                    (
                        fechas_validas(FechaInicio, FechaFin) -> %Se verifica que inicio sea menor que fin
                        nl,write('╭────────────────────────────────────────────╮'), nl,
                        format('----       Los datos ingresados son      ----~n╰────────────────────────────────────────────╯~n  ✔ Nombre de Proyecto: ~w~n  ✔ Empresa: ~w~n  ✔ Presupuesto : ₡ ~w~n  ✔ Fecha Inicio: ~w~n  ✔ Fecha Fin: ~w~n    ', [NombreMinuscula, EmpresaMinuscula, Presupuesto, FechaInicio, FechaFin]),nl,
                        nl,loadProyecto, registraProyecto(NombreMinuscula, EmpresaMinuscula, Presupuesto, FechaInicio, FechaFin),main_Proyectos
                        ;alerta_messageProyectos,pideData
                        
                    );
                    alerta_messageProyectos2,pideData
                );
                alerta_messageProyectos,pideData, nl, !
            )
            ; alerta_messageProyectos2,pideData
        )
    ).


% Entrada: nombre, empresa, presupuesto, fecha inicio* y fecha fin*.
registraProyecto(Nombre, Empresa, Presupuesto, FechaInicio, FechaFin) :-   %Ejemplo: registraPersona('personas.txt', 'Juan', 'Gerente', 5000, 4.5).
    append('../data/proyectos.txt'), % Abre el archivo en modo escritura
    downcase_atom(Nombre, NombreMinuscula),
    downcase_atom(Empresa, EmpresaMinuscula),
    write(NombreMinuscula),
    write(","),
    write(EmpresaMinuscula),
    write(","),
    write(Presupuesto),
    write(","),
    write(FechaInicio),
    write(","),
    write(FechaFin),
    nl,
    told.  % Cierra el archivo



%                   Validaciones

% Predicado para validar que la tarea no sea vacía
validaVacio(Dato) :-
    string_length(Dato, 0).

% Verifica que la fecha sea válida %% dd/mm/aaaa
fecha_valida(Fecha) :-
atomic(Fecha), % Verifica que el argumento sea un átomo (string)
atom_length(Fecha, 10), % La fecha debe tener exactamente 10 caracteres
% Extrae el día, mes y año como subcadenas
sub_atom(Fecha, 0, 2, _, Dia),
sub_atom(Fecha, 3, 2, _, Mes),
sub_atom(Fecha, 6, 4, _, Anio),
atom_number(Dia, DiaNum), % Convierte el día a número
atom_number(Mes, MesNum), % Convierte el mes a número
atom_number(Anio, AnioNum), % Convierte el año a número
between(1, 31, DiaNum), % Verifica el rango del día
between(1, 12, MesNum), % Verifica el rango del mes
between(1000, 9999, AnioNum). % Verifica el rango del año


% Predicado para verificar si la fecha de fin no es menor que la fecha de inicio
fechas_validas(FechaInicio, FechaFin) :-
    fecha_valida(FechaInicio),
    fecha_valida(FechaFin),
    fecha_menor_o_igual(FechaInicio, FechaFin).

% Predicado para verificar si una fecha es menor o igual a otra
fecha_menor_o_igual(Fecha1, Fecha2) :-
    reformatear_fecha(Fecha1, FechaReformateada1),
    reformatear_fecha(Fecha2, FechaReformateada2),
    FechaReformateada1 @=< FechaReformateada2.

% Predicado para reformatear una fecha en un formato comparativo
reformatear_fecha(Fecha, Reformateada) :-
    split_string(Fecha, "/", "", [Dia, Mes, Anio]),
    atomic_list_concat([Anio, Mes, Dia], '-', Reformateada).



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

% Predicado para leer una línea del archivo
read_line(Stream, Line) :-
    read_line_to_string(Stream, Line).


% Verifica si el archivo existe
archivo_existe(NombreArchivo) :- 
    exists_file(NombreArchivo).


mostrar_datos :-
    nl,nl,mssg_mostrarProyectos,
    (
        archivo_existe('../data/proyectos.txt') ->
        open('../data/proyectos.txt', read, Stream),
        mostrar_datos_desde_archivo(Stream),
        close(Stream),main_Proyectos;
        alerta_messageProyectos4,mostrar_datos
    ).

mostrar_datos_desde_archivo(Stream) :-
    read_line(Stream, Line),
    (Line \== end_of_file ->
        formatar_y_mostrar(Line),
        mostrar_datos_desde_archivo(Stream)
    ; true
    ).

% Predicado para leer una línea del archivo
read_line(Stream, Line) :-
    read_line_to_string(Stream, Line).

% Predicado para formatear y mostrar la línea
formatar_y_mostrar(Line) :-
    atomic_list_concat([NombreProyecto, Empresa, Presupuesto, FechaInicio, FechaFin], ',', Line),
    write('╭────────────────────────────────────────────────╮'), nl,
    format('         Información de la Proyecto: ~w~n', [NombreProyecto]),
    write('╰────────────────────────────────────────────────╯'), nl,
    format('  • Empresa: ~w~n', [Empresa]),
    format('  • Presupuesto: ₡ ~w~n', [Presupuesto]),
    format('  • Fecha de Inicio: ~w~n', [FechaInicio]),
    format('  • Fecha de Finalización: ~w~n~n', [FechaFin]).



% FALTA
% VALIDACIONES