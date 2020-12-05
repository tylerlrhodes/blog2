---
title: "SICP - Lists, Accumulate and Flatmap, part 1"
date: 2018-08-15T21:17:32-04:00
draft: false
series: tech
tags: [
      "SICP",
      "programming",
      "scheme"
]

---

The first chapter in SICP deals with computational processes and how
to build procedures.  The second chapter is about data abstraction,
and how to represent different types of data using Scheme.  It
introduces the idea of compound data, and presents a number of
approaches for representing complex data with Scheme.  By utilizing
compound data in constructing abstractions, we are afforded the
ability of reasoning about the data at a higher conceptual level.  The
use of compound data also increases the modularity of programs.

Scheme provides a compound structure called a *pair* which allows us
to construct compound data.  Pairs can be constructed using the
primitive procedure *cons* which takes two arguments and returns a
compound data object.  We can use the primitive procedures *car* and
*cdr* which allow us to retrieve the elements of the pair, car
returning the first, and cdr the second.

The second chapter spends a good portion of time discussing how you
can represent different types of data objects, and shows how you can
construct them using pairs.  In this blog post we are going to focus
simply on how pairs work and how they are used to build lists.

First it may be helpful to see how we would be able to implement pairs
on our own, if they weren't provided as primitive objects through
Scheme.

The below procedures effectively show the behavior of cons, car and cdr.

```
(define (cons x y)
  (define (dispatch m)
    (cond ((= m 0) x)
          ((= m 1) y)
          (else (error "Argument not 0 or 1 -- CONS" m))))
  dispatch)

(define (car z) (z 0))

(define (cdr z) (z 1))
```

Here, if you were to apply car or cdr to a pair created by cons, it
would apply the dispatch procedure with the argument of either 0 or 1
respectively.  You can run the code above to test it out if it's not
clear how it works.

Exercises 2.4 through 2.6 show a number of different ways with which
you can represent pairs without using the primitive procedures.

Section 2.2 starts off by discussing how to visualize pairs using the
box and pointer method, and shows that you can *glue* pairs together
to form compound data.

One of the structures which can be built with pairs is a *sequence*,
which is an ordered collection of data objects.  In this construction
the car of each pair is the corresponding item in the chain, and the
cdr is the next pair in the chain.  Such a sequence of pairs, when it
is terminated with *nil*, forms a list.

For example:

```
(cons 1
      (cons 2
            (cons 3
                  (cons 4 nil))))
```

This construction of a sequence of pairs by using cons forms a list.  

Scheme provides a primitive called *list* which can be used to form
this type of compound data.

```
(list 1 2 3 4)
```

This is the equivalent of the code shown above creating a list by
using cons.

Typically a list will be output by showing the sequence of items
enclosed in parenthesis.  DrRacket outputs the list of items enclosed
in brackets.

Lists and pairs in Scheme provide a useful tool for constructing other
compound data objects, and they are used extensively in the rest of
the book.

If you haven't started to get better at recursion by working this far
through SICP, the book will be nearly impossible to get through.  SICP
goes through a number of exercises which require you to recursively
reason about lists, and taking the time to work through them is
imperative to getting through the other exercises and understanding
much of the example code.  I've worked through them and still get
stumped for a while at some of them.

The book, *The Little Schemer*, looks like it will help a lot for
reasoning about programming in a recursive fashion.  I've made it
through chapter 5 and doing more and more of it, it gets easier to
think recursively, although I'm still not fantastic at it.  I plan on
finishing *The Little Schemer* once I finish with the exercises for
chapter 2 of SICP.  I'm up to 2.63, so I'm making good progress and
I'm about two months in.

Through chapter 2 a number of generic procedures are developed for
performing operations with lists.

One of the more useful procedures developed is *accumulate* which
we'll look at in the next post in this series.  Following that we'll
examine *flatmap* and how it is used in SICP.

