---
title: "Windows Kernel Synchronization"
date: 2019-04-02T11:27:24-04:00
draft: false
series: tech
tags: [
      "programming",
      "concurrency",
      "windows"
]      
---

The primitives offered by Windows for thread synchronization are
kernel objects.  These objects, created using their corresponding
Win32 or .NET APIs are managed by the OS, and make up the fundamental
building blocks of synchronization on Windows.  Five object types are
thread synchronization specific: mutexes, semaphores, auto-reset events,
manual-reset events, and waitable timers.

Each kernel object can be in either a signaled or nonsignaled state,
with the rules for transition between states differing by object
type.  A thread will block waiting for a kernel object to become
signaled.  When a thread is blocked it will be in the waiting state,
marked as ineligible for execution by the scheduler.

While there are libraries available for synchronising between threads,
there are some reasons to use kernel objects directly, such as:

* Interprocess Synchronization - kernel objects can be named and
  shared between processes.
* Security - kernel objects can be secured via ACLs.
* More sophisticated waits and control
* Interoperate between native and managed code

Creating, waiting, and signaling these objects is accomplished using
their respective APIs in either Win32 or .NET.  Waitable timers aren't
directly exposed via .NET, however are available indirectly via the
thread pool.  Many threads can wait simultaneously for the same kernel
object.  Depending on the type of object, when it becomes signaled it may
awaken one or more waiting threads.

## Notes on Waiting

When these synchronization objects become signaled the thread(s)
waiting on them will be awakened in a manner consistent with the type
of object.  Both the Win32 and .NET APIs provide for a way to wait for
one object or multiple objects to become signaled.  The kernel is
intelligent in how it awakens threads, and a thread waiting on objects
A, B, and C will not prevent a thread waiting only on A from being
awakened ahead of it when A is signaled but B and C are not.  In
general when multiple threads awaken at the same time they are
awakened in a FIFO order although this is not strictly preserved.

When using WaitForSingleObjectEx or WaitForMultipleObjectsEx the
thread can be wakened before the wait is satisfied by a user-mode
asynchronous procedure call (APC) if the alertable flag is set in the
call to the wait function.  Concurrent Programming on Windows (CPOW)
describes this in greater detail and talks about potential issues that
this can cause.  Waits in .NET are performed in an alertable state and
the APIs don't provide for a way to change this.  This can create
non-obvious deadlocking situations which CPOW covers.

CPOW also talks about handling message pumping while waiting in Win32,
something that is important for GUI and COM applications.  .NET
handles message pumping for you through the CLR and libraries.  

When a thread wakes from being blocked that thread's priority is
temporarily boosted to increase the probability that thread will run
again sooner, often leading to quicker rescheduling.  This boost
depending upon the machine can have a negative impact.  For instance,
it's possible that the thread which signaled the object releasing the
other thread still holds a resource the awakened thread needs.  This
can result in additional waiting and context switches.


## Kernel Thread Synchronization Objects

**Mutex**

The mutex is used for building mutually exclusive critical regions,
which is facilitated by the mutex transitioning between signaled and
nonsignaled states atomically.  A mutex is available for acquisition
when it is signaled (no current owner).  A wait will atomically
transition the mutex into a nonsignaled state.  A mutex is owned by a
single thread at a time, and ownership is based on the physical OS
thread used to wait on the mutex.  A mutex is acquired by waiting on
it, and care must be taken to release it.  The mutex supports
recursive acquires through an internal recursion counter.  It's
possible for a mutex to become abandoned when it's not correctly
released before its owning thread terminated.

**Semaphore**

A semaphore is a synchronization object which maintains a count.  When
the count is greater than zero the semaphore is signaled and when it
reaches zero it becomes nonsignaled.  A thread waits on the semaphore to
acquire it, and decrements the count when it is acquired.  When the
thread releases the semaphore the count is incremented.  Using a
semaphore allows for controlling the number of threads with access to
a shared resource.

Unlike a mutex, the semaphore does not support recursive acquisition,
and the count can be decremented by a thread waiting on it more then
once.  Also unlike a mutex the semaphore count can be increased by
any thread releasing it -- it's not owned like a mutex.

**Events**

Auto and manual reset events are used to coordinate multiple threads.
Like mutexes and semaphores, they can be either signaled or
nonsignaled (set or unset).  The event objects are useful for
signaling that a particular event has occurred.

Auto-reset events when signaled will awaken one thread waiting on
it. When that thread wakes from its wait the auto-reset event is
automatically reset back to nonsignaled.  Any thread can reset the
event, it has no thread ownership like a mutex does, and does not
support recursion like a mutex.

The manual-reset event does not automatically transition back to
nonsignaled when it is set.  When set, any threads waiting on it, or
that go to wait on it, will be scheduled for execution until it is
reset back to nonsignaled.

**Waitable Timers**

The waitable timer object is signaled when a specified time arrives.
The time can be a set time in the future, or a recurring period of
time.  Timers support both manual-reset and auto-reset modes just
like events.  The manual-reset timer allows multiple threads to wait
on it and must be reset.  An auto-reset timer only wakes one waiting
thread and automatically resets back to nonsignaled after releasing
the one thread.

