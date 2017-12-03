def compute_surroundings(m, x, y, max)
    value = 0
    [[x-1, y], [x+1, y], [x, y-1], [x, y+1], [x-1, y-1], [x-1, y+1], [x+1, y-1], [x+1, y+1]].each do |i|
        if i[0] >= 0 && i[0] < max && i[1] >= 0 && i[1] < max && m[i[0]][i[1]] != -1
            value += m[i[0]][i[1]]
        end
    end
    return value
end

unless ARGV.length > 0
    puts "Need an input"
    exit 1
end

input = Integer(ARGV[0])
square_size = Math.sqrt(input).ceil
if square_size % 2 == 0
    square_size += 1
end

m = Array.new(square_size) { Array.new(square_size) { -1 } }
center = ((square_size-1)/2)-1
m[center][center] = 1

latest_value = 1
current_half_matrix = 2
x = center
y = center
while true
    # To the right
    y += 1
    while y < center + current_half_matrix
        m[x][y] = compute_surroundings(m, x, y, square_size)
        if m[x][y] > input
            puts m[x][y]
            exit
        end
        y += 1
    end
    y -= 1
    # To the top
    x -= 1
    while x > center - current_half_matrix
        m[x][y] = compute_surroundings(m, x, y, square_size)
        if m[x][y] > input
            puts m[x][y]
            exit
        end
        x -= 1
    end
    x += 1
    # To the left
    y -= 1
    while y > center - current_half_matrix
        m[x][y] = compute_surroundings(m, x, y, square_size)
        if m[x][y] > input
            puts m[x][y]
            exit
        end
        y -= 1
    end
    y += 1
    # To the bottom
    x += 1
    while x < center + current_half_matrix
        m[x][y] = compute_surroundings(m, x, y, square_size)
        if m[x][y] > input
            puts m[x][y]
            exit
        end
        x += 1
    end
    x -= 1
    current_half_matrix += 1
end
