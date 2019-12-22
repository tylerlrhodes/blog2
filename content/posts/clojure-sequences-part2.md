---
title: "Clojure: Sequences, part 2"
date: 2019-12-21T08:39:46-04:00
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

In Scheme, as show in in SICP, it's possible to create streams which
produce the next value when its needed, instead of all at once.  This
is explored in section 3.5 of SICP, and implemented using *delay* and
*force*.

Can we do the same thing in Clojure using the built in *cons*?

I don't think it's possible due to the way that Clojure's *cons* is
different from *cons* in Scheme.  In Scheme *cons* is used to create
*cons cells*, which can be combined into lists.  In SICP *cons-stream*
is defined which produces the *cdr* lazily, by using *delay* and
*force*, and a custom *cdr-stream* function.

Clojure's *cons* on the other hand accepts a value as its first
parameter and then a sequence where the value becomes the first
element and the given sequence the rest.  In Clojure, *cons cells*
aren't the primitive structure used to build everything else that they
are in Scheme, and *cons* in Clojure does not produce the same
structure as *cons* in Scheme.

We can of course define our own *cons* using a *closure* and use
Clojure's *delay* and *force* to create the lazy streams shown in
SICP.  This is the approach I've taken while working through 3.5 in
SICP using Clojure.

However, really there is no nead to do this when programming in
Clojure, because sequences in Clojure are already lazyily produced.
The underlying mechanism of this production is hidden in Clojure's
runtime, and depending upon the actual data structure the sequence is
constructed from, it functions slightly differently.

While we can't directly mimic the streams approach of SICP using
Clojure's *cons* due to the differences, we don't need to.  Clojure
provides *lazy-seq* which does the same thing with the help of the
runtime.


```Clojure
(defmacro lazy-seq
  "Takes a body of expressions that returns an ISeq or nil, and yields
  a Seqable object that will invoke the body only the first time seq
  is called, and will cache the result and return it on all subsequent
  seq calls. See also - realized?"
  {:added "1.0"}
  [& body]
  (list 'new 'clojure.lang.LazySeq (list* '^{:once true} fn* [] body)))
```

This allows us to produce code like the following:

```Clojure
(defn inf-seq
  ([] (inf-seq 1))
  ([n]
   (lazy-seq (cons n (inf-seq (inc n))))))
```

Which looks very similiar to the definition of *cons-stream* given by
SICP:
```Scheme
(cons-stream <a> <b>)

;; defined as:

(cons <a> (delay <b>))

;; and used like:

(define (integers-starting-from n)
  (cons-stream n (integers-starting-from (+ n 1))))

(define integers (integers-starting-from 1))

```

So we can see here that we're basically doing the same thing in
Clojure as SICP demonstrates with Scheme, but in Clojure's case we're
aided by the runtime in the background.

Clojure's implementation also provides the cacheing of produced items
which is also shown in SICP.

Now that we see how lazy sequences in Clojure are created manually
using *lazy-seq*, let's take a look at how items are produced.  For
instance, what actually happens if we run the following code:

```Clojure

(first (inf-seq))

(first (rest (inf-seq)))
```



* Show and incorporate why holding onto the head of a seq is bad generally

```Clojure
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


Streams are a clever idea that allows one to use sequence manipulations without incurring the costs of manipulating sequences as lists

 - sicp - are lazy sequences the same?


Streams / Lazy Sequences allow us to achieve in the declarative style using sequence manipulations while maintaining the efficiency of an iterative implementation.

With streams the implementation evalutes the cdr, or next element, at selection time instead of when the stream is constructed.

In SICP delayed streams are built using delay and force:

Clojure's delay and forced vs SICP delay and force (memo-proc)


