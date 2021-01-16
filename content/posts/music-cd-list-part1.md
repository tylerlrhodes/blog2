---
title: "A Refactoring Project in Python: Music CD List, Part 1"
date: 2021-01-13
draft: true
series: tech
description: "Basic code refactoring in Python.  From okay to good?"
tags: [programming]
keywords: [python, queue, linked list, refactor]
---

This is the first entry in a series of entries that are going to
explore a short refactoring project in Python.  The plan is for three
entries, each building upon the previous to achieve a Pythonic and
well factored linked list used in a simple test program: The "Music CD
List."

The code will start as a rushed example which "works."  The first
thing we'll do is add unit tests and make it fit more closely to PEP 8
code formatting.  Following that we'll aim to make it coded with an
eye towards extensibility and try to make it Pythonic, or as close to
that ideal as we can.

This series of articles is not an introduction to the "theory of
refactoring."  You won't hear about the laws of SOLID or at least not
too much.  But some "refactoring theory" may brush off anyway.  Sorry.

It will hopefully be more focused on using Python in a Pythonic way
compared to what will be the initial take, while along the way
demonstrating some of what this author thinks is "good enough example
software."

From the perspective of someone who can write Python but perhaps not
Pythonically, it will be an endeavor to become aware of the ways of
the Pythonic, and imitate them to write better code.

The example application will be start as a simple "Music CD"
collection and used a hand coded linked list for its data storage.
Over this and the following entries we'll improve it to be well
factored and efficient Python code.  Hopefully.

Before you ask, yes, the only reason I have so far for hard coding the
linked list is a memory refresher and to use it as an example.
Python's `list` is the "better" choice for all intents.

Besides, everyone needs to know how to write a linked list from
scratch with one hand tied behind their back on a half functioning
white board while the egg timer clicks away for an interview.  Yes of
course it has to work correctly too!

Python is one of those great programming languages where it's
incredibly easy to get started and hack away at some code.  It's
also effective and highly useful.  I learned it a little over a year
ago but then put it on the shelf a little.  The first take at this is
a simple hacked together linked list to store some items. 

The code that follows is a first take with my "rusty" Python skills
which we'll refactor and learn some updated Python best practices
with.

