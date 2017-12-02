if length(ARGS) < 1
    println("Need an input")
    exit(1)
end
f = open(ARGS[1])
sum = 0
div_result = 0
for row in eachline(f)
    row = map(x->parse(Int32, x), split(row, "\t"))
    for val1 in row
        for val2 in row
            if val1 > val2 && (val1%val2 == 0) && val1 != 1 && val2 != 1
                div_result =val1 / val2
            end
        end
    end
    sum += div_result 
end
println("Result $(sum)")
