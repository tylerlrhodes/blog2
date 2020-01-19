---
title: "Ansible Terraform AWS and Clojure"
date: 2020-01-19T10:28:58-05:00
draft: true

---

In this post we are going to focus on the build and deployment of a
web application developed with Clojure.  We are going to deploy the
application to AWS, and it is going to run on a single EC2 instance.
While it won't necessarily be "web-scale," in our case it won't need
to be.

The application itself will be a simple one, and its development won't
be covered in this post.  It is a simple application for tracking
daily goals progress and expenditures.  It's written in Clojure and
ClojureScript. It uses a simple file-based system for storing data.
No databases required.

We will build out our infrastructure using *Terraform*, and then we
will deploy our code and configuration using *Ansible*, and it will
run on AWS.

We'll build out a simple *dev* environment for testing, and a
*production* environment for the real thing.  If you follow along and
deploy it to your own AWS environment it may cost you real money.  I
won't be covering potential costs in this post.

By the end of this post we'll have a functioning environment and
deployment system, which in addition to hosting the web application,
will also automatically utilize *Let's Encrypt* to acquire a free SSL
certificate.

Oh, fyi, this is the first time I'm doing this and its basically
pieced together random bits of information on the internet.  I didn't
even stay at a Holiday Inn Express last night.

Caveat emptor.

So anyway, to start out, let's just kind of wing it and build up the
development environment.

## Getting Started

First, I'm doing this on an Ubuntu workstation and I've already
installed Terraform, Ansible, and a utility which helps connect
Ansible and Terraform in a way.

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

This post is going to go over the broard strokes and occasionally dip
down into the details to help out.  But it's going to leave a lot out
and assume you can follow along anyway.

The first thing we're going to do is get our dev environment setup on
AWS using Terraform.

I'm going to define success here as a running EC2 instance publicly
accessible via DNS, with an SSL certificate, running the simple web
application.

Let's tackle the Terraform part of that now.

Terraform allows us to pretty easily define our infrastructure as
code.  It took me an hour or two to get my initial setup working,
because the Terraform getting started guide of course didn't work for
me.  I think it has to do with some different defaults on my AWS
account.

Basically, all the AWS resources are defined in code, and Terraform
processes the code, creates/modified/deletes the infrastructure on
AWS, and everything is great.  A repeatable, clearly defined
infrastructure that isn't driven by clicking through a GUI or one off
commands that you can only dream of repeating identically the next
time you need to.










