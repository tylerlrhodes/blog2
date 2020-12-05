---
title: Bagombo Deprecated
date: 2018-03-11T18:21:52Z
draft: false
series: personal
tags: [personal]
description: Bagombo is deprecated but remains available on GitHub.  Moving my blog to Hugo and S3.
keywords: [bagombo, hugo, s3, aws]
---
Before I get into why I'm deprecating Bagombo, I think it's more important for me to reflect on why I want to blog and how I got sidetracked.

## Why blog?

This is really the first question anyone thinking of blogging should ask themselves.  

My motivation for blogging is to improve my writing chops to the point where I can communicate well about technical matters.  Well enough to write a technical book, which is something I've always wanted to do.  A secondary goal would be to increase my visibility within the tech industry and provide an avenue for me to establish myself as knowledgeable.  A tertiary goal might be at some point to have enough readers where some advertising revenue could be gained, perhaps enough to pay for hosting of the site.

I think blogging is an important medium for communication on the internet.  I also think it's unique in that it gives people an avenue for their voice to be heard.  There are a lot of good bloggers on the internet, and one of the things I plan to do is putting together a links page for good technical and non-technical blogs.

In addition to blogs being an excellent source of mostly good technical information from people in the industry with first hand experience, they're also frequently a fun source of opinion from people who don't get column space in the paper.  For someone involved in technology as a career and passionate about tech in general, it can be a lot of fun to spend an hour or two just reading other peoples thoughts in blog form.

Now of course as a programmer, the first thing I ran into when I started my blogging career, was where to host my blog and what software to use.  After probably not looking around enough and not wanting to use some hosted blogging service, I of course decided to write my own which I could chalk up as a learning experience.

So I started working on Bagombo.  Of course, this ate up my time for blogging.

## Why not Bagombo?

Bagombo is basically a blog engine.  It's written in C# and uses ASP.NET Core and Entity Framework Core.  You can find it [here](http://github.com/tylerlrhodes/bagombo).  At 222 commits and over a year of on and off work, I've decided that while Bagombo with some more effort could become something other people would want to use and was basically good enough for me, my energy could be better spent.

So while I have a lot of ideas for what could be done with Bagombo, I've decided for now to stop working on it and actually get to blogging.

That's not to say that Bagombo isn't still a reasonable blog engine that may be what some folks are looking for.  For me the main drawback is that it's driven by SQL Server, or any database engine you can use with Entity Framework Core with some minor code changes.

This isn't really a bad thing per say, but it is more expensive to run then it is to just use static files.  And that's the main reason I'm switching.  After a lot of thinking about it I came to the conclusion that I really wanted something that basically just used AWS S3 as its backing store instead of SQL Server.  

Now Bagombo's data model would allow for this change to be made.  But I'd rather just spend my time on actual blogging and learning some new things for now.  I think I'll store up some of my ideas for Bagombo and possibly move forward with them at a later time.

## Why Hugo (for now)?

Hugo seems like a solid static site generator and with a little work I'll have an automated setup for deploying to AWS S3 and CloudFront.

Hugo is fairly powerful, and it's written in Go, which is appealing to me.  You can find more information about it out on the internet.

It's a little confusing to use at first and the docs could be a little less scattered, but once you start to pick up on it Hugo is seems solid.

It should also give me a chance to blog instead of fretting over developing new features for a blog engine.

The experience with Bagombo does however have me thinking of ways to make money by developing blogging software and a platform, however, I want to let these ideas marinate for a while before developing something that will be dead in a year.

So onto blogging!  