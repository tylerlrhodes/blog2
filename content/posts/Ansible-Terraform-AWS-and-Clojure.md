---
title: "Deploying a Web App with Ansible and Terraform on AWS, part 1"
date: 2020-02-08T10:28:58-05:00
draft: true

---

In this series of posts we are going to focus on the build and
deployment of a web application developed with Clojure.  We are going
to deploy the application to AWS, and it is going to run on a single
EC2 instance.  While it won't necessarily be "web-scale," in our case
it won't need to be.

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

By the end of these posts we'll have a functioning environment and
deployment system, which in addition to hosting the web application,
will also automatically utilize *Let's Encrypt* to acquire a free SSL
certificate for the production system.  At the end of this post
itself, the dev environment will be up (hopefully).

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

Working alone, this is pretty simple to manage.  Once you need to work
with other people it will of course be more complicated, and there are
a few possiblities for managing the state and the infrastructure's
code when things progress.

Here I'm going to ignore all of that, and just do everything locally
since it's just me working on this, and you could probably write a
whole book on Terraform if you wanted to.

So what I ended up doing was a little bit of trial and error to figure
out all the AWS resources I needed to create in order to have a
publicly accessible development server.  In the end I needed to spell
out everything: a keypair, VPC, subnet, internet gateway, routing
table, EC2 instance, security group, and the dns record.

Really the only interesting part I ran into was figuring out how to
update a resource that was created independtly of my Terraform code.
I already had a hosted DNS zone created in Route 53, and I want that
zone to not be destroyed with the rest of my resources I define in
Terraform when I turn off the dev environment.

This is accomplished using a data source, which basically lets me find
a reference to something not defined in my Terraform module.

I'm avoiding going over all of the Terraform definitions because I
don't know them all, and to get my dev server up and running, I don't
need to know it.  When we do the prod server, we'll refactor the
Terraform, and make it more useful down the road.

If you are a developer, I would imagine that the roadblocks to using
Terraform would be less about Terraform, and more about how
knowledagable you are about systems, networking, and "the cloud."

Anyway, the development server is defined in *terraform-dev.tv* in the
Github repository, and you can see it in all of its glory there.  I'm
sure there are some mistakes built into it, but it seems to more or
less work.

That file, if you were to change the values of the domain_name under
the locals section, together with a Route 53 zone (that matches the
domain name you define), and a working AWS CLI and Terraform program,
should get you an EC2 instance up and running.  This, of course, is
dependent upon the moon being in the correct phase, and whether or not
the technology gods are currently demanding tribute.

But it will probably more or less work.  Oh you have to generate a
keypair for it to work too.  And maybe some other stuff, but that's
probably it.  You only need the keypair if you actually want to
connect to the instance anyway.

Besides you probably don't want to just deploy random Terraform files
you found on the internet without knowing what they will do (yes,
terraform will tell you want it plans on doing, but if you don't
understand whats in the file, you probably won't understand that
either).

So if you've learned anything so far from this post, it's that
Terraform isn't that hard, and will work, if the moon is in the
correct phase, and the cloud gods permit it.  Also, you should deploy
random Terraform files you find on the internet because YOLO.

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
deployment/managment things from a non-Windows operating system.  Not
a big deal really, and there are ways to do it from Windows with WSL
or whatever, but just a heads up.

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

This is actually suprisingly easy to get setup with Ansible.  The only
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
you're configuring is probably 

* Learn about Ansible Handlers
* "Best Practices"











