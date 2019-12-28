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

* use lazy-seq example
* don't hold onto head

Now that we know we don't have to do anything special to use them,
let's look at how they work.

## Lazy Sequences in the Runtime

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
parameter and then a sequence for its second parameter, where the
value becomes the first element of a new sequence, and the provided
sequence the rest.  In Clojure, *cons cells* aren't the primitive
structure used to build everything else that they are in Scheme, and
*cons* in Clojure does not produce the same structure as *cons* in
Scheme.

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

So originally I was going to say we could easily debug this in
IntelliJ and step through and see what was going on.  And then I tried
to do this, and my IntelliJ debugger seems to lose track of itself
pretty regularly and becomes useless debugging Clojure.

My guess is that this has something to do with the on demand compiling
of code and IntelliJ is getting lost somehow.  But really I don't
know.  But I do know that debugging the code in *jdb* on the command
line works much better than doing it in IntelliJ.  The problem is that
you're debugging from the command line, which is, well, not terribly
fun.

But it works then!

I'll just kind of gloss over this and leave getting the debugging in
IntelliJ to work for another day.

It's not terribly complicated, and you can actually step through it
using *jdb* (hopefully also IntelliJ with some settings tweaks or
something).

So the first thing that happens is we hit the *first* method, which
calls the *seq* method, which calls the *sval* method, which does
things.

*sval* (short for seq val?) checks *fn*, and if it's not null, invokes
*fn* and sets *sv* to the result (these are member fields of the
*LazySeq*).  Then, if *sv* isn't null, it returns that, and we're
back in *seq*.  Or it returns *s* if *sv* is null.

This is kind of the root of the caching, once *fn* has been run once,
*seq* is going to set *s*, and the next time we hit *sval*, it's just
going to return *s*.  But the first time through there is more work to
do.

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

So *LazySeqs* are pretty lazy.  They only produce the value when its
called for, and they only do it one time.

You can put in some printf debugging into your *lazy-seq* to see that
this is in fact the case.  The second time to you go get a value which
has already been produced, the cached value is returned.





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


