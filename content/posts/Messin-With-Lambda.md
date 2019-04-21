---
title: "Messin With Lambda"
date: 2018-03-25T20:58:52-04:00
draft: false
tags: [
    "aws",
    "lambda",
    "golang"
]
---

Well I finally found a little time to play around with AWS Lambda using Golang.  It wasn't painless, but it wasn't terrible once I started to get the hang
of it.  I'm a beginner at both Lambda and Golang for the most part, and throw in the use of the API Gateway and it took a little time to work out.  But
I managed to get it going and it is pretty cool.  One nice part is that Lambda will be basically free unless I get a ton of traffic to some API that I'm 
not using at all.  So hopefully there isn't someone out there searching for random APIs to call.  Hmmm, maybe I should turn it off...

My initial feelings with Lambda and "Serverless" programming is excitement more then anything else.  It has the potential for some really cool applications
and takes the whole pay for what you use concept to new levels.  AWS bills for Lambda literally by how long your code executes for.  They measure this in
GB/seconds and the number of requests.  The first 400,000 GB seconds and 1,000,000 requests per month are free.  This doesn't expire after a year like some
of the other free stuff they have on AWS.

Now there are some things with Lambda that I haven't worked out yet and the tooling around it and the documentation could be better.  One of the more 
compelling use cases for Lambda is to use it as an HTTP backend for an API.  Amazon has a few different ways where you could setup deployment stages and integration
with their API Gateway for managing releases. With CloudFormation and the Serverless Application Model it should be possible to do this, but the initial setup
would take some work.  That being said, the more I look at AWS the more it looks like doing anything on AWS and not using CloudFormation could be a serious
mistake for production deployments.  It lets you define your entire infrastructure for your application in JSON or YAML and scale and modify it as needed.

Now the internet is littered with the downsides of Serverless programming and just like the whole Docker thing it has its good and bad.  I haven't done anything
serious with it to know first hand but I've also seen littered on the internet positive stories of using it as well.

My take on it is that the largest downside is vendor lock-in.  And not lock-in like I have a server in a server room that I'm stuck with.  Lock-in like I 
architected my application to run on some 3rd party cloud and now I'm basically stuck there.  Throw in a choice like DynamoDB on AWS or Cosmos on Azure and
stuck there you are.  

Now in my experience you're most likely going to be just as stuck with SQL Server or Oracle if you pick one of those and develop locally
or in an RDS instance.  But with one of those while you are stuck with either Microsoft or Oracle software, you still have the flexibility of migrating your 
data somewhere else.  There are also migration stories for moving from one database to another and if you're software is written so that you don't have TSQL
scattered everywhere in your code you should be able to successfully migrate to other database software.   

What I don't see yet is how to migrate a serverless application on AWS to Azure or another provider.  I do know that there is an open source project called OpenFaaS 
(Functions as a Service) which lets you have your own Serverless fun anywhere you want to run it.  It's in it's early stages and beyond playing around it's probably
going to be a while (if ever) before a company would build something for it.  What it does almost have however is a migration story.  Functions get packaged as programs
in Docker containers.  If the input and output mechanism is standardized then you would have some portability.  There's even an API Gateway.

But I drank the AWS kool-aid for some reason and just like I like Apple stuff too (as I write this on a PC) I want to use Lambda.  Azure Functions just has a funny
name in my opinion and it doesn't look like they support Golang in their functions.  

So despite the lock-in problem and since my new Hugo based blog lacks comments, my first Lambda programming assignment for myself is going to be to build a Lambda
based commenting system.  I even think I'm going to use DynamoDB as the backend.  I'm starting to really like the idea of stuff where I don't have to manage a 
server at all and scales automatically for you.

The farthest I got the other day was getting one function up and running through the API Gateway.  I figured out how to get access to the request object after 
misconfiguring the API Gateway and fighting with it for a while.  It's basically the code you'll find on the AWS documentation site.  I also switched to using the 
AWS CLI instead of their PowerShell management tools.  Soon I'll go further to the dark side and use CloudFormation.  

The code for the function is below.

<script src="https://gist.github.com/tylerlrhodes/1a3c3125b8fabea6808fbde1a4fec741.js"></script>