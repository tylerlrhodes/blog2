---
title: "A Refactoring Project in Python: Music CD List, Part 3 of 3"
date: 2021-02-19T19:11:10-05:00
draft: true
series: tech

description: "The third and final entry about refactoring a simple
Python program to be more 'Pythonic.'"
tags: [programming]
keywords: [python, unittest, linked list, refactor]
---

Where I left the Music CD List at the end of [part
2](/posts/music-cd-list-part2) was as a simple application (which it
remains) that allows you to maintain a list of CDs and save it in CSV
format.  What started as a poorly contrived example to work on
building a Linked List "Pythonically" has grown to provide a
thread-safe `ListStore` based upon Python's `MutableSequence`
abstraction, which I use to store the list of CDs.

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
internet would be able to add and see CDs.

But, before that evolves into another post, or posts, I'm going to
finish up this Pythonic refactoring project.

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
interface that works reasonably well so far, if unfinished because you
can't edit or delete CDs through the web interface yet.

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
help me get to the point where I didn't think this was too terrible to
write a series of blog posts about.

### Reviewing Music CD List for the "Un-Pythonic" ###




