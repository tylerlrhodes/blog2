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

In Scheme, as show in in SICP, it's possible to create streams which
produce the next value when its needed, instead of all at once.  This
is explored in section 3.5 of SICP, and implemented using *delay* and
*force*.

Can we do the same thing in Clojure using the built in *cons*?

Let's look at how *cons* is implemented in Clojure.  First, the
definition in *clojure.core*:

```Clojure
(def
 ^{:arglists '([x seq])
    :doc "Returns a new seq where x is the first element and seq is
    the rest."
   :added "1.0"
   :static true}

 cons (fn* ^:static cons [x seq] (. clojure.lang.RT (cons x seq))))
```

And digging a little deeper into the Java implementation in *RT.java*:

```Java
    static public ISeq cons(Object x, Object coll) {
        //ISeq y = seq(coll);
        if (coll == null)
            return new PersistentList(x);
        else if (coll instanceof ISeq)
            return new Cons(x, (ISeq) coll);
        else
            return new Cons(x, seq(coll));
    }
```

So we should probably look at the *Cons* class it's handing back in
two of the cases:

```Java
final public class Cons extends ASeq implements Serializable {

    private final Object _first;
    private final ISeq _more;

    public Cons(Object first, ISeq _more) {
        this._first = first;
        this._more = _more;
    }


    public Cons(IPersistentMap meta, Object _first, ISeq _more) {
        super(meta);
        this._first = _first;
        this._more = _more;
    }

    public Object first() {
        return _first;
    }

    public ISeq next() {
        return more().seq();
    }

    public ISeq more() {
        if (_more == null)
            return PersistentList.EMPTY;
        return _more;
    }

    public int count() {
        return 1 + RT.count(_more);
    }

    public Cons withMeta(IPersistentMap meta) {
        if (meta() == meta)
            return this;
        return new Cons(meta, _first, _more);
    }
}
```

Ok so without copying all the source code into this post, lets just
trace through what the following code would do:

```Clojure
;; Cons example
```


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


Streams are a clever idea that allows one to use sequence manipulations without incurring the costs of manipulating sequences as lists

 - sicp - are lazy sequences the same?


Streams / Lazy Sequences allow us to achieve in the declarative style using sequence manipulations while maintaining the efficiency of an iterative implementation.

With streams the implementation evalutes the cdr, or next element, at selection time instead of when the stream is constructed.

In SICP delayed streams are built using delay and force:

Clojure's delay and forced vs SICP delay and force (memo-proc)


