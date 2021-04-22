---
title: "A Refactoring Project in Python: Music CD List, Part 3 of 3"
date: 2021-03-05T19:11:10-05:00
draft: true
series: tech

description: "The third and final entry about refactoring a simple
Python program to be more 'Pythonic.'"
tags: [programming]
keywords: [python, unittest, linked list, refactor]
---

The Music CD List started as an example program making use of a
hand-coded Linked List to demonstrate refactoring to the Pythonic, and
it has grown to a web application with a thread safe 'ListStore.'  By
the end of [part 2](/posts/music-cd-list-part2) it had a functional
web front-end with a number of features.

Now it's time to wrap up this blog series and review a little bit.  In
addition to talking about the refactoring and Pythonic I'll also go
over the packaging I did between blog posts to dump the application
into a Docker image.

It's left in a state where it could be taken further in a number of
different directions.  One option, would be to turn it into a
Serverless application on AWS.  Another option, though arguably less
fun, would be to make it a more traditional server based application.
The utility of the existing `ListStore` abstraction that came about in
the second post would depend upon the required persistence model the
future version would require.  The Serverless edition would likely
favor changing the `ListStore`, or replacing it.

For now the application is as baked as it's going to be for the near
future.  The future of the Music CD List is most likely for it to sit,
unadmired, gathering internet dust on the shelves of useless example
repositories gathered on GitHub.

But anyway, before I go over packaging it up into a Docker based build and image
which can run the application, I'll go over the refactoring.

### The Quest for the Pythonic ###

I started this series of posts with a simple Linked List storing a
list of CDs that was entered directly in the code.  Then, I added in
some unit tests, and finally an abstraction with the idea of allowing
any data structure to be used to back the CD list.  In the end, the
abstraction ended up using Python's `MutableSequence`, but hey, it
works.  So far I've yet to use anything besides the Linked List.

In between posts I added a Flask Web API and also a simple React based
front-end application to make it easier to actually use the CD List.
Now, you can add CDs through the GUI, upload or download
the list as a CSV, and sort and paginate the results.  It's a simple
interface that works reasonably well so far -- if yet unfinished
because you can't edit or delete CDs through the web interface yet.

But returning to the original task of the series of posts, and not
getting drawn into continually developing it, it's time to offer some
final 'refactorings' and reflect on making this simple program more
"Pythonic."

In [The Hitchhiker's Guide to Python: Code
Style](https://docs.python-guide.org/writing/style) the common fact
that code is read more than it is written is recognized, and a number
of style guidelines are offered, or "Pythonic" idioms.

So to finish of this refactoring project, and make the code as
Pythonic as possible, I'm going to do a review and try to fix any
flagrant violations of the Pythonic I can see (while learning more of
the Pythonic way).  I'll also incorporate advice from the book
"Effective Python."

Then, to finish it off I'll write up a summary reflecting on PEP 20,
and how I setup my VS Code project using linting and unit testing to
help me get to the point where I didn't think this was too embarassing
to put on the internet.

### Reviewing Music CD List for the "Un-Pythonic" ###

1) Search for obviously Un-Pythonic code:

Somehow I can't find any obvious examples right away in the sample
program.  If only I was reviewing the JavaScript!  I'll let this slide
for now, there are a few variable names I could change, but that would
be boring.  So much for a few obvious examplee.

2) Consider PEP 20 - The Zen of Python

With the code relatively fresh in my mind I read through the aphorisms
contained in PEP 20 and picked out a few to focus on.

*Beautiful is better than ugly*

Without going to extremes, this is a straightforward thing to
evaluate and I think here I've done okay.  None of the code in
Music CD List is terrible to look at, and overall it has a simple
design, I think.  I'll leave it to the reader to easily disagree.
Hey, it could have been C# or Clojure!

*Errors should never pass silently.*

Hmmm, I kind of took a flyer on this one.  Not only do errors not
silently pass, they take a crash and burn approach.  I could probably
pick up a few points on this code by adding in better exception
handling.  I've seen idomatic Python that uses exception handling as a
course of normal code flow and program control, more so than I'd say
is typical in other languages, and it has thrown me for a loop on
occasion.

I actually ran into this when implementing support for mutable
sequences.  During the iteration there is a "stop condition" that
apparently expects an Exception to be thrown to stop the iteration!

*Readability counts.*

Readability definitely counts, and I like to think that in general I
can write code that is readable.  It's not always a given, but I try
to write things out well, and that means sometimes not writing code
in the shortest, or contraversly, longest way possible.

After having experience I've also found different code bases become
more or less readable after spending more time with them, and
sometimes readability becomes intertwined with the architecture and
layout of the code.  I think the readability increases the more one
becomes familiar with the idioms and style of the author -- hence,
here, the Pythonic.  Following the Pythonic style (and a somewhat
standard layout) in general adds to the readability for potential new
contributors right away.

*Now is better than never.*

<i>Although never is often better than *right* now.</i>

These two are the reason the Music CD List exists basically.  I could
have waited and studied the "Pythonic" and everything written on it
for months before diving into this.  That said, I wouldn't have a
half-baked Music CD List if I didn't (hey, wait a second).  Although
that's more due to not having a great idea to start with more than
striving for the Pythonic.

I read these two aphorisms as contradictions.  I could be wrong, but I
don't think the second one is meant to be taken seriously.  I'm great
at procrastinating myself, and know how the second one works for me.
But they are fungible enough to fit many situations equally well.

### Deployment ###

I developed the Music CD List basically as a demo app, and while I may
grow it to use as an AWS example, for now I'm going to keep the
"deployment" fairly simple.  The end state of this series of posts is
the application capable of being built into a Docker container and
run.

While I was developing it I switched from VS Code to PyCharm, and
found debugging both the SPA portion and the Python portion simple
within both of these environments.  I tend to lean a little bit
towards liking PyCharm better at this moment, but either is fine and
easy to setup as is.

To run it locally and not in the Docker container, you simply launch
the Python Flask application after installing the requirements (from
"requirements.txt" -- I setup a Virtual Environment) and then run the
React frontend.  The frontend was setup simply using the "Create React
App" tool provided with Ract and can be launched for debugging with
"npm start" from the command line after setting an environment
variable for the host and port the Flask application is listening on.
If you look through the Dockerfile you can see the environment
variable to set.

After the first time of running the application it becomes very easy,
and easy to also integrate with VS Code or PyCharm, and I switch
around between IDEs enough not to be totally a "super expert" in any
(as I write this in Emacs).

To finish it off and leave this series of posts with a somewhat
"finished" product I packaged it up into a Docker container which
serves the static front end using nginx while proxying the API calls
to the Flask app using the standard uwsgi.

I was able to make use of the multistage Docker build, where I use a
node Docker image to build the SPA, and then copy the build output to
the Python Docker image where nginx and uwsgi are setup along with the
Python app.  I customized the uwsgi and nginx configurations a little
from what may be considered the norm because this application supports
multiple threads, but not multiple processes.  With multiple processes
you start to see inconsistent results because the state is stored in
process and not shared between the proccesses.

I certainly wouldn't consider the current Docker setup ready for
production, as there are a few best practices I'm not following.
Starting with what would probably be considered the questionable use
of a shell script to launch multiple processes instead of supervisor
or something like that.  But for a cheap, fast, locally runnable
"finsihed" product I think it's fine.









