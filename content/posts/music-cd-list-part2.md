---
title: "A Refactoring Project in Python: Music CD List, Part 2 of 3"
date: 2021-01-25
draft: true
series: tech

description: "The second post in a series on code refactoring in
Python.  Implementing the collections.abc interface and further
abstracting the storage for the Music CD List program."

tags: [programming]
keywords: [python, queue, linked list, refactor]
---


The [first post](/posts/music-cd-list-part1) on the Music CD List
program detailed some basic refactorings to make it more attuned to
the needs of a growing program.  It has unit tests, and is slowly
beginning to look Pythonic.

While a linked list is more than enough to store a fairly large list
of CDs for a single user in a performant manner, or any of the
built-in Python collections for that matter, for the sake of an
exercise I'm going to build out the storage to be more abstract and
allow for other data structures to take place of the list.

I'll also be inheriting from Python's `collections.abc` interface to
make it easier for the custom built sequence/storage classes to be
used in other places.

The requirement's I'll meet with this series of refactorings include
the following:

* Utilize the `collections.abc` interface
* Allow for a "List Store" to use a linked list, double linked list,
  binary tree, or other data structure as desired.
* Allow for custom sorting algorithms to be used with the list storage
* Allow for the sort to take place based upon any key
* Unit tests for all of it

The first thing I'll do is map out how to go about achieving this.  In
the last post there were long code blocks within the post.  This post
is going to rely more upon the Github repo to review the code changes,
and a few more select and concise code snippets to show the ideas that
go into the refactorings.


