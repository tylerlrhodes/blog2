---
title: "A Refactoring Project in Python: Music CD List, Part 1 of 3"
date: 2021-01-23
draft: true
series: tech

description: "The first post in a series on code refactoring in
Python.  The code goes from bad to kind of okay? I mean it has unit
tests at the end..."

tags: [programming]
keywords: [python, queue, linked list, refactor]
---

Sometimes, as a software developer, there's a little bit of code which
could use a little bit of tweaking to make it just right.  Othertimes,
there's a lot of code that could use a ton of rewriting to make it
half-way decent.  And sometimes, it's not until months later when this
realization occurs.

What follows is a contrived example to demonstrate building, and in
the process refactoring, a small Python application.  The only
"requirement" at the start: store a list of cds using a linked list.
And yes, inputting the CDs in the code is just fine (this will be
fixed after unit tests are added, and not addressed in the post
directly).

This is the first entry in a series of entries that are going to
explore this program and a series of refactorings to improve it.  The
plan is for three entries, each building upon the previous to achieve
a Pythonic and well factored linked list used in a simple test
program: The "Music CD List."  

The code will start as a rushed example which "works."  The first
thing I'll do after showing this is add unit tests and make it fit
more closely to PEP 8 code formatting.  Following that I'll aim to
make it coded with an eye towards extensibility and try to make it
Pythonic, or as close to that ideal as I can.

From the perspective of someone who can write Python but perhaps not
Pythonically, it will be an endeavor to become aware of the ways of
the Pythonic, and imitate them to write better code.

The example application will start as a simple "Music CD list
application," and use a hand coded linked list for its data storage.
During this and the following entries I'll improve it to be well
factored and efficient Python code.  Hopefully.

The code that follows is a first take with my "rusty" Python skills
which I'll refactor and learn some updated Python best practices
with.

