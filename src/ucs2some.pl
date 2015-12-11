#!/usr/bin/env perl
# $Id; ucs2some.pl $
#
# Author: Tomi Ollila -- too ät iki piste fi
#
# Created: Sun Nov 04 20:30:08 EET 2007 too
# Last modified: Mon 27 Jan 2014 21:40:53 +0200 too
#
# * public domain *


# Quick & simple, to support more encodings this should convert all found
# ENCODING values from source file for target. Now this just does 128..255.

use strict;
use warnings;

my %supported =
  ( "iso-8859-1" => [ "ISO8859-1", "160..255" ],
    "iso-8859-2" => [ "ISO8859-2", "160..255" ],
    "iso-8859-3" => [ "ISO8859-3", "160..164,166..173,175..189,191..194,196..207,209..226,228..239,241..255" ],
    "iso-8859-4" => [ "ISO8859-4", "160..255" ],
    "iso-8859-7" => [ "ISO8859-7", "160..173,175..209,211..254" ],
    "iso-8859-9" => [ "ISO8859-9", "160..255" ],
    "iso-8859-10" => [ "ISO8859-10", "160..255" ],
    "iso-8859-13" => [ "ISO8859-13", "160..255" ],
    "iso-8859-14" => [ "ISO8859-14", "160..255" ],
    "iso-8859-15" => [ "ISO8859-15", "160..255" ],
    "iso-8859-16" => [ "ISO8859-16", "160..255" ]
  );

die "Usage: $0 to-code filename\n" unless defined $ARGV[1];

die "Filename $ARGV[1] does not end with '-iso10646-1.bdf'\n"
  unless $ARGV[1] =~ /-iso10646-1.bdf$/;

my $code = $supported{$ARGV[0]};

#$code = [ "ISO8859-X", "160..255" ]
die "$ARGV[0] not currently supported encoding\n"
  unless defined $code;

my $chrset = $code->[0];
my $chrrange = $code->[1];

$chrset =~ /(.*)-(.*)/; # greedy!
my $chrset_registry = $1;
my $chrset_encoding = $2;

open I, '-|', 'iconv -l' or die "Running iconv failed: $!\n";

my ($f, $t) = 0;

while (<I>)
{
    $t = $1 if /^(utf32be)\b/i;
    $t = $1 if /^(utf-32be)\b/i and ! $t;
    $f = 1 if /\b$ARGV[0]\b/i;
}
close I;

die "iconv does not know utf32be\n" unless $t;
die "iconv does not know $ARGV[0]\n" unless $f;

die "$ARGV[1]: not a file\n" unless -f $ARGV[1];


my %encmap;

open I, "set -x; perl -e 'print chr \$_ - 128, chr \$_ for ($chrrange)' | iconv -f $ARGV[0] -t $t |" or die "Running iconv failed: $!\n";

while (read(I, $_, 8) == 8)
{
    my ($n, $v) = unpack("NN", $_);
    $encmap{$v} = $n + 128;
}
close I;

open I, '<', $ARGV[1] or die "Can not open $ARGV[1] for reading\n";

my (@header, @lines);

while (<I>)
{
    chomp;
    if (/^FONT\s/) {
	s/ISO10646-1\s*$/$chrset/ or die "'$_' does not end with ISO10646-1\n";
    } elsif (/^CHARSET_REGISTRY\s/) {
	$_ = qq(CHARSET_REGISTRY "$chrset_registry");
    } elsif (/^CHARSET_ENCODING\s/) {
	$_ = qq(CHARSET_ENCODING "$chrset_encoding");
    }

    push @header, "$_\n";
    last if /^ENDPROPERTIES/;
}

$" = '';
for (; defined $_; $_ = <I>)
{
    next unless /^STARTCHAR/;
    my @line = ( $_ );
    my $use = 0;
    while (<I>)
    {
	if (/^ENCODING\s+(\d+)/)
	{
	    $use = 1;
	    push(@line, $_), next if $1 < 128;
	    my $mv = $encmap{$1};
	    $use = 0, next unless defined $mv;
	    push @line, "ENCODING $mv\n";
	    next;
	}
	push @line, $_;
	last if /^ENDCHAR/;
    }
    push(@lines, "@line") if $use;
}
close I;

my @sorted = sort {
    $a =~ /NCODING\s+(\d+)/; my $av = $1; $b =~ /NCODING\s+(\d+)/; $av <=> $1;
} @lines;

print @header;
print 'CHARS ', scalar @sorted, "\n";
print @sorted;
print "ENDFONT\n";
