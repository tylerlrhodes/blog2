---
title: "A Refactoring Project in Python: Music CD List, Part 2 of 3"
date: 2021-01-29
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

Here in the second post I'm going to go even further with the
additions and refactoring, adding features and improving the code to
enhance functionality.  I'll go from a simple linked list for the
storage to being able to swap different containers in for the backing
storage.

In the last post there were long code blocks within the post.  This
post is going to rely more upon the Github repo to review the code
changes, and a few more select and concise code snippets to show the
ideas that go into the refactorings will be brought into the post to
reduce the length.

A linked list is more than enough to store a fairly large list of CDs
for a single user in a performant manner.  As would be any of the
built-in Python collections for that matter. However, for the sake of
this exercise I'm going to build out the storage to be more abstract
and allow for other data structures to take place of the list.

The first thing I'll do is map out how to go about achieving this
before diving into the code, while also reviewing the new requirements.

There are a few changes which can be made which will allow the storage
system to be expanded from just a linked list to other data structures
while also making it more Pythonic.  One of these changes is to
utilize the `collections.abc` base classes to assume the behavior of
existing Python collections.

Before going into the particulars, here is the set of requirements
I'll try to meet with the refactoring:

* Utilize the `collections.abc` interface
* Allow for a "List Store" to use a linked list, double linked list,
  binary tree, or other data structure as desired.
* Allow for custom sorting algorithms to be used with the list storage
* Allow for the sort to take place based upon any key
* Unit tests for all of it
* Thread Safe (for the Flask web application)

Looking at the requirements it seems like a decent solution would be
to potentially evaluate how the "List Store" idea would be used.
Right now, it appears to only be used from the web application, and
it's use is limited to iterating over it and adding an item to the
end.

However, it also needs to be aware of concurrency issues.  For
instance, Flask can have multiple incoming requests, and without some
form of locking all kinds of havoc can occur given the right
circumstances.



```Python

""" List Store Class """

from collections.abc import MutableSequence
from linked_list import LinkedList


class ListStore(MutableSequence):
    """ List Store """
    def __init__(self, storage = LinkedList(None), sort_method = None):
        self.storage = storage
        self.sort_method = sort_method

    def __delitem__(self, index):
        pass

    def __setitem__(self, index, value):
        pass

    def __getitem__(self, index):
        pass

    def __len__(self):
        pass

    def insert(self, index, value):
        pass

```



