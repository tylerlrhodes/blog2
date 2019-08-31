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
show the power of using sequences as a *conventional interfaces*.
This is a powerful abstraction which allows for a common set of
functions to be performed over data structures which function as sequences.

While Clojure is a Lisp, it doesn't take the approach of using
*pairs*, or *cons cells* as it's basic building block of all data
structures.

Instead, Clojure provides a number of data structures (persistent and
immutable) natively.  It then provides *seqs*, or sequences, as an
abstraction which allows for a common set of operations to be
performed.  The ISeq interface allows for data structures to provide
access to their elements as sequences.  The *seq* function is used to
provide an implementation of *ISeq* for the given collection.

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




- differences between clojure and lisp(s) - cons cells vs ISeq
- abstraction of collections
- th Seq interface
- immutability
- lazy sequences, chunking
- concurrency - iterables and ConcurrentModificationException
- lazy-seq vs lazy-cons
- java collections and sequences
- iterable

