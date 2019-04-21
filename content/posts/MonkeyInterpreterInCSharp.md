---
title: "Monkey Interpreter In C#"
date: 2018-05-28T11:02:29-04:00
draft: false
tags: [
    "interpreter",
    "monkey"
]
---

# About Monkey

Monkey is a small programming language invented by Thorsten Ball and described in his book "Writing an
Interpreter in Go".  

The language has support for first class functions, dynamic typing (integers, strings, arrays and hashes), if/else conditional statements, and a few built-in functions.  I may be missing a few things, but in short, it has just enough to write some fun little test programs.  Curiously, it lacks any looping construct besides recursion.

In short, while it certainly isn't a language you would develop a real-world application with, it is a 
short fun language to implement an interpreter for.  

In the book, Mr. Ball builds it from the ground up.  He implements the lexer, parser, and tree-walking evaluation for the language in Golang and describes the algorithms in place.  The book is easily approachable even if you don't know Golang that well.  It's a great starting
point for anyone interested in how interpreters work, and provides more then enough material and instruction to not only implement Monkey as described, but extend it as well.

Since I'm a beginner at programming language implementation and design, this book really was a great way to get started.  While there are other resources online this book is short and complete and within 300 pages you'll have completed the toy language monkey and learned enough techniques to build upon.

There is another online book being written called ["Crafting Interpreters"](http://www.craftinginterpreters.com) which is also very well done by Bob Nystrom.  This book is still in progress, however there is already a wealth of information contained within it.  It's well written and there is lots of source code to look at.  I'm watching this one closely as well and plan to buy it when it's finished, as in addition to building a tree-walking interpreter, the second part of the book is about building a bytecode interpreter in C and will also include a garbage collection implementation.

# My Implementation of Monkey

I decided to implement Monkey with a few modifications as a learning exercise.  I also decided to do it in C# instead of Golang, simply so that I would have to think a little bit more as I translated the code from Golang to C# and added things.  However besides the implementation being in C#, the structure of the lexer, parser and evaluator are very similar to how they are implemented in the book.

I also adopted some of the code patterns for the parsing implementation from Bob Nystrom's blog entry on [Pratt Parsing](http://journal.stuffwithstuff.com/2011/03/19/pratt-parsers-expression-parsing-made-easy/), which he shows in Java.  However, the algorithm, Pratt Parsing, is the same as in Mr. Ball's book, I just thought that the pattern shown by Nystrom was more appropriate for C# (his blog entry is Java based).

In my implementation of Monkey I have made some additions, including a few more infix operators, and support for if/else if/else instead of simply if/else.  I haven't gotten to adding in support for arrays and hashes to mine yet.  I also plan on adding in support for a looping construct and classes.

# Future "Monkey" Plans

I plan on using my implementation of Monkey as a testing ground for how to add certain language constructs and evaluating and parsing them.  For instance, in Mr. Ball's implementation there is no looping construct or classes, so adding these will be a good exercise.

Beyond that there is a lot that can be done.  Getting this far has shown that building out a language involves quite a bit of work.  I'm a software engineer during the day, and it seems I enjoy programming
enough that I still do it a fair amount in my spare time.  Given that I've always been interested in languages finally implementing one myself has been a lot of fun.

My plans for monkey include using it as a learning platform and a jumping off point for what will hopefully eventually become my next big project after this, much of which will be determined by how my tests with Monkey play out.

After baking in a few more language features and testing it out, I'd like to add in support via Visual Studio Code plugins for debugging and syntax highlighting.  I think this will be a fun project, and any language needs a debugging experience .

While I'm working out the Monkey implementation and playing around with it, I plan on studying more of the theory behind languages, and plan on making my next project a strongly typed language that compiles to byte code or native machine code.

If you'd like to check out my version of Monkey, you can take a look on [Github](https://github.com/tylerlrhodes/Monkey).
