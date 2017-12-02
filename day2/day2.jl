if length(ARGS) < 1
    println("Need an input")
    exit(1)
end
f = open(ARGS[1])
sum = 0
for row in eachline(f)
    row = map(x->parse(Int32, x), split(row, "\t"))
    mini = minimum(row)
    maxi = maximum(row)
    sum += maxi - mini
end
println("Result $(sum)")
