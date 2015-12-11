
.PHONY: fonts
fonts:
	make -C src all
	@echo; echo 'Fonts built. Execute `make xset` (or make all) to activate these fonts.'; echo

all:	fonts xset

.PHONY: xset
xset:
	@-x() { echo "$$@" >&2; exec "$$@"; }; x xset fp- "$$PWD"/pcf
	@x() { echo "$$@" >&2; exec "$$@"; }; x xset fp+ "$$PWD"/pcf
	xset fp rehash

.PHONY: xunset
xunset:
	@x() { echo "$$@" >&2; exec "$$@"; }; x xset fp- "$$PWD"/pcf
	xset fp rehash

.PHONY: clean
clean:
	make -C src clean
	rm -f *~ tools/*~

distclean: clean
	rm -rf pcf

# drop make builtin suffix rules
.SUFFIXES:
