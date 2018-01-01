import java.util.Date
import groovy.time.TimeDuration
import groovy.time.TimeCategory

def applySpin(String[] seq, int num) {
    return seq[(seq.length - num)..(seq.length-1)] + seq[0..(seq.length-num-1)]
}

def applyExchange(String[] seq, int pos1, int pos2) {
    return seq.swap(pos1, pos2);
}

def applyPartner(String[] seq, String elem1, String elem2) {
    int pos1 = -1
    int pos2 = -1
    for (i in 0 .. seq.length-1) {
        if (pos1 == -1 && seq[i] == elem1) {
            pos1 = i
        } else if (pos2 == -1 && seq[i] == elem2) {
            pos2 = i
        }

        if (pos1 != -1 && pos2 != -1) {
            break
        }
    }
    return applyExchange(seq, pos1, pos2)
}

def move2fn(String move) {
    String rest = move.substring(1);
    def fn = 0
    if (move.startsWith("s")) {
        fn = { seq -> applySpin(seq, rest.toInteger()) }
    } else if (move.startsWith("x")) {
        String[] splitted_rest = rest.split("/")
        fn = { seq -> applyExchange(seq, splitted_rest[0].toInteger(), splitted_rest[1].toInteger()) }
    } else if (move.startsWith("p")) {
        String[] splitted_rest = rest.split("/")
        fn = { seq -> applyPartner(seq, splitted_rest[0], splitted_rest[1]) }
    }
    return fn
}

// Program start
if (args.length == 0) {
    println "Need an input"
    System.exit(1);
}

String fileContent = new File(args[0]).text
String[] moves = fileContent.split(",")
moves[moves.length-1] = moves.last().trim()

def functions = []
for (String move : moves) {
    functions.add(move2fn(move))
}

String[] seq = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p"];
def repeats = [:]
repeats.put(0, seq.join())

//for (i in 1 .. 1000000000) {
for (i in 1 .. 16) {
    for (def fn : functions) {
        seq = fn(seq)
    }
    def joined = seq.join()
    if (repeats.containsValue(joined)) {
        println "Repeat at ${i} ${joined}"
    }
    repeats.put(i, joined)
}

for (String elem : seq) {
    print elem
}
