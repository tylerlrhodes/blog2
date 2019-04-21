---
title: "Planning to Build a Blog Commenting System with Lambda and DynamoDB, part 1"
date: 2018-04-04T19:08:41-04:00
draft: false
tags: [
    "aws",
    "lambda",
    "dynamodb"
]
---

Adding comments to your blog is easy for the most part.  You sign up for Disqus either for free or pay them a monthly fee and you
have comments on your blog.  Unless that is you want to roll your own commenting system.  Which by itself isn't that hard to do, but
gauging from reading different things on the internet and my experience with Bagombo, is kind of tricky to do right.  

Disqus has some nice features if you want it.  It supports social like commenting and almost looks like a FaceBook feed more then
a simple string of comments when you see an active one.  It certainly looks like the easiest way to add comments to your blog.  You sign up,
sprinkle some JavaScript on your site and you're all set.  You however are stuck doing things the Disqus way.  It apparently does offer
the ability to export the comments from your site as XML, so in theory you would be able to migrate to another system if you wanted.

However, after not thinking about it long enough or hard enough, I'm of course planning on building a comment system using AWS Lambda,
DynamoDB, and the API Gateway.

Before I get too bogged down in the details, I wanted to think about the following aspects of the design:

* Core Features
* Spam
* Cost
* Security
* Ease of use
* Management


## Core Features

The more I think about the core features for adding in a robust commenting system the more I consider just using Disqus.  That being said,
at its core this is basically a simple system for commenting on blog posts.  The complexity comes in with supporting authentication for users, 
although with Cognito that will be a good exercise and shouldn't be too bad.

Ultimately how much I implement will be a function of how much time I want to put in this.  But I plan on utilizing CloudFormation along with
the other AWS services and releasing it as an open-source project.  This would allow for others to deploy it to their own AWS accounts for use.

Below are the core features that I think it needs to support at a minimum (with the exception of threading possibly).

* Comments
* Threading?
* Formatting comments with HTML
* Mobile friendly
* Delete comments as admin
* Email notification of new comments
* Validate commenters through a login
* Allow for anonymous comments
* Option to require approval for anonymous comments before posting them
* Antispam 
* Scalable 
* Economical

## Spam

When I was using Bagombo which had built-in comments I didn't think spam would be a problem due to the low traffic that it got.  Surprisingly,
within a few days of enabling comments on the blog, I had started to get spam comments.  It seems spammers have a way of finding anything they
might be able to spam.

Mitigating spam with Bagombo was accomplished by using Akismet.  However, I'm slightly worried about using Akismet and calling out to a
third party API from Lambda due to the latency, although in reality it probably wouldn't be that bad.

There are a number of approaches to take such as:

* Require a valid email address
* Require users to sign in
* Use Akismet to check for spam
* Any number of suggestions from the article [here](https://digwp.com/2009/11/dont-need-plugins-to-stop-comment-spam/)

I haven't decided whether or not to just use Akismet yet, which is probably the quickest most straightforward approach.

## Cost

Cost is a variable that is wholly dependent upon how much traffic this blog will get.  Realistically at this point the usage
of both DynamoDB and Lambda will most likely stay within the free tier.  The API Gateway doesn't have a free tier and costs
3.50 per million requests.

I would anticipate the cost for implementing this to be under a few dollars a month due to the low traffic.  If the costs does grow
that would mean I'm getting a number of readers.  I have plans to write an eBook at some point in the future and if I start getting
enough traffic to the blog where serving the comments begins to cost more then a few dollars a month, I should be able to offset that
with eBook sales or some other mechanism of making money.

## Security

The input for comments will need to be sanitized to guard against XSS attacks and other forms of malicious input so that people can't
input JavaScript or anything else that shouldn't go into a comment.  This can be accomplished using an open-source library such as 
[bluemonday](https://github.com/microcosm-cc/bluemonday).

CORS will also need to be setup with the API Gateway to limit requests to the hosting domain of the blog.  It shouldn't be possible for
someone to simple copy the JavaScript code for the comments to add them to a random site.  Ideally this will allow for testing with comments
to be done from a local machine in a non-hosted environment.

Authentication for users and for administration will be done by making use of AWS Cognito.  This should offer a secure method of managing
user logins.

## Ease of Use

It needs to be easy for readers to add comments and authenticate if they want to.  People need to be able to use either a login specific to
the site, or a 3rd party social login such as FaceBook or Twitter.

It also needs to be easy to use from an administrative perspective for deleting and approving comments as needed.

## Management

The commenting system should provide for the following management features:

* Deleting comments
* Configuring notifications

There may be other management related items that are uncovered as development and usage continues.  For example
it may be necessary to block users or disable anonymous comments.



