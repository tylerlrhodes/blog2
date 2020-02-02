---
title: "Emacs/CIDER Notes"
date: 2019-11-16T10:02:15-05:00
draft: false
keywords: [emacs, clojure]
tags: [programming]
description: "My notes on using Emacs."
---


This is a short collection of notes I've made on using Emacs.  Mostly
its the things I've been using just infrequently enough to forget.

It's a work in progress.

### Emacs to do:

Can I have a bash shell in emacs?

Learn all the emacs temp and backup files and why they show up.

Set the mode based upon file extension automatically (md files text-mode with auto-fillmode)

### Terminology

**Frame**: otherwise known as a "window" in Windows.<br/>
**Window**: a window is a view of a buffer within a frame.<br/>
**Buffer**: the place between your brain and the hard disk where work goes
to be dislayed in a window.<br/>


### Windows & Frames

Switch to another window: *C-x o*

Switch to the window on other frame: *C-x 5 o*

Create a new frame: *C-x 5 2*

Delete the frame: *C-x 5 0*

Create a new window on the right: *C-x 3*

Create a new window below: *C-x 2*

Close the current window: *C-x 0*

*add (windmove-default-keybindings) to init.el, then Shift + arrow switches to different windows*


### Motion

Re-center window: *C-l*

End of file : *M->*

Beginning of file : *M-<*

Next list : *C-M-n*

Previous list : *C-M-p*

Display next full screen of file : *C-v*

Display previous full screen of file : *M-v*

Go to line number : *M-x goto-line*

Move back to previous paragraph beginning (backward-paragraph): *M-{*

Move forward to next paragram end (forward-paragraph): *M-}*

Put a point and mark around this or next paragraph (mark-paragraph): *M-h*


### CIDER

Connect to CIDER REPL: *M-x cider-jack-in* | *M-x -jac*

Set namespace : *C-c M-n*

Clear the buffer : *M-x cider-repl-clear-buffer*

Indent the selected region : <i>C-M-\\</i>

Format the entire buffer : *M-x cider-format-buffer*

Restart sesman: C-c C-s C-r 'sesman-restart

### CIDER Debugging / Evaluation

Eval last expression : *C-x C-e*

Load/Eval buffer : *C-c C-k*

Eval current sexp : *C-c C-v C-v*

Eval defn at point : *C-M-x*

Debug : *C-u C-M-x* <br />
[Debugger docs](https://docs.cider.mx/cider/debugging/debugger.html)

### Searching

Search: C-s [press it again to repeat the search]


### Spell Check

ispell: M-x ispell

skip word: `<SPC>`

replace word: r *new* <RET> | R *new* <RET> (which does query-replace through document)

replace with suggestion: *digit*

accept the incorrect word: a | A (A for only this editing session and buffer)

insert this word into private dictionary: i

More: [Spelling](https://www.gnu.org/software/emacs/manual/html_node/emacs/Spelling.html)

### To Investigate

Helm