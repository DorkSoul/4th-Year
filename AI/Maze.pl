% Define the maze as a 2-dimensional list
maze([
    [G, _, _, _, _],
    [_, X, X, X, _],
    [_, X, S, X, _],
    [_, X, _, _, _],
    [_, _, _, _, _]
]).

% Define the starting point
start(3, 3).

% Define the goal point
goal(1, 1).

% Define the blocked squares
blocked(2, 2).
blocked(2, 3).
blocked(2, 4).
blocked(3, 2).
blocked(3, 4).
blocked(4, 2).

% Define valid moves
move(NX, NY, X, Y) :- NX is X - 1, NY is Y. % move left
move(NX, NY, X, Y) :- NX is X + 1, NY is Y. % move right
move(NX, NY, X, Y) :- NY is Y - 1, NX is X. % move down
move(NX, NY, X, Y) :- NY is Y + 1, NX is X. % move up

% Check if the move is valid
valid_move(X, Y) :-
    \+ blocked(X, Y),
    maze(Maze),
    nth1(Y, Maze, Row),
    nth1(X, Row, _).

% Depth-first search implementation
dfs(Path, X, Y) :-
    goal(X, Y),
    reverse([(X, Y) | Path], FinalPath),
    writeln(FinalPath).

dfs(Path, X, Y) :-
    move(NX, NY, X, Y),
    valid_move(NX, NY),
    \+ member((NX, NY), Path),
    dfs([(X, Y) | Path], NX, NY).

% Entry point for the program
solve :-
    start(X, Y),
    dfs([], X, Y).
