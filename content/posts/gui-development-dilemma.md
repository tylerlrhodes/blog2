---
title: "The GUI Development Dilemma"
date: 2018-03-10T16:25:45-04:00
draft: false
series: personal
tags: [
    "musings"
]
---

In my perfect world GUI development would end at the creation of a command line interface for my program.  

In reality we're faced with a multitude of technologies to choose from and support when doing GUI work.  I know that in general this should be a good thing, but in reality I don't think that it is.  Not only are there differences between operating systems, but there are differences between browsers and mobile devices.  

And it gets worse.  There are multiple frameworks/stacks to pick from for each platform now.  But the part that gets bad is not that there are a lot of choices, but that it seems like no matter which direction you choose to take, within a period of 5-10 years you'll be stuck with something that has been superseded by a newer shinier technology.

Microsoft is a prime example of a company doing this.  Win32, MFC, WinForms, WPF, SilverLight and now UWP and possibly others are all a set of ways which you can use to develop a GUI application.  Now ironically if you decide to go with Win32 you'll probably end up with something that may outlive all of the other ones, but chances are nobody is going to write their Windows desktop app in C now.

What we're really left with as developers is that applications which have been started in different time periods and chose the "latest and greatest" to develop with.  This leaves us with the reality of having to support and extend applications written with multiple frameworks.  I think the same kind of thing happens on the back-end, but it might be less apparent and to some extent may not be quite as bad.

I'm a developer that likes to learn new things, but the allure of learning a new language and stack just for the fun of doing it is wearing off a little bit.  Worse then this, I think the fact that we're left with supporting multiple applications written with different technologies in many instances (given this will vary depending upon where you work) leads to sub-standard applications.  It's hard to write great applications when you're stuck switching gears all the time.  There's something to be said for mastering something and the constant churn of technology makes that hard to do.

This places an emphasis on factoring code properly and following good design paradigms such as SOLID for object oriented programming, but even with that I'm of the opinion that all of this churn is in part responsible for problems in the software that we use.

It's 2018 now and despite the push of being security aware, it's painfully obvious that it's hard to write programs that are secure.  Large companies with deep pockets have trouble securing their systems.  Small companies have it even worse.

I think part of this problem comes from the technology churn.  Instead of being able to master a stack and spend a good part of your career on it, we're faced with the constant movement to the latest and greatest.  It certainly doesn't look like this trend will end at any point in the foreseeable future.  

I do like the fact that there are a lot of options to pick from in developing software.  What I don't like is that even when large organizations put out frameworks and stacks to develop with, they too have a shelf life that is a little on the short side.  Worse still is that they frequently have multiple options out there and can't stick to anything for any length of time.

The technology stack that you pick will largely be driven by organizational requirements.  The safe bets are probably something from Microsoft, Oracle and perhaps Google.  Anything else is taking a risk on what should be a strategic asset for you.  If you pick a fly by night technology to work with, you may end up doing a lot of work twice.  There's a reason Java and C# are as popular as they are.  Most new projects aren't written in C, but I have a feeling that doing that would be far from the worst idea possible.

There are a lot of applications out there that need to be supported and are written in "legacy" technology stacks.  I had shelved my books on COM years ago thinking I would most likely never need them.  I have them back on my bookshelf now.  I also have the books for WinForms and WPF, and given enough time I'll probably need the good old Petzold book on Win32.  I can't seem to find where I put mine ...

So if you're just getting into tech, unless you plan on sticking on one team with one company for a long time, get ready to switch gears and learn multiple different technologies.  I don't like to predict things, but chances are with the way internet development is progressing we'll probably see more and not less choices for developing applications.

Unfortunately I think this leads to most places having software of a lesser quality then would be possible than if we were to stick with one thing for a while.  I don't have any proof of this, but it seems a reasonable assumption to make.

Hopefully the tech world can eventually slow down a little bit.  Docker is cool, Windows 10 is nice, mac OSX is slick, and mobile devices are great.  I know the tech companies are driven to add new features all of the time so that they can sell more licenses and support, but in reality, if we spent the next 10 years fixing and securing the crap we have now instead of building more crap on top of it we might be better off.

Although, maybe with all of this technology churn and incessant need to make buttons look cooler, humanity won't have enough time to develop the dystopian future of so many science fiction films.