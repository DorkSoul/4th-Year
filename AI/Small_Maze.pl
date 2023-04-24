% change maze size, star and goal as needed s well as blocked cells.
% please run "set_prolog_flag(answer_write_options, [max_depth(0)])." in the interpreter first to see full path tree
% use one of the below commands in the interpreter to run
% dfs(Path). 
% ids(Path). 
% astar(Path).

% Define the maze size
maze(5, 5).

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
move(up, X/Y, X/Y1) :- Y > 1, Y1 is Y-1, \+ blocked(X,Y1).  % Move up if not at the top row and the cell above is not blocked
move(right, X/Y, X1/Y) :- maze(MaxX, _), X < MaxX, X1 is X+1, \+ blocked(X1,Y).  % Move right if not at the rightmost column and the cell to the right is not blocked
move(down, X/Y, X/Y1) :- maze(_, MaxY), Y < MaxY, Y1 is Y+1, \+ blocked(X,Y1).  % Move down if not at the bottom row and the cell below is not blocked
move(left, X/Y, X1/Y) :- X > 1, X1 is X-1, \+ blocked(X1,Y).  % Move left if not at the leftmost column and the cell to the left is not blocked

% Define the depth-first search algorithm
dfs(Path) :-
    start(StartX, StartY),
    goal(GoalX, GoalY),
    dfs_helper((GoalX, GoalY), [(StartX, StartY)], Path).

% Define the helper predicate for depth-first search
dfs_helper(Goal, [(GoalX, GoalY)|Visited], [(GoalX, GoalY)|Visited]) :-
    Goal = (GoalX, GoalY).  % If the current position is the goal, we have found a path, so return the path found so far
dfs_helper(Goal, [(X, Y)|Visited], Path) :-
    \+ Goal = (X, Y),  % If the current position is not the goal, continue searching
    move(_, X/Y, X1/Y1),  % Find the next valid move from the current position
    \+ member((X1, Y1), [(X, Y)|Visited]),  % Ensure that the next position has not already been visited
    dfs_helper(Goal, [(X1, Y1),(X, Y)|Visited], Path).  % Recursively search from the next position, adding it to the visited list and path found so far








% Define the Iterative deepening search algorithm
ids(Path) :-
    start(StartX, StartY),
    goal(GoalX, GoalY),
    ids_helper((GoalX, GoalY), [(StartX, StartY)], Path, 0).

% Define the helper predicate for iterative deepening search
ids_helper(Goal, [(GoalX, GoalY)|Visited], [(GoalX, GoalY)|Visited], _) :-
    Goal = (GoalX, GoalY).  % If the current position is the goal, we have found a path, so return the path found so far
ids_helper(Goal, [(X, Y)|Visited], Path, Depth) :-
    \+ Goal = (X, Y),  % If the current position is not the goal, continue searching
    Depth < 10,  % set a maximum depth limit
    move(_, X/Y, X1/Y1),  % Find the next valid move from the current position
    \+ member((X1, Y1), [(X, Y)|Visited]),  % Ensure that the next position has not already been visited
    Depth1 is Depth+1,  % Increase the depth limit for the next iteration
    ids_helper(Goal, [(X1, Y1),(X, Y)|Visited], Path, Depth1).  % Recursively search from the next position, adding it to the visited list and path found so far

	
	
	
	
	
	


% Define the Manhattan distance heuristic function
manhattan_distance((X1,Y1), (X2,Y2), D) :-
    D is abs(X1-X2) + abs(Y1-Y2).  % Calculate the Manhattan distance between two points

% Define the A* search algorithm using Manhattan distance as the heuristic function
astar(Path) :-
    start(StartX, StartY),
    goal(GoalX, GoalY),
    manhattan_distance((StartX, StartY), (GoalX, GoalY), H0),  % Calculate the heuristic value for the start position
    astar_helper([(StartX, StartY, 0, H0, [])], [], (GoalX, GoalY), Path).  % Call the helper predicate with an initial queue containing the start position

astar_helper([(GoalX, GoalY, _, _, Path)|_], _, (GoalX, GoalY), Path) :-
    !.  % If the goal position is at the front of the queue, we have found a path, so return the path found so far
astar_helper([(X, Y, G, H, Path)|Rest], Closed, Goal, FinalPath) :-
    findall((X1, Y1, G1, H1, [(X, Y)|Path]),
            (move(_, X/Y, X1/Y1),
             \+ member((X1, Y1, _, _, _), Closed),
             G1 is G+1,
             manhattan_distance((X1, Y1), Goal, H1)),
            Successors),  % Generate a list of possible next positions with their associated costs
    sort(Successors, SortedSuccessors),  % Sort the list of possible next positions by their total cost (g+h)
    add_to_queue(SortedSuccessors, Rest, NewQueue),  % Add the sorted list of possible next positions to the queue
    astar_helper(NewQueue, [(X, Y, G, H, Path)|Closed], Goal, FinalPath).  % Recursively search from the next position in the queue, adding it to the closed list and path found so far

add_to_queue([], Queue, Queue).
add_to_queue([(X,Y,G,H,Path)|Xs], Queue, NewQueue) :-
    (   select((X,Y,G1,_,_), Queue, RestQueue)  % Check if there is already a position with the same coordinates in the queue
    ->  (   G < G1  % If the new position has a lower total cost than the position already in the queue, replace the old position with the new position
        ->  insert((X,Y,G,H,Path), RestQueue, NewQueue)
        ;   add_to_queue([(X,Y,G,H,Path)|Xs], Queue, NewQueue)  % Otherwise, recursively add the new position to the rest of the list
        )
    ;   insert((X,Y,G,H,Path), Queue, NewQueue)  % If there is no position with the same coordinates in the queue, insert the new position
    ).

insert(State, [], [State]).
insert(State, [State1|Queue], [State, State1|Queue]) :-
    State = (_, _, G, H, _),
    State1 = (_, _, G1, H1, _),
    F is G+H,  % Calculate the total cost of the new position
    F1 is G1+H1,  % Calculate the total cost of the old position
F =< F1, % If the total cost of the new position is less than or equal to the total cost of the old position, insert the new position before the old position
!.
insert(State, [State1|Queue], [State1|NewQueue]) :-
insert(State, Queue, NewQueue). % Recursively add the new position to the rest of the list
