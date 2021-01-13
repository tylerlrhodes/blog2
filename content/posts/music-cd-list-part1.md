---
title: "A Refactoring Project in Python: Music CD List, Part 1"
date: 2021-01-09
draft: true
series: tech
description: "Basic code refactoring in Python.  From okayish to good?"
tags: [programming]
keywords: [python, queue, linked list, refactor]
---

This series of posts is going to explore a short refactoring project
in Python.  The plan is for three blog entries, each building upon the
previous to achive a Pythonic and well factored linked list used in a
simple test program -- the "Music CD List."

The code will start as a rushed example which "works."  The first
thing we'll do is add unit tests and make it fit more closely to PEP 8
code formatting.  Following that we'll aim to make it coded with an
eye towards extensability.  This series of articles is not an
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
Pythong's `list` is the "better" choice for all intents.

The linked list is the first data structure that I remember learning.
I think it showed up in a book on C programming I read a lont time
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

Here is my "linked list music cd collector program":

### Insert Code Take 1 ###
```Python

# music_list.py
class MusicCD:
    def __init__(self, artist, title, year, cdid):
        self.artist = artist
        self.title = title 
        self.year = year
        self.cdid = cdid
    
    def __str__(self):
        return f"__str__:{self.title} by {self.artist} from {self.year}"

    def comparator(self, other):
        if self.title == other.title:
            return 0
        elif self.title > other.title:
            return 1
        else:
            return -1

    def display(self):
        return f"{self.title} by {self.artist} from {self.year}"

class Node:
    def __init__(self, item):
        self.item = item
        self.next = None


### LinkedList
class LinkedList:
    def __init__(self, node):
        self.head = node

    def __iter__(self):
        self._ptr = self.head
        return self
    
    def __next__(self):
        n = self._ptr
        if self._ptr == None:
            raise StopIteration
        else:
            self._ptr = self._ptr.next
            return n

    def get_last_node(self):
        ln = self.head
        while ln != None and ln.next != None:
            ln = ln.next
        return ln

    def add_to_list(self, item):
        n = Node(item)
        ln = self.get_last_node()
        if ln == None:
            self.head = n
        else:
            ln.next = n

    def sort(self):
        return 

    def reverse(self):
        return
    
    def delete(self, n):
        return 
    
    def insert(self, item, n):
        #insert before item
        #have p, c, n
        #set p.n to i
        #set i.n to c

        return
        

music_list = LinkedList(None)

kid_a = MusicCD("Radiohead", "Kid A", 2000, 1)
the_bends = MusicCD("Radiohead", "The Bends", 1995, 2)
the_king_of_limbs = MusicCD("Radiohead", "The King of Limbs - Live from the Basement", 2011, 3)
crash = MusicCD("Dave Matthews Band", "Crash", 1996, 4)
american_idiot = MusicCD("Green Day", "American Idiot", 2004, 5)

music_list.add_to_list(kid_a)
music_list.add_to_list(the_bends)
music_list.add_to_list(the_king_of_limbs)
music_list.add_to_list(crash)
music_list.add_to_list(american_idiot)

for cd in music_list:
    print(f"CD: {cd.item}")
```

### End Code Insert Take 1 ###


So this little program is fairly useless because there is no dynamic
input, but that's actually okay for this.  It has a number of
features, including sort, reverse, add and delete.

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

However, before doing any of this, we are going to add the key thing
which will help perform some of the refactorings we'll take on in this
series of posts.

Can you guess what it is?

Add unit tests!!!

It would be more than nice to know that this code actually works.  It
will also be nice to have some tests we can just fire of whenever we
change the code to see that it's still working like it was.



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

