---
title: "Emacs/CIDER Notes"
date: 2019-11-16T10:02:15-05:00
draft: true
keywords: [emacs, clojure]
tags: [programming]
description: "My notes on using Emacs."
---


This is a short collection of notes I've made on using Emacs.  Mostly
its the things I've been using just infrequently enough to forget.

It's a work in progress.

### Terminology

**Frame**: otherwise known as a "window" in Windows.<br/>
**Window**: a window is a view of a buffer within a frame.<br/>
**Buffer**: the place between your brain and the hard disk where work goes
to be dislayed in a window.<br/>


### Windows & Frames

*C-x o* : switch to another window

*C-x 5 o* : switch to the window on other frame

*C-x 5 2* : create a new frame

*C-x 5 0* : delete the frame

*C-x 3* : create a new window on the right

*C-x 2* : create a new window below

*C-x 0* : close current window


### Motion

Re-center window: *C-l*

End of file : *M->*

Beginning of file : *M-<*

Next list : *C-M-n*

Previous list : *C-M-p*

Display next full screen of file : *C-v*

Display previous full screen of file : *M-v*

Go to line number : *M-x goto-line*


### CIDER

Connect to CIDER REPL: *M-x cider-jack-in* | *M-x -jac*

Set namespace : *C-c M-n*

Clear the buffer : *M-x cider-repl-clear-buffer*

Indent the selected region : <i>C-M-\\</i>

Format the entire buffer : *M-x cider-format-buffer*



### CIDER Debugging / Evaluation

Eval last expression : *C-x C-e*

Load/Eval buffer : *C-c C-k*

Eval current sexp : *C-c C-v C-v*

Eval defn at point : *C-M-x*

Debug : *C-u C-M-x* <br />
[Debugger docs](https://docs.cider.mx/cider/debugging/debugger.html)

### Searching







