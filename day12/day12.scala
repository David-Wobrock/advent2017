import scala.io.Source
import scala.collection.mutable

class Node(id: Int, n: Array[Int]) {
    var name: Int = id
    var next: Array[Int] = n
    var visited = false
}

def BFS(nodes: mutable.Map[Int, Node], id: Int): Unit = {
    val n = nodes(id)
    if (!n.visited) {
        n.visited = true
        for (next <- n.next) {
            BFS(nodes, next)
        }
    }
}

def processInput(input: String): Unit = {
    var nodes = mutable.Map[Int, Node]()
    for (line <- Source.fromFile(input).getLines()) {
        val splitted = line.split(" <-> ")
        val id: Int = splitted(0).toInt
        val n: Array[Int] = splitted(1).split(", ").map(x => x.toInt)
        var node = new Node(id, n)
        nodes(id) = node
    }
    BFS(nodes, 0)
    println(nodes.values.filter(_.visited).size)
}

// Program start
if (args.length < 1) {
    println("Need an input")
    System.exit(1)
}

processInput(args(0))
