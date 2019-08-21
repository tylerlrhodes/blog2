---
title: "Clojure: Destructuring and Optional Arguments"
date: 2019-08-17T19:04:14-04:00
draft: true
description: "Destructuring in Clojure is something that shows up
frequently in code, and to the beginner Clojurist can be difficult to
decipher.  Being a beginner Clojurist myself, and getting tired of
having to look it up everytime, I'm writing my own reference to it."
keywords: [Clojure, destructuring]
tags: [programming]
---

Imagine you have a map, or a vector, or some composite object to
represent something in your application.  Then imagine you would like
to refer to a property which is represented by an element in that map
or vector to easily reference it.  Destructuring allows you to do this
in short order.

When I first saw it in Clojure code I semi-recognized it.  It's used
fairly regularly it seems in books about Clojure and other code on the
net, so I figured it was high time to get more acquainted with its
use.  There are a number of Clojurisms that show up in Clojure code.
I'm slowly learning them.

Let's look at the following code:

```clojure
(def person ["Tyler Rhodes" "blue" 36 195 180])

(let [[name
       eye-color
       age
       current-weight
       target-weight]
      person]
  (println name "has" eye-color "eyes, is " age
           ", weighs " current-weight ", and would like to weigh" target-weight))
```

This code starts off by defining the person vector.  Then it
destructures that vector into its composite parts to more easily refer
to them when it prints out the information.

The destructuring is achieved in the let expression.  Where you would
normally declare the symbols to be bound to values, you "describe the
bindings" based upon their sequential ordering.  The language
"describe the bindings" is taken from [Destructuring in
Clojure](https://clojure.org/guides/destructuring).

Clojure's destructuring is broken up into two categories, sequential
and associative.

The above was an example of sequential destructuring, where a vector
was destructured.  This type of destructuring can be applied to
anything that can produce a sequence.

For example, the following are also valid:

```clojure
(defn positive-numbers
  ([] (positive-numbers 1))
  ([n] (lazy-seq (cons n (positive-numbers (inc n))))))
;; ex 1
(let [[two three four] (drop 1 (take 4 (positive-numbers)))]
  (println [two three four]))
;; [2 3 4]
;; ex 2
(let [[_ _ three] (take 3 (positive-numbers))]
  (println three))
;; 3
;; ex 3
(let [[one two three four] (take 2 (positive-numbers))]
  (println one two three four))
;; 1 2 nil nil
;; ex 4
(let [[one two three] (take 10 (positive-numbers))]
  (println one two three))
;; 1 2 3
```

For the examples I've used a simple function which produces a lazy
sequence of positive numbers to show that any sequence can be
destructured.

The first example shows an attempt at getting the second, third, and
fourth values from the sequence.  Here I've manipulated the values
provided to the destructuring using drop and take to accomplish this.
As expected, [2 3 4] is displayed in the output.

However, say you have a sequence where you want to grab one of the
elements, or perhaps a number of them, while ignoring others.  It's
easy to do this by binding them to a name you won't use.  Typically,
the underscore is used for this, as shown in example two.  This
technique could have easily been used to accomplish the desired
destructuring in the first example.

The third example shows what happens when the size of the sequence
being desctructured is smaller than the bindings.  In this case the
extra symbols are bound to nil.

The fourth example shows what happens when the sequence is larger.
Here they are ignored.

These are some simple examples of sequential destructuring.  But it
doesn't stop here.

Let's look at a few more examples.

```clojure
;; ex 5
(let [[[a b] c] [['a 'b] 'c]]
  (printf "a: %s\nb: %s\nc: %s\n" a b c))
;; a: a
;; b: b
;; c: c

;; ex 6
(let [[one two three & nums] (take 10 (positive-numbers))]
  (println one two three)
  (println "rest:" (clojure.string/join "," nums)))
;; 1 2 3
;; rest: 4,5,6,7,8,9,10

;; ex 7
(let [[one two & nums :as all] (take 5 (positive-numbers))]
  (printf "one: %s\ntwo: %s\nnums: %s\nall: %s" one two nums (apply str all)))
;; one: 1
;; two: 2
;; nums: (3 4 5)
;; all: 12345
```

Example five shows that the destructuring operates recursively, and
you can do nested sequential destructurings.

The next example shows how you can bind the remaining items in a
sequence after first bindings are destructured.

And finally, example seven, displays how in addition binding the
sequence to the named symbols, you can still bind the sequence as a
whole by using :as and yet another named symbol.  Fun times.

This makes possible doing something like this:

```clojure
(def tr [["Tyler" "Rhodes"]
         (java.util.Date. "4/16/1983")
         ["Jurassic Park" "Programming C" "The Joy of Clojure"
          "Programming Clojure" "Fluent Python" "Common Sense Investing"]
         ["Pizza" "Steak" "Chicken Wings" "Burritos"]])

(let [[[first-name last-name]
       birthday
       [favorite-book & books :as library]
       [favorite-food :as foods]]
      tr]
  (println "Firstname: " first-name)
  (println "Lastname: " last-name)
  (println "Birthday: "
           (.format
            (java.text.SimpleDateFormat. "MM/dd/yyy") birthday))
  (println "Favorite book: " favorite-book)
  (println "Rest of library: " (clojure.string/join ", " books))
  (println "Favorite food: " favorite-food)
  (println "Rest of diet: " (clojure.string/join ", " foods)))
```



The other destructuring in Clojure is known as associative
destructuring, 





