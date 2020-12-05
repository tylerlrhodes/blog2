---
title: "SICP - Lists, Accumulate and Flatmap, part 3"
date: 2018-09-15T12:37:56-04:00
draft: false
series: tech
tags: [
      "SICP",
      "programming",
      "scheme",
      "csharp"
]      
---

In the third post of this series on lists in Scheme and SICP we are
going to take a look at the *flatmap* procedure.  In chapter 2,
*flatmap* is made use of in a number of examples and in some of the
exercises, so it's worth taking a little bit of time to understand how
it works and what it does.  We'll also take a quick look at it's
counterpart in the C# language, *SelectMany*, which is provided
through the LINQ framework.

*Flatmap*, and in C#, *SelectMany*, both perform the same operation.
 What they do is flatten a sequence of sequences, or a list of lists.
 This means that you pass in a list of lists, and out comes one list
 containing all of the items.  They flatten the list of lists by one
 level in effect.

This is easily seen in the following Scheme code, which uses the
provided procedures from the SICP text.

<script src="https://gist.github.com/tylerlrhodes/ef77f8376687b9d807830a56f95c900d.js"></script>

The first call to *flatmap* in the code uses the *identity* procedure
which is applied to each sequence provided.  Then those sequences
passed in are flattened into one sequence or list.  This is done by
*flatmap* by making use of the *accumulate* procdure.  If you look at the
code for *flatmap*, you'll see it's simply a call to *accumulate* with
*append* passed in as the operation.  It applies the supplied procedure
to the sequence before calling *accumulate*.

The next call to *flatmap*, which is commented out, shows that an error
is produced when *flatmap* is called with simply a list as its
argument.  *Flatmap* expects a list of lists, and breaks down when a
simple list is passed.

The next example shows calling *flatmap* with just a list, however, this
doesn't result in an error.  This example shows that the procedure is
applied to the provided sequence before being flattened.  In this
example, we turn each item in the sequence into a list, which allows
*flatmap* to procede to flatten the list of lists at this point.
Granted, this example isn't that useful in the real world, however, it
shows the input that *flatmap* is expecting.

The final example is taken from SICP, and shows a way to generate a
sequence of unique pairs using *flatmap*.  Coming from a more imperative
programming style this code to generate pairs would typically be
written as a nested loop of some sort.

C#, and most other languages, provide a method such as *flatmap*.  C#
has this functionality through LINQ, and is a method called
*SelectMany*.

The code below shows how *SelectMany* is used to flatten the sequences
of books on each bookcase into one sequence of books.  This is the
same functionality that is provided by *flatmap* in SICP.

<script
src="https://gist.github.com/tylerlrhodes/010e0a0e726a337df8ffb3d8fdf48ca7.js"></script>



