package main

import (
    "fmt"
    "os"
    "bufio"
    "io"
    "strings"
    "strconv"
)

type node struct {
    name string
    weight int
    next []string
}

func ReadGraph(filename string) (nodes map[string]node){
    f, err := os.Open(filename)
    if err != nil {
        panic(err)
    }

    nodes = make(map[string]node)
    reader := bufio.NewReader(f)
    var line string
    for {
        line, err = reader.ReadString('\n')
        if err != nil {
            break
        }

        s := strings.Split(strings.TrimRight(line, "\n"), " ")
        name := s[0]
        weight, _ := strconv.Atoi(strings.TrimRight(strings.TrimLeft(s[1], "("), ")"))

        if len(s) > 2 {
            var next []string
            next = make([]string, len(s)-3, len(s)-3)
            for i := 3; i < len(s); i++ {
                next[i-3] = strings.TrimRight(s[i], ",")
            }
            nodes[name] = node{name: name, weight: weight, next: next}
        } else {
            nodes[name] = node{name: name, weight: weight}
        }
    }

    if err != io.EOF {
        fmt.Printf(" > Failed!: %v\n", err)
    }

    return nodes
}

func arrayContains(arr []string, el string) (contains bool) {
    for i := 0; i < len(arr); i++ {
        if arr[i] == el {
            return true
        }
    }
    return false
}

func findRoot(nodes map[string]node) (root string){
    var not_top_node node
    for _, value := range nodes {
        if len(value.next) > 0 {
            not_top_node = value
            break
        }
    }

    var has_node_below bool
    has_node_below = true
    for has_node_below {
        has_node_below = false

        for _, value := range nodes {
            if arrayContains(value.next, not_top_node.name) {
                has_node_below = true
                not_top_node = value
                break
            }
        }
    }

    return not_top_node.name
}

func sumAbove(nodes map[string]node, root string, depth int) (sum int) {
    var root_node node
    root_node = nodes[root]

    sum = root_node.weight

    var each_sum []int
    each_sum = make([]int, len(root_node.next), len(root_node.next))
    if len(root_node.next) != 0 {
        for i := 0; i < len(root_node.next); i++ {
            each_sum[i] = sumAbove(nodes, root_node.next[i], depth+1)
            sum += each_sum[i]
        }
    }
    for j := 0; j < len(each_sum)-1; j++ {
        if each_sum[j] != each_sum[j+1] {
            fmt.Printf("!!!!!!!! Problem with %s\n", root);
        }
    }

    var stars []string
    stars = make([]string, depth, depth)
    fmt.Printf("%s %s sum is %d = %d + %v\n", strings.Join(stars, "**"), root, sum, root_node.weight, each_sum);
    return sum
}

func main() {
    if len(os.Args) < 2 {
        fmt.Println("Need an input")
        os.Exit(1)
    }
    filename := os.Args[1]
    var data map[string]node
    data = ReadGraph(filename)
    var root string
    root = findRoot(data)
    sumAbove(data, root, 1)
}
