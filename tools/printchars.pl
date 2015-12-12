#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 4 -*-
# $ printchars.pl $
#
# Author: Tomi Ollila -- too ät iki piste fi
#
#	Copyright (c) 2013-2015 Tomi Ollila
#	    All rights reserved
#
# Created: Fri 23 Aug 2013 17:01:57 EEST too
# Last modified: Tue 24 Nov 2015 21:02:52 +0200 too

# print characters referenced by a bdf file

use 5.8.1;
use strict;
use warnings;

binmode STDOUT, ':utf8';

if (@ARGV) {
    die "'$ARGV[0]': no such file\n" unless -f $ARGV[0];
    open I, '<', $ARGV[0] or die;
}
else {
    my $dir = $0;
    $dir = '.' unless $dir =~ s|/[^/]+$||;
    my $file = "$dir/../src/fatty7x16-iso10646-1.bdf";
    die "'$file': no such file -- enter one (.bdf) from the command line\n"
      unless -f $file;
    open I, '<', $file or die;
}

my @codes;

while (<I>) {
    push @codes, chr($1) if /ENCODING\s+(\d+)/;
}

sub out()
{
    my $cnt = 0;
    foreach (@codes) {
	print $_;
	$cnt = 0, print("\n"), next if $cnt >= 68;
	$cnt = $cnt + 1;
    }
    print "\n" if $cnt;
    print "\n";
}

print "\n";
print "\033[1m"; # bold
out;
print "\033[0m"; # normal
print "\033[3m"; # italics
out;
print "\033[1m"; # bold italics (add bold to italics)
out;
print "\033[0m"; # normal
out;
