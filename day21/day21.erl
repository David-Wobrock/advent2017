-module(day21).
-export([main/1]).

readRules(Filename) ->
    {ok, Data} = file:read_file(Filename),
    Splitted = binary:split(Data, [<<"\n">>], [global, trim]),
    toRules(Splitted).

toRules([]) -> [];
toRules([Line|Rest]) -> binary:split(Line, [<<" => ">>], []) ++ toRules(Rest).

splitRow([], []) -> [];
splitRow([Head11|[Head12|Rest1]], [Head21|[Head22|Rest2]]) ->
        FirstRow = unicode:characters_to_binary([Head11, Head12], unicode),
        SecondRow = unicode:characters_to_binary([Head21, Head22], unicode),
        SplittedArt = unicode:characters_to_binary([FirstRow, <<"/">>, SecondRow], unicode),
        [binary_to_list(SplittedArt)] ++ splitRow(Rest1, Rest2).

splitRow([], [], []) -> [];
splitRow([Head11|[Head12|[Head13|Rest1]]], [Head21|[Head22|[Head23|Rest2]]], [Head31|[Head32|[Head33|Rest3]]]) ->
        FirstRow = unicode:characters_to_binary([Head11, Head12, Head13], unicode),
        SecondRow = unicode:characters_to_binary([Head21, Head22, Head23], unicode),
        ThirdRow = unicode:characters_to_binary([Head31, Head32, Head33], unicode),
        SplittedArt = unicode:characters_to_binary([FirstRow, <<"/">>, SecondRow, <<"/">>, ThirdRow], unicode),
        [binary_to_list(SplittedArt)] ++ splitRow(Rest1, Rest2, Rest3).

splitRows2(_, Id, Size) when Id >= Size -> [];
splitRows2(Rows, Id, Size) ->
    Row1 = binary_to_list(lists:nth(Id, Rows)),
    Row2 = binary_to_list(lists:nth(Id+1, Rows)),
    splitRow(Row1, Row2) ++ splitRows2(Rows, Id+2, Size).

splitRows3(_, Id, Size) when Id >= Size -> [];
splitRows3(Rows, Id, Size) ->
    Row1 = binary_to_list(lists:nth(Id, Rows)),
    Row2 = binary_to_list(lists:nth(Id+1, Rows)),
    Row3 = binary_to_list(lists:nth(Id+2, Rows)),
    splitRow(Row1, Row2, Row3) ++ splitRows3(Rows, Id+3, Size).

splitArt(Art, Size, FullSize) when Size == 2 ->
    Rows = binary:split(Art, [<<"/">>], [global]),
    splitRows2(Rows, 1, FullSize);
splitArt(Art, Size, FullSize) when Size == 3 ->
    Rows = binary:split(Art, [<<"/">>], [global]),
    splitRows3(Rows, 1, FullSize).

applyRules(Art, Rules) ->
    ArtSize = length(binary:bin_to_list(lists:nth(1, binary:split(Art, [<<"/">>], [])))),
    if
        (ArtSize rem 2) == 0 -> Size = 2;
        (ArtSize rem 3) == 0 -> Size = 3
    end,
    SmallerArts = splitArt(Art, Size, ArtSize),
    AllNewArts = applySmallerArts(SmallerArts, Rules, Size),
    glueTogether(AllNewArts).

applySmallerArts([], _, _) -> [];
applySmallerArts([Art|Rest], Rules, Size) ->
    AllCombinations = getAllCombinations(list_to_binary(Art), Size),
    [tryRules(AllCombinations, Rules)] ++ applySmallerArts(Rest, Rules, Size).

getAllCombinations(Art, Size) ->
    Rows = binary:split(Art, [<<"/">>], [global]),
    FirstRow = binary_to_list(lists:nth(1, Rows)),
    LastRow = binary_to_list(lists:last(Rows)),
    case Size of
        2 ->
            FlipVertical = unicode:characters_to_binary([LastRow, <<"/">>, FirstRow], unicode),
            FlipHorizontal = unicode:characters_to_binary([lists:reverse(FirstRow), <<"/">>, lists:reverse(LastRow)], unicode),

            FirstColumn = binary_to_list(unicode:characters_to_binary([lists:nth(1, FirstRow), lists:nth(1, LastRow)], unicode)),
            LastColumn = binary_to_list(unicode:characters_to_binary([lists:nth(2, FirstRow), lists:nth(2, LastRow)], unicode)),
            RotateLeft = unicode:characters_to_binary([LastColumn, <<"/">>, FirstColumn], unicode),
            RotateRight = unicode:characters_to_binary([lists:reverse(FirstColumn), <<"/">>, lists:reverse(LastColumn)], unicode),
            RotateFull = unicode:characters_to_binary([lists:reverse(LastRow), <<"/">>, lists:reverse(FirstRow)], unicode),
            [Art, FlipVertical, FlipHorizontal, RotateLeft, RotateRight, RotateFull];
        3 ->
            MiddleRow = binary_to_list(lists:nth(2, Rows)),
            FlipVertical = unicode:characters_to_binary([LastRow, <<"/">>, MiddleRow, <<"/">>, FirstRow], unicode),
            FlipHorizontal = unicode:characters_to_binary([lists:reverse(FirstRow), <<"/">>, lists:reverse(MiddleRow), <<"/">>, lists:reverse(LastRow)], unicode),

            FirstColumn = binary_to_list(unicode:characters_to_binary([lists:nth(1, FirstRow), lists:nth(1, MiddleRow), lists:nth(1, LastRow)], unicode)),
            MiddleColumn = binary_to_list(unicode:characters_to_binary([lists:nth(2, FirstRow), lists:nth(2, MiddleRow), lists:nth(2, LastRow)], unicode)),
            LastColumn = binary_to_list(unicode:characters_to_binary([lists:last(FirstRow), lists:last(MiddleRow), lists:last(LastRow)], unicode)),
            RotateLeft = unicode:characters_to_binary([LastColumn, <<"/">>, MiddleColumn, <<"/">>, FirstColumn], unicode),
            RotateRight = unicode:characters_to_binary([lists:reverse(FirstColumn), <<"/">>, lists:reverse(MiddleColumn), <<"/">>, lists:reverse(LastColumn)], unicode),
            RotateFull = unicode:characters_to_binary([lists:reverse(LastColumn), <<"/">>, lists:reverse(MiddleColumn), <<"/">>, lists:reverse(FirstColumn)], unicode),
            [Art, FlipVertical, FlipHorizontal, RotateLeft, RotateRight, RotateFull]
    end.

