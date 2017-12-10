open System

let applyPermutation (hash:int list) (position:int) (perm:int) =
    let hashArray = List.toArray hash
    if (position + perm) > (List.length hash) // Two parts to reverse
    then
        let countStartOfPartToBeReversed = (List.length hash) - position
        let startOfPartToBeReversed = Array.sub hashArray position countStartOfPartToBeReversed
        let countEndOfPartToBeReversed = position + perm - (List.length hash)
        let endOfPartToBeReversed = Array.sub hashArray 0 countEndOfPartToBeReversed

        let startOfRest = countEndOfPartToBeReversed
        let countOfRest = position - startOfRest
        let restOfHash = Array.sub hashArray startOfRest countOfRest

        let reversed = Array.rev (Array.append startOfPartToBeReversed endOfPartToBeReversed)
        let newStartOfHash = Array.sub reversed 0 countStartOfPartToBeReversed
        let newEndOfHash = Array.sub reversed countStartOfPartToBeReversed (perm - countStartOfPartToBeReversed)
        let ret = Array.concat [ newEndOfHash; restOfHash; newStartOfHash ]
        Array.toList ret
    else // One part to reverse
        let before = Array.sub hashArray 0 position
        let toBeReversed = Array.sub hashArray position perm
        let after = Array.sub hashArray (position+perm) (max 0 ((Array.length hashArray) - (position+perm)))
        let reversed = Array.rev toBeReversed
        let ret = Array.concat [ before; reversed; after ]
        Array.toList ret


let rec toDense (sol:int []) (i:int) (hash:int list) =
    if i = 16
    then sol
    else
        let hashArray = List.toArray hash
        let newSol = Array.reduce (fun a b -> a ^^^ b) (Array.sub hashArray (i*16) 16)
        toDense (Array.append sol [|newSol|]) (i+1) hash

let printToHex (dense:int []) =
    Array.map (printf "%02x") dense


let rec processPermutations (hash: int list) (position:int) (permutations: int list) (skip:int) (fullPermutations:int list) (iteration:int) =
    if iteration = 64
    then hash
    else
        match permutations with
        | [] -> processPermutations hash position fullPermutations skip fullPermutations (iteration+1)
        | perm::otherPerms ->
            let nextHash = applyPermutation hash position perm
            let nextPos = (position + perm + skip) % (List.length hash)
            let nextSkip = skip+1
            processPermutations nextHash nextPos otherPerms nextSkip fullPermutations iteration


let processInput(input:int[]) = 
    let hash:int list = [for i in 0..255 -> i]
    let permutations = Array.toList (Array.append input [|17; 31; 73; 47; 23|])
    let position:int = 0
    let skip:int = 0
    processPermutations hash 0 permutations 0 permutations 0
    |> toDense [||] 0
    |> printToHex
    printfn ""

[<EntryPoint>]
let main(args) =
    if Array.length args < 1 then printfn "Need an input"
    else processInput (Array.map int (args.[0].ToCharArray()))
    0

