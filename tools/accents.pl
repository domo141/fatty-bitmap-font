#!/usr/bin/env perl
# $Id; accents.pl $
#
# Author: Tomi Ollila -- too ät iki piste fi
#
#	Copyright (c) 2007 Tomi Ollila
#	    All rights reserved
#
# Created: Mon Nov 19 19:41:49 EET 2007 too
# Prev modified: Mon Nov 19 21:07:32 EET 2007 too
# Last modified: Tue 24 Nov 2015 23:26:21 +0200 too

use strict;
use warnings;

use charnames ':full';

#use Data::Dumper;

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

my (%caps, %smalls);

while (<I>)
{
    if (/ENCODING\s+(\d+)/)
    {
	$_ = charnames::viacode($1);
	if (defined $_)
	{
	    my $n = $1;
	    if (/\bcapital\b.*\s(\w)\s/i)
	    {
		if (defined $caps{$1}) {
		    push @{$caps{$1}}, $n;
		}
		else {
		  $caps{$1} = [ $n ];
	      }
	    }
	    elsif (/\bsmall\b.*\s(\w)\s/i)
	    {
		if (defined $smalls{$1}) {
		    push @{$smalls{$1}}, $n;
		}
		else {
		    $smalls{$1} = [ $n ];
		}
	    }
	}
    }
}
close I;

#print Dumper (%caps, %smalls);

binmode STDOUT, ":utf8";

print "\n";

while (my ($k, $v) = each %caps)
{
    print uc($k), ": ";
    foreach (@{$v}) {
	print chr($_);
#	print "$_ ";
    }
    print "\n";
}

print "\n";

while (my ($k, $v) = each %smalls)
{
    print lc($k), ": ";
    foreach (@{$v}) {
	print chr($_);
	#print "$_ ";
    }
    print "\n";

}

print "\n";
