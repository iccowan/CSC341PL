/*
Ian Cowan
CSC 341 W20
P3 Clue

This program has defined all of the possibilities for who could
have destroyed Olin, which weapon they may have used, and which
room it could have been done in. This program has all of the
known information hard coded and then uses that information to
solve the mystery.

To compile this program, simply run this file with SWI Prolog
by using the command "swipl cowan.pl". The mystery should automatically solve
and print out the result.

Example:
  Input:
    swipl cowan.pl
  
  Output:
    The suspect is: mcallister
    The room is: chemistry_prep
    The weapon is: compiler

NOTE:
  The suspects, weapons, and rooms are defined in this
  program according to the following:

  Suspects:
    fieberg => Dr. Fieberg
    mcallister => Dr. McAllister
    neiser => Dr. Neiser
    swanson => Dr. Swanson
    fulfer => Dr. Fulfer
    allen => Dr. Allen
  Weapons:
    compiler => A compiler
    calculator => A calculator
    wrecking_ball => Wrecking Ball
    exploding_beaker => Exploding beaker of @#$%$#!
    pendulum => The pendulum
    real_analysis_book => A Real Analysis textbook
  Rooms:
    lounge => The lounge
    bathroom => The basement men's room
    lab => The optics lab
    elevator => The elevator
    office => Dave Toth's (old) office
    chemistry_prep => The chemistry prep room
    staircase => The back staircase
    one_o_seven => 107
    hallway => The hallway
*/

% Define all the suspects
suspect(fieberg).
suspect(mcallister).
suspect(neiser).
suspect(swanson).
suspect(fulfer).
suspect(allen).

% Define all the weapons
weapon(compiler).
weapon(calculator).
weapon(wrecking_ball).
weapon(exploding_beaker).
weapon(pendulum).
weapon(real_analysis_book).

% Define all the rooms
room(lounge).
room(bathroom).
room(lab).
room(elevator).
room(office).
room(chemistry_prep).
room(staircase).
room(one_o_seven).
room(hallway).

/*  Known information */

% Weapons that could have been used by a person
can_use(mcallister, real_analysis_book).
can_use(neiser, pendulum).
can_use(fieberg, pendulum).
can_use(swanson, pendulum).
can_use(neiser, calculator).
can_use(swanson, wrecking_ball).
can_use(fulfer, wrecking_ball).
can_use(allen, compiler).
can_use(mcallister, compiler).

% Weapons that could not have been used by a person
can_not_use(allen, compiler).

% Locations where the person was definitely seen
was_seen(allen, lounge).
was_seen(allen, hallway).
was_seen(allen, one_o_seven).
was_seen(fulfer, staircase).
was_seen(fulfer, chemistry_prep).
was_seen(fulfer, lab).
was_seen(fulfer, weisman).
was_seen(swanson, weisman).
was_seen(allen, proush).
was_seen(fieberg, proush).
was_seen(mcallister, elevator).

% Locations where the person definitely was not seen
was_not_seen(neiser, staircase).
was_not_seen(neiser, elevator).
was_not_seen(mcallister, staircase).
was_not_seen(mcallister, bathroom).

% Locations that DPS has cleared as "clean"
cleared_by_dps(bathroom).
cleared_by_dps(lab).

% Weapons that did not use magic
no_magic(real_analysis_book).

% Room where magic was found
magic_found(chemistry_prep).

/*
Solves the solution and calls the appropriate predicate to
print it to the console.

Inputs:
  None
Outputs:
  None
Side Effects:
  Halts SWI Prolog when finished solving the mystery
*/
solve() :- foundSuspect(Suspect, Room, Weapon),
           printResult(Suspect, Room, Weapon),
           halt().

/*
Prints the discovered results to the console, as inputted.

Inputs:
  S : The discovered suspect
  R : The discovered room
  W : The discovered weapon
Outputs:
  None
Side Effects:
  Prints the results to the console
*/
printResult(S, R, W) :- write('The suspect is: '), writeln(S),
                        write('The room is: '), writeln(R),
                        write('The weapon is: '), writeln(W).

/*
Defines how we find the solution to the mystery.

Inputs:
  S : Empty variable which is reassigned to the suspect
  R : Empty variable which is reassigned to the room
  W : Empty variable which is reassigned to the weapon
Outputs:
  None
Side Effects:
  None
*/
foundSuspect(S, R, W) :- suspect(S),
                         room(R),
                         weapon(W),
                         not( away_from_olin(S) ),
                         not( was_not_seen(S, R) ),
                         can_use(S, W),
                         magic_found(R),
                         not( can_not_use(S, W) ),
                         not( no_magic(W) ),
                         not( cleared_by_dps(R) ).

/*
Checks to see if the suspect was away from Olin at the
time of the incident.

Inputs:
  S : Suspect to be checked
Outputs:
  None
Side Effects:
  None
*/
away_from_olin(S) :- was_seen(S, R),
                     not( room(R) ).

% Run the solve predicate on program run
:- solve.
