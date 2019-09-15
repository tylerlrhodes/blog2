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
Computer Programs' (SICP), provides *cons* to build up pairs, which
can be combined to build data structures.  It then provides *car* and
*cdr* to access the first and second items in the pair
respectively. These primitives are used to build all of the
data structures represented in SICP.

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
much the same way as described in SICP.  At it's core is a simple
interface for traversing a sequence, which allows for functionality to
be built from this base.

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

And the Clojure *Seq* Interface*:

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
*next*, even though they appear to do the same thing.

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

The [sequence documentation](https://clojure.org/reference/sequences)
has a list of a number of the functions which operate on *Seqs* in
Clojure, such as *map*, *reduce*, *filter*, *distinct*, and many
others.  The *Seq* abstraction allows us to share a significant amount
of functionality across different underlying types, and provides a
common framework for composing operations.

While *seqs* may commonly be thought of as sequential orderings over
general data structures such as lists and vectors, the abstraction can
be extended and utilized over a number of input sources which can
conform to the abstraction.

For example, the *Seq* interface allows us to do something like this:

```clojure
(with-open [rdr (io/reader file-name)]
  (doseq [line (map #(string/upper-case %) (line-seq rdr))]
    (println line)))
```    

This short snippet of code opens a file, reads it line by line, and
transforms each line to upper case and prints it.

The *Seq* interface also extends to structures such as XML and trees.

For example:

```clojure
(let [xml "<?xml version=\"1.0\" encoding=\"UTF-8\"?><top attr1=\"one\"><middle>hello</middle></top>"]
  (let [root (xml/parse (java.io.ByteArrayInputStream. (.getBytes xml)))]
    (doseq [node (xml-seq root)]
      (println node))))
```      

The *Seq* interface also allows us to perform these operations on Java
collection types, and use them in the same way we would use any other
Clojure collection.

```clojure
(let [stack (java.util.Stack.)]
  (doto stack
    (.push 10)
    (.push 20)
    (.push 30))
  (reduce + stack))
```

This is possible because Java's *Stack* collection implements
*Iterable*, from which *seq* is able to produce an implementation of
*ISeq* for the sequence.

It's important to be aware however, that when the underlying
collection isn't one of the immutable persistent types provided by
Clojure, it's possible to run into your common concurrency issues with
mutable state.

For a simple demonstration, lets look at the following examples:

```clojure
(let [signal (atom false)
      array (int-array 5)]
  (println "initial:")
  (doseq [val array] (println val))
  (async/thread
    (Thread/sleep 500)
    (println "...starting thread...")
    (loop [stop @signal]
      (when-not stop
        (do
          (dotimes [n 5]
            (aset array n (+ 1 (rand-int 100))))
          (Thread/sleep 100)
          (recur @signal)))))
  (println "next:")
  (doseq [val array]
    (println val)
    (Thread/sleep 1000))
  (compare-and-set! signal false true)
  (println "final:")
  (doseq [val array]
    (println val)))
```    

If you were to run this (you need core.async for thread) you would see
the following output (values would be different):
```
initial:
0
0
0
0
0
next:
0
...starting thread...
92
87
63
36
final:
25
58
51
41
43
```

You can see here that the values of the sequence can change out from
under you depending upon the underlying type.  In this case the
modifications to the array show up while the sequence is iterated and
the values are printed.

The next example is a little trickier:

```clojure
(defn seq-test [count]
  (let [signal (atom false)
        stack (java.util.Stack.)]
    (dotimes [n count]
      (.push stack 0))
    (println "initial:")
    (doseq [val stack] (println val))
    (async/thread
      (loop [stop @signal]
        (when-not stop
          (do
            (.push stack (+ 1 (rand-int 10)))
            (Thread/sleep 100)
            (recur @signal)))))
    (println "next: ")
    (doseq [i stack]
      (println i)
      (Thread/sleep 1000))
    (compare-and-set! signal false true)))
(seq-test 10)
```

What would you expect the output from this to be? Maybe it should
generate a ConcurrentModifiedException?  This is what prints out:

```
initial:
0
0
0
0
0
0
0
0
0
0
next: 
0
0
0
0
0
0
0
0
0
0
```

Let's see what the output is when we call *(seq-test 35)*:

```
initial:
0
.
. (33 zeros)
0
next:
0
.
. (30 zeros)
0 
Execution error (ConcurrentModificationException) at java.util.Vector$Itr/checkForComodification (Vector.java:1320).
null
```

This time we get the exception. We also see that despite the fact we
are pushing values onto the stack, and it is being obviously modified
while we are iterating over it and printing the values, we're still
getting the 0's we put on first.  Not very stack like.

The reason for this is in the way Clojure creates the *seq*, and this
method in particular:

```java
public static ISeq chunkIteratorSeq(final Iterator iter) {
        if (iter.hasNext()) {
            return new LazySeq(new AFn() {
                public Object invoke() {
                    Object[] arr = new Object[CHUNK_SIZE];
                    int n = 0;
                    while (iter.hasNext() && n < CHUNK_SIZE)
                        arr[n++] = iter.next();
                    return new ChunkedCons(new ArrayChunk(arr, 0, n), chunkIteratorSeq(iter));
                }
            });
        }
        return null;
    }
```    

When the *seq* function is used to provide an implementation of *ISeq*
for Java's *Stack* structure, it uses this *chunkIteratorSeq* method
to provide the implementation.  You can see that this method, while
providing a *LazySeq*, grabs chunks of the provided Iterator in
increments of *CHUNK_SIZE*.  This is why we don't see the new values
of the *Stack* while iterating over the sequence, and is also why we
don't get a *ConcurrentModificationException* while we called our test
function with a count of only 10.

So it's important to remember that even though you can utilize the
*Seq* interface with Java collections, if you're dealing with
concurrency, you have to be careful.  This is in contrast to Clojure's
*vector, map*, and *list*, which are immutable and persistent and can
safely be used by any threads without synchronization.

## Summary

The *Seq* interface is a powerful abstraction which is useful in many
instances, especially in Clojure.  It lends itself to a declarative
style of programming, which, coming from an iterative/OOP style can
take a little getting used to.



- differences between clojure and lisp(s) - cons cells vs ISeq
- abstraction of collections
- th Seq interface
- immutability
- lazy sequences, chunking
- concurrency - iterables and ConcurrentModificationException
- lazy-seq vs lazy-cons
- java collections and sequences
- iterable

