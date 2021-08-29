#!/usr/bin/perl

use 5.8.1;
use strict;
use warnings;

die "Usage: $0 {file}.bdf\n" unless @ARGV == 1;

while (<>) {
    print "\n$_" if /STARTCHAR/;
    next unless /BITMAP/;
    while (<>) {
	last if /ENDCHAR/;
	chomp;
	$_ = sprintf "%08b", hex($_);
	tr/01/ #/;
	print " :$_:\n";
    }
}
print "\n";
