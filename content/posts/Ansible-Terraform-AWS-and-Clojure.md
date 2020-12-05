---
title: "Deploying a Web App with Ansible and Terraform on AWS, part 1"
date: 2020-02-08T10:28:58-05:00
draft: false
series: tech
description: "Part 1 in a series of posts concerning the deployment of
a web application using Terraform and Ansible to AWS"
tags: [ "ansible", "terraform", "aws", "tech" ]
keywords: [ "programming", "tech" ]
---

This is the first post in what will be a few posts concerning the
deployment of a web application to AWS.

This post will provide a high-level overview of the process and
technologies used to deploy the application, and by the end of it a
functioning development environment will be deployable in a repeatable
manner.

While the rest of the posts, and the application, are yet to be
developed, I plan on a few posts (2 or 3) and having a tagged GitHub
which shows the state of the development to go with the associated
post.

The GitHub repo is available
[here](https://github.com/tylerlrhodes/daily-goal/tree/part1), and the
state at the end of this post is marked with the tag 'part1.' It
represents my first take at a repeatable dev environment, and will be
refactored a bit as I go along further.

The application development is a bit orthogonal to this series of
posts, and isn't terribly important.  This outline and deployment
would work for nearly any basic web application on Linux, with
modifications of course.  And I mean **basic**, the end state of this
application is a simple, single server application.  Not a complex
distributed system with multiple databases spanning two cloud providers.

Most of this post is going to be high-level kind of descriptions and
things that I've discovered/done along the way while doing this.  It's
not really a how-to guide, although if you're considering using this
tech for something similar it might be useful to you.

Oh, fyi, this is the first time I'm doing this and its basically
pieced together random bits of information on the internet.  I didn't
even stay at a Holiday Inn Express last night.

Caveat emptor.

So anyway, to start out, let's just kind of wing it and build up the
development environment.

## Getting Started

First, I'm doing this on an Ubuntu workstation and I've already
installed Terraform, Ansible, and a utility which helps connect
Ansible and Terraform.  

So, just to make sure you can expect close to the same results, this
is the software and versions I'm using:

* Terraform - v0.12.19
* Terraform-inventory - v0.9 available at
 [https://github.com/adammck/terraform-inventory](https://github.com/adammck/terraform-inventory)
* Ansible - v2.9.3

I'm not going to go into great detail on every little step of this,
and I'm going to assume the reader can do things like install software
and troubleshoot why it may not be working.

For instance, to work with Terraform and AWS, you need the AWS CLI
installed but I didn't list that up there.

This post is going to go over the broad strokes and occasionally dip
down into the details to help out.  But it's going to leave a lot out
and assume you can follow along anyway.

The first thing we're going to do is get our dev environment setup on
AWS using Terraform.

I'm going to define success here as a running EC2 instance publicly
accessible via DNS, with an SSL certificate, running the simple web
application.

Let's tackle the Terraform part of that now.

## Terraforming things

Terraform allows us to pretty easily define our infrastructure as
code.  It took me an hour or two to get my initial setup working,
because the Terraform getting started guide of course didn't work for
me.  I think it has to do with some different defaults on my AWS
account.

Basically, all the AWS resources are defined in code, and Terraform
processes the code, creates/modifies/deletes the infrastructure on
AWS, and everything is great.  A repeatable, clearly defined
infrastructure that isn't driven by clicking through a GUI or one off
commands that you can only dream of repeating identically the next
time you need to.

When Terraform processes the code and creates the infrastructure, it
needs to keep track of the resources it has created, and how they map
to the resource definitions in the code files.  It does this by
storing the mappings between the deployed resource, and its
definition, in a state database.  The database is basically just a
file and it maps resource ids to the definitions in your code file.

Terraform offers a few ways for managing this state and the mapping to
your code.  The simplest way, is to work with the file locally.  This
however doesn't work so well when you have multiple users, or, in my
case, want to work from multiple computers.

There are a few options for setting up a remote store for the state,
and these options are documented on the Terraform site.  I ended up
going with the Terraform cloud after starting off just using the local
file.  It was easy to setup, and best of all, free.

Since the Terraform getting started guide, which showed basically
exactly what I wanted to do, didn't work, I had more to do in order to
get going.  In the end it wasn't too bad, it just took a little longer
than the five minute getting started guide laid out.

What I ended up doing was a little bit of trial and error to figure
out all the AWS resources I needed to create in order to have a
publicly accessible development server.  In the end I needed to spell
out everything: a keypair, VPC, subnet, internet gateway, routing
table, EC2 instance, security group, and the DNS record.

Really the only interesting part I ran into was figuring out how to
update a resource that was created independently of my Terraform code.
I already had a hosted DNS zone created in Route 53, and I want that
zone to not be destroyed with the rest of my resources I define in
Terraform when I turn off the dev environment.

This is accomplished using a data source, which basically lets me find
a reference to something not defined in my Terraform module.

I'm avoiding going over all of the Terraform definitions because I
don't know them all, and to get my dev server up and running, I don't
need to know it.  When we do the prod server, we'll refactor the
Terraform, and make it more useful down the road.

Overall working with Terraform is a pretty good experience, and the
documentation out there is reasonable.  It was a few more hours work
to get it going than it looked like it might be, but this is pretty
par for the course in technology land.  Sometimes the guide works,
sometimes it doesn't.

If you are a developer, I would imagine that the roadblocks to using
Terraform would be less about Terraform, and more about how
knowledgeable you are about systems, networking, and "the cloud."

Anyway, the development server is defined in *terraform-dev.tv* in the
GitHub repository, and you can see it in all of its glory there.  I'm
sure there are some mistakes built into it, but it seems to more or
less work.

To be fair, the Terraform file in the repo at this point \*works\*,
and seems to work pretty well -- but it needs some refactoring.  Not
just the code (that's probably just about ok), but the directory
structure.  It's not prime-time Terraform, but it's not a bad starting
point I think.

Now onto the next learning adventure, which is using Ansible to deploy
even more buzzwords onto your EC2 instance automatically.

## Deploy Buzzwords with Ansible

So now that we have a dev environment that we can easily turn on and
off again, we need to be able to setup the software on that server.

Now I've decided to use Ansible for this, and I like to think that I
made a good decision to do so, because I don't need a management
server to do anything and when I started playing with all of this it
worked basically right away.

That said, there isn't an \*official\* Ansible provider for Terraform,
and I guess there are for some other configuration/deployment
technologies, but whatever, because so far it works and this is my
blog I can do what I want to.

The thing with Ansible is that you need to do your
deployment/management things from a non-Windows operating system.  Not
a big deal really, and there are ways to do it from Windows with WSL
(I assume anyway), but just a heads up.

Ansible is for the configuration of software on the systems, like
Terraform is for the configuration of infrastructure on the cloud.

By defining "playbooks", which are basically YAML files with tasks to
be run on different hosts, Ansible lets you automate the deployment
and configuration of software.  Actually, you can do other stuff like
automate your network switches and things like that as well.

The dev server (and production too basically) needs a few things to be
installed and configured to host our application.

It's going to need:

* nginx
* Java Runtime
* SSL certificate
* configuration changes for nginx
* configuration to start the web app (it's a java program basically)
* the application

This is actually surprisingly easy to get setup with Ansible.  The only
part that requires digging a little is the use of
*terraform-inventory*, which is a little utility which dynamically
builds an inventory for Ansible from the Terraform state.

Besides that, it's just a matter of composing the configuration files
and the playbook for Ansible.  I basically used the ad-hoc Ansible
command to find the correct usage of the modules to install the
software, and then built a playbook from that.  It was almost too easy
for the most part.

In fact, Ansible was so easy to get started with, that I have to say
I'm pretty impressed.  Again, like Terraform, knowledge about what
you're configuring is probably the limiting factor.

That said, I'm definitely not using Ansible as well as I could be, and
it too needs some work before production.  But -- for now, I can
deploy and configure my dev server with just a few commands, which is
good enough.

## To Conclude Part 1

Getting this stuff working was actually a lot of fun.  I started
working in technology fixing printers and computers (ok actually it
was QBasic but professionally anyway), and progressed into systems and
networking, only to circle back to development.  So I think this
infrastructure as code, and automated deployment and configuration
stuff is pretty sweet.

It took a little bit of time to do (mostly just to write this), but my
development server can be launched in just a few minutes, from
nothing.  Totally awesome.

I would like to be able to just shut it off somehow in case I forget
it's on.  But it's only a t3.nano, which is cheap, but not free.  If it
was more money I would definitely want a shutoff, almost like reverse
monitoring.  The alerts come in when it's still on or something like
that.

There are a few things I have to sort out still, but not really.
Mostly it's just how to manage the private certificates for the
environments for SSH access to the box from my many computers.  But
copy and paste is pretty much fine for now, or maybe keep it in
1Password.  Actually I'll spend some time figuring this out, but it
shouldn't be too bad.

There is definitely some refactoring to be done, and improvements that
could be made to the Ansible and Terraform code.  So after I develop
the app a little more, I'm going to work on this, and the next post
will go into breaking up the Terraform appropriately, and improving
the Ansible a bit with things like handlers and other good practices.












