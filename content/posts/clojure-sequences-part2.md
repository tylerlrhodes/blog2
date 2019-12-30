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

Let's take a look at how we use lazy sequences in Clojure.

## Using Lazy Sequences

If you're been programming in Clojure and using sequences, then you
have already been using lazy sequences.  Most of the functions in
Clojure which produce a sequence do so lazily, and you don't really
have to do anything special for this to happen.

Looking through the source code of many of Clojure's sequence related
functions you can see that they return *lazy seqs*.

So basically you just use sequences in Clojure, and they are lazy.
It's not like SICP where we coded all of the sequence functions
ourselves and then later went back and made them lazy.  In Clojure
they're already lazy and we don't have to do anything.

It is possible to create our own lazy sequences when necessary.
Clojure provides the *lazy-seq* macro which plugs into the runtime
behind the scenes and allows us to make our own lazy sequences.

```Clojure
(defn inf [n]
 (do
  (print \.)
  (lazy-seq
   (cons
    n
    (inf (inc n))))))

(take 2 (take 10 (inf 1)))
```

This is a simple example of how lazy sequences work.  Running the
above code will show clearly that the elements are produced on demand.

One thing to note is that it's possible to basically create infinite
sequences using *lazy-seq*.  If you do this, and hold onto a reference
to the head of the sequence, you run into the possibility of running
out of memory.

Clojure relies on the JVM for garbage collection, and if you hold onto
the head of lazy sequence and go on to produce a large number of
items, it won't be able to garbage collect those items as it goes.
Bad things could happen.  If you run into an out of memory
exception, it may be because you're holding onto the head of a large
lazy sequence somewhere.

Now that we know we don't have to do anything special to use them,
let's look at how they work.

## Lazy Sequences in the Runtime

In Scheme, as show in in SICP, it's possible to create streams which
produce the next value when its needed, instead of all at once.  This
is explored in section 3.5 of SICP, and implemented using *delay* and
*force*.

It SICP we build *cons-stream*, coupled with *car-stream* and
*cdr-stream* to make use of streams, which are basically the SICP
equivalant of Clojure's lazy sequences.

Clojure's lazy sequences are implemented in the Clojure runtime, and
the clearest example of how they work is by looking at the use of
*lazy-seq*.

First we'll look at just using the macro, and then we'll explore some
of the code behind the scenes in Clojure's Java implementation code.

Below is the defintion of the *lazy-seq* macro:

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

Aided by the ability to look at Clojure's source code (and run it
through a debugger while it evaluates the code), we can peek under the
hood and see exactly how it works (we'll skip the part about how the
code is compiled on the fly and executed -- looking at the source for
RT.java and LazySeq.java provides enough details for our purposes).

In the first case, we can trace the code a bit from *first* in RT.java
through LazySeq.java and see what's going on:

```Java
static public Object first(Object x) {
        if (x instanceof ISeq)
            return ((ISeq) x).first();
        ISeq seq = seq(x);
        if (seq == null)
            return null;
        return seq.first();
    }
```

So *first* is pretty straight forward.  We can see that we're going to
be running the *first* method of *x* in our case, since a *LazySeq* is
an *ISeq*.

We won't look at the entire source for *LazySeq*, though you can, but
we'll look at a few methods and the constructor to get a bit of an
idea.

First, the constructor:

```Java
public LazySeq(IFn fn) {
        this.fn = fn;
    }
```

Pretty straight forward again, it takes a function, which it will use
to produce a value eventually.

So let's look at the code that actually does the work.

```Java
// from LazySeq.java
public Object first() {
        seq();
        if (s == null)
            return null;
        return s.first();
    }

final synchronized public ISeq seq() {
        sval();
        if (sv != null) {
            Object ls = sv;
            sv = null;
            while (ls instanceof LazySeq) {
                ls = ((LazySeq) ls).sval();
            }
            s = RT.seq(ls);
        }
        return s;
    }    

final synchronized Object sval() {
        if (fn != null) {
            sv = fn.invoke();
            fn = null;
        }
        if (sv != null)
            return sv;
        return s;
    }
```

So the first thing that happens is we hit the *first* method, which
calls the *seq* method, which calls the *sval* method.

*sval* (short for seq val?) checks *fn*, and if it's not null, invokes
*fn* and sets *sv* to the result (these are member fields of the
*LazySeq*).  Then, if *sv* isn't null, it returns that, and we're
back in *seq*.  Or it returns *s* if *sv* is null.

This is kind of the root of the caching, once *fn* has been run once,
*seq* is going to set *s*, and the next time we hit *sval*, it's just
going to return *s*.

