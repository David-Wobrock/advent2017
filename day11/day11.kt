package david.advent.day11

import java.io.File

fun distanceFrom00(x: Int, y: Int): Int? {
    val ax = y
    val az = x
    val ay = -ax-az

    return arrayOf(Math.abs(ax), Math.abs(ay), Math.abs(az)).max()
}

fun processInput(filename: String) {
    val inputStream = File(filename).inputStream()
    val input: String = inputStream.bufferedReader().use { it.readText() }.trim()
    
    var x: Int = 0
    var y: Int = 0
    for (direction in input.split(",")) {
        if (direction == "n") {
            y -= 1
        } else if (direction == "s") {
            y += 1
        } else if (direction == "ne") {
            x += 1
            y -= 1
        } else if (direction == "nw") {
            x -= 1
        } else if (direction == "se") {
            x += 1
        } else if (direction == "sw") {
            x -= 1
            y += 1
        } else {
            println("Unknown direction")
        }
    }
    println("x: ${x}")
    println("y: ${y}")
    println(distanceFrom00(x, y))
}

fun main(args: Array<String>) {
    if (args.size < 1) {
        println("Need an input")
    } else {
        processInput(args[0])
    }
}
