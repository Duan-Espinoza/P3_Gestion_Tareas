:- dynamic proyecto/5.  % Declarar los hechos dinámicos necesarios.
:- dynamic tarea/4.
:- dynamic persona/3.

% Predicado para cargar la base de conocimientos.
cargar_base_conocimientos :-
    cargar_proyectos,
    cargar_tareas,
    cargar_personas.

% **********************************************************
% La funcionalidad del rating 
% **************************************************
% Calcula la puntuación de una persona para un proyecto y una tarea específicos.
calcular_puntuacion_persona(NombreProyecto, NombreTarea, NombrePersona, Puntuacion) :-
    % Desarrollo Previo: Por cada tarea asignada del tipo, suma 2 ptos.
    contar_tareas_tipo(NombrePersona, TipoTarea, ContadorTipo),
    PuntosDesarrolloPrevio is ContadorTipo * 2,

    % Afinidad por proyecto: Si la persona tiene alguna tarea del proyecto, suma 5 ptos.
    (persona_tiene_tarea_proyecto(NombrePersona, NombreProyecto) -> PuntosAfinidadProyecto = 5 ; PuntosAfinidadProyecto = 0),

    % Rating: Se le suma el rating de la persona.
    persona(NombrePersona, _, Rating),
    PuntosRating is Rating,

    % Tareas abiertas: Por cada tarea asignada con estado activa, se le resta 3 ptos.
    contar_tareas_abiertas_persona(NombrePersona, ContadorAbiertas),
    PuntosTareasAbiertas is -3 * ContadorAbiertas,

    % Calcular la puntuación total.
    Puntuacion is PuntosDesarrolloPrevio + PuntosAfinidadProyecto + PuntosRating + PuntosTareasAbiertas.


% *********************************************************
% Esta es la funcionalidad a llamar para mostrar recomendaciones
% Aqui se solicitan nombre de proyecto y nombre de tarea
%********************************************************
% Recomendar personas para un proyecto y una tarea específicos.
recomendar_personas(NombreProyecto, NombreTarea) :-
    cargar_base_conocimientos, % Cargar proyectos, tareas y personas.
    
    % Obtener la lista de personas que pueden realizar la tarea.
    findall(NombrePersona, persona_puede_realizar_tarea(NombrePersona, NombreTarea), Personas),

    % Calcular y almacenar la puntuación de cada persona.
    calcular_y_almacenar_puntuaciones(NombreProyecto, NombreTarea, Personas, Puntuaciones),

    % Ordenar las personas de mayor a menor puntuación.
    sort(0, @>=, Puntuaciones, PuntuacionesOrdenadas),

    % Mostrar las personas recomendadas.
    mostrar_personas_recomendadas(PuntuacionesOrdenadas).

% Predicado para contar las tareas de un tipo asignadas a una persona.
contar_tareas_tipo(NombrePersona, TipoTarea, Contador) :-
    findall(Tarea, tarea(NombreTarea, NombrePersona, Tarea, TipoTarea), Tareas),
    length(Tareas, Contador).

% Predicado para verificar si una persona tiene alguna tarea en un proyecto.
persona_tiene_tarea_proyecto(NombrePersona, NombreProyecto) :-
    tarea(NombreProyecto, NombrePersona, _, _).

% Predicado para contar las tareas abiertas de una persona.
contar_tareas_abiertas_persona(NombrePersona, Contador) :-
    findall(Tarea, tarea(_, NombrePersona, Tarea, 'activa'), TareasAbiertas),
    length(TareasAbiertas, Contador).

% Predicado para verificar si una persona puede realizar una tarea.
persona_puede_realizar_tarea(NombrePersona, NombreTarea) :-
    tarea(_, NombrePersona, NombreTarea, _).

% Predicado para calcular y almacenar las puntuaciones de las personas en una lista.
calcular_y_almacenar_puntuaciones(_, _, [], []).
calcular_y_almacenar_puntuaciones(NombreProyecto, NombreTarea, [Persona|RestoPersonas], [(Persona, Puntuacion)|RestoPuntuaciones]) :-
    calcular_puntuacion_persona(NombreProyecto, NombreTarea, Persona, Puntuacion),
    calcular_y_almacenar_puntuaciones(NombreProyecto, NombreTarea, RestoPersonas, RestoPuntuaciones).


% *****************************************
% Predicado para mostrar las personas recomendadas con sus puntuaciones y tipos de tareas.
mostrar_personas_recomendadas([]).
mostrar_personas_recomendadas([(Persona, Puntuacion)|RestoPersonas]) :-
    write('Nombre de la Persona: '), write(Persona), nl,
    write('Puntuación: '), write(Puntuacion), nl,
    mostrar_tipos_de_tareas_persona(Persona),
    nl,
    mostrar_personas_recomendadas(RestoPersonas).

**********************************************
% Predicado para mostrar los tipos de tareas que realiza una persona.
mostrar_tipos_de_tareas_persona(Persona) :-
    findall(TipoTarea, tarea(_, Persona, _, TipoTarea), TiposTareas),
    list_to_set(TiposTareas, TiposTareasUnicos),
    write('Tipos de Tareas que Realiza: '), write(TiposTareasUnicos), nl.


% ******************************************************************
% Ejemplo de uso para recomendar personas para un proyecto y una tarea específicos.
% al llamarse esta funcion se reemplaza 'NombreProyecto' y 'NombreTarea' en este predicado 
% con los nombres de proyecto y tarea para los cuales deseas obtener recomendaciones
% *******************************************************************
ejemplo_recomendacion :-
    recomendar_personas('NombreProyecto', 'NombreTarea').

% Cargar la base de conocimientos al iniciar el sistema.
:- cargar_base_conocimientos.
