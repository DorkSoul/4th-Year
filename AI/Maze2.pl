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

% Define the rules for moving in each direction
move(up, X/Y, X/Y1) :- Y > 1, Y1 is Y-1, \+ blocked(X,Y1).
move(right, X/Y, X1/Y) :- X < 5, X1 is X+1, \+ blocked(X1,Y).
move(down, X/Y, X/Y1) :- Y < 5, Y1 is Y+1, \+ blocked(X,Y1).
move(left, X/Y, X1/Y) :- X > 1, X1 is X-1, \+ blocked(X1,Y).

% Define the depth-first search algorithm
dfs(Goal, Path) :-
    start(StartX, StartY),
    dfs_helper(Goal, [(StartX, StartY)], Path).

dfs_helper(Goal, [(GoalX, GoalY)|Visited], [(GoalX, GoalY)|Visited]) :-
    Goal = (GoalX, GoalY).
dfs_helper(Goal, [(X, Y)|Visited], Path) :-
    \+ Goal = (X, Y),
    move(_, X/Y, X1/Y1),
    \+ member((X1, Y1), [(X, Y)|Visited]),
    dfs_helper(Goal, [(X1, Y1),(X, Y)|Visited], Path).
