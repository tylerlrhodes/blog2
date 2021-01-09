---
title: "Refactoring a Python Linked List, Part 1"
date: 2021-01-09
draft: true
series: tech
description: "Basic code refactoring in Python.  From okayish to good?"
tags: [programming]
keywords: [python, queue, linked list, refactor]
---


First, we'll make a giant old mess of a linked list in Python just to
give us something to work with:

### Insert Code Take 1 ###
```Python
class Node:
    def __init__(self, item):
        self.item = item
        self.next = None

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

l = LinkedList(None)

for i in range(5):
    l.add_to_list(i)

for i in l:
    print(i.item)
```

### End Code Insert Take 1 ###


What shall we do with the code?

* Make it "Pythonic" (within reason of code formatting of this blog):
at least with regards to Effective Python
* What functions should it support: sorting, searching, insertion
* Options for support functionality: class based or functionali
* Exception handling - where can there be an exception
* Flow control, propwer
* An eye towards thread safety


In <q> `def __next__` </q> what does this look like?

