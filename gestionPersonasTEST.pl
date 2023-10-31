% Autor: Aarón Piñar Mora
% Fecha: 22/04/2020
% Descripción: Programa que permite gestionar personas para un proyecto de software
% Lenguaje: Prolog
% Ejecución: swipl -s gestionPersonas.pl
% Ejemplo: main.
% Nota: Para salir del programa se debe de ingresar el numero 3


% Inicializador 
% Restricciones: Se debe de seleccionar alguna de las opciones disponibles
main:- 
    write('\nBienvenido a Gestión de Personas'), 
    write('\n 1. Registrar una persona'), 
    write('\n 2. Mostrar personas'),
    write('\nIngrese una opción: '),
    read(Opcion), 
    ejecutar(Opcion).

ejecutar(Opcion):-
    Opcion == 1, datosPersona;
    Opcion == 2, true; 
    Opcion == 3, write('\nSerá devuelto al menun principal').

% Funcion encargada de pedir los datos de la persona
% Entradas: Nombre, Puesto, Costo, Reating, Tareas
% Salidas: Recopilacion de los datos de la persona
% Restricciones: Los datos deben de ser validos y no deben de estar vacios
datosPersona:- 
    write('\nIngrese el nombre de la persona: ').
    read(Nombre), 
    write('\nIngrese el puesto de la persona: '),
    read(Puesto),
    write('\nIngrese el costo por tarea de la persona: '),
    read(Costo),
    write('\nIngrese el rating: '),
    read(Reating),
    write('\nIngrese los tipos de tareas que realiza la persona (Debe de ser una lista): '),  % Solo se permite Listas %% Tareas disponibles: requerimientos, disenio desarrollo,  qa,  fullstack,  frontend,  backend  y  administracion
    read(Tareas).

% Guarda los datos de la persona en un archivo
% Entradas: Nombre, Puesto, Costo, Reating, Tareas
% Salidas: Archivo con los datos de la persona
% Restricciones: El archivo debe de existir
reegistraPersona(Filename,Nombre,Puesto,Costo,Reating) :-
    append(Filename),
    write(Nombre), 
    write(Puesto),
    write(Costo),
    write(Reating),
    told.  % Cierra el output stream