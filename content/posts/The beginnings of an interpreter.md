---
title: "The Beginnings of an Interpreter"
date: 2018-05-16T19:51:00-04:00
draft: false
series: personal
tags: [
    "interpreter",
    "musings"
]
---

One of the projects I've always wanted to work on has been developing my own programming language.
From a practical perspective at this point it serves of little value besides the academic exercise of
how it's actually accomplished, but for me that is more then enough.  I suspect that in exploring different
parsing and execution techniques I'll discover useful algorithms for use in other areas of development.

To start off I've decided after some reading to build a simple interpreter, using the algorithms and techniques
that I've found in the book "Writing an Interpreter in Go" and some other sources on the internet.  I've also decided
that the first step is to of course construct one that I can throw away, and so, to start, I'm basically going
to build a very simple interpreter to explore how some techniques can be accomplished.  After this I'll do some further
research and analysis and build something else better - hopefully.

To start off with, I'm going to build the follow features into the first take:

* Proper expressions and precedence
* Dynamic typing
* Variables
* Functions - first class functions and closures
* Conditional Statements - if/else and switch case
* A looping construct
* Classes with inheritance

Even this is a fairly significant undertaking, however with the sources available on the internet and the 
"Writing an Interpreter in Go" book I've started construction in C#.  Currently I've gotten the beginnings 
of the scanner and parser working, and I'm able to lex and parse basic math expressions with the correct
operator associativity.  The parsing algorithm that I'm using is called Pratt Parsing, or, Top-Down Operator Precedence
Parsing, which is an elegant recursive algorithm that builds up the abstract syntax tree.

Before tacking on too much more to the parsing I'm going to code some of the evaluation part in, which will
basically give me a calculator.  Then I plan on expanding the lexer and parser to further support some of the 
language constructs such as functions and classes so that I can develop and work with the techniques and algorithms
necessary to accomplish this and complete the evaluation part.  The evaluation algorithm that I plan on using for 
this first phase will be to perform tree-walking, which again is a relatively simple way to interpret the abstract 
syntax tree generated from the parsing.

Upon completion of this "simple" interpreter I plan on doing a fair bit more research.  There is a lot to learn with
regards to building a high-performance interpreter, or compiler, and before diving into the second one, I'd like to
have completed further research into varying techniques and their benefits or pitfalls.

Writing an interpreter is certainly an interesting project, and more algorithmic than most side-projects that I've 
undertaken before.  While it's unlikely that whatever the language I ultimately put together would find practical use,
I think constructing something like this provides a good educational project and is fun at the same time.

As a follow up to this I plan an in-depth article on Pratt Parsing to go over just how the abstract syntax tree is 
built, and how it actually handles the operator associativity.  I basically understand how it works, but a post on it
to help others will help it sink deeper into my brain as well.

If you're interested in writing an interpreter or finding out more about Pratt Parsing, the following resources will 
probably be of assistance:

* [Writing an Interpreter in Go, by Thorsten Ball](https://www.amazon.com/Writing-Interpreter-Go-Thorsten-Ball/dp/300055808X/ref=sr_1_1?ie=UTF8&qid=1526516425&sr=8-1&keywords=writing+an+interpreter+in+go)
* [Simple Top-Down Parsing in Python](http://effbot.org/zone/simple-top-down-parsing.htm#ternary-operators)
* [Pratt Parsing and Precedence Climbing Are the Same Algorithm](http://www.oilshell.org/blog/2016/11/01.html)
* [From Precedence Climbing to Pratt Parsing](https://www.engr.mun.ca/~theo/Misc/pratt_parsing.htm)
* [Top-Down operator precedence parsing](https://eli.thegreenplace.net/2010/01/02/top-down-operator-precedence-parsing/)
* [Pratt Parsers: Expression Parsing Made Easy](http://journal.stuffwithstuff.com/2011/03/19/pratt-parsers-expression-parsing-made-easy/)

If you're interested in following the development of the first interpreter I'm working on, you can find the code [here](https://github.com/tylerlrhodes/Monkey).  It's a slightly modified version of the
monkey interpreter built in the book "Writing an Interpreter in Go" by Thorsten Ball.