This code is available at Github in the "CD List Refactoring Demo"
repo, and this version is tagged "linked_list_snippet1a."  It's even
got some messy comments in the repo on this version!  Just waiting to
be cleaned up!  Check it out
[here](https://github.com/tylerlrhodes/cd-list-refactoring-demo/tree/linked_list_snippet1a).

Without further delay, here is the initial version (all in one file
linked in Github, the copy posted here removed some comments).

### Initial "Music CD List":

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

It is also screaming for some type of system which allows the person
to input their CDs without having to open a Python file to type them
in (that will be in the repo at the end, and not covered in the post
directly).

### On Route to the Pythonic###

So a long time ago, before the sample program was pasted into this
blog post and to the point you would have to scroll to review what I
wrote, I said we were going to make this have unit tests, and endeavor
to make the code "Pythonic."

Well, unit tests are not that hard.  But what in the world is
"Pythonic?"  Is there an official "Organization Pythonic" which
declares what is and what is not Pythonic?  Is it people who know
Python on Twitter tweeting yay or nay?  

Hmmmm, this just got complicated all of a sudden.  I have stumbled
into the world of Pythonic subjectivity and I'm not even an expert in
all things Python.  It is time to consult the scrolls of other
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
Dictionary.com definition of 'Pythonic' is potentially right, at
least one of the definitions!  If all Python code was Pythonic and the
definition of Pythonic is "Python like..."  I'll stop now.  The rest
of the links are fine.

My personal definition is that you should follow the best practices of
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
possible for now.  If I miss some, I'll pick them up later.

### Refactor Take 1: Add Unit Tests, Basic Cleanup ###

The first thing was to figure out how to unit test the Python code.
Turns out this is extremely easy in Python, just use the "unittest"
module which is built-in.  There are other ways, but to get started,
and have some potential automation, this is "good enough."  It will
let us test the software.

To get started cleaning the code up I've cleaned up the
`linked_list.py` of the previous snippet, removing all of the test
code which was of very little use there anyway.

Then I created `test_linked_list.py` which is where the unit tests are
stored.  The tests are simple to run from the command line:

```
python -m unittest
```

This scans the directory for all files that start with `test*` and
runs the tests and reports the results.

It's also possible to run them through an integrated test runner, such
as is available and easily setup in a few clicks with Visual Studio
Code.  In fact this is what I have been doing in general.

The basics of the `unittest` module are extremely easy to get started
with.  Import the module, and create a class which derives from
`unittest.TestCase`.  The methods in that class which begin with
`test_` will be executed by the runner.  Success or failure is handled
by the `assert` statements which are used to check the results of the
code being tested with the expected results.

Here is the unit testing code:

```Python

###CodeSnippet-test_linked_list_snippet1a###

import unittest
from linked_list import LinkedList, Node

class Item:
    """ Default Item for Linked List Test """
    def __init__(self, title):
        self.title = title

    def comparator(self, other):
        """ Comparator for item """
        if self.title.lower() == other.title.lower():
            return 0
        if self.title.lower() > other.title.lower():
            return 1
        return -1

class TestLinkedList(unittest.TestCase):
    """ Linked List Unit Test Class """
    @staticmethod
    def _validate_list(linked_list, items = None):
        for idx, val in enumerate(linked_list):
            assert items[idx].title == val.item.title

    @staticmethod
    def _gen_tmp_list():
        tmp = LinkedList(None)
        item_1 = Item("a")
        item_2 = Item("b")
        item_3 = Item("c")
        tmp.add_to_list(item_1)
        tmp.add_to_list(item_2)
        tmp.add_to_list(item_3)
        return tmp, [item_1, item_2, item_3]

    @staticmethod
    def test_iterator():
        """ Test the iterator """
        a, b, c = Item("a"), Item("b"), Item("c")
        tmp = LinkedList(Node(a))
        tmp.head.next = Node(b)
        tmp.head.next.next = Node(c)
        TestLinkedList._validate_list(tmp, [a, b, c])
        assert len(tmp) == 3, "Expected 3"

    @staticmethod
    def test_get_last_node():
        """ Test getting the last node """
        a,b,c = Item("a"), Item("b"), Item("c")
        tmp = LinkedList(None)
        tmp.add_to_list(a)
        assert tmp.get_last_node().item is a, "Expected last to be Item a"
        tmp.add_to_list(b)
        tmp.add_to_list(c)
        assert tmp.get_last_node().item is c, "Expected last to be Item c"

    @staticmethod
    def test_sort():
        """ Test sorting the linked list """
        tmp, [i1, i2, i3] = TestLinkedList._gen_tmp_list()
        tmp.sort()
        TestLinkedList._validate_list(tmp, [i1, i2, i3])
        i4 = Item("d")
        i5 = Item("e")
        i6 = Item("f")
        tmp.add_to_list(i5)
        tmp.add_to_list(i6)
        tmp.add_to_list(i4)
        tmp.sort()
        TestLinkedList._validate_list(tmp, [i1, i2, i3, i4, i5, i6])
        tmp2 = LinkedList(None)
        tmp2.add_to_list(i1)
        tmp2.sort()
        TestLinkedList._validate_list(tmp2, [i1])

    @staticmethod
    def test_reverse():
        """ Test reversing the linked list"""
        item_d = Item("d")
        tmp = LinkedList(None)
        tmp.add_to_list(item_d)
        tmp.reverse()
        TestLinkedList._validate_list(tmp, [item_d])
        tmp, [i1, i2, i3] = TestLinkedList._gen_tmp_list()
        tmp.add_to_list(item_d)
        tmp.reverse()
        TestLinkedList._validate_list(tmp, [item_d, i3, i2, i1])

    @staticmethod
    def test_reverse_recur():
        """ Test recursively reversing the linked list """
        item_d = Item("d")
        tmp = LinkedList(None)
        tmp.add_to_list(item_d)
        tmp.reverse_recur()
        TestLinkedList._validate_list(tmp, [item_d])
        tmp, [i1, i2, i3] = TestLinkedList._gen_tmp_list()
        tmp.add_to_list(item_d)
        tmp.reverse_recur()
        TestLinkedList._validate_list(tmp, [item_d, i3, i2, i1])

    @staticmethod
    def test_insert():
        """ Test inserting an item into the linked list """
        tmp, [i1, i2, i3] = TestLinkedList._gen_tmp_list()
        i4 = Item("d")
        tmp.insert(i4, i2)
        TestLinkedList._validate_list(tmp, [i1, i4, i2, i3])
        i5 = Item("e")
        tmp.insert(i5, i1)
        TestLinkedList._validate_list(tmp, [i5, i1, i4, i2, i3])

    @staticmethod
    def test_count():
        """ Test getting a count of items """
        tmp, items = TestLinkedList._gen_tmp_list()
        assert tmp.count() == len(items), "Expected equal lengths"
        assert len(tmp) == len(items), "Expected equal lengths"

    @staticmethod
    def test_merge():
        """ Test mergint the linked list """
        letters = ["a", "c", "e", "g"]
        letters2 = ["b", "d", "f", "h"]
        items = []
        l1, l2 = LinkedList(None), LinkedList(None)
        for _, (i, i2) in enumerate(zip(letters, letters2)):
            l1.add_to_list(Item(i))
            items.append(Item(i))
            l2.add_to_list(Item(i2))
            items.append(Item(i2))
        l1.merge(l2)
        TestLinkedList._validate_list(l1, items)

    @staticmethod
    def test_add():
        """ Test adding an item to the linked list """
        tmp = LinkedList(None)
        tmp.add_to_list(Item("a"))
        assert tmp.count() == 1
        tmp.add_to_list(Item("b"))
        tmp.add_to_list(Item("c"))
        assert tmp.count() == 3
        titles_correct = ["a", "b", "c"]
        for idx, val in enumerate(tmp):
            assert titles_correct[idx] == val.item.title

    @staticmethod
    def test_delete():
        """ Test deleting an item from the linked list """
        tmp, items = TestLinkedList._gen_tmp_list()
        tmp.delete(items[2])
        items.remove(items[2])
        TestLinkedList._validate_list(tmp, items)
        tmp, [i1, i2, i3] = TestLinkedList._gen_tmp_list()
        tmp.delete(i2)
        TestLinkedList._validate_list(tmp, [i1, i3])
        tmp, [i1, i2, i3] = TestLinkedList._gen_tmp_list()
        tmp.delete(i1)
        TestLinkedList._validate_list(tmp, [i2, i3])

if __name__ == "__main__":
    unittest.main()
###CodeSnippetEnd-test_linked_list_snippet1b###
```

So overall, very easy to add unit tests here, and easy to see that it
offers a consolidated way to automate testing of the `LinkedList`
class, and any other classes in a similar fashion.  It begs to work
with Test Driven Development (TDD), or something similar in the
future.  It makes it easier to modify the class later as well.

Now it's possible that this code will need to be changed fairly
drastically in the next post.  The LinkedList class has some
modularity coming to it, so that pieces of its functionality can be
implemented by different providers.  Nobody wants to use Bubble Sort
all the time to sort their list like we are here.  Part of arguably
making this more "Pythonic" will involve even further refactoring.

Despite this, cleaning up the code and adding some tests is a good
first step, and by the sole act of adding tests I can be confident
that the list is working.  If I find a bug, I have a place to come and
add a test to track it down or prevent it before shipping it next
time.

### Is it Pythonic? ###

Um, maybe, slightly more?  Although definitely not if you follow along
with a book like "Effective Python" by Brett Slatkin.  The `LinkedList`
class definitely doesn't inherit from `collections.abc` or implement
all that it should with regards to that.  I'm sure there are idioms
that were missed as well.  Overall, I'd say it's more Pythonic than
the first iteration, but it has a reasonable distance to go.  With the
addition of running `pylint` and some configuration I have managed to
get it to follow the PEP 8 guidelines for formatting the code.

I'll continue to fix it up in the next two blog posts.

I also improved it by moving the `MusicCD` class out of
`LinkedList.py` since it's independent of it.

You can see the code for with these changes
[here](https://github.com/tylerlrhodes/cd-list-refactoring-demo/tree/linked_list_snippet1b).
It's tagged "linked_list_snippet1b."

### Coming Up: ###

This little program is still fairly useless because there is no
dynamic input, but that's about to be remedied.  It has a number of
features, including sort, reverse, add and delete.  After the first
refactoring it has a nice suite of tests which can be easily
automated.

To add in an input method what I've done after the first refactoring
is to add a basic user interface in the form of a SPA using React.  It
allows the user to upload a CSV file with CDs which are then stored in
a Linked List on the server, as well as add or delete entries in the
Linked List, and then download them as a CSV.

The web portion of the project isn't central to the theme of these
posts, so besides making a few short appearances in the next two
posts you'll only see it in the repo.  It will add in another layer to
the program, and influence and encourage proper refactoring.

It would be nice to be able to do the following:

* Sort on any key
* Change sorting algorithms
* Store Video CDs (or other types of items)
* Put the LinkedList class into a repo all of its own for reuse.
* Put the Program that uses it in another repository and call this
code.
* Many other things I'll think of later.

In the next post we're going to start with a few of these. Starting
with refactoring the Linked List class so that we can accomplish a few
of these items, and of course, also -- be more Pythonic.  I'll also
look at how it's connected to the web application.

The tagged repo with the web interface support is available
HERE[FIXME] and the README file has instructions for running it.  It's
a basic Python Flask web application.  It has basic instructions for
running it.

Test

