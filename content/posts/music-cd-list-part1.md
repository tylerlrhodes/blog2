---
title: "A Refactoring Project in Python: Music CD List, Part 1"
date: 2021-01-13
draft: true
series: tech
description: "Basic code refactoring in Python.  From okay to good?"
tags: [programming]
keywords: [python, queue, linked list, refactor]
---

*update* 

This series of posts is going to explore a short refactoring project
in Python.  The plan is for three blog entries, each building upon the
previous to achieve a Pythonic and well factored linked list used in a
simple test program -- the "Music CD List."

The code will start as a rushed example which "works."  The first
thing we'll do is add unit tests and make it fit more closely to PEP 8
code formatting.  Following that we'll aim to make it coded with an
eye towards extensibility.  This series of articles is not an
introduction to the "theory of refactoring."  You won't hear about the
laws of SOLID or at least not too much.

It's more focused on using Python in a Pythonic way compared to what
will be the initial take, and demonstrate some of what this author
thinks is "good enough demo" software.

The example application will be start as a simple "Music CD"
collection and used a hand coded linked list for its data storage.
Over this and the following entries we'll improve it to be well
factored and efficient Python code.  Hopefully.

Before you ask, yes, the only reason I have so far for hard coding the
linked list is a memory refresher and to use it as an example.
Python's `list` is the "better" choice for all intents.

The linked list is the first data structure that I remember learning.
I think it showed up in a book on C programming I read a long time
ago.  It's not really the go to data structure for performance, but it
has it's places, it's easy to code, and will work just fine for the
purposes of this refactoring project.

Python is one of those great programming languages where it's
incredibly easy to get started and hack away at some code.  It's
also effective and highly useful.  I learned it a little over a year
ago but then put it on the shelf a little.

The code that follows is a first take with my "rusty" Python skills
which we'll refactor and learn some updated Python best practices
with.

Here is my "linked list music CD collector program":

```Python
###CodeSnippet-linked_list_snippet1a###
###CodeSnippetEnd-linked_list_snippet1a###
```

So this little program is fairly useless because there is no dynamic
input, but that's actually okay for this.  It has a number of
features, including sort, reverse, add and delete.  It "tests" them in
a rudimentary fashion after the code for the `LinkedList`.

But it would be nice to be able to do the following:

* Read the CDs from a CSV file
* Sort on any key
* Change sorting algorithms
* Store Video CDs (or other types of items)
* Use standard Python coding styles
* Have a nice output format -- maybe a web page?
* Put the LinkedList class into a module all of its own for reuse.
* Put the Program that uses it in another repository and call this
* code.
* Many other things I'll think of later.

However, before doing any of this, we are going to add the key thing
which will help perform some of the refactorings we'll take on in this
series of posts.

Can you guess what it is?

Add unit tests!!!

This code works ... at first glance.  But to be fair I haven't tested
for every edge case, and I'm sure while it looks like it works like a
linked list, I'm also guessing there is a bug or three.

So adding unit tests will allow me to automate the testing to detect
regressions, and also find any bugs I may have put in in the initial
take.  I'm guessing a TDD purist would have objected already to this
post, because I didn't write the tests first, and then write the
linked list.  A note to my future self would agree.  That totally
would have been the way to go.

But this is a post on refactoring!  I can incorporate the TDD into the
future posts once we learn how to add unit tests to this code.








What shall we do with the code?

* Make it "Pythonic" (within reason of code formatting of this blog):
at least with regards to Effective Python
* What functions should it support: sorting, searching, insertion
* Options for support functionality: class based or functional
* Exception handling - where can there be an exception
* Flow control, proper
* An eye towards thread safety
* What Python built-in types would function as a linked list?  For
instance, python lists?
* Python comparators how to extend?
* collections.abc interface for classes - what is it? why use it?

In <q> `def __next__` </q> what does this look like?

