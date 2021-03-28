---
title: "A Refactoring Project in Python: Music CD List, Part 3 of 3"
date: 2021-03-05T19:11:10-05:00
draft: true
series: tech

description: "The third and final entry about refactoring a simple
Python program to be more 'Pythonic.'"
tags: [programming]
keywords: [python, unittest, linked list, refactor]
---

At the end of [part 2](/posts/music-cd-list-part2) the Music CD List
was left off as a simple application that allows you to maintain a
list of CDs and save it in CSV format.  It started as an example
program making use of a hand-coded Linked List to demonstrate
refactoring to the Pythonic, and it has grown to a web application
with a thread safe 'ListStore.'

At this point it's slightly ridiculous, and I made it more so between
posts by adding in server-side pagination and sorting.  It's gotten to
the point where after this third post's final attempt to make it more
Pythonic, I actually want to use it!  I frequently hear a song or CD
and forget what it is later, why not use this to write it down!

It will turn into a reasonably fun project to make the SPA and API
driven design of the application into a AWS Lambda project utilzing
the API Gateway.  With the `ListStore` abstraction, while it could be
messy, it may be possible to introduce server side storage utilizing
something like S3 or DynamoDB depending upon how crazy the design
gets.  It will also need some authentication, otherwise anybody on the
internet would be able to add and see CDs.  But that project will be
another series of posts if I ever get around to it.

I had said towards the end of the last post that this post would focus
on the deployment and wrapping up this litle project, doing things
like making the web interface nice.  I'd say the web interface is
about as baked as it's going to get for this, and you can check out
the React/Bootstrap front-end and the pagination in the Github repo.

Before I go over packaging it up into a Docker based build and image
which can run the application, I'll go over the refactoring.

### The Quest for the Pythonic ###

I started this series of posts with a simple Linked List storing a
list of CDs that was entered directly in the code.  Then, I added in
some unit tests, and finally an abstraction to allow for any data
store to be used to back the CD list.  In actuality, the abstraction
ended up just being Python's `MutableSequence`, but hey, it works.  So
far I've yet to use anything besides the Linked List.

In between posts I added a Flask Web API and also a simple React based
front-end application to make it easier to actually use the CD List.
As it stands now, you can add CDs through the GUI, upload or download
the list as a CSV, and sort and paginate the results.  It's a simple
interface that works reasonably well so far -- if yet unfinished
because you can't edit or delete CDs through the web interface yet.

But returning to the original task of the series of posts, and not
getting drawn into continually developing it, it's time to offer some
final 'refactorings' and reflect on making this simple program more
"Pythonic."

In [The Hitchhiker's Guide to Python: Code
Style](https://docs.python-guide.org/writing/style) the common fact
that code is read more than it is written is recognized, and a number
of style guidelines are offered, or "Pythonic" idioms.

So to finish of this refactoring project, and make the code as
Pythonic as possible, I'm going to do a review and try to fix any
flagrant violations of the Pythonic I can see (while learning more of
the Pythonic way).  I'll also incorporate advice from the book
"Effective Python."

Then, to finish it off I'll write up a summary reflecting on PEP 20,
and how I setup my VS Code project using linting and unit testing to
help me get to the point where I didn't think this was too embarassing
to put on the internet.

### Reviewing Music CD List for the "Un-Pythonic" ###

1) Search for obviously Un-Pythonic code:

Somehow I can't find any obvious examples right away in the sample
program.  If only I was reviewing the JavaScript!  I'll let this slide
for now, there are a few variable names I could change, but that would
be boring.  So much for a few obvious examplee.

2) Consider PEP 20 - The Zen of Python

With the code relatively fresh in my mind I read through the aphorisms
contained in PEP 20 and picked out a few to focus on.

*Beautiful is better than ugly*

Without going to extremes, this is a straightforward thing to
evaluate and I think here I've done okay.  None of the code in
Music CD List is terrible to look at, and overall it has a simple
design, I think.  I'll leave it to the reader to easily disagree.
Hey, it could have been C# or Clojure!

*Errors should never pass silently.*

Hmmm, I kind of took a flyer on this one.  Not only do errors not
silently pass, they take a crash and burn approach.  I could probably
pick up a few points on this code by adding in better exception
handling.  I've seen idomatic Python that uses exception handling as a
course of normal code flow and program control, more so than I'd say
is typical in other languages, and it has thrown me for a loop on
occasion.

I actually ran into this when implementing support for mutable
sequences.  During the iteration there is a "stop condition" that
apparently expects an Exception to be thrown to stop the iteration!

*Readability counts.*

Readability definitely counts, and I like to think that in general I
can write code that is readable.  It's not always a given, but I try
to write things out well, and that means sometimes not writing code
in the shortest, or contraversly, longest way possible.

After having experience I've also found different code bases become
more or less readable after spending more time with them, and
sometimes readability becomes intertwined with the architecture and
layout of the code.  I think the readability increases the more one
becomes familiar with the idioms and style of the author -- hence,
here, the Pythonic.  Following the Pythonic style (and a somewhat
standard layout) in general adds to the readability for potential new
contributors right away.

*Now is better than never.*

<i>Although never is often better than *right* now.</i>

These two are the reason the Music CD List exists basically.  I could
have waited and studied the "Pythonic" and everything written on it
for months before diving into this.  That said, I wouldn't have a
half-baked Music CD List if I didn't (hey, wait a second).  Although
that's more due to not having a great idea to start with more than
striving for the Pythonic.

I read these two aphorisms as contradictions.  I could be wrong, but I
don't think the second one is meant to be taken seriously.  I'm great
at procrastinating myself, and know how the second one works for me.
But they are fungible enough to fit many situations equally well.

### Deployment ###






