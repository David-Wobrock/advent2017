import std.conv;
import std.process;
import std.stdio;
import std.string;

void main(string[] args) {
    if (args.length < 2) {
        writeln("Need an input");
    } else {
        string input = args[1];
        string hash, binary16bits;
        long value;
        long numberOfFull = 0;
        for (int i = 0; i < 128; ++i) {
            hash = strip(executeShell("mono ../day10/part2.exe " ~ input ~ "-" ~ to!string(i))[1]);
            for (int k = 0; k < 32; ++k) {
                value = to!ulong(to!string(hash[k]), 16);
                binary16bits = format("%4b", value);
                for (int a = 0; a < binary16bits.length; ++a) {
                    if (binary16bits[a] == '1') {
                        ++numberOfFull;
                    }
                }
            }
        }
        writeln(numberOfFull);
    }
}
