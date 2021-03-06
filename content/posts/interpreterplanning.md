---
title: "Interpreter Planning"
date: 2018-06-10T16:25:49-04:00
draft: false
series: personal
tags: [
      "musings",
      "interpreter"
]
---

In the past few weeks I've been continuing on my "learning plan",
slowly, at that.  I'm slowly building the energy to relearn some of
the math I once knew.  I've been working through my old college text
book on Algebra, and after that I'll keep going with the Pre-Calculus
and Calculus books.  While doing that, before tackling "Concrete
Mathematics" by Knuth and others, I'll also go through a book on
Discrete Math that I have.

I've also made some progress by building up my version of a Monkey
interpreter in C#.  A lot of this was simply translating code from
Golang to C# from the book, although I handled some things in what I
would say is more of a C# way of doing things (which was inspired by
the techniques of a blog post by Bob Nystrom and his implementation of
a Pratt parser).  I still have a bit to do to bring my Monkey
interpreter up to spec with the one implemented by Thorsten Ball in
his book, but thats just a matter of a little effort and time.

Building my Monkey interpreter and working through the book "Writing
an Interpreter in Go" solidified my interest in programming languages
and inspired a bit of a book buying.  What I quickly found by
implementing Monkey was that implementing a programming language and
interpreter is no small undertaking.  While coding the Monkey
interpreter didn't take too long, it quickly became apparent that it
would take a lot of effort to implement anything non trivial.  I also
discovered that I didn't want to simply implement a language which was
just an interpreted version of what was already out there.

So my impelemtation of Monkey won't expand too much beyond what Ball
has implemented in the book.  I do plan on adding classes and a few
other things which aren't present in the book, however this should be
fairly trivial.  I'm also planning on implementing a byte code
interpreted version of Monkey which will be executed by a Stack based
VM. Implementing a stack VM will provide a foundation for future
language projects as well.  I don't quite think it's worth the effort
to go all out and compile to machine code, however that may be an
option in the future.

In the meantime while I'm implemeting a bytecode interpreter for
Monkey, I decided I should learn a little bit more about techniques
for building interpreters.  I also wanted to expand on my knowledge of
some of the techniques and practices which are found in functional
programming languages.  This way, when I finally get around to my next
interpreter project, I'll have more information on what features I
would like to put into the language.

So I've bought a number of books to start my learning joureny (as I
normally do).  I think it's going to take years to get through all
these books and for some of them I'm going to have to buckle down and
learn some new things (including some mathematical notation).  The
books I picked up (some a while ago)  include:

* Programming in Scala
* Types and Programming Languages
* A Philosophy of Software Design
* ML for the Working Programmer, 2nd Edition
* Purely Functional Data Structures
* Modern Compiler Implementation in ML
* Essentials of Programming Languages
* An Introduction to Functional Programming Through Lambda Calculus
* Structure and Interpretation of Computer Programs

Reading and working through these books while also solidifying my math
skills is certainly going to take some time.  My guess is that it's
going to take between 2-3 years if not more doing it at night and on
the weekends, especially taking into account my Netflix addiction.
But I'm sure that learning this stuff will provide ample amounts of
information and ideas for what to include in my interpreter.  The only
thing that I know for sure right now is that it will be a bytecode
interpreter and not a simple tree-walker.  The performance gain by
using a bytecode interpreter should be substantial even if it is more
work to implement.

Based upon what I've found so far I think that finding a reason for
the language I'll ultimately design to exist will be important.  I
don't think it's pointless to design and implement something solely
for educationaly purposes, however, it would be nice to build
something with some direction so that it would continue to be useful.
My initial thoughts are to design a language that would be a good
language for experimenting with different types of algorithms and data
structures. It would also be nice if it could serve some practical
purpose.

Despite the fact that it will probably be over a year or so before any
serious design is done, on the way I'll be learning lots of new and
useful things.  I also think that I'll take the information I learn on
functional programming through these books and projects to learn and
write a book about F#.

In the meantime, I'll keep going on learning new math skills.  I've
already started to read about Standard ML and it's exciting to learn a
non-brackets language like C# or C.  I'm also learning Emacs so that
I'll have some environment for writing SML in.  It should be a fun
project that I'll try to document here on my blog as I go for anyone
interested in following along.



