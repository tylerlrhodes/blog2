---
title: "A Hugo Blog on AWS"
date: 2018-03-16T23:04:41-04:00
draft: false
tags: [
    "hugo",
    "aws"
]
---

I'm running my blog on AWS using only static content that I use Hugo to generate.  I've got my own domain,
DNS, SSL, CDN, storage, and automated deployment setup and the expected cost is about 5 dollars a month.  

Now to get this setup for yourself it could take a few hours, or it could take you
a lot longer.  

If you are a technical person who understands AWS and the infrastructure of the web it shouldn't
take long to do.  

If you are a new blogger who just wants to blog but doesn't know about any of this other stuff 
pay someone to do it so you can actually get it to work, or find a service that does it for you.

I'm not going to detail every step that I took to get this working.  Instead I'm going to go over it from a high level
and show you what tools I used to make this work.


## Hugo

Hugo is what I used to build the site's content and structure.

Hugo takes a theme and layout and applies it to your content and metadata to generate a static site.  It's a fairly lightweight application
written in Go that runs on multiple platforms.

A static site is just a collection of resources and doesn't include any server-side code which runs.

While this is limiting in some regards it can lower your hosting costs and offer flexibility.

When you combine your output from Hugo with AWS (or another provider) you can get a site that is fast, cheap, and easy to maintain.

## AWS

AWS (Amazon Web Services) is a lot of different things. It is the cloud.  It lets you build things using
different services which you can tailor to your needs.  You pay for what you use.

For my blog, I'm using the following services from AWS:

* Route 53 - this is the DNS for tylerrhodes.net
* SNS (Simple Notification Service) and SES (Simple Email Service) - I used these solely for getting the domain validation email for my certificate.  I used the article [here](https://aws.amazon.com/premiumsupport/knowledge-center/ses-sns-domain-validation-email/) to do it.
* AWS Certificate Manager - manages my SSL certificate for tylerrhodes.net
* AWS S3 - this is the storage for the site.
* AWS CloudFront - this is the CDN.
* AWS IAM - this is for the account I use to upload to S3 and refresh the CDN.

So basically if you just go and find someone to host your blog/site for you, they'll do all this for you.

If not, have fun piecing them all together to get it working.  If you know the basics of what these services provide it's really not too bad.

Previously I was using a Windows EC2 instance to host the site which was based on ASP.NET Core and SQL Server.  It cost about 25-30 dollars a month.  This should cost about 5 dollars a month.

The SSL certificate is provided by Amazon for free so long as you use AWS (although you can't just use the certificate on an EC2 instance unfortunately (use Let's Encrypt there)).  You also have to 
factor in the price of the domain registration, so maybe with that it's 6 dollars a month.

## Deployment

This is the part I'm happiest with.  Using the AWS CLI for PowerShell Core, I put together the following little 
script which does it all for me.  I don't even have to login to AWS to deploy updates to the blog.  (Granted there are some improvements I can make here)

<script src="https://gist.github.com/tylerlrhodes/b401ff317f865a3e04f7854d99770984.js"></script>

I store all my content and works in progress on GitHub.  You can check it out [here](https://github.com/tylerlrhodes/blog) if you would like.

## Conclusion

I'm happy so far with my new setup.  Before I had been writing my own blogging software called Bagombo.  It was fun and it's actually useable as a blog engine now.
But I determined that I didn't like paying for the hosting and it ran its course.  If you're interested in it you can checkout the [source code](https://github.com/tylerlrhodes/bagombo).

So now I have cheap, fast, reliable hosting and a capable site generator that I can muck with if I want to.

Now it's time to look at Lambda.

