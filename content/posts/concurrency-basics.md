---
title: "Concurrency Basics"
date: 2019-02-10T11:04:40-05:00
draft: false
tags: [
      "programming"
]
---

Programming with concurrency is something that's easy to get started
with and can be difficult to do effectively and bug free.

It's also something that is essential to use when writing software
now, and without it we're left with unresponsive interfaces and
inefficient software.  Before I was a professional programmer but not
before I was using computers and programming too much, there was a
steady march of increasing processor speeds.  However, with the end of
Moore's Law (at least with regards to increasing processor frequency
speed, perhaps not transistor density - see [The Free Lunch is Over](http://www.gotw.ca/publications/concurrency-ddj.htm)), the trend has moved from an increase in processor speed
to the increase of cores and the necessity of concurrent programming.

What this means is that in order to take advantage of the computing
power available to a system, we need to adapt our programs to perform
operations concurrently.

Taking advantage of concurrency in our applications allows us to have
multiple threads of execution operating at the same time.  This means
that instead of having your user interface stuck in place while
waiting for a file to load, you can load that file in the background
and the UI can still be responsive.  It means that a server can handle
multiple clients at the same time while performing IO without blocking
the server from performing other useful work while waiting for the
disk to respond or a network response.

Without concurrency we wouldn't have the performance available to us
that we have now.  If you're computer couldn't walk and chew gum at
the same time, it would be impossible to watch Netflix and use Twitter
concurrently.

The idea of concurrency is easy enough to grasp as a concept.  If
you're computer has two processors, they're both capable of executing
instructions at the same time.  At the most basic, let's say you're
running two programs on you're computer and you have two processors.
They could both execute their code concurrently, one on each
processor.  This is a over-simplified example of how it works, but
conceptually this is concurrency in a nutshell.

The difficulty with concurrent programming, overly generalized, enters
into play when those two programs both need to share something.

Let's say that you're using a spreadsheet program and a separate
program that analyzes the spreadsheet data.  They're both running at
the same time, and while you're updating your spreadsheet the analyzer
is analyzing it.

This is great, because you have a list of transactions in your
spreadsheet and it sums up the total money you have in your balance.
The analyzer is looking at you're balance and doing something
complicated, like printing out a message on a screen for your
assistant on whether or not they should buy the Apple Watch when you
have enough money.

So you enter in a bunch of new transactions into your spreadsheet and
you want it to calculate the new balance.  For some reason it takes a
period of time for each transaction to process, and after each
transaction it updates the balance.  So in comes a transaction that
takes your balance to having just enough money to buy the Apple
Watch.

The analzyer, which is constantly monitoring the balance, prints the
new Apple Watch purchasing balance on the screen, and you're assistant
writes a check at Best Buy and tada you are the new owner of an Apple
Watch.

In the mean time, the spreadsheet is chewing away at the other
transactions that you wanted to process, and finally after a few
minutes it does the last one and updates the balance.  You know, the
balance that you really wanted the analyzer to base its decision on.
Now if you're lucky, the final balance supports the purchasing
decision and everything is great.  You've got a new Apple Watch, and
the software is working wonderfully.  I mean, you didn't even have to
talk on the phone to your assitant or write a check yourself.

In the real world what probaly happens is that the balance doesn't
support buying an Apple Watch and you yell at your assistant for being
an idiot.  Why in the world would you buy this Apple Watch when I
don't have enough money for it?  Now I have to return it and I have
this stupid overdraft fee to pay.

Of course, you're assistant says that the all knowing analyzer said to
purchase the Apple Watch and he was just following his robot overlord.

How did this happen?  We were using concurrency and our computer was
walking and chewing gum at the same time and everything was
wonderful.  It worked great in the past when it decided to buy other
stuff.  What could have possibly gone wrong?

This is one of the kinds of issues that can come up when writing
concurrent systems.  It illustrates the idea of atomicity, which is
that an operation or set of operations appears as if they happened all
at once.  In this case it would have been great if all of those
transactions happened "all at once" and the analyzer only saw the
balance after they had all posted.  This would have lead to a better
outcome unless you consider overdraft fees a good thing.

Concurrent programming introduces all kinds of new things to think
about that you didn't have to do when you're applications aren't
concurrent.  As we've seen with this simple example, sharing data
between processes running concurrenty can introduce all kinds of
havoc into the system unless it's done carefully.

In fact with compiler optimizations and the fact that one simple line
of source code can require multiple operations for the processor to
process, it requires thinking about things that you don't have to
reason about otherwise.

In SICP, the simple act of being able to mutate a variable's state
isn't demonstrated before getting a few hundred pages into the text.
Instead, it takes a functional approach to programming for a great
deal of what it covers because it allows for us to reason about a
program's behavior more easily than when things can just change on us.
Unfortunately SICP dedicates just one section to dealing with
concurrency.  However it covers the core principles and demonstrates
how synchronizing access to shared state is critically important to
ensure the correct operation of programs.

Concurrent programming is a broad topic even if the basics can be
learnt in a few days.  Operating systems provide constructs to enable
it and programming languages are incorporating language level support
to enable its use.

If you're a professional programmer today you've already dealt with
it.  You probably know that chasing down synchronization problems is
not fun in a large codebase and that the problems aren't always easy
to reproduce.

Even with it's pitfalls it's unavoidable and necessary if you're going
to write performant software.  I know the basics and enough to get
around day to day, but to expand on the introductory coverage provided
on SICP and beyond simply synchronizing access to shared data, I'm
going to reinforce the fundamental concepts and explore different
patterns of programming for enabling concurrent applications.

I'm currently working through the book "Concurrent Programming on
Windows" in addition to my Python and SICP work.  I plan on spending a
few hours a week on this one and looking at ways to grow my ability to
write code which is easier to reason about when dealing with
concurrency issues.  It's interesting stuff to learn about, and if you
spend any time writing code, something you're probably already dealing
with on occasion.







