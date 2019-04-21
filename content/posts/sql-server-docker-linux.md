---
title: "SQL Server for Linux on Docker"
date: 2019-01-02T22:33:08-05:00
draft: true
tags: [
      "SQL Server",
      "docker"
]
---

I'm always working with SQL Server at work, and while I'm reasonably
good at it there's always more to learn.  I also don't like installing
things on my home PC as much as possible, and I don't really want to
have my PC run SQL Server in the background all the time where I would
have to remember to shut it off.  Now given that I basically use my
computer to code, watch netflix, and browse the internet, my powerful
machine could probably handle running SQL Server all the time and I
wouldn't notice it at all, but to me this seems like a pretty good
spot to use Docker.

One of the pitfalls of using docker here is that when the container
stops, anything that you've saved is lost.  So I have to setup a
volume so that I can redirect some of the storage on the container
instance to my local disk, thus, enabling me to not lose my data when
I stop the container.

So, I'm going to run the Linux Edition of SQL Server on my Windows 10
PC and try to redirect the database storage to a local folder so that
I don't lose my work.  I don't know where SQL Server puts its data on
Linux by default, so I'm going to 
