#!/usr/bin/perl
# -*- mode: cperl; cperl-indent-level: 4 -*-
# $ bdfbits-braille.pl $
#
# Author: Tomi Ollila -- too ät iki piste fi
#
#	Copyright (c) 2015 Tomi Ollila
#	    All rights reserved
#
# Created: Wed 09 Dec 2015 19:02:24 EET too
# Last modified: Fri 11 Dec 2015 20:08:52 +0200 too

use 5.8.1;
use strict;
use warnings;

binmode STDOUT, ':utf8';

my $d = $0; $d = '.' unless $d =~ s|/[^/]+$||;

open I, '-|', $d . '/bdfbits.pl', @ARGV or die;
#open I, 'fatty-bitmap-font.txt' or die;

my @l;

# http://www.alanwood.net/unicode/braille_patterns.html
# https://github.com/asciimoo/drawille

sub brout()
{
    my @s = (0) x 512;
    my ($l, $c, $mc); $mc = 0;
    $c = 0; $l = (shift @l) . '.';
    while ($l =~ s/(.)(.)//) {
	$s[$c++] |= ($1 eq '#') * 1 + ($2 eq '#') * 8;
    }
    $mc = $c if $mc < $c;
    $c = 0; $l = (shift @l || '') . '.';
    while ($l =~ s/(.)(.)//) {
	$s[$c++] |= ($1 eq '#') * 2 + ($2 eq '#') * 16;
    }
    $mc = $c if $mc < $c;
    $c = 0; $l = (shift @l || '') . '.';
    while ($l =~ s/(.)(.)//) {
	$s[$c++] |= ($1 eq '#') * 4 + ($2 eq '#') * 32;
    }
    $mc = $c if $mc < $c;
    $c = 0; $l = (shift @l || '') . '.';
    while ($l =~ s/(.)(.)//) {
	$s[$c++] |= ($1 eq '#') * 64 + ($2 eq '#') * 128;
    }
    splice @s, $mc;

    print " ";
    print chr(0x2800 + $_) for (@s);
    print "\n";
    @l = ();
}

while (<I>)
{
    if (/([,.#]{4,})/) {
	#print $1, "\n";
	push @l, $1;
	brout if @l == 4;
    }
    else {
	brout if @l;
    }
}

close I;
exit $?;