tryRules(_, []) -> false;
tryRules(AllCombinations, [Rule|[Output|Rest]]) ->
    case tryRule(AllCombinations, Rule) of
        true -> Output;
        false -> tryRules(AllCombinations, Rest)
    end.

tryRule(AllCombinations, Rule) ->
    Pred = fun(Combi) -> string:equal(Rule, Combi) end,
    lists:any(Pred, AllCombinations).

glueTogether(AllNewArts) ->
    case length(AllNewArts) of
        1 -> list_to_binary(AllNewArts);
        _ ->
            SquareLen = math:sqrt(length(AllNewArts)),
            glueBlocks(AllNewArts, 1, SquareLen)
    end.

glueBlocks(_, IdIn, Size) when IdIn > (Size*Size) -> nil;
glueBlocks(Arts, IdIn, Size) ->
    Id = round(IdIn),
    ElementSize = length(binary:split(lists:nth(1, Arts), <<"/">>, [global])),
    Current = glueRows(Arts, Id, 1, Size, ElementSize),
    Next = glueBlocks(Arts, Id+Size, Size),
    if
        Next == nil -> Current;
        true -> unicode:characters_to_binary([Current, <<"/">>, Next], unicode)
    end.

glueRows(_, _, ElementIdx, _, ElementSize) when ElementIdx > ElementSize -> nil;
glueRows(Arts, Id, ElementIdx, Size, ElementSize) ->
    Row = glueRowLoop(Arts, Id, 0, ElementIdx, Size),
    Next = glueRows(Arts, Id, ElementIdx+1, Size, ElementSize),
    if
        Next == nil -> unicode:characters_to_binary([Row],  unicode);
        true -> unicode:characters_to_binary([Row, <<"/">>, Next], unicode)
    end.

glueRowLoop(_, _, RowCount, _, Size) when RowCount >= Size -> nil;
glueRowLoop(Arts, RowStart, RowCount, ElementIndex, Size) ->
    Row = lists:nth(RowStart+RowCount, Arts),
    Blocks = binary:split(Row, <<"/">>, [global]),
    Element = lists:nth(ElementIndex, Blocks),
    Next = glueRowLoop(Arts, RowStart, RowCount+1, ElementIndex, Size),
    if
        Next == nil -> unicode:characters_to_binary([Element],  unicode);
        true -> unicode:characters_to_binary([Element, Next], unicode)
    end.

loop(Art, _, It, Limit) when It == Limit -> Art;
loop(Art, Rules, It, Limit) when It < Limit ->
    NewArt = applyRules(Art, Rules),
    loop(NewArt, Rules, It+1, Limit).

loop(Art, Rules, Limit) ->
    loop(Art, Rules, 0, Limit).


countOnPixels(Art) -> countOnPixelsLoop(binary_to_list(Art), 0).

countOnPixelsLoop([], Count) -> Count;
countOnPixelsLoop([Head|Rest], Count) when Head == 35 -> countOnPixelsLoop(Rest, Count+1);
countOnPixelsLoop([_|Rest], Count) -> countOnPixelsLoop(Rest, Count).

main(Filename) ->
    Rules = readRules(Filename),
    %io:fwrite("~w~n", [Rules]),
    %io:format(Rules),
    %io:fwrite("~w~n", [length(Rules)]),
    Art = <<".#./..#/###">>,
    %io:fwrite("~w~n", [Art]),
    %io:format(Art),
    FinalArt = loop(Art, Rules, 5),
    io:format("\nEnd\n"),
    io:format(FinalArt),
    io:format("\n"),
    Len = length(binary:split(FinalArt, <<"/">>, [global])),
    io:fwrite("~w~n", [Len*Len]),
    OnPixels = countOnPixels(FinalArt),
    io:format("\nOn pixels: "),
    io:fwrite("~w~n", [OnPixels]),
    io:format("\n").
