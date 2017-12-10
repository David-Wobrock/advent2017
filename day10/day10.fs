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


let rec processPermutations (hash: int list) (position:int) (permutations: int list) (skip:int) =
    match permutations with
    | [] -> (List.head hash) * (List.head (List.tail hash))
    | perm::otherPerms ->
        let nextHash = applyPermutation hash position perm
        let nextPos = (position + perm + skip) % (List.length hash)
        let nextSkip = skip+1
        processPermutations nextHash nextPos otherPerms nextSkip


let processInput(input:string) = 
    let hash:int list = [for i in 0..255 -> i]
    let permutations = Array.toList (Array.map int (input.Split [|','|]))
    let position:int = 0
    let skip:int = 0
    printfn "%d" (processPermutations hash 0 permutations 0)


[<EntryPoint>]
let main(args) =
    if Array.length args < 1 then printfn "Need an input"
    else processInput args.[0]
    0
