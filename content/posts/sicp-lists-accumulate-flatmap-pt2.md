---
title: "SICP - Lists, Accumulate and Flatmap, part 2"
date: 2018-08-19T11:48:06-04:00
draft: false
tags: [
      "SICP",
      "programming",
      "scheme"
]

---

In the second post in the little series on lists, *accumulate*, and
flatmap we're going to take a closer look at *accumulate*, and some
operations on lists that we run into during SICP.

The *accumulate* procedure is an example of what SICP drills into us in
Chapter 1, which is composing higher order procedures which abstract
functionality.  In section 2.2.3, *Sequences as Conventional
Interfaces*, the text describes a number of common operations which
are performed on sequences.  It includes such operations as
enumeration, filtering, mapping, and accumulation. By organizing
programs around these abstractions, it helps to increase the clarity
of the code.

In this post we're going to focus on one of these operations,
accumulataion, and we'll see how a number of other procedures can be
written in terms of the *accumulate* procedure.  The text offers more
details and examples of incorporating the other generic procedures
into programs, and there are a number of exercises for working with
them.

The *accumulate* procedure, simply put, takes an operator (procedure),
an initial value, and a sequence.  It then applies the operator to the
the sequence, recursively building up its return value, using the
provided initial value as the base value to be applied.  The
operator shall be a procedure which takes two arguments, which will be
elements of the sequence, or in the base case, an element of the
sequence and the initial value.

By virtue of the dynamic typing in Scheme, this allows the *accumulate*
procedure to be applied to differing types, and allows for different
types of procedures to be used as the operator as well.  For example,
to sum up the numbers 1 through 10, we can use *accumulate* as follows:

```
(accumulate + 0 '(1 2 3 4 5 6 7 8 9 10))
```

In this case, we pass the '+' operator as the procedure, and we use 0
as the initial value.  If we wanted the product of the numbers from 1
through 10, we would have passed in 1 as the initial value.

It's important to note, that with *accumulate*, the value is built
from the right to the left.  In effect, when the base case is reached,
the last element of the sequence and the initial value will have the
operator applied, with the element of the sequence being the left hand
operand.  Then the next to last element of the sequence has its value
and the value of the previous computed, and so on.  This results in
the final value being built from right to left.  This is also why the
*accumulate* procedure is also known as *fold-right*.  The opposite,
*fold-left*, applies the initial value to the first value in the
sequence, building from left to right.  Examining the code at the end
of this post in the gist shows this clearly.

This is most clear by examining the results of applying division:

```
(accumulate / 1 '(2))
; 2

(accumulate / 2 '(1))
; 1/2
```

The above would have the same result as calling *fold-right*.  The
*fold-left* procedure, shown below, produces the opposite:

```
(fold-left / 1 '(2))
; 1/2

(fold-left / 2 '(1))
; 2
```

Here you can see that the final value is built from the left to the
right.

*Accumulate* is a versatile procedure which can be creatively used.
 SICP provides a number of problems to work on which involve applying
 the *accumulate* procedure in a number of ways.  Some of the
 solutions to a few of the problems are shown in the gist below.

For example, it's possible to build *append*, *map*, *fold-right*, and
*length* all using the accumualte procedure.  It's also possible to
reverse a list using *fold-right* and *fold-left*.

The code below shows how *append* is written without *accumulate*, and
then shows how it can be constructed in terms of *accumulate*.  I've
also shown how *map* and *length* can be written in terms of
*accumulate*.  Also, the code from the book for *fold-left* is
included.

If you are working through SICP you should take the time to work
through these procedures and really understand how they work.  Again,
working with *accumulate* and lists and understanding how they are
constructed are essential to getting through the text.  Also, by this
point, you should be somewhat more comfortable formulating solutions
recursively.  How *accumulate* works is easy recursion compared to
what comes next with trees.

This code should work with DrRacket if you want to try it out by
entering some test cases into the REPL.

In the next post in this series we will take a look at *flatmap* and
how it is used in SICP.

<script src="https://gist.github.com/tylerlrhodes/8fea746fc1132458ce445e5cc0ee7020.js"></script>

