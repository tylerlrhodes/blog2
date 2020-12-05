---
title: "Book Review - Programming Clojure"
date: 2019-08-17T01:17:31-04:00
draft: false
series: book-review
description: "A book review of Programming Clojure, by Aaron Bedra,
Stuart Halloway and Alex Miller."
keywords: [Book Review, Clojure]
tags: [programming]
---

'Programming Clojure' is a relatively short book and good for getting
started with the Clojure language.  It's targeted at experienced
programmers who may not have had exposure to Lisp, or functional
programming in general.

I found the book to be well written and organized, and it contains
enough samples where someone with experience would be able to get
started using Clojure.  It doesn't hold your hand like a beginners
book, but explains the concepts well.  If you've never programmed
before this book won't be good, and experience with a Lisp will make
it easier to follow.

The book does a good job of exploring Clojure and its characteristics
that make it an appealing and powerful language.  It's coverage is
more broad than deep, however, it is deep enough where you can start
writing Clojure code and applications after going through the book.

The book covers many key Clojure concepts, such as: sequences,
functional programming, state, concurrency, and interfacing with
Java.  It does not cover some of the well known libraries such as
core.async, which are described elsewhere.

The book also does not cover things like installing and compiling
Clojure programs, or picking a development environment.  There's
plenty of information on the internet for doing this, and even on
Windows, it's not that hard to get started here.  It also doesn't
cover deploying Clojure applications.

Some experience with the JVM and Java would most likely be helpful for
utilizing Clojure, although probably isn't a strict requirement.  I
haven't done much with Clojure beyond a Tetris clone and a utility,
but I imagine for more performance oriented applications knowledge of
the JVM and a deeper understanding of how Clojure code is executed
would be important.  I can hack some Java code, but dont have a deep
understanding of the JVM's operations and reflection.

The book also covers macros, perhaps the most intriguing reason for
exploring a Lisp.  In addition, clojure.spec is covered, which allows
for the creation of "specs" that describe the structure of data.  This
may come in useful given that Clojure is a dynamically typed language.

A full chapter is used for the discussion of state and concurrency in
Clojure.  Here one of Clojure's more compelling reasons for use, its
software transactional memory system (STM) is explored.  The STM
provides language level support for maintaining state safely in a
concurrent environment.  While it certainly doesn't gaurantee correct
concurrent program design and implementation, it offers language level
support for managing state in a concurrent environment which other
languages don't have.

The chapter on managing state however does very little to approach the
issue of concurrency in Clojure, outside of the management of state.
Obviously given the fact that you have full access to the Java
libraries and frameworks from within Clojure, in addition to Clojure
threading libraries, there will be multiple approaches for managing
threading from within a Clojure program.  Nothing is covered with
respect to this.

Anyway I felt that overall this was a really good book for getting
started with Clojure.  It covers the fundamentals of Clojure well.
For other topics like developing web applications you'll have to
consult other sources.





