use strict;
use warnings;

open(my $fh, "<", $ARGV[0]) or die "Can't open file";

my @stack; 
my $len = 0;
while(my $line = <$fh>) {
    @stack[$len] = int($line);
    $len++;
}

my $old_i;
my $i = 0;
my $counter = 0;
while ($i < $len) {
    $old_i = $i;
    $i += $stack[$i];
    $stack[$old_i]++;
    $counter++;
}

print "Result $counter\n";
