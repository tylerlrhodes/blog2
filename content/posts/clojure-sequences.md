---
title: "Clojure: Sequences, part 1"
date: 2019-08-28T21:01:22-04:00
draft: true
keywords: [Clojure, sequences, lazy-seq, chunking, map, reduce]
tags: [programming]
description: "Sequences are a key abstraction in Clojure, and
represent a way to lazily iterate over a collection.  The sequence
abstraction allows for a common way of processing collections which
extends across a number of collection types."
---

Sequences provide an abstraction which allow for us to perform a
common set of operations across any number of data structures which
provide an implementation of the necessary interface.

Scheme, as shown in the book 'The Structure and Interpretation of
Computer Programs,' provides *cons*, *car* and *cdr* to compose pairs,
which can be combined to build data structures.  In fact these
primitives are used to build all of the data structures represented in
SICP.

One of the structures which can be built in Scheme with pairs is that
of a sequence -- an ordered collection of objects.  SICP goes on to
show the power of using sequences as *conventional interfaces*.  This
is a powerful abstraction which allows for a common set of functions
to be performed over data structures which function as sequences.

While Clojure is a Lisp, it doesn't take the approach of using
*pairs*, or *cons cells* as it's basic building block of all data
structures.

Instead, Clojure provides a number of data structures (persistent and
immutable) natively.  It then provides *seqs* as an abstraction which
allows for a common set of operations to be performed. 

## Exploring the Seq "interface"

Clojure's *Seq* interface functions as a conventional interface in
much the same way as described in SICP.  *Seqs* are persistent and
immutable, and much of the sequence library is lazy in nature.

The core of Clojure's *Seq* interface is exposed by exploring it's
Java implementation.  By examining a few functions and interfaces we
can see how the *seq* function allows for *seqs* to be produced for a
number of collection types.

The *ISeq* interface allows for data structures to provide access to
their elements as sequences.  The *seq* function is used to provide an
implementation of *ISeq* for the given collection.

Below is the Java code which shows the implementation of how the *seq*
function provides an implementation of *ISeq* for a given collection:

*(This is from the Clojure source code on Github, specifically [this
file](https://github.com/clojure/clojure/blob/master/src/jvm/clojure/lang/RT.java). The
licenense and copyright can be seen there).*

```java
static public ISeq seq(Object coll){
	if(coll instanceof ASeq)
		return (ASeq) coll;
	else if(coll instanceof LazySeq)
		return ((LazySeq) coll).seq();
	else
		return seqFrom(coll);
}

// N.B. canSeq must be kept in sync with this!
static ISeq seqFrom(Object coll){
	if(coll instanceof Seqable)
		return ((Seqable) coll).seq();
	else if(coll == null)
		return null;
	else if(coll instanceof Iterable)
		return chunkIteratorSeq(((Iterable) coll).iterator());
	else if(coll.getClass().isArray())
		return ArraySeq.createFromObject(coll);
	else if(coll instanceof CharSequence)
		return StringSeq.create((CharSequence) coll);
	else if(coll instanceof Map)
		return seq(((Map) coll).entrySet());
	else {
		Class c = coll.getClass();
		Class sc = c.getSuperclass();
		throw new IllegalArgumentException("Don't know how to create ISeq from: " + c.getName());
	}
}
```

As you can see, this flexible implementation of *seq* allows an
implementation of *ISeq* to be provided based upon the collection
type.

We can also check out the definition of *ISeq*, as well as the
exposure of the *Seq* interface in Clojure:

```Java
public interface ISeq extends IPersistentCollection {

    Object first();

    ISeq next();

    ISeq more();

    ISeq cons(Object o);

}
```

And the Clojure *Seq Interface*:

```clojure
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
   :doc "Returns a seq of the items after the first. Calls seq on its
  argument.  If there are no more items, returns nil."
   :added "1.0"
   :static true}  
 next (fn ^:static next [x] (. clojure.lang.RT (next x))))
 
(def
 ^{:arglists '([coll])
   :tag clojure.lang.ISeq
   :doc "Returns a possibly empty seq of the items after the first. Calls seq on its
  argument."
   :added "1.0"
   :static true}  
 rest (fn ^:static rest [x] (. clojure.lang.RT (more x))))

(def
 ^{:arglists '([x seq])
    :doc "Returns a new seq where x is the first element and seq is
    the rest."
   :added "1.0"
   :static true}
 cons (fn* ^:static cons [x seq] (. clojure.lang.RT (cons x seq))))
```

You'll notice that the *ISeq* interface supports a *next* method,
however the documentation regarding *Seqs*
[here](https://clojure.org/reference/sequences) show the *Seq*
interface as being only composed of *first, rest,* and *cons*.

Going by the docs here, the immediate thing to be concerned with is
the potential difference in the return value between *rest* and
*next*, even though the appear to do the same thing.

The roots of this are explored at [Making Clojure
Lazier](https://clojure.org/reference/lazy), and is a sort of
collection of notes on changes to the *seq* model to allow for full
laziness.

The next part of this series on Sequences in Clojure will explore
*lazy seqs* in depth.

From this we can see that essentially the *Seq* interface provided by
Clojure functions in much the same way as the *pairs* implementation
with *car* and *cdr* in Scheme.  The difference being that the
underlying collections are not built using *pairs*, but instead built
using whatever structure Clojure or the JVM allows.

## Making use of *Seqs*

In SICP we spend a fair amount of time building up a set of sequence
operations.  Since we're using Clojure, many of these operations that
we build manually in SICP are provided for us in the core library.

Clojure provides all of the structures that you'll typically need in
general development, such as *maps, vectors,* and *lists.*  With the
*Seq* interface, we also have a large common set of functions that we
can perform on these and other collection types.



- differences between clojure and lisp(s) - cons cells vs ISeq
- abstraction of collections
- th Seq interface
- immutability
- lazy sequences, chunking
- concurrency - iterables and ConcurrentModificationException
- lazy-seq vs lazy-cons
- java collections and sequences
- iterable

