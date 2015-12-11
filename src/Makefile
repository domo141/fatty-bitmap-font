
f7b0 = fatty7x16
f7b1 = fatty7x16B fatty7x16I fatty7x16BI

f7bu0 = $(f7b0:%=%-iso10646-1.bdf)
f7bu1 = $(f7b1:%=%-iso10646-1.bdf)

f7bu = $(f7bu0) $(f7bu1)

f7bl1 = $(f7bu:%-iso10646-1.bdf=%-iso8859-1.bdf)
f7bl2 = $(f7bu:%-iso10646-1.bdf=%-iso8859-2.bdf)
f7bl3 = $(f7bu:%-iso10646-1.bdf=%-iso8859-3.bdf)
f7bl4 = $(f7bu:%-iso10646-1.bdf=%-iso8859-4.bdf)
f7bl5 = $(f7bu:%-iso10646-1.bdf=%-iso8859-9.bdf)
f7bl6 = $(f7bu:%-iso10646-1.bdf=%-iso8859-10.bdf)
f7bl7 = $(f7bu:%-iso10646-1.bdf=%-iso8859-13.bdf)
f7bl8 = $(f7bu:%-iso10646-1.bdf=%-iso8859-14.bdf)
f7bl9 = $(f7bu:%-iso10646-1.bdf=%-iso8859-15.bdf)
f7bl10= $(f7bu:%-iso10646-1.bdf=%-iso8859-16.bdf)

f7bgen = $(f7bu1) $(f7bl1) $(f7bl2) $(f7bl3) $(f7bl4) $(f7bl5) \
	$(f7bl6) $(f7bl7) $(f7bl8) $(f7bl9) $(f7bl10)

f7bdfs= $(f7bu0) $(f7bgen)

bdfs = $(f7bdfs)

pcfs = $(bdfs:%.bdf=%.pcf)

pcfgz = $(pcfs:%.pcf=../pcf/%.pcf.gz)

#all:	@echo $(pcfgz) | tr ' ' \\012

all: ../pcf/.stamp $(pcfgz) ../pcf/fonts.dir ../pcf/fonts.alias # ttffont.try

# /-- uncomment if keeping intermediate files is desired...
#.SECONDARY:

ttffont.try:
	: create .ttf font if fonttosfnt tool exists
	fonttosfnt -v -o fattyBitmap.ttf 2>/dev/null \
		fatty7x16-iso10646-1.bdf || :
	test -f fattyBitmap.ttf && { \
		test -d ../ttf || mkdir ../ttf; \
		mv fattyBitmap.ttf ../ttf; touch ttffont.try; } || :

$(pcfgz): ../pcf/.stamp

../pcf/.stamp:
	test -d ../pcf || mkdir ../pcf; : > $@

../pcf/fonts.dir: ../pcf/.stamp $(pcfgz)
	cd ../pcf && exec mkfontdir -x .bdf

../pcf/fonts.alias: ../pcf/.stamp $(pcfgz) Makefile
	sed -n '/^fontalias.sh:/,/^ *$$/ p' Makefile | tail -n +3 | sh -ve #-nv


clean:
	rm -f $(f7bgen) $(pcfs) ttffont.try *~

.INTERMEDIATE: mkitalic-1.0-dy4
mkitalic-1.0-dy4: mkitalic-1.0 Makefile
	perl -pe 's/3/4/ if /slant deep/' $< > $@

%.pcf:	%.bdf
	bdftopcf -o $@ $<

../pcf/%.pcf.gz: %.pcf
	gzip -c $< > $@

fatty7x16-iso8859-%.bdf: fatty7x16-iso10646-1.bdf
	perl ./ucs2some.pl iso-8859-$* $< > $@

fatty7x16B-%.bdf: fatty7x16-%.bdf
	perl ./mkbold-1.0 $< > $@

fatty7x16I-%.bdf: fatty7x16-%.bdf   mkitalic-1.0-dy4
	perl ./mkitalic-1.0-dy4 $< > $@

fatty7x16BI-%.bdf: fatty7x16B-%.bdf mkitalic-1.0-dy4
	perl ./mkitalic-1.0-dy4 $< > $@


fontalias.sh:
	exit 1 # this target is not to be run.
	set -eux
	rm -f ../pcf/fonts.alias
	exec > ../pcf/fonts.alias.wip
	:
	o () {	echo ${ap}$1 "  $2" -$fp-medium-r-normal--16-160-75-75-c-$w-$3
		echo ${ap}I$1 " $2" -$fp-medium-i-normal--16-160-75-75-c-$w-$3
		echo ${ap}B$1 " $2" -$fp-bold-r-normal--16-160-75-75-c-$w-$3
		echo ${ap}BI$1 "$2" -$fp-bold-i-normal--16-160-75-75-c-$w-$3
		echo
	}
	ap=fatty7x16 fp=too-fatty w=70
	o '' '    ' iso10646-1
	o '-l1' ' ' iso8859-1
	o '-l2' ' ' iso8859-2
	o '-l3' ' ' iso8859-3
	o '-l4' ' ' iso8859-4
	o '-l5' ' ' iso8859-9
	o '-l6' ' ' iso8859-10
	o '-l7' ' ' iso8859-13
	o '-l8' ' ' iso8859-14
	o '-l9' ' ' iso8859-15
	o '-l10' '' iso8859-16
	mv ../pcf/fonts.alias.wip ../pcf/fonts.alias
	exit

# drop make builtin suffix rules
.SUFFIXES:
