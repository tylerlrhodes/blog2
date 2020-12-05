---
title: "Higher-Order Procedures"
date: 2018-07-08T12:58:05-04:00
draft: false
series: tech
tags: [
      "scheme",
      "c",
      "csharp",
      "golang",
      "programming"
]
---

While programming there are many situations that arise which call out
for different abstraction techniques. Different languages emphasize
different techniques for designing programs, whether it be functional,
object oriented, or procedural; however, despite their differences in
this manner, most modern languages treat functions as first class.

When a language treats functions as first class, it in effect means
that the function can be treated as any other variable in the
language.  This means that the function can be used in the program in
the same way that you may use a variable that contains an integer or
string.  You can pass the function as an argument to another function,
or return a function from a function to be used later.

By treating procedures as first class citizens in the language, it
allows for procedures to be constructed which manipulate procedures.
Procedures which do this are said to be higher-order procedures.  By
utilizing higher-order procedures, we're able to increase the
expressive power of the language that we're using.

The use of higher-order procedures is typically more associated with
the functional style of programming (although functional programming
entails more than simply the use of higher order procedures).  Despite
this, and the fact that most popular languages are oriented towards
object oriented programming, the use of higher-order procedures is
fairly common now.  C, which is an older procedural language, supports
higher-order procedures through its use of function pointers (although
technically functions in C aren't first class due to the inability to
create new functions at run-time).  JavaScript also treats functions
as first class, and allows for many functional programming paradigms
to be used.

Without knowing what they are, if you program in C#, C, Golang or
(unlikely) Scheme/LISP you've most likely encountered higher-order
procedures.

Let's take a look at the following example in C#:

<script
src="https://gist.github.com/tylerlrhodes/921f6bf07919f555b0e158d5912f281d.js"></script>

This example shows a simple implementation of 'Map' which is a
higher-order function.  It takes a function delegate as its second
parameter, which it applies to each item in the provided list. (This
is actually a poor example of 'map' which would typically return the
elements after the function had been applied to them in a new
enumeration).

Here's an example in C which makes use of the 'qsort' function to sort
a list.

<script src="https://gist.github.com/tylerlrhodes/dfd17f883c0041f289ddeb6820e34dbe.js"></script>

As you can see, you pass in the compare function as an argument to
qsort, which it uses to sort the array.

Our next example we'll do in Golang, a modern language which the
Golang FAQ says is and is not an object-oriented language, which also
supports higher-order procedures.  Like C#, but unlike C, Golang
supports closures, which increases the power of higher order
procedures.  On the [Tour of Go](https://tour.golang.org/moretypes/25)
website, they have the following example which shows Go's support for
closures and higher-order procedures.

<script
src="https://gist.github.com/tylerlrhodes/337559bf0892bc9fdeaf317baf70d89b.js"></script>

Here you can see an example of a function which returns a function
which takes an integer and keeps a running sum.

Finally, we'll look at an example in Scheme, which abstracts the
summation process.

<script src="https://gist.github.com/tylerlrhodes/b9302a3e7c698ae162940e09b09ce1b2.js"></script>

Here, we have a generic procedure 'sum' which takes two procedures,
'term' and 'next', which are used to calculate the summation.  Two
examples are shown, one, which produces the sum of integers from one
to ten, and a second example, which produces the sum of cubes from one
to ten.

These examples show how different languages support first class
functions and higher-order procedures.  Higher-order procedures show
that in addition to creating abstractions based upon objects and
subtypes, we can create functional abstractions to generalize the use
of procedures.

While Scheme, and C may not be considered "modern" languages (although
C is widely used), many languages, including JavaScript, support first
class functions and the paradigms their use enables.  
