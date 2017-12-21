<?php

function myreadfile($name) {
    $array = array();
    $handle = fopen($name, "r");
    $line_ctn = 0;
    if ($handle) {
        while (($line = fgets($handle)) !== false) {
            array_push($array, array());
            for ($i = 0; $i < strlen($line); $i++) {
                array_push($array[$line_ctn], $line[$i]);
            }
            $line_ctn = $line_ctn + 1;
        }
    } else {
        print("Cannot open file\n");
        exit(1);
    }
    return $array;
}

function find_start($laby) {
    for ($i = 0; $i < sizeof($laby[0]); $i++) {
        if ($laby[0][$i] === '|') {
            return $i;
        }
    }
}

function is_empty($arg) {
    return $arg === " " || $arg === ' ' || $arg == '' || $arg == "";
}

function is_end($laby, $x, $y, $dir) {
    $surroundings = 0;
    // Up
    if (!is_empty($laby[$x-1][$y])) {
        $surroundings = $surroundings + 1;
    }
    // Down
    if (!is_empty($laby[$x+1][$y])) {
        $surroundings = $surroundings + 1;
    }
    // Right
    if (!is_empty($laby[$x][$y+1])) {
        $surroundings = $surroundings + 1;
    }
    // Left
    if (!is_empty($laby[$x][$y-1])) {
        $surroundings = $surroundings + 1;
    }

    return $surroundings === 1;
}

function move($laby, $x, $y, $dir) {
    // Move into direction if possible
    if ($dir === 'n' && !is_empty($laby[$x-1][$y])) {
        return array($x-1, $y, $dir);
    } elseif ($dir === 's' && !is_empty($laby[$x+1][$y])) {
        return array($x+1, $y, $dir);
    } elseif ($dir === 'w' && !is_empty($laby[$x][$y-1])) {
        return array($x, $y-1, $dir);
    } elseif ($dir === 'e' && !is_empty($laby[$x][$y+1])) {
        return array($x, $y+1, $dir);
    } else {
    // Else, change direction
        if ($dir === 'n' || $dir === 's') {
            if (!is_empty($laby[$x][$y-1])) {
                return array($x, $y-1, 'w');
            } elseif (!is_empty($laby[$x][$y+1])) {
                return array($x, $y+1, 'e');
            }
        } elseif ($dir === 'e' || $dir === 'w') {
            if (!is_empty($laby[$x-1][$y])) {
                return array($x-1, $y, 'n');
            } elseif (!is_empty($laby[$x+1][$y])) {
                return array($x+1, $y, 's');
            }
        }
    }
    print("ERROR");
    exit(1);
}

function on_letter($laby, $x, $y) {
    return (!is_empty($laby[$x][$y])) && $laby[$x][$y] != '+' && $laby[$x][$y] != '|' && $laby[$x][$y] != '-';
}

function do_labyrinth($laby) {
    $x = 1;
    $y = find_start($laby);
    $dir = 's'; // south
    $values = array();

    while (!is_end($laby, $x, $y, $dir)) {
        $new_move = move($laby, $x, $y, $dir);
        $x = $new_move[0];
        $y = $new_move[1];
        $dir = $new_move[2];
        if (on_letter($laby, $x, $y)) {
            $letter = $laby[$x][$y];
            array_push($values, $letter);
        }
    }

    return $values;
}

// Program start
if (sizeof($argv) < 2) {
    print("Need an input\n");
    exit(1);
}

$input = $argv[1];
$laby = myreadfile($input);

$seen_values = do_labyrinth($laby);
for ($i = 0; $i < sizeof($seen_values); $i++) {
    print("$seen_values[$i]");
}
print("\n");
