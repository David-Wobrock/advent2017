unless ARGV.length > 0
    puts "Need an input"
    exit 1
end

input = Integer(ARGV[0])
square_size = Math.sqrt(input).ceil
if square_size % 2 == 0
    square_size += 1
end

istart = (square_size - 2) * (square_size - 2) + 1
iend = square_size * square_size

dist1 = (square_size-1)/2

distances = []

middle = iend - dist1
distances += [(input - middle).abs]

middle = iend - dist1 - (square_size-1)
distances += [(input - middle).abs]

middle = iend - dist1 - (square_size-1)*2
distances += [(input - middle).abs]

middle = iend - dist1 - (square_size-1)*3
distances += [(input - middle).abs]

result = dist1 + distances.min
puts "Result #{result}"
