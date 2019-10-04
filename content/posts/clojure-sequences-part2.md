---
title: "Clojure: Sequences, part 2"
date: 2019-09-21T10:39:46-04:00
draft: true
description: "An in depth look at lazy sequences in Clojure: how to
use them, and how they work."
tags: [programming]
keywords: [clojure, sequences, lazy-seq]
---

In the first part of this series I took a look at sequences in
Clojure.  I reviewed how the *Seq* interface functions as a
conventional interface, how *seqs* are implemented and exposed in
Clojure, and how they may be used.  I also looked at using standard
Java collection classes, and some of the things to watch out for in
concurrent code.

In this post I'll take a look at how Clojure works with lazy
sequences - both how to use them, and how they are implemented by the
runtime.  I'll also explore the behavior of sequences when using the
REPL, and why they don't seem to behave lazily.

Lazy sequences in Clojure allow for functions that return *seqs* to do
so incrementally, thus delaying potential computation or I/O, and only
performing the operation to produce an item as elements are consumed.
Most of the functions in the sequence library in Clojure are lazy,
including *map*, *filter*, *cycle*, *take* etc.

Lazy sequences in Clojure are similar to *Streams* as demonstrated in
*The Structure and Interpretation of Computer Programs*, in section
3.5.  Both allow for values in a sequence to be produced on demand,
allowing for sequence manipulations to be performed without the need
for the entire sequence to be copied at each step.

* verify above statement

Clojure goes even further than Lazy Sequences and offers another tool
called *Transducers*, which allow for the composition of
transformations, reducing further the number of sequences needed to
perform composed operations.  I'm not going to cover *Transducers* in
this blog post.

## Using Lazy Sequences




## Lazy Sequence Implementation


```Clojure
(defmacro lazy-seq
  "Takes a body of expressions that returns an ISeq or nil, and yields
  a Seqable object that will invoke the body only the first time seq
  is called, and will cache the result and return it on all subsequent
  seq calls. See also - realized?"
  {:added "1.0"}
  [& body]
  (list 'new 'clojure.lang.LazySeq (list* '^{:once true} fn* []
  body)))

(def
 ^{:arglists '([coll])
   :doc "Returns the first item in the collection. Calls seq on its
    argument. If coll is nil, returns nil."
   :added "1.0"
   :static true}
 first (fn ^:static first [coll] (. clojure.lang.RT (first coll))))

(def
 ^{:arglists '([coll])
   :tag clojure.lang.ISeq
   :doc "Returns a possibly empty seq of the items after the first. Calls seq on its
  argument."
   :added "1.0"
   :static true}  
 rest (fn ^:static rest [x] (. clojure.lang.RT (more x))))
 

```  



* How the REPL evaluates expressions
* How lazy-seq is implemented by the runtime
* 


