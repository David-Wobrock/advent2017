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

def turnReverse(dir)
    if dir == 'n'
        newDir = 's'
    elsif dir == 'w'
        newDir = 'e'
    elsif dir == 's'
        newDir = 'n'
    elsif dir == 'e'
        newDir = 'w'
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
infected = Array({Int32, Int32}).new
weak = Array({Int32, Int32}).new
flagged = Array({Int32, Int32}).new
i = 0
grid_size = lines.size
factor = grid_size/2
while i < grid_size
    j = 0
    while j < grid_size
        if lines[i][j] == '#'
            infected << {i-factor, j-factor}
        end
        j += 1
    end
    i += 1
end

virus_x = 0
virus_y = 0
virus_dir = 'n'

num_it = 10000000
i = 0
num_caused_infection = 0
while i < num_it
    current_is_infected = infected.find {|t| t[0] == virus_x && t[1] == virus_y} != nil
    current_is_weak = weak.find {|t| t[0] == virus_x && t[1] == virus_y} != nil
    current_is_flagged = flagged.find {|t| t[0] == virus_x && t[1] == virus_y} != nil
    current_is_clean = (!current_is_infected) && (!current_is_weak) && (!current_is_flagged)
    # Step 1 - Direction
    if current_is_infected
        virus_dir = turnRight(virus_dir)
    elsif current_is_clean
        virus_dir = turnLeft(virus_dir)
    elsif current_is_flagged
        virus_dir = turnReverse(virus_dir)
    end
    # Step 2 - Infection
    if current_is_clean
        weak << {virus_x, virus_y}
    elsif current_is_weak
        weak.delete({virus_x, virus_y})
        infected << {virus_x, virus_y}
        num_caused_infection += 1
    elsif current_is_infected
        infected.delete({virus_x, virus_y})
        flagged << {virus_x, virus_y}
    elsif current_is_flagged
        flagged.delete({virus_x, virus_y})
    end
    # Step 3 - Move
    newXY = moveForward({virus_x, virus_y}, virus_dir)
    virus_x = newXY[0]
    virus_y = newXY[1]

    i += 1
end

puts "# caused infection :"
puts num_caused_infection

