import std.container;
import std.conv;
import std.process;
import std.stdio;
import std.string;

void propagateOnNeighbours(ulong[128][] grid, ulong posX, ulong posY, ulong group) {
    if (posY != 0 && grid[posX][posY-1] != 0 && grid[posX][posY-1] != group) {
        grid[posX][posY-1] = group;
        propagateOnNeighbours(grid, posX, posY-1, group);
    }
    if (posX != 0 && grid[posX-1][posY] != 0 && grid[posX-1][posY] != group) {
        grid[posX-1][posY] = group;
        propagateOnNeighbours(grid, posX-1, posY, group);
    }
    if (posY != 127 && grid[posX][posY+1] != 0 && grid[posX][posY+1] != group) {
        grid[posX][posY+1] = group;
        propagateOnNeighbours(grid, posX, posY+1, group);
    }
    if (posX != 127 && grid[posX+1][posY] != 0 && grid[posX+1][posY] != group) {
        grid[posX+1][posY] = group;
        propagateOnNeighbours(grid, posX+1, posY, group);
    }
}

void main(string[] args) {
    if (args.length < 2) {
        writeln("Need an input");
    } else {
        string input = args[1];
        string hash, binary16bits;
        long value;
        auto grid = new ulong[128][128];
        for (int i = 0; i < 128; ++i) {
            for (int j = 0; j < 128; ++j) {
                grid[i][j] = 0;
            }
        }

        ulong posX, posY;
        ulong nextGroup = 1;
        for (int i = 0; i < 128; ++i) {
            posX = i;
            hash = strip(executeShell("mono ../day10/part2.exe " ~ input ~ "-" ~ to!string(i))[1]);
            for (ulong k = 0; k < 32; ++k) {
                value = to!ulong(to!string(hash[k]), 16);
                binary16bits = format("%4b", value);
                for (ulong a = (4 - binary16bits.length); a < 4; ++a) {
                    if (binary16bits[a] == '1') {
                        posY = (k*4) + a;
                        // Check if group exists around (4 directions)
                        // If yes, take this number
                        if (posY != 0 && grid[posX][posY-1] != 0) {
                            grid[posX][posY] = grid[posX][posY-1];
                        } else if (posX != 0 && grid[posX-1][posY] != 0) {
                            grid[posX][posY] = grid[posX-1][posY];
                        } else if (posY != 127 && grid[posX][posY+1] != 0) {
                            grid[posX][posY] = grid[posX][posY+1];
                        } else if (posX != 127 && grid[posX+1][posY] != 0) {
                            grid[posX][posY] = grid[posX+1][posY];
                        } else {
                            // Else new number and increment
                            grid[posX][posY] = nextGroup++;
                        }
                        propagateOnNeighbours(grid, posX, posY, grid[posX][posY]);
                    }
                }
            }
        }

        RedBlackTree!ulong tree = new RedBlackTree!ulong();
        for (int i = 0; i < 128; ++i) {
            for (int j = 0; j < 128; ++j) {
                tree.insert(grid[i][j]);
            }
        }
        writeln(tree.length - 1);
    }
}
