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








ids(Goal, Path) :-
    start(StartX, StartY),
    ids_helper(Goal, [(StartX, StartY)], Path, 0).

ids_helper(Goal, [(GoalX, GoalY)|Visited], [(GoalX, GoalY)|Visited], _) :-
    Goal = (GoalX, GoalY).
ids_helper(Goal, [(X, Y)|Visited], Path, Depth) :-
    \+ Goal = (X, Y),
    Depth < 10, % set a maximum depth limit, e.g. 10
    move(_, X/Y, X1/Y1),
    \+ member((X1, Y1), [(X, Y)|Visited]),
    Depth1 is Depth+1,
    ids_helper(Goal, [(X1, Y1),(X, Y)|Visited], Path, Depth1).
	
	
	
	
	
	


% Define the Manhattan distance heuristic function
manhattan_distance((X1,Y1), (X2,Y2), D) :-
    D is abs(X1-X2) + abs(Y1-Y2).

% Define the A* search algorithm using Manhattan distance as the heuristic function
astar(Goal, Path) :-
    start(StartX, StartY),
    astar_helper([(StartX, StartY, 0, manhattan_distance((StartX, StartY), Goal, _))], [], Goal, ReversePath),
    reverse(ReversePath, Path).

astar_helper([(GoalX, GoalY, _, _)|_], _, (GoalX, GoalY), [(GoalX, GoalY)]) :-
    !.
astar_helper([(X, Y, G, H)|Rest], Closed, Goal, Path) :-
    findall((X1, Y1, G1, H1), (move(_, X/Y, X1/Y1), \+ member((X1, Y1, _, _), Closed), G1 is G+1, manhattan_distance((X1, Y1), Goal, H1)), Successors),
    add_to_queue(Successors, Rest, NewQueue),
    astar_helper(NewQueue, [(X, Y, G, H)|Closed], Goal, Path1),
    Path = [(X, Y)|Path1].



add_to_queue([], Queue, Queue).
add_to_queue([(X,Y,G,H)|Xs], Queue, NewQueue) :-
    (   select((X,Y,G1,_), Queue, RestQueue)
    ->  (   G < G1
        ->  insert((X,Y,G,H), RestQueue, NewQueue)
        ;   add_to_queue(Xs, Queue, NewQueue)
        )
    ;   insert((X,Y,G,H), Queue, NewQueue)
    ).


insert(State, [], [State]).
insert(State, [State1|Queue], [State, State1|Queue]) :-
    State = (_, _, G, H),
    State1 = (_, _, G1, H1),
    F is G+H,
    F1 is G1+H1,
    F =< F1,
    !.
insert(State, [State1|Queue], [State1|NewQueue]) :-
    insert(State, Queue, NewQueue).