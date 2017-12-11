package david.advent.day11

import java.io.File

fun distanceFrom00(x: Int, y: Int): Int {
    val ax = y
    val az = x
    val ay = -ax-az

    return arrayOf(Math.abs(ax), Math.abs(ay), Math.abs(az)).max() ?: 0
}

fun processInput(filename: String) {
    val inputStream = File(filename).inputStream()
    val input: String = inputStream.bufferedReader().use { it.readText() }.trim()
    
    var x: Int = 0
    var y: Int = 0
    var furthest: Int = 0
    var dist: Int
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
        dist = distanceFrom00(x, y)
        if (dist > furthest) {
            furthest = dist
        }
    }
    println(furthest)
}

fun main(args: Array<String>) {
    if (args.size < 1) {
        println("Need an input")
    } else {
        processInput(args[0])
    }
}

