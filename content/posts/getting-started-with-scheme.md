---
title: "Getting Started With Scheme"
date: 2018-06-16T11:57:03-04:00
draft: false
tags: [
      "scheme",
      "drracket"
]
---


I've just started to get my feet wet with Scheme.  My reasons for
learning Scheme descend from my desire to learn more about
implementing interpreters and the fact that two books on this subject
make use of Scheme for their examples.  In case you're wondering, the
book that really led to me deciding it's worthwhile to use Scheme is
the book "Essentials of Programming Languages" (EOPL).  The book I need to
work through before that one is "Structure and Interpretation of
Computer Programs" (SICP) which also uses Scheme.

Chances are if you've decided to learn Scheme or LISP it's because
you're a curious programmer.  I can't imagine finding the book SICP on
accident when looking around for a first book on programming, and if
you did stumble upon it on your own, well I feel slightly bad for
you.  It definitely looks like a great book on learning about
programming and computing, however, it is fairly far outside what most
first programming books are on.  SICP is not going to teach you how to
make a website or a game.  However, if you already know how to program
and are looking to expand your horizons it looks like it has a lot to
offer.

Since I have too much time on my hands and I'm generally a curious
programmer, I'm going to work through SICP and then EOPL so that I can
learn more about how interpreters and compilers work so that I can
ultimately implement my own.  I've always been interested in how
compilers work, but it wasn't until recently that I made it a point of
actually learning.  For a long time (and still to a big extent) they
seemed to work magically.  Then I did a little research and read
"Writing an Interpreter in Go" by Thorsten Ball, and found that they
are not magic.  If you're looking for a fast and good book that will
help you write your first interpeter the book by Ball is a great
start.

So I'm onto SICP and learning Scheme then.

The first thing I noticed is that learning Scheme will require using
different tools then Visual Studio or other "mainstream" programming
environments.  While Scheme has a standard now, it's clearly used more
for academic purposes than for real world programming, and as such the
toolset surrounding it is a little different.  Getting started was
confusing, especially since I basically just wanted to find a way to
write Scheme that wouldn't be too painful.

Luckily, there is a great tool which is cross-platform and free.  It's
called DrRacket and it's an IDE and interpreter for the Racket
language, which is a Scheme/LISP variation.  While the Racket language
isn't Scheme exactly, DrRacket, has a way of putting it into a mode
which is compatible with the Scheme dialect used in both SICP and
EOPL.  The IDE is easy to use, and also includes a REPL
(Read-Eval-Print-Loop).  You can download DrRacket
[here](https://racket-lang.org).  For how to set up DrRacket to work
with SICP you can check out the guide
[here](http://docs.racket-lang.org/sicp-manual/index.html).  DrRacket
and the Racket language look to be interesting tools in their own
right, as it's an ecosystem for developing and deploying new
languages.  

Once you've got DrRacket setup and begin questioning whether or not
you should actually learn Scheme because it won't help you get a job,
you'll probably like me want to start learning how to do things in
Scheme like you do in other languages.  It's a little different then
how you would do stuff in a language like C# or Java.  First, Scheme
is a functional programming language, which in and of itself is
basically totally different then C# and Java which are imperative
programming languages.

The other thing you'll most likely notice, or at least I seemed to
notice, is that since there are lots of dialects of Scheme, LISP, and
so on, it's not exactly clear on what will work with the version
you've chosen to work with.

I've decided to stick with the simple SICP mode that DrRacket has so
that I hopefully don't have to search for how to translate concepts
and function names all the time while I'm working through SICP.

But I do feel that it's important to write the canonical first program
in Scheme similar to how just about every other book on programming
does (SICP doesn't).  If you don't know what that program is, then you
may want to learn another language first.  If not, and you already
bought SICP and have no idea how to prograrm, follow the link for
putting DrRacket in SICP mode write the following in the REPL (the
window on the bottom that yells at you when you type things in it
doesn't like).

(display "hello world")

And now you can say you program in Scheme.

