---
title: "Writing A Simple HTTP Server in Python"
date: 2021-04-24T13:06:31-04:00
draft: true
description: "Writing a HTTP server in Python."
series: tech
keywords: [Python, HTTP, Networking, sockets]
tags: [Python, programming]
---


This post is going to explore writing a simple HTTP server in Python
to demonstrate the basics of HTTP and also a simple network
application.  It's basically a learning exercise pure and simple.
I'll also go over the history or HTTP, some of the differences between
the versions, and some of the more pertinent and interesting aspects
of HTTP.

As I assume you know, HTTP, the Hyper Text Transfer Protocol, is
implemented and used to serve up content to requesting clients.  A
HTTP server makes it possible to deliver this blog post to your
browser, from simple text to more sophisticated content such as images
and videos.

Now, depending upon your requirements, you may not even need to be
aware of what software is being used to serve up your website.  Or how
it works for the most part.  This blog is served from Amazon's CDN,
CloudFront, and I have no idea what web server is actually used.  It
doesn't really matter to me.  All I know is that it serves up the site
quickly, and since I get no readers, it's basically free too.
Services like Cloudfare and others do the same thing.  Barely a
thought is given to what server is actually used.

Users, or readers, unless they have good reason to, could care less
how the content gets down to their computer.  Even when it doesn't
work they don't care!  They just want it to work again.

Web Developers, on the other hand, have good reason to be more
familiar with HTTP servers (and clients).  The web server provides a
crucial interface between the client and the application.  Without it,
there is no web application for the most part.

Before diving straight into code and exploring how to build a simple
HTTP server, let's review what HTTP is and what we can do with it.

## HTTP Overview ##



https://tools.ietf.org/html/rfc7230


Introduction

- What does HTTP do and why do we have it?
- Brief history


Why

- Why is the reader going to read this?


Networking Basics
- OSI
- TCP/IP
- IP Addressing
- Routing and Switching

HTTP Basics

- Protocol basics of HTTP
- RFCs
- Different versions
- WebSockets
- MIME Types
- Long Polling?
- Identifying resources (URIs)
- Cookies


Prerequisites

- Knowledge expectations
  - Basic networking
  - DNS
  - Python

What we'll build
- Single threaded
- HTTP 1.0 Server
- HTTP 1.1 Server


What you'll understand at the end:
- select based IO
- HTTP
- basic network programming




Future things to build:


Sessions


Authentication


Performance


HTTP/2 and The Future


References


