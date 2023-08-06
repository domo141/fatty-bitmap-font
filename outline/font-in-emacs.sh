#!/bin/sh
:; test $# -gt 0 || { echo "Usage: $0 font [more emacs options]" >&2; exit 1; }
:; unset WINDOWID
:; exec "${EMACS:-emacs}" --debug-init --load "$0" -geometry 50x22 -fn "$@"
:; exit not reached

(defun out (msg &optional prop)
  (let ((start (point)))
    (insert "\n " msg "\n "
	    "abcdefghijklmnopqrstuvwxyz 1234567890 []" "\n "
	    "ABCDEFGHIJKLMNOPQRSTUVWXYZ !\"#$%&/()= {}" "\n")
    (if prop (add-face-text-property start (point) prop))))

(text-mode)

(out "bold" 'bold)
(out "italic" 'italic)
(out "bold-italic" 'bold-italic)
(out "normal")

(insert "\n")
(insert (format " default font width:  %d\n" (default-font-width)))
(insert (format " default font height: %d\n" (default-font-height)))

(not-modified)
(message "C-x C-c to exit")

;; ref: emacsninja.com/posts/forbidden-emacs-lisp-knowledge-block-comments.html
#@00 /* We've just seen #@00, which means "skip to end". */

^^ emacs no longer evaluates this file ^^
-- this block left for future reference -

# Local variables:
# mode: lisp-interaction
# End:
