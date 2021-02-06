---
title: "A Refactoring Project in Python: Music CD List, Part 2 of 3"
date: 2021-02-06
draft: false
series: tech

description: "The second post in a series on code refactoring in
Python.  Implementing the collections.abc interface and further
abstracting the storage for the Music CD List program."

tags: [programming]
keywords: [python, unittest, linked list, refactor]
---


The [first post](/posts/music-cd-list-part1) on the Music CD List
program detailed some basic refactorings to make it more attuned to
the needs of a growing program.  It has unit tests, and is slowly
beginning to look Pythonic.

In the second post I'm going to go even further with the additions and
refactoring, adding features and improving the code to enhance
functionality.  I'll go from a simple linked list for the storage to
being able to swap different containers in for the backing storage.

I'm going to make one change from how the code is presented from the
last post.  I'll demonstrate with short code snippets the ideas
that I went through and decided on to refactor the code.  The impact
of that style of refactoring can then be viewed throughout the updated
Github repo at the appropriate tag(s), instead of large blocks of code
displaying entire files in the post.  

### Continued Refactoring From Part 1 ###

A linked list is more than enough to store a fairly large list of CDs
for a single user in a performant manner.  As would be any of the
built-in Python collections for that matter. However, for the sake of
this exercise I'm going to build out the storage to be more abstract
and allow for other data structures to take place of the list.

The first thing I'll do is map out how to go about achieving this
before diving into the code.  I'll also take a minute to review the
new requirements beforehand.

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
to potentially evaluate how the "List Store" idea would be used and
evaluate from this perspective how to refactor to meet these
requirements.

Right now, it is only being used from the web application, and
it's use is limited to iterating over it and adding an item to the
end.  In fact, the "List Store" in the web application is just an
instance of the current `LinkedList` class used as a global variable.

So a first thought approach might involve something like a separate
`ListStore` class, utilizing `collections.abc`, and delegating to the
appropriate storage type, which could be passed in upon construction
of the `ListStore`.

This approach also seems to allow for passing in custom sorting
algorithms and key selectors as well.

For instance: 


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


One additional concern the `ListStore` also needs to be aware of is
concurrency issues.  For instance, Flask can have multiple incoming
requests, and without some form of locking all kinds of havoc can
occur given the right circumstances.  This is also one of the
requirements.  I am going to skip this for this iteration and hope
it doesn't bite me too badly.

This is just example code to help move my mind along in the thinking
and writing process.  Here nothing is plugged in really, but this is
an approach for the overall structure without the implementation.  One
possibility using this model would be to require the collection passed
in to also be a `MutableSequence`, which is just a sequence which can
be updated and derives from the `collections.abc` abstract base class.
Then, `ListStore` is a front with some added functionality for this
backing collection.

This would also allows for custom sorting algorithms and to be used.
Python's `sorted` function takes an `Iterable` and two other
parameters: a key selector, and whether to reverse the sort.

So looking at it again here, there are just a few modifications that
would be needed for `ListStore` to meet that requirement where I can
also select the key, and say whether to reverse the sort or not.  And
it becomes very easy if the sequences passed into `ListStore` is a
`MutableSequence`.

As long as the `sort_method` passed in works with an `Iterable`
object, like Python's, I can customize the sort algorithm and key
selection, in addition to using the built-in `sorted` function.

At this point an option for `ListStore` would be to forget about
making it conform to `MutableSequence`; it's already taking a
collection to use for storage that does, and doesn't necessarily need to
support `MutableSequence` at this level.  However it is nice to at
least be able to iterate over the `ListStore`, so at first I'm going
to let it be.

To sum it up, if `LinkedList` implemented the `MutableSequence` base
class, we could have a `ListStore` that looks something like this, and
basically does everything that we need (minus the thread safety).

Here's the outline code for this:

```Python
""" List Store Class """

from collections.abc import MutableSequence

class ListStore(MutableSequence):
    """ List Store """
    def __init__(self, seq = None,
                 sort_method = sorted, key_selector = lambda x: x, 
                 reverse = False):
        self.seq = seq
        self.sort_method = sort_method
        self.key_selector = key_selector
        self.reverse = reverse

    def sort(self):
        """ Sorts the sequence """
        return self.sort_method(self.seq, key=self.key_selector, reverse=self.reverse)

    def __delitem__(self, index):
        self.seq.__delitem__(index)

    def __setitem__(self, index, value):
        self.seq.__setitem__(index, value)

    def insert(self, index, value):
        self.seq.insert(index, value)

    def __getitem__(self, index):
        return self.seq.__getitem__(index)

    def __len__(self):
        return len(self.seq)
```	

As long as the sequence passed in inherits from `MutableSequence` we
can get quite a bit done, even going potentially further such as
allowing for a sequence to be backed by persistent storage.

Testing this is also straightforward.

But before I do that, I'm going to evaluate the thread safety
situation, which can become anything but simple very easily.

### Thread Safety for the List Store ###

The `LinkedList` and `ListStore` classes as they stand are not thread
safe, and certainly do not protected against deadlocks or race
conditions, or doing anything to guarantee data consistency.

If this wasn't an example application I may not do anything (if it was
just for me).  But it's a demonstration web application, and it would
be nice to make it work correctly if possible.

The front-end is using Flask and React, and Flask utilizes threading
for performance reasons.  This means that if two requests come in at
the same time, and require concurrent access to the `ListStore`, than
there certainly could be a concurrency bug that crops up.

One approach, and the approach I took at the end of the first post is
to simply lock access to the list. I did this from the Flask web
application by simply putting a lock around any API calls which
interacted with the list.

This puts the onus on the user of `ListStore` as opposed to the
`ListStore` itself.  In this case I'm going to take the approach that
putting the locking into a `ThreadSafeListStore` class that derives
from `ListStore` is the safer route to go, removing the need to
remember to lock all the time in the Flask application.

Below is the code to accomplish this with some help from the `wrapt`
package and its `synchronized` decorator.


```Python

import threading
from collections.abc import MutableSequence
from wrapt import synchronized

class ListStore(MutableSequence):
    """ List Store """
    def __init__(self, seq = None,
                 sort_method = sorted, key_selector = lambda x: x,
                 reverse = False):
        self.seq = seq
        self.sort_method = sort_method
        self.key_selector = key_selector
        self.reverse = reverse

    def sort(self):
        """ Sorts the sequence """
        return self.sort_method(self.seq, key=self.key_selector, reverse=self.reverse)

    def __delitem__(self, index):
        self.seq.__delitem__(index)

    def __setitem__(self, index, value):
        self.seq.__setitem__(index, value)

    def insert(self, index, value):
        self.seq.insert(index, value)

    def __getitem__(self, index):
        return self.seq.__getitem__(index)

    def __len__(self):
        return len(self.seq)


class ThreadSafeListStore(ListStore):
    """ Thread Safe List Store """
    @synchronized
    def __init__(self, seq = None,
                 sort_method = sorted, key_selector = lambda x: x,
                 reverse = False):
        super().__init__(seq, sort_method, key_selector, reverse)

    @synchronized
    def sort(self):
        """ Sorts the sequence """
        return self.sort_method(self.seq, key=self.key_selector, reverse=self.reverse)

    @synchronized
    def __delitem__(self, index):
        self.seq.__delitem__(index)

    @synchronized
    def __setitem__(self, index, value):
        self.seq.__setitem__(index, value)

    @synchronized
    def insert(self, index, value):
        self.seq.insert(index, value)

    @synchronized
    def __getitem__(self, index):
        return self.seq.__getitem__(index)

    @synchronized
    def __len__(self):
        return len(self.seq)
```	    

### A Few Other Things ###

With these framework changes, short of updating the `LinkedList` class
and modifying the unit tests, I have hit all of the marks I was going
for.

It's now possible to swap out containers for the `ListStore` without
too much trouble, and wrap a thread safe list storage access mechanism
in front of it.  Plus, I can pass in custom sorting algorithms and key
selectors to the `ListStore` which wasn't possilbe before this
refactoring.

Of course, there were other approaches to the refactoring I could have
taken here which would arguably been just as good, but based upon my
knowledge I feel that this is the best and most "Pythonic" so far.


### Concluding Part 2 ###

Finishing off the second part of this three part series is a link to
the tagged point in the repo with all of these changes.  

You can them out in the repo Github tagged at
[music_cd_list_post2c](https://github.com/tylerlrhodes/cd-list-refactoring-demo/tree/music_cd_list_post2c).

There has also been a few bug fixes and updates to the web
application, which again, hasn't been a focal point at all of the
entries, but that's about to change a little bit for the third post
coming up.

For now, when I add a new CD, I at least need to know that if I put a
comma in the title of a CD it won't break the whole thing!  So there
have been a couple of tweaks to improve the way that it works.

The third and final post in this series will do something a little
different and look at sprucing up the web application, the unit
testing infrastructure, and also some basic deployment type issues
that cropped up in the project.

To spruce up the web application we'll add in the ability to sort by
column, as well as paginate the results.  Nothing too fantastic, and
editing is still limited to modifying the list in the CSV file.  One
hurdle so far is that using Python's built-in `sorted` function returns
a Python `list`, instead of a `LinkedList`, so I'll have to tackle
that as well.  It will be an chance to provide a custom sorting method
to the `ListStore`.

I'll also give the whole project a once over looking at it from the
perspective of the book 'Effective Python' by Brett Slatkin to see if
there aren't some additional changes to make it even more Pythonic.

