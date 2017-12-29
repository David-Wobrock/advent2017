fs = require 'fs'

run = () ->
    statement = program[state["pc"]]
    splitted = statement.split " "
    instruction = splitted[0]
    arg1 = splitted[1]
    arg2 = splitted[2]
    if instruction == "set"
        setInstruction(arg1, arg2)
    else if instruction == "sub"
        subInstruction(arg1, arg2)
    else if instruction == "mul"
        mulInstruction(arg1, arg2)
        mulCount++
    else if instruction == "jnz"
        jnzInstruction(arg1, arg2)

    state["pc"] = state["pc"] + 1

getValue = (arg) ->
    return if state[arg] != undefined then state[arg] else parseInt arg

setInstruction = (arg1, arg2) ->
    state[arg1] = getValue(arg2)

subInstruction = (arg1, arg2) ->
    state[arg1] = state[arg1] - getValue(arg2)

mulInstruction = (arg1, arg2) ->
    state[arg1] = state[arg1] * getValue(arg2)

jnzInstruction = (arg1, arg2) ->
    if getValue(arg1) != 0
        #console.log getValue arg1
        state["pc"] = state["pc"] + getValue(arg2) - 1

# Program start
filename = "input"
program = fs.readFileSync(filename).toString().split '\n'
program = (line for line in program when line.length > 0)

state = {
    "pc": 0,
    "a": 0,
    "b": 0,
    "c": 0,
    "d": 0,
    "e": 0,
    "f": 0,
    "h": 0,
    "g": 0
}
mulCount = 0

run() while state["pc"] < program.length
console.log mulCount
