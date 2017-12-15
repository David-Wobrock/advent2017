function matches(a, b)
    return bit32.band(a, 65535) == bit32.band(b, 65535)
end

function generate_next(input, factor, divide)
    return (input * factor) % divide
end

function generate_next_a(input)
    return generate_next(input, 16807, 2147483647)
end

function generate_next_b(input)
    return generate_next(input, 48271, 2147483647)
end

-- Program

if arg[2] == nil then
    print("Need two inputs")
    os.exit()
end

a_input = tonumber(arg[1])
b_input = tonumber(arg[2])

a_output = generate_next_a(a_input)
b_output = generate_next_b(b_input)
counter = 0
for i = 1, 40000000 do
    if matches(a_output, b_output) then
        counter = counter + 1
    end
    a_output = generate_next_a(a_output)
    b_output = generate_next_b(b_output)
end
print(counter)
