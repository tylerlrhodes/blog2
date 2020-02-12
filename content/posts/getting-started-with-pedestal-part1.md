---
title: "Getting Started With Pedestal"
date: 2020-01-02T21:21:58-05:00
draft: true
tags: [pedestal, clojure, programming]
keywords: [programming, pedestal, clojure, rum, bide router]
description: "A short post on getting started with Pedestal, a web framework for Clojure."
---


Outline:

Part 1

1. Overview of Pedestal
2. Creating the project
3. Running the project
4. Developing at the REPL
5. Serving files
6. A simple API
7. Testing
8. Getting around

Part 2

1. Interceptors (middleware)
2. Understanding ring
3. Using ring middleware
4. Content types
5. Forms (getting parameters and data from requests)
6. A more powerful API

Part 3

1. Logging in pedestal
2. Security (CSRF, CSP, XSS, etc)
3. Authentication
4. Inteceptors revisited
5. Routing revisited
6. Integrating ClojureScript

Part 4

1. Our over engineered booklist
2. The design overview
3. Detour into Rum/Citrus/Bide
4. Integrations
5. Code Review
6. Deployment

Part 5

1. Overview of "Async"
2. Pedetal and async
3. Stuff to watch out for
4. Async-ifying booklist
5. A short guide to crashing and burning
6. Do you need it?









Pedestal is a web development framework for the Clojure programming
language.  Or, it's more specifically a set of libraries that can be
used to build services and applications.

It's not too hard to get going with Pedestal.  I haven't done anything
sophisticated yet, but I'm building an RSS reader application which I
have grand plans for, and I've started to do it with Pedestal.

I've sucessfully gotten it working on it's own, serving up static
files and responding to API requests from a very basic Rum/React
frontend that so far only lets you login.  But the core parts are
pretty much there, including: CSRF, session management, and cookie
authentication.

To be fair, if I had gone with ASP.NET MVC I probably would have been
further along by now.  If you've ever used the Microsoft package, for
all it's warts, its usually got most of the batteries and parts
included to get a lot of stuff done.  ASP.NET MVC, and MVC Core, are
pretty comprehensive frameworks for developing web applications in
C#. They are also fairly well documented and there are a lot of
bloggers who write about them.

For anyone wondering and thinking about using Pedestal (which I would
say just go for it I guess), FYI, the documentation is a little bit
sparse.  It's not sparse if you think that the code is the
documentation.  But if you're hoping to be able to google and easily
find how to do something, well, I tried and now when I need to find
something I basically just go and look at the code.

However, if you're not a first time web developer, and you've built an
API or two before, and the thought of CORS and CSRF doesn't strike
fear into you (and you hopefully know how they work a little bit),
then getting into Pedestal isn't going to be too bad.

If you're a new web developer and you have a deadline and you don't
know Clojure or web development then I don't know what to tell you.  I
guess just learn Clojure and Pedestal anyway and tell you're boss it
will take as long as it takes?

But I would like to show once you figure out how the pieces go
together a little bit just how easily you can get a simple page up and
running with a few of the bells and whistles.

Following along here will give you the bare bones of a single page
application using Pedestal on the backend, and React and Rum on the
frontend using ClojureScript.  It's actually really easy to get this
setup, and if you're running Linux or on the Mac I think it's even
easier than Windows.

The only short-cut I'll take is using the figwheel-main lein template
to save some time, but it's definitely not necessary and adding
figwheel-main and ClojureScript to an existing Clojure project is
pretty easy to do.
