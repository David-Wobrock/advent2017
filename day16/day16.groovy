def applySpin(String[] seq, int num) {
    return seq[(seq.length - num)..(seq.length-1)] + seq[0..(seq.length-num-1)]
}

def applyExchange(String[] seq, int pos1, int pos2) {
    return seq.swap(pos1, pos2)
}

def applyPartner(String[] seq, String elem1, String elem2) {
    int pos1 = seq.findIndexValues { it == elem1 }[0]
    int pos2 = seq.findIndexValues { it == elem2 }[0]
    return seq.swap(pos1, pos2)
}

def applyMove(String[] seq, String move) {
    String rest = move.substring(1);
    if (move.startsWith("s")) {
        new_seq = applySpin(seq, rest.toInteger());
    } else if (move.startsWith("x")) {
        String[] splitted_rest = rest.split("/")
        new_seq = applyExchange(seq, splitted_rest[0].toInteger(), splitted_rest[1].toInteger())
    } else if (move.startsWith("p")) {
        String[] splitted_rest = rest.split("/")
        new_seq = applyPartner(seq, splitted_rest[0], splitted_rest[1])
    }
    return new_seq
}

// Program start
if (args.length == 0) {
    println "Need an input"
    System.exit(1);
}

String fileContent = new File(args[0]).text
String[] moves = fileContent.split(",")
moves[moves.length-1] = moves.last().trim()

String[] seq = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"];

for (String move : moves) {
    seq = applyMove(seq, move)
}

for (String elem : seq) {
    print elem
}
