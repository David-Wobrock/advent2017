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

    var groups: Int = 1
    BFS(nodes, 0)
    var remaining = nodes.values.filter(_.visited == false)
    while (remaining.size > 0) {
        BFS(nodes, remaining.iterator.next().name)
        groups += 1
        remaining = nodes.values.filter(_.visited == false)
    }
    println(groups)
}

// Program start
if (args.length < 1) {
    println("Need an input")
    System.exit(1)
}

processInput(args(0))
