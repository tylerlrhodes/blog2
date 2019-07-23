---
title: "First Clojure Program - Tetris Clone"
date: 2019-06-09T11:38:57-04:00
draft: false
tags: [
      "clojure",
      "emacs"
]
description: "I wrote my first Clojure program, which is a clone of
Tetris.  The post covers my experience developing it. "
keywords: [ "Clojure, Tetris, Programming, Emacs" ]
---

My first Clojure program is basically done.  It's a bare bones working
clone of Tetris, and it's actually playable.  I just spent the last
hour playing it in it's current form and it actually feels like
playing Tetris.  I'm already starting to think of minor ways to
improve it such as music and some sound.  

<br />

![Tetris Screenshot](/images/tetris-screenshot.png)

[https://github.com/tylerlrhodes/tetris](https://github.com/tylerlrhodes/Tetris)

<br />

Besides adding music, there is also a bit of refactoring to the code I
would like to do.  I'll say that it most definitely is not the best
looking Clojure code, and there are some spots where I'd like to make
it a little more "functional" and idiomatic.  But for a first
application in Clojure I think it went well.

## Learning Curve

So there is definitely a significant learning curve to getting started
with Clojure.

For me it wasn't too terrible.  I decided early on to use Emacs as my
editor, and since I had already started to use it as the editor for
writing this blog, I knew the basics of working around it.  I'm at the
point now where I can add things to my init file, such as adding MELPA
which is a source of packages for Emacs.  Adding the CIDER package and
installing Lein and Clojure isn't too terrible, but for a rank
beginner, it would be much more confusing than getting started with
Python and VS Code.

There are other editors for Clojure of course, however my impression
was that despite the learning curve Emacs was the way to go.  CIDER
works very well with Clojure.  I was able to navigate and get it to do
what I wanted without too much trouble, and the REPL based development
wasn't too hard to get into.  It's also possible to step through code
in the editor for a more traditional debug experience which is nice.

Another popular editor is Cursive, which is an IntelliJ plugin and is
not free, however the internet seems to like it.  If you're not an
Emacs user it's probably an easier way to go.

Clojure itself also presents a potential big learning curve depending
upon where you're coming from.  It's too bad, but I think for someone
who has never programmed before jumping into Clojure would be pretty
difficult.  A determined beginner could probably do it, but the
overhead of needing a basic understanding of Java and the JVM for
better or worse, coupled with finding an editor to use, and there
being less resources than for something like Python, would probably
make it hard.

The idioms in Clojure and the approach for accomplishing things being
more functional than a traditional OOP language presents another
learning curve coming from the C#/Java world, but it's not too big a
jump if you've used something like LINQ or are familiar with
map/reduce etc.

If you've never programmed in a Lisp dialect before it takes a little
getting used to, but isn't as bad as the parenthesis make it look.  I
have some background with Scheme from working through SICP, so it was
a natural progression from there.

## Initial Take on Clojure

Having been warmed up to Lisp by SICP, I was really excited to do some
stuff with Clojure, and after writing some code in it I'm even more
excited to do even more.  I don't know yet what even more is, but
whatever it is, I definitely want to do it in Clojure.

My feelings after working through Tetris and reading a few books on
Clojure is that it is a very powerful language for getting things
done.  It's refreshingly terse compared to the verbiage of C# which I
primarily work with, and the functional approach and it's explicit
management of state and the STM system really are interesting and
powerful.

Mostly I had fun writing Tetris and working with Clojure in the REPL
driven development, and despite being a beginner, was able to get into
it and can see areas where I can improve and be more productive.

If you're on the fence about learning Clojure I'd say take the
plunge.  Lisp and it's dialects present a different paradigm from OOP
and procedural programming, and the "code is data, data is code"
thing, which I'm slowly understanding, is powerful.

I had fun writing code in Clojure, much more fun than I did when I
started writing Python and Go code.

There may not be that many Clojure jobs out there compared to other
languages, but my impression is that for getting things done, Clojure
seems like a good choice.  I think the Tetris clone is about 500 lines
of code, and a lot of that is just the matrix definitions of the
pieces.

## Summary

Clojure is a powerful functional language with strong support for
concurrent programming with its STM and explicit state management.
You can easily interoperate with Java code, providing access to a huge
assortment of existing libraries and functionality that doesn't need
to be recreated.

If you are looking for a new language to learn it's definitely
worth it in my opinion.  While it doesn't have the huge corporate
backing of a Google or Microsoft, it has some huge corporations who
think it's solid enough for use, such as Walmart and others.




