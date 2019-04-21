---
title: "An Infinite \"Loop\" in Scheme, or, Applicative vs Normal-Mode Evaluation"
date: 2018-06-16T15:36:52-04:00
draft: false
tags: [
      "scheme",
      "SICP"
]
---

Getting started with Scheme, and SICP (Structure and Interpretation of
Computer Programs) introduces some terms and ways of thinking about
code that you don't always run into while programming in a language
like C#.

The first thing that you're bound to notice are things like the use of
parenthesis everywhere, and the use of prefix notation instead of
infix notation for performing arithmetic and other operations.  These
are pretty easy to get used to, although reading code written in
Scheme takes some work coming from a more "mainstream"
imperative language.

One of the first things that SICP delves into in section 1.1.5 is the
topic of the substition model for procedure application.  In a
nutshell, this is basically talking about how the expressions are
evaluated and how the procedure is applied to these expressions.  In
Scheme, the interpreter follows the applicative-order evaluation
model, which means that the arguments to the procedure are evaluated
and then the procedure is applied.

SICP also talks about an alternative evaluation technique, known as
normal-mode evaluation, in which the arguments are not evaluated
before the procedure body is applied.

This early on in the book it doesn't go too far into the differences
between the two, besides mentioning that LISP uses applicative order
evaluation partly because of the performance boost of not having to
evaluate the expressions multiple times.  Normal-mode evaluation can
result in the expressions being evaluated multiple times, due to the
fact that an expression passed in as an argument may be used further
on in multiple expressions in the procedure.

That being said, you can also imagine how an expression passed as an
argument may result in significant computation, and if it's passed
into a procedure which may not use the value of that expression, it
would be beneficial to not spend the time evaluating it needlessly.

To demonstrate a method which shows that Scheme uses applicative mode
evaluation, SICP gives us exersize 1.5, where one of the "characters"
in the book, Ben Bitdiddle, writes a procedure to determine whether
the interpreter uses applicative or normal-mode evaluation.

The procedure written is shown below:

<script src="https://gist.github.com/tylerlrhodes/df2ae3a8dcf4265130114692dc1acab3.js"></script>

This is a simple test.  What I didn't quite see at first is how 'p'
would be evaluated. It's basically a recursive procedure
definition that evaluates to itself.  Scheme looks a little different
then C# and JavaScript.

If you type this into the REPL in DrRacket, and execute the '(test 0
(p))' command, you'll quickly see that it hangs the REPL.  In effect,
it loops infinitely due to (p) being evaluated over and over again.
This effect is caused by the applicative evaluation mode that Scheme
makes use of.  Before (test) is applied the arguments have to be
evaluated, and in this case evaluating (p) causes the infinite loop,
since there is no base case which breaks the recursion in the
evaluation 

At this point you can probably figure out how this "test" works to see
if the interpreter is using applicative or normal-mode evaluation.
Had normal-mode evaluation been in use, the argument which evaluates
to (p) would never had been evaluated, and the procedure would have
returned 0 in this case.

### Update 6-26-2018

Another example of evaluating normal-mode vs applicative-mode
evaluation comes up in exercise 1.20, where the text asks you to
evaluate how many times the remainder operation is performed for the
given procedure which calculates the GCD of two numbers.

This example shows clearly how normal-mode evaluation can lead to an
operation being evaluated many more times then it would be with
applicative-mode evaluation.

Bill the Lizard? (name unknonwn) has a great write-up where he shows
the process of normal-mode evaluation.

You can check it out [here](http://www.billthelizard.com/2010/01/sicp-exercise-120-gcd.html).
