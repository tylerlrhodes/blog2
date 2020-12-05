---
title: "Second Clojure Program - Hugo Front Matter Editor"
date: 2019-08-11T09:34:05-04:00
draft: false
series: tech
description: "My second program in Clojure, where I put together a
short tool to edit the front matter of my blog posts."
keywords: [Clojure, Hugo, programming]
tags: [programming]
---

I just finished my second Clojure program, a short tool of about 120
lines that I can use to update the front-matter of my posts.

You can check out the code for it at
[GitHub](https://github.com/tylerlrhodes/blogutils/tree/master/front-matter-editor).
It would be fairly easy to make some modifications such as
adding/removing new front-matter.

The reason for writing it was basically laziness and it being a good
project to use Clojure again.  I have less than 50 posts, so I could
have easily just edited the front-matter manually.

Overall it's pretty simple.  The flow of reading the documents,
extracting the front-matter, and processing them worked well with
Clojure.  The only real mutable state within the application is the
file system where the updates are written.

I don't think I'm thinking in a very Clojure-ish style yet, but I'm
slowly starting to.  I wrote one function which after some reflection
could have been a lot simpler:

```clojure
(defn get-front-matter
  [file-name]
  (try
    {:file-name file-name
     :front-matter
     (let [result
           (with-open [rdr (reader file-name)]
             (reduce
              #(if (and
                    (not (nil? %2))
                    (= %2 "---"))
                 (if (= 1 (:marker %1))
                   (reduced
                    (string/join "\n" (:lines %1)))
                   {:marker (inc (:marker %1))
                    :lines  (:lines %1)})
                 {:marker (:marker %1)
                  :lines  (conj (apply vector (:lines %1)) %2)})
              {:marker 0 :lines nil}
              (line-seq rdr)))]
       (if (map? result)
         nil
         result))}
    (catch Exception e
      println e)))
```

This easily could have just read the file in and used a regex to
extract the front-matter.  Of course, I didn't quite think of that at
the time (I don't exactly love regular expressions).  The one benefit
this function does have is that it doesn't read the whole file into
memory, so there is that.  It also has a bug.... but works for my
purposes.

I also feel like this function is slightly a hack because I turned
reduce into a while loop with a break by using reduced.  But it
works.  I feel like using a map to keep the running reduction is a
little crazy, and think that a more iterative while loop would be
clearer here.  In retrospect Clojure's loop construct may have been
better.  But anyway...

There are some other functions which parse the front-matter YAML into
a map and check if it needs the update.

The core driver of the program looks like this:

```clojure
(defn update-entries
  [directory]
  (let [entries
        (filter
         #(:needs-fix %1)
         (map
          (comp needs-meta-fix? get-yaml get-front-matter)
          (get-files directory)))]
    (loop [entries entries
           term false]
      (if (or
           (empty? entries)
           (= term true))
        true
        (do
          (println "Existing entry: \n")
          (print-entry (first entries))
          (let [updated-entry (get-new-meta (first entries))]
            (println "\n\nUpdated Entry:")
            (print-entry updated-entry)
            (println "\nr to redo, n to continue, q to quit, wq to write and quit:")
            (let [input (str (read-line))]
              (cond
                (= input "r") (recur entries false)
                (= input "n") (do (write-updated-entry updated-entry) (recur (rest entries) false))
                (= input "wq") (do (write-updated-entry updated-entry) (recur nil true))
                (= input "q") (recur nil true)))))))))
```

I think the nice part of this is the beginning before the business of
the loop to prompt for input.  Composing the retrieval and parsing of
the files with map, compose, and filter made for a succint declaration
of what to do.

The program works so far.  The function which writes out the updated
front-matter uses a regex and I haven't run it on everything yet so
there's a chance I have a bug or two there to fix.

In fact getting the regex right took more time than writing the rest
of the code.  I managed to not copy something correctly after finding
the one that worked, so that added an hour or so simply by not
noticing I didn't copy it correctly.

I'm really liking Clojure and the REPL development and Emacs.
Especially the REPL driven development and the fast feedback.  It's a
nice process for working, and just feels different than the
write-compile-run process of other environments.  Plus I'm slowly
getting better at Emacs, which is turning out to be a joy to work with
for the most part.  I haven't even cracked the surface of its power
yet.








