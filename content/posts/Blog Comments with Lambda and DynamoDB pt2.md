---
title: Planning to Build a Blog Commenting System with Lambda and DynamoDB, part 2
date: 2018-04-08T15:10:06Z
draft: false
series: tech
tags: [programming]
description: After planning I decide not to implement a custom commenting system using Lambda and DynamoDB.  It would be a lot of work.
keywords: [AWS, Lambda, DynamoDB]
---

Well during the last post I said that I didn't think long enough or hard enough before deciding to build
out a commenting system using Lambda, DynamoDB, API Gateway and Cognito.

While writing that post I realized just how much work it would be.  I spent a few hours yesterday and went
back on my previous decision to just build one.  While I think it would be a worthwhile project, there were
a few key things that are holding me back at this point.

* CloudFormation would take a long time to get right
* The Serverless Application Model documentation is unclear about some parts
* Not a lot of information on debugging Golang Lambda functions locally 
* I can just use Disqus

I think the fractured documentation on setting this up with CloudFormation is the one thing that really made
me decide to go another route.  CloudFormation is something I want to learn more about, but it's not really
at the top of my priority list right now.  I kind of don't want to embark on a 3 or 4 month side project that
doesn't really align with what I would rather be learning in my free time.

I could have built it out without using CloudFormation, but that would have made it hard to share with others 
so that they could deploy it into their own environment.

I think I'll take a slower approach to this and get used to using CloudFormation with some other side projects
that aren't such a large undertaking.  I don't use any AWS stuff at work so while I do like doing it, there 
are a few things I could better focus my learning on career wise.

So part 2 of this is basically me putting this project on hold and deciding to use Disqus.
