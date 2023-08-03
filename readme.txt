
  ⠀⢠⡶⢦⠀⣀⣀⠀⣰⣆⡀⢀⣶⣀⠀⣀⠀⣀⠀⠀⠀⠀⣶⢀⡀⠀⣐⡋⠀⣰⣆⡀⢀⡀⢀⡀⢀⣀⡀⢀⢀⣀⠀⠀⠀⠀⠀⣴⠶⡄⢀⣀⡀⢀⢀⣀⠀⣰⣆⡀
  ⢰⡿⠶⢀⣨⣭⡿⢈⡿⠉⠀⣹⠏⠁⣸⢇⣸⠇⠀⠀⠀⣸⠟⣹⠇⢈⡿⠀⢈⡿⠉⢀⡿⢿⡿⣀⣭⣽⢇⡿⢉⡿⠀⠀⠀⠀⣾⠷⠆⣸⠏⣹⢇⡿⢋⡿⢈⡿⠉⠀
  ⠼⠃⠀⠸⠷⠺⠃⠸⠷⠚⠀⠿⠖⢃⠙⢫⡟⠀⠀⠀⠠⠻⠷⠛⠠⠾⠗⠀⠸⠷⠚⠼⠃⠼⠃⠿⠖⠟⣼⠋⠛⠁⠀⠀⠀⠠⠟⠀⠀⠿⠶⠛⠼⠃⠼⠃⠸⠷⠚⠀
  ⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣘⣛⣋⣁⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣐⣋⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⣀⡀

  (update 2023-07-27 -- emboldening outline fonts in outline/)

  fatty is a 7x16 pixel, fixed width bitmap font. this contais
  647 glyphs (of which 256 (U+2800 - U+28ff) braille patterns)
  (the title is constructed of braille characters, i hope your
  current font can show it properly).

  this font has originally been "designed" for ~125 dpi screen
  lcd and the criteria has been more in usability than beauty.
  in smaller displays with higher dpi (such as mobile devices)
  which are close to eye there might be use cases as well...

  this font is delivered in glyph bitmap distribution format
  (bdf) (see wikipedia) in src/ directory. the bold and italic
  variants are created from the normal regular format by two
  public domain tools, also available in src/ directory. the
  third tool in src/ is used to create iso-8859-n variants of
  the (one and only) iso-10646-1 source file.

  currently the only supported output format is .pcf, portable
  compiled format used by Xserver in its core font system (see
  wikipedia)

  to build this font, just enter 'make' on the top directory.
  it will build normal, bold, italic and bold-italic versions,
  iso-10646-1 and iso-8859-n where n is 1,2,3,4,9,10,13,14,15
  and 16. to test the just build font on an X11 desktop, enter
  'make xset' (like instructed at the end of build process).
  now e.g. 'xterm -fn fatty7x16' or 'urxvt -fn fatty7x16'
  should open terminal using this font.

  to install this for general use, move the pcf/ directory
  somewhere and add 'xset fp+ <directory>' to some of your X11
  environment startup scripts (i guess there's some "standard"
  place for this under users' $HOME/ but i just don't know it
  right now).

  (update 2023-08-03: create dir $HOME/.local/share/fonts/core/,
   copy files there and run that xset fp+ (xset fp- previous
   first, if one... and also run fc-cache -fv. now also
   urxvt -fn xft:Fatty:pixelsize=16  and  emacs -fn Fatty
   may work...)

  the tools/ directory contains tools related to this font.
  these are safe to run as is (these don't modify anything
  by default and these give brief help if needed). perhaps
  the neatest thing there is 'tools/sbfe-in-emacs' the
  "simplish bitmap font editor in emacs".

  thanks to Jim Knoble, for his altneep font (8x15 one) which
  i used for initial base in 2003 when i started doing this
  font. much of it i broke to get it to fit here. to Mark
  Leoisher, for xmbdfed which i used when converting altneep
  glyphs. to Markus G. Kuhn whose ucs-fonts package, i used
  that for reference when continuing beyond iso-8859-1 and
  iso-8859-15. to Nagao Sadakazu and Yasuyuki Furukawa, for
  their mkbold-1.0 and mkitalic-1.0 tools.

  these fonts are released under GPL v2 or later, in the hope
  that these will be useful, but WITHOUT ANY WARRANTY; without
  even the implied warranty of MERCHANTABILITY or FITNESS FOR
  A PARTICULAR PURPOSE. See the GNU General Public License for
  more details.

  Tomi Ollila
