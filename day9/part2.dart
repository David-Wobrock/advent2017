import 'dart:io';

int processInput(input) {
    var ret = processGroup(input, 1); // input[0] is {, so start at i=1
    return ret[1];
}

List processGroup(input, i) {
    var amountOfGarbage = 0;
    var mylist;
    while (i < input.length) {
        if (input[i] == '!') {
            i = processEspace(input, i+1);
        } else if (input[i] == '<') {
            mylist = processGarbage(input, i+1);
            i = mylist[0];
            amountOfGarbage += mylist[1];
        } else if (input[i] == '{') {
            mylist = processGroup(input, i+1);
            i = mylist[0];
            amountOfGarbage += mylist[1];
        } else if (input[i] == '}') {
            // End of group
            return [i+1, amountOfGarbage];
        } else {
            ++i;
        }
    }
}

int processEspace(input, i) {
    return i+1;
}

List processGarbage(input, i) {
    var amountOfGarbage = 0;
    while (i < input.length) {
        if (input[i] == '!') {
            i = processEspace(input, i+1);
        } else if (input[i] == '>') {
            // End of garbage
            return [i+1, amountOfGarbage];
        } else {
            ++i;
            ++amountOfGarbage;
        }
    }
}

void main(args) {
    if (args.length == 0) {
        print('Need an input');
        exit(1);
    }
    var filename = args[0];
    var f = new File(filename);
    var input = f.readAsLinesSync()[0];
    var garbage = processInput(input);
    print('Garbage ${garbage}');
}
