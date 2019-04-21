---
title: "Processes and Threads on Windows"
date: 2019-03-16T08:56:34-04:00
draft: false
tags: [
      "programming",
      "concurrency",
      "windows"
]
---

I've been reading "Concurrent Programming In Windows" (CPIW) and wanted to
turn some of my notes into a post to explain processes and threads in
a high level which may be of use to an application developer.

I originally thought that this post would be relatively easy to write
and quickly found that depending upon what you want to know about a
process or thread you'll have a long list of things to explain.  I've
tried to keep this to what at the time I thought was useful to know at
a high level concerning processes and threads.

## Processes and Threads in a Nutshell

I wanted to go deeper than the conceptual overview, but it turns out
that in a lot of ways the conceptual overview of a process being a
running program, and a thread being an execution context for work
being performed actually seems to sum up the core of what you need to
know as an application developer to a large extent.

It's the OS that seperates running processes and gives them their own
address space and schedules the execution of threads within them.

A process on Windows contains at least one thread of execution, which
in turn can launch additional threads to perform operations
concurrently.

A key concept to understand is that a process on Windows is given its
own virtual address space which all the threads share (in addition to
the other resources a process is given).

Microsoft, at [About Processes and
Threads](https://docs.microsoft.com/en-us/windows/desktop/procthread/about-processes-and-threads),
says that a thread is an entity within a process that can be scheduled
for execution.  CPIW says "A thread is in some sense just a virtual
processor.  Each runs some program's code as though it were
independent from all other virtual processors in the system."

You'll also note that I've conveniently left out any notion of an
application or program, because in some ways these terms can imply an
abstraction that may contain multiple processes which are the
coordinated in some way.

So how is it that threads are able to execute concurrently even on a
computer that has only one CPU?

## Thread Scheduling

Windows uses preemptive scheduling for all threads on the system, also
known as time-slicing.  This means that Windows may interrupt one
thread to let another thread run on its processor.  This allows for
threads to be scheduled in a fair way, which ensures that they are
given time to execute.

This control of the scheduling by Windows and the virtualization of
resources is what makes it possible for multiple programs to appear
run at the same time on a single CPU.  On a multiprocessor computer
the system can execute one thread on each processor present
concurrently.

Each thread in the system is in a given state at any moment in time
throughout its lifetime.  While there are a number of different states
a thread can be in, the running and waiting states in my opinion are
the most important to understand for an application developer.

A thread in the running state simply means that its currently being
executed on a processor.  It may of course be preempted by the
scheduler to allow for another thread to run.

When in the waiting state a thread is not under consideration for
execution by the scheduler.  A thread enters this state anytime it
waits on a kernel synchronization object, performs an I/O activity, or
voluntarily sleeps.  Thread suspension also places a thread into this
state.

Windows also uses priorities to schedule execution of threads.
Typically as an application developer these won't be of much concern,
and from my experience should be left be unless you have a specific
known reason to modify them.

It is possible to use User-mode Scheduling (UMS) which allows
applications to schedule their own threads which can provide
additional efficiency in certain scenarios.

## Practical Notes

When developing a concurrent system on Windows there are a number of
issues to keep in mind, especially if your system will have a large
number of threads and performance is critical.  CPIW addresses these
in detail in chapter 4, however, for general development and knowledge
there are a few things to remember.

Given that each thread has a context which includes a stack, there is
a non-trivial amount of overhead to consider.  The stack size can be
modified, and indeed is by default in things like ASP.NET.  Also,
switching between threads incurs overhead as well.

Normally a process's threads are eligible for execution on any of the
available processors.  Windows tries to run a given thread on it's
ideal processor (see CPIW chapter 4) or the processor it last ran on.
This is in an attempt to improve memory locality and distribute
workload across the machine.  It is possible to set a thread's
processor affinity which limits its execution to a subset of
processors on the system.

Windows provides a number of kernel synchronization objects which
allow for data and control synchronization between threads.  CPIW
covers these in detail.

## Additional Information

There are a huge number of resources which cover concurrent
programming and threads on Windows in detail.

* Concurrent Programming in Windows, by Joe Duffy
* Windows Via C/C++
* Windows Systems Programming
* MSDN
* Windows Internals - these books cover the Windows System at a low level.










