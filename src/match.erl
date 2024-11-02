-module(match).

-export([start/0,start/2,run/3,guess/2,compare_match/1,compare_member/2,check_match/2,check_member/2,number_to_atom_sequence/2,convert_num_to_atom/2]).

%Start the match game in a process.
start() ->
    Random_list = [rand:uniform(10) || _ <- lists:seq(1, 5)],
    Valid_inputs = lists:seq(1, 10),
    io:format("Guessing game has started. The sequence is (~p) elements long and contains~n~p as available inputs.~nFor more info, select info instead of your guess list. ~n", [length(Random_list), Valid_inputs]),
    spawn(?MODULE, run, [0, Random_list, Valid_inputs]).
start(Length, Number) when is_number(Number)->
    Random_list = [rand:uniform(Number) || _ <- lists:seq(1, Length)],
    Valid_inputs = lists:seq(1, Number),
    io:format("Guessing game has started. The sequence is (~p) elements long and contains~n~p as available inputs.~nFor more info, select info instead of your guess list. ~n", [length(Random_list), Valid_inputs]),
    spawn(?MODULE, run, [0, Random_list, Valid_inputs]);
start(Length, List) ->
    Lists = [color, elements, mixed],
    case lists:member(List, Lists) of
        true  ->
            case List =:= color of
                true ->
                    Atom_list = [red,orange,yellow,green,blue,indigo,violet],
                    Random_list = number_to_atom_sequence(Length, Atom_list);
                false ->
                    case List =:= elements of
                        true ->
                            Atom_list = [water, earth, fire, air],
                            Random_list = number_to_atom_sequence(Length, Atom_list);
                        false ->
                            case List =:= mixed of
                                true ->
                                    Atom_list = [1,2,3,4,5,6,7,8,9,10,red,orange,yellow,green,blue,indigo,violet],
                                    Random_list = number_to_atom_sequence(Length, Atom_list)
                            end
                    end
            end,
            io:format("Guessing game has started. The sequence is (~p) elements long and contains~n~p as available inputs.~nFor more info, select info instead of your guess list. ~n", [Length, Atom_list]),
            spawn(?MODULE, run, [0, Random_list, Atom_list]);
        false ->
            _ = {fail_start, not_valid_list}
    end.

run(Count, Random_list, Valid_inputs) ->
    receive
        {From, info} ->
            New_count = Count,
            From ! {squence_length, length(Random_list), valid_inputs, Valid_inputs};

        {From, Guess_list} when not is_list(Guess_list) ->
            New_count = Count,
            From ! {fail, Guess_list, is_not_list};

        {From, Guess_list} when (length(Random_list) < length(Guess_list)) -> 
            New_count = Count,
            From ! {fail, Guess_list, too_many_items};

        {From, Guess_list} when (length(Random_list) > length(Guess_list)) -> 
            New_count = Count,
            From ! {fail, Guess_list, not_enough_items};

        {From, Guess_list} when (length(Random_list) =:= length(Guess_list)) ->
            case  lists:all(fun(X) -> lists:member(X, Valid_inputs) end, Guess_list) of
                true ->
                    New_count = Count +1,
                    case Random_list =:= Guess_list of
                        true ->
                            From ! {correct, Random_list, guessed_in, New_count, guesses};
                        false ->
                            Dual_list = lists:zip(Guess_list, Random_list),
                            {Match_hint_list, Matched_list} = lists:mapfoldl(fun(X, List) -> {compare_match(X), check_match(X, List)} end, Random_list, Dual_list),
                            {Hint_list, _} = lists:mapfoldl(fun(X, List) -> {compare_member(X, List), check_member(X, List)} end, Matched_list, Match_hint_list),
                            From ! {incorrect, Hint_list, try_again}
                    
                    end;
                    
                false ->
                    New_count = Count,
                    From !{fail, Guess_list, contains_invalid_input}
            end
    end,
    run(New_count, Random_list, Valid_inputs).

guess(Pid, Guess) ->
    Pid ! {self(), Guess},
        receive
            Response ->
                Response
        end.

compare_match(Elem_tuple) ->
    {Elem1, Elem2} = Elem_tuple,
    case Elem1 =:= Elem2 of
        true ->
            _ = {o,o};
        false ->
            _ = Elem_tuple
    end.

compare_member(Elem_tuple, List) ->
    {Elem1, _} = Elem_tuple,
    case Elem_tuple =:= {o,o} of
        true ->
            _ = o;
        false ->
            case lists:member(Elem1, List) of
                true ->
                    _ = i;
                false ->
                    _ = x
            end
    end.

check_match(Elem_tuple, List) ->
    {Elem1, Elem2} = Elem_tuple,
    case Elem1 =:= Elem2 of
        true ->
            _ = List -- [Elem1];
        false ->
            _ = List
    end.

check_member(Elem_tuple, List) ->
    {Elem1, _} = Elem_tuple,
    case lists:member(Elem1, List) of
        true ->
            _ = List -- [Elem1];
        false ->
            _ = List
    end.

number_to_atom_sequence(Length, Atom_list) ->
    Atom_list_length = length(Atom_list),
    Atom_map_nums = lists:seq(1, Atom_list_length),
    Atom_mapped_list = lists:zip(Atom_map_nums, Atom_list),
    Random_num_list = [rand:uniform(Atom_list_length) || _ <- lists:seq(1, Length)],
    _ = lists:map(fun(X) -> convert_num_to_atom(X, Atom_mapped_list) end, Random_num_list).

convert_num_to_atom(Number, Atom_tuple_list) ->
    [Atom_tuple|Rest_of_list] = Atom_tuple_list,
    {Atom_num, Atom} = Atom_tuple,
    case Number =:= Atom_num of
        true ->
            _ = Atom;
        false ->
            convert_num_to_atom(Number, Rest_of_list)
    end.