*LazySeq's* *seq* method looks a little more complicated than it is,
but it's basically producing a sequence that is no longer lazy, so
there is a value there.  It's not immediately obvious why this would
be done, until you realize you can write code like this:

```Clojure
(defn inf-nuts [n] (lazy-seq (lazy-seq (lazy-seq (cons n (inf-nuts (inc n)))))))
```

Eventually *seq* is going to run into a *Cons* here, and *s* will be a
*Cons*, and then *first* is going to get the value of *n*.  

So it's actually pretty simple how it works.  Let's trace through the
second sample I had put, where we get the first of the rest.

This time we call *rest*, which is defined in RT.java as:

```Java
static public ISeq more(Object x) {
        if (x instanceof ISeq)
            return ((ISeq) x).more();
        ISeq seq = seq(x);
        if (seq == null)
            return PersistentList.EMPTY;
        return seq.more();
    }
```

So we're going to hit *more* in *LazySeq*, which looks like:

```Java
public ISeq more() {
        seq();
        if (s == null)
            return PersistentList.EMPTY;
        return s.more();
    }
```

Now it's pretty clear that this works almost exactly the same way as
when we called *first*, just the method names have changed.

So the call to *rest* is going to essentially end up calling *more* on
the *Cons* object, which is going to return a *LazySeq*.

Then we call *first*, which does what we did last time, and again
we'll run into the *Cons*, and it's *first* is going to have the value
of 2.

And this is basically how *LazySeqs* work.  It's slightly more complex
than the implementation given in SICP, but not much, and it only seems
that way because we're dealing with more than just *cons cells*.

It's interesting to examine the implementation of lazy sequences in
Clojure's runtime and basically see that it's the same thing that is
done in SICP.  It's also interesting to see how depending upon the
backing data structure of the sequence, how it is lazily produced may
be different than another type, but basically its doing the same
thing.

I didn't show any of the code besides *LazySeq*, but if you remember
from the first post on sequences, we ran into the code that produces a
*chunked iterator*, for instance with a map, and it wraps it up in a
*LazySeq*.

Another example might be *range*.  If you look at the definition of
the *range* function, you'll see it uses some Java types behind the
scenes.  These types implement *ISeq*, and produce their values
lazily, even if they don't use the *LazySeq* type.

## Lazy Sequences and the REPL

Let's put together some code which we'll run at the REPL to show that
lazy sequences are in fact lazy, even if the REPL makes it look like
they aren't on occasion.

```Clojure
(defn up-to-10
  ([] (up-to-10 1))
  ([n]
   (lazy-seq
    (when (> 10 n)
      (print \.)
      (cons n (up-to-10 (inc n)))))))

(up-to-10)

(take 3 (up-to-10))
```

What's going on when we run this code?  Why does evaluating (up-to-10)
at the REPL cause the entire sequence to be produced, but evaluating
(take 3 (up-to-10)) doesn't?

The answer to this lies once again, of course, in Clojure's source
code.  Hidden deep within the bowel's of the REPL.  Actually not that
deep.

This is from the *repl* function in clojure.main:

```Clojure
read-eval-print
(fn []
  (try
    (let [read-eval *read-eval*
          input (try
                  (with-read-known (read request-prompt request-exit))
                  (catch LispReader$ReaderException e
                    (throw (ex-info nil {:clojure.error/phase :read-source} e))))]
      (or (#{request-prompt request-exit} input)
          (let [value (binding [*read-eval* read-eval] (eval input))]
            (set! *3 *2)
            (set! *2 *1)
            (set! *1 value)
            (try
              (print value)
              (catch Throwable e
                (throw (ex-info nil {:clojure.error/phase :print-eval-result} e)))))))
    (catch Throwable e
      (caught e)
      (set! *e e))))
```

And the reason that our lazy sequences get printed in their totality
if you evaluate them by themselves at the REPL, is because of the line
*(print value)*, which results in some code running which iterates the
sequence provided.  If it's our lazy sequence *up-to-10* then it
prints out all the values.  If it's an infinite sequence it just keeps
printing until it throws an error.

## Summary

In the first post on sequences I went over how to use them, and tried
to show the versatility of sequences in Clojure.  *Seqs* allow us to
use a common set of functions across a number of underlying types, and
to write our code in a declarative, easy to follow style.

The runtime hides a lot of the details of how this works and lets us
just use functions like *map* and *reduce* against anything that can
be turned into a *seq*.

Not only are *seqs* thread-safe while using Clojure's persistent data
structures, but they are also lazy, allowing us to be thrifty with our
resources and processing power.  And they do this by default, without
even generally needing to be aware of this.




