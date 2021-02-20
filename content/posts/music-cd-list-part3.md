---
title: "A Refactoring Project in Python: Music CD List, Part 3 of 3"
date: 2021-02-19T19:11:10-05:00
draft: true
series: tech

description: "The second post in a series on code refactoring in
Python.  Implementing the collections.abc interface and further
abstracting the storage for the Music CD List program."
tags: [programming]
keywords: [python, unittest, linked list, refactor]
---

Where I left off at the end of [part 2](/posts/music-cd-list-part2),
the Music CD List program was a simple application (and remains so)
which allows you to maintain a list of CDs and save it in CSV
format.  It started off as a poorly contrived example to work on
building a Linked List "Pythonically," and has grown slightly, to
provide an abstract thread-safe `ListStore` based upon Python's
`MutableSequence` abstraction.

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