This code is available at Github in the "CD List Refactoring Demo"
repo, and this version is tagged "linked_list_snippet1a."  It's even
got some messy comments in the repo on this version!  Just waiting to
be cleaned up!  Check it out
[here](https://github.com/tylerlrhodes/cd-list-refactoring-demo/tree/linked_list_snippet1a).

Without further delay, here is the initial version (all in one file
linked in Github, the copy posted here removed some comments):

```Python
###CodeSnippet-linked_list_snippet1a###

class MusicCD:
    def __init__(self, artist, title, year, cdid):
        self.artist = artist
        self.title = title 
        self.year = year
        self.cdid = cdid
    
    def __str__(self):
        return f"__str__:{self.title} by {self.artist} from {self.year}"

    def comparator(self, other):
        if self.title.lower() == other.title.lower():
            return 0
        elif self.title.lower() > other.title.lower():
            return 1
        else:
            return -1

    def display(self):
        return f"{self.title} by {self.artist} from {self.year}"

class Node:
    def __init__(self, item):
        self.item = item
        self.next = None

    def compare(self, other):
        return self.item.comparator(other)

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
        # bubble sort it
        start = True 
        while start:
            prev = None
            start = False 
            for n in self:
                a = n 
                b = n.next 
                if b is not None and a.compare(b.item) == 1:
                    self.__swap(prev, a, b)
                    start = True
                prev = a 
        return 

    def reverse(self):
        p = None
        current = self.head 
        while current != None:
            next = current.next
            if next != None: 
                self.head = next
            current.next = p 
            p = current
            current = next 
        return
    
    def reverse_recur(self, p=None, current=None):
        if p == None:
            current = self.head
        if current != None:
            next = current.next 
            if next != None:
                self.head = next
            current.next = p
            self.reverse_recur(current, next)
        return

    def delete(self, item):
        n, prev = self.find_node(item)
        if prev is None:
            self.head = n.next 
        else:
            prev.next = n.next
        return 
    
    def insert(self, item_to_insert, item_after):
        #insert before item
        n, prev = self.find_node(item_after)
        if n is None:
            raise ValueError("Error finding item to insert before...")
        # if prev is null, then item_after is head, insert before
        if prev is None:
            node = Node(item_to_insert)
            node.next = self.head
            self.head = node
        #else, insert between prev and n 
        else:
            node = Node(item_to_insert)
            prev.next = node 
            node.next = n 

    def __len__(self):
        return self.count()

    def __swap(self, prev, a , b):
        self.__swap_adjacent(prev, a, b)

    def __swap_adjacent(self, prev, a, b):
        # swap nodes a and b, assuming previous is provided
        if a is None or b is None:
            raise ValueError("No value is provided for either node!")        
        a.next = b.next 
        b.next = a 
        if prev is not None:
            prev.next = b
        else:
            self.head = b  

    def count(self):
        i = 0
        p = self.head
        while p != None:
            i += 1
            p = p.next

        return i

    def find_node(self, item):
        prev = None 
        for n in self:  
            if n.compare(item) == 0:
                return n, prev 
            prev = n  
        return None
    
    def merge(self, other):
        # merge the two lists
        new_list = LinkedList(None)
        a = self.head
        b = other.head 
        while a is not None or b is not None:
            if a is not None and b is not None:
                if a.compare(b.item) <= 0:
                    new_list.add_to_list(a.item)
                    a = a.next 
                else:
                    new_list.add_to_list(b.item)
                    b = b.next 
            elif a is not None:
                while a is not None:
                    new_list.add_to_list(a.item)
                    a = a .next 
            else:
                while b is not None:
                    new_list.add_to_list(b.item)
                    b = b.next        
        self.head = new_list.head



def print_music_list(music_list):
    for cd in music_list:
        print(f"CD: {cd.item}")

if __name__ == "__main__":
    music_list = LinkedList(None)
    kid_a = MusicCD("Radiohead", "Kid A", 2000, 1)
    the_bends = MusicCD("Radiohead", "The Bends", 1995, 2)
    the_king_of_limbs = MusicCD("Radiohead", "The King of Limbs - Live from the Basement", 2011, 3)
    crash = MusicCD("Dave Matthews Band", "Crash", 1996, 4)
    american_idiot = MusicCD("Green Day", "American Idiot", 2004, 5)
    vsq_strung_out_vol9 = MusicCD("Vitamin String Quartet", "Strung Out, Vol. 9: VSQ Performs Music's Biggest Hits", 2008, 6)

    music_list.add_to_list(kid_a)
    music_list.add_to_list(the_bends)
    music_list.add_to_list(the_king_of_limbs)
    music_list.add_to_list(crash)
    music_list.add_to_list(american_idiot)
    music_list.add_to_list(vsq_strung_out_vol9)

    print(f"Count of list: {len(music_list)}")
    print_music_list(music_list)
    music_list.sort()
    print(f"\n\nPost Sort:\n")
    print_music_list(music_list)
    music_list.delete(the_bends)
    print(f"\nDelete the_bends")
    print_music_list(music_list)
    music_list.delete(american_idiot)
    print(f"\nDelete american_idiot")
    print_music_list(music_list)    
    music_list.insert(american_idiot, crash)
    print(f"\nInserted america_idiot before crash...")
    print_music_list(music_list)
    print(f"\nInserted the_bends before vsq_strung_out...")
    music_list.insert(the_bends, vsq_strung_out_vol9)
    print_music_list(music_list)
    music_list.sort()
    print(f"\nSort it again....")
    print_music_list(music_list)

    # Test out Merge capability
    print(f"\n\nTest out merge capability (by title)")
    tmp = LinkedList(None)
    tmp.add_to_list(MusicCD("A", "A", 1, 1))
    tmp.add_to_list(MusicCD("C", "C", 2, 2))
    tmp.add_to_list(MusicCD("E", "H", 1, 1))
    tmp.add_to_list(MusicCD("E", "J", 2, 2))
    print("\ntmp 1 list:")
    print_music_list(tmp)
    tmp2 = LinkedList(None)
    tmp2.add_to_list(MusicCD("B", "B", 1, 1))
    tmp2.add_to_list(MusicCD("D", "D", 2, 2))
    tmp2.add_to_list(MusicCD("G", "G", 2, 2))
    print("\ntmp 2 list:")
    print_music_list(tmp2)
    print("\nAfter merging tmp1 and tmp2 (by title)")
    tmp.merge(tmp2)
    print_music_list(tmp)
    
###CodeSnippetEnd-linked_list_snippet1a###
```

This program is screaming profitable startup business, obviously.  I
always like to type my CDs into a Python file to add them to a list
that I can't even save to disk.  Just imagine the sales.  Investors
are probably looking for my email address after reading through it.

Realistically, it's screaming: TEST ME!!!!

Or, at least test it better than it's being tested so far anyway.

The repo at this tag is also begging to have some left over comments
removed, so while you won't see them in this post, if you check out
the repo there is some free flowing comments and ideas left in the
file.  Those will be deleted in the next tag.

So a long time ago, before the sample program was pasted into this
blog post and to the point you would have to scroll to review what I
wrote, I said we were going to make this have unit tests, and endeavor
to make the code "Pythonic."

Well, unit tests are not that hard.  But what in the world is
"Pythonic?"  Is there an official "Organization Pythonic" which
declares what is and what is not Pythonic?  Is it people who know
Python on Twitter tweeting yay or nay?  

Hmmmm, this just got complicated all of a sudden.  We have stumbled
into the world of Pythonic subjectivity and I'm not even an expert in
all things Pythonic.  It is time to consult the scrolls of other
bloggers posted elsewhere to determine the proper definition.

Here are some links to smarter folks who have written it down to be
shared:

* [How to be Pythonic and why you should
  care](https://towardsdatascience.com/how-to-be-pythonic-and-why-you-should-care-188d63a5037e), 
  Featuring: *Pythonic: a Bionic Python?*
* [The Hitchhiker's Guide to Python: Code
  Style](https://docs.python-guide.org/writing/style/)
* [Pythonic Code: Best Practices to Make Your Python More
  Readable](https://www.codementor.io/blog/pythonic-code-6yxqdoktzt)
* [Pythonic | Definition of Pythonic at
  Dictionary.com](https://www.dictionary.com/browse/pythonic)
* [PEP 20 -- The Zen of
  Python](https://www.python.org/dev/peps/pep-0020/)

The previous list shows how the internet can lead you astray.  The
Dictionary.com definitioni of 'Pythonic' is potentially right, at
least one of the definitions!  If all Python code was Pythonic and the
definition of Pythonic is "Python like..."  I'll stop now.  The rest
of the entries are just fine.

My person definition is that you should follow the best practices of
software development as applied to the Python language.  Which to me,
at this point, means following PEP 8 and respecting PEP 20, or, "The
Zen of Python."  PEP 8 is more style guidelines for Python code, while
PEP 20, is more a spiritual framework for writing good Python code,
with pearls like:

* Beautiful is better than ugly.
* Explicit is better than implicit.
* Sparse is better than dense.
* Now is better than never.
* Although never is often better that *right* now.
* ...

In essense, follow good practices and use the modern idioms of Python
as best as possible.  Don't write C style code in Python.  That
wouldn't be Pythonic.

It's time to clean up this code, add some unit tests, and make it's
second iteration on the whole better than the first.  The goal will be
to test it well, and try to follow the idioms of Python as well as
possible for now.  If we miss some, we'll pick them up later.

### Refactor Take 1: Add Unit Tests, Basic Cleanup ###

The first thing was to figure out how to unit test the Python code.
Turns out this is extremely easy in Python, just use the "unittest"
module which is built-in.  There are other ways, but to get started,
and have some potential automation, this is "good enough."  It will
let us test the software.













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
* Move MusicCD class out of linked_list!

In <q> `def __next__` </q> what does this look like?

