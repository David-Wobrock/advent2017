def turnRight(dir)
    if dir == 'n'
        newDir = 'e'
    elsif dir == 'e'
        newDir = 's'
    elsif dir == 's'
        newDir = 'w'
    elsif dir == 'w'
        newDir = 'n'
    end
    return newDir
end

def turnLeft(dir)
    if dir == 'n'
        newDir = 'w'
    elsif dir == 'w'
        newDir = 's'
    elsif dir == 's'
        newDir = 'e'
    elsif dir == 'e'
        newDir = 'n'
    end
    return newDir
end

def moveForward(xy, dir)
    newX = xy[0]
    newY = xy[1]
    if dir == 'n'
        newX -= 1
    elsif dir == 's'
        newX += 1
    elsif dir == 'e'
        newY += 1
    elsif dir == 'w'
        newY -= 1
    end
    return {newX, newY}
end

if ARGV.size < 1
    puts "Need an input"
    exit(1)
end

lines = File.read_lines(ARGV[0])
grid = Array({Int32, Int32}).new
i = 0
grid_size = lines.size
factor = grid_size/2
while i < grid_size
    j = 0
    while j < grid_size
        if lines[i][j] == '#'
            grid << {i-factor, j-factor}
        end
        j += 1
    end
    i += 1
end

virus_x = 0
virus_y = 0
virus_dir = 'n'

num_it = 10000
i = 0
num_caused_infection = 0
while i < num_it
    current_is_infected = grid.find {|t| t[0] == virus_x && t[1] == virus_y} != nil
    # Step 1 - Direction
    if current_is_infected
        virus_dir = turnRight(virus_dir)
    else
        virus_dir = turnLeft(virus_dir)
    end
    # Step 2 - Infection
    if current_is_infected
        grid.delete({virus_x, virus_y})
    else
        grid << {virus_x, virus_y}
        num_caused_infection += 1
    end
    # Step 3 - Move
    newXY = moveForward({virus_x, virus_y}, virus_dir)
    virus_x = newXY[0]
    virus_y = newXY[1]

    i += 1
end

puts "# caused infection :"
puts num_caused_infection
