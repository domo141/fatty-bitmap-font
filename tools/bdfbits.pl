#!/usr/bin/env perl
# $Id; bdfbits.pl $
#
# Author: Tomi Ollila -- too ät iki piste fi
#
#	Copyright (c) 2007 Tomi Ollila
#	    All rights reserved
#
# Created: Tue Nov 06 21:21:34 EET 2007 too
# Last modified: Fri 11 Dec 2015 20:06:18 +0200 too

use strict;
use warnings;

die "Usage $0 filename (or '.' for default) [filename...]\n" unless @ARGV;
if ($ARGV[0] eq '.') {
    $ARGV[0] = "$0";
    $ARGV[0] = '' unless $ARGV[0] =~ s|/[^/]+$|/|;
    $ARGV[0] = $ARGV[0] . '../src/fatty7x16-iso10646-1.bdf';
}


while (<>)
{
    next unless /^STARTCHAR\s+(.*)\s*/;
    my $startchar = $1;
    my $encoding;
    while (<>)
    {
	$encoding = $1, next if /^ENCODING\s+(.*)\s*/;
	last if /^BITMAP/;
    }
    my (@bitlines, $width); $width = 0;
    while (<>)
    {
	last if /^ENDCHAR/;
	chomp;
	my $w = length;
	my $val = hex $_;
	push @bitlines, [$_, $val];
	$width = $w if $w > $width;
    }
    printf "Char $encoding (0x%x): $startchar\n\n", $encoding;

    print ' ' x $width;
    $width *= 4;
    print ' '. '-' x ($width + 2), "\n";
    foreach (@bitlines) {
	my $bv = $_->[1];
	print $_->[0], ' |';
	for (reverse 0..$width-1)
	{
	    if ($bv & 2 ** $_) { print "#"; } else { print $_&1?'.':','; }
	}
	print "|\n";
    }
    print ' ' x ($width / 4);
    print ' ', '-' x ($width + 2), "\n\n";
}
