
TL;DR; These days I just do:

   $ podman pull debian:12
   $ ./mk-dffci.sh !
   $ cp /path/to/Hack-*.ttf .
   $ ./podman-run debian-12-fontforge:20230902 ./width90-hack.pe Hack-*.ttf
   $ mkdir $HOME/.config/fontconfig/
   $ cp ./fonts.conf $HOME/.config/fontconfig/fonts.conf
   $ mkdir -p $HOME/.local/share/fonts/hack/
   $ mv EmblCondHack-*.ttf $HOME/.local/share/fonts/hack/
   $ fc-cache -fv
   $ emacs -fn EmblCondHack-12 &

--

Eyes gets older and display resolutions higher

Therefore the fatty bitmap font has not been enough for
normal terminal (and emacs) use for me -- size too small.

(It is still very useful in "special" cases (along with "fixed")
(I use it in terminals which starts and logs vpn tunnels))

So, in most cases I'm using "Hack" font, with widths 50-100+
larger than fatty (fatty 7, this one I'm writing w/ 15px width
font (in 6000+ pixels/meter screen)).

But, there I've experienced the same "problem" than with bitmap
fonts -the glyphs are too "thin".

For long time I had this solved with:

  $ urxvt -fn xft:Hack-11:embolden:matrix='.95 0 0 1' -letsp -1

  (and now $ urxvt -fn xft:Hack-11:embolden -letsp -2)

and

  $ emacs -xrm Xft.embolden:true -fn Hack-11

While the rxvt-unicode version (still) works (why would it not),
the emacs version (since using Cairo instead of xft) no longer
utilizes the Xft.embolden resource (it would if one compiled
using the xft backend but...).

Also,   emacs -fn Hack-11:embolden[=true]   does not work as
expected...
Update 2023-08: With emacs-pgtk 29.1 the above seems to work,
so until everyone who desires this emboldening has updated to
 emacs new enough this is still useful (in addition to the
width reducinf feature in some of the scripts...)


So, after playing a while with a thought whether an "emboldened"
version of the font I am using (Hack) could be done, and after
some internet searching and a bit of playing with Fontforge I
got a script written which seems to provide satisfactory results
for me.

and that one is the `./emb-90-hack.pe` here.

Update 2023-08-06: Since the first try I've changed to use fonts.conf
to to the emboldening (and dropped use of `ChangeWeight() in newer
*.pe files). The one I currently use are `width90-hack.pe` and
`fonts.conf` -- this text will be updated later...

That one requires Fontforge to be installed on the system. One
can do that, or (if having podman(1) available), create debian:12
based container image (debian-12-fontforge:yyyymmdd) using the
script ./mk-dffci.sh (make debian 12 fontforge container image)
(and then use ./podman-run-sh to run it).

The script ./font-in-urxvt.sh shows some chars in bold, italic,
bold-italic and regular faces, and {width}x{height} of the
"monospace!" font (and space required for 80x24 character window).

./font-in-emacs.sh does the same using emacs...

I executed /path/to/embolden.pe Hack-*.ttf in $HOME/.fonts/Hack
where I had the Hack font installed (should be in
~/local/share/fonts but...). It created EmbHack-...ttf files,
with only 'familyname' change in metadata. Probably more than
that should be changed before writing the new Emb* -prefixed
files but as those currently work for me I haven't cared too
much. Should someone(tm) desire to distribute the created fonts
(using any source, not just Hack) probably more metadata is to be
updated (after checking *all* glyphs look good enough, too)...

And, now just the following seems to work good enough for me:

  $ urxvt -fn xft:EmbHack-11 -letsp -1

and

  $ emacs -fn EmbHack-11
