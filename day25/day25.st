Object subclass: State [
    | currentState currentPosition onesPosition |
    State class >> new [
        | r |
        r := super new.
        r init.
        ^r
    ]
    init [
        currentState := 'A'.
        currentPosition := 0.
        onesPosition := Set new.
    ]

    getCurrentState [
        ^currentState
    ]
    getCurrentValue [
        (onesPosition includes: currentPosition)
            ifTrue: [
                ^1
            ]
            ifFalse: [
                ^0
            ].
    ]
    addCurrentPosition [
        onesPosition add: currentPosition.
    ]
    removeCurrentPosition [
        onesPosition remove: currentPosition.
    ]
    getNumberOnes [
        ^(onesPosition size)
    ]

    updateState: state [
        currentState := state.
    ]
    move: dir [
        (dir = 'left')
            ifTrue: [
                currentPosition := currentPosition - 1.
            ]
            ifFalse: [
                currentPosition := currentPosition + 1.
            ].
    ]
]

Object subclass: StateAction [
    | ifZeroValue ifZeroMove ifZeroState ifOneValue ifOneMove ifOneState |
    StateAction class >> new [
        | r |
        r := super new.
        r init.
        ^r
    ]
    init [
    ]

    setZeroValue: value [
        ifZeroValue := value.
    ]
    setZeroMove: dir [
        ifZeroMove := dir.
    ]
    setZeroState: state [
        ifZeroState := state.
    ]
    setOneValue: value [
        ifOneValue := value.
    ]
    setOneMove: dir [
        ifOneMove := dir.
    ]
    setOneState: state [
        ifOneState := state.
    ]

    getIfZeroValue [
        ^ifZeroValue
    ]
    getIfZeroMove [
        ^ifZeroMove
    ]
    getIfZeroState [
        ^ifZeroState
    ]
    getIfOneValue [
        ^ifOneValue
    ]
    getIfOneMove [
        ^ifOneMove
    ]
    getIfOneState [
        ^ifOneState
    ]
]

"Start of program"
| filename numIt |
filename := 'input'.

stateActions := Dictionary new.
file := FileStream open: filename mode: FileStream read.
lineNum := 0.
[ file atEnd ] whileFalse: [
    line := file upTo: Character nl.
    (lineNum == 0 | lineNum == 2) ifTrue: [].
    (lineNum == 1)
        ifTrue: [
            "Read number of iterations"
            (line =~ 'checksum after (\d+) steps') ifMatched: [:match |
                numIt := ((match at: 1) asNumber).].
        ].
    (lineNum > 2)
        ifTrue: [
            | readState stateAct |
            "Create a state action"
            stateAct := StateAction new.
            1 to: 9 do: [:i |
                (i == 1) "In state X:"
                    ifTrue: [
                        (line =~ 'In state ([A-Z])') ifMatched: [:match |
                            readState := (match at: 1).].
                    ].
                (i == 2) "If current value 0"
                    ifTrue: [].
                (i == 3) "Write the value X"
                    ifTrue: [
                        (line =~ 'Write the value (\d)') ifMatched: [:match |
                            stateAct setZeroValue: ((match at: 1) asNumber).].
                    ].
                (i == 4) "Move one slot to the right/left"
                    ifTrue: [
                        (line =~ 'to the (left|right)') ifMatched: [:match |
                            stateAct setZeroMove: (match at: 1).].
                    ].
                (i == 5) "Continue with state X"
                    ifTrue: [
                        (line =~ 'Continue with state ([A-Z])') ifMatched: [:match |
                            stateAct setZeroState: (match at: 1).].
                    ].
                (i == 6) "If current value 1"
                    ifTrue: [].
                (i == 7) "Write the value X"
                    ifTrue: [
                        (line =~ 'Write the value (\d)') ifMatched: [:match |
                            stateAct setOneValue: ((match at: 1) asNumber).].
                    ].
                (i == 8) "Move one slot to the right/left"
                    ifTrue: [
                        (line =~ 'to the (left|right)') ifMatched: [:match |
                            stateAct setOneMove: (match at: 1).].
                    ].
                (i == 9) "Continue with state X"
                    ifTrue: [
                        (line =~ 'Continue with state ([A-Z])') ifMatched: [:match |
                            stateAct setOneState: (match at: 1).].
                    ].
                line := file upTo: Character nl.
            ].
            stateActions at: readState put: stateAct.
        ].
    lineNum := lineNum + 1.
].
file close.

state := State new.
numIt printNl.

| action currentValue |
1 to: numIt do: [:i |
    action := (stateActions at: (state getCurrentState)).
    currentValue := (state getCurrentValue).
    (currentValue == 1)
        ifTrue: [ "Value is 1"
            ((action getIfOneValue) == 0)
            ifTrue: [
                state removeCurrentPosition. "Set current position to 0"
            ].
            state updateState: (action getIfOneState).
            state move: (action getIfOneMove).
        ]
        ifFalse: [ "Value is 0" 
            ((action getIfZeroValue) == 1)
            ifTrue: [
                state addCurrentPosition. "Set current position to 1"
            ].
            state updateState: (action getIfZeroState).
            state move: (action getIfZeroMove).
        ].
].
(state getNumberOnes) printNl.
