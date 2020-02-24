---
title: "Deploying a Web App with Ansible and Terraform on AWS, part 2"
date: 2020-02-16T18:13:13-05:00
draft: true
---


This is the second post in the series on deploying at web application
with Ansible and Terraform on AWS.  In the first post (link) I went
over the technologies from a high level, and described getting the
first iteration of a development environment up and running.

By the end of that post, and as shown in the repository, I had a basic
development environment up and running.  However, there was ample room
for improvement, and in this post that's what I'm going to do.  Try to
improve the setup -- both for the development environment, and also
looking to the production environment.

There are a number of spots to improve, that I'll address in this post
(maybe the next one too):

* Managing secrets - private keys especially, AWS credentials
* Terraform - proper use of modules, layout of files, variables and
  output
* Ansible
  * Handlers
  * Splitting files up
  * Dev vs Prod
  * variables
  * inventory

This post is going to dive down into the weeds a little bit more than
the previous post and go into a few details of the technologies used.
I found all of them easy to get started with: building the dev
environment was easy and enjoyable using this stuff.

But, given that my goal is to have a seriously stupidty proof build
and deployment system (to enable my laziness), it's time to improve
upon the beginnings.

## Secrets Management

Starting out, the only secrets I really care about managing here are
the ones that if they were lost, would cost me money, or really really
embarass me.

I'm not building Fort Knox, basically this is for a simple application
for keeping track of daily goals (in a nutshell), and I'm not planning
on having any evil or embarassing goals, but it would be embarassing
if somebody could easily see them, just because it means I didn't
build it correctly.

It would be really bad though if I managed to just put my AWS
credentials up on GitHub or something like that, because that could
cost me money.

- find something to scan github automatically for credentials

Basically I just need to make sure that my private keys are protected,
and that I don't just commit them to GitHub on accident.

They should probably also be password protected, both the SSH key for
the EC2 instance, and the private key for the development web server
certificate.

So the secrets that need to be managed are:

* AWS Credentials: for Terraform, and also application access to S3
* EC2 SSH Private key: need this from a few machines
* Dev server private web certificate: not critical if comprimised
* Others?

### AWS Credentials

So my AWS root account is protected with 2FA, but it's crazy 2FA,
because it's also my Amazon account, which is also protected by 2FA,
so I have to type in two different authenticator codes, but they're
from the same device, so I guess it's still 2FA, just crazy style.

I like to imagine that one day, when my application is making tons of
money, and get's hacked into, some people will laugh at me for using
the same account to buy underwear that I use to pay for my massive AWS
bill.

But besides hoping for laughter in the future, I will try to at least
make it kind of hard for someone to spend my money when I dont' want
them to.  The application, once it's deployed to AWS, should not be
able to do crazy things with my AWS account if it gets hacked.

There are two sets of credentials here that need to be managed.

One is for the deployment of the environments using Terraform.  This
set of credentials needs access to create resources in AWS, such as
the EC2 instance, S3 Bucket, and associated required resources (VPC,
internet gateway, etc).

I'm not sure if for this its necessary to lock this down too much,
since it's really only me that's using these credentials, and they'll
only be used locally.  I've created a user that isn't the root user
through IAM, and the access keys for this are tied to that.

The other is for access to S3 from the application.  While these
credentials won't need to be able to create the buckets, they will
need to be able to read and write to them.

It looks like a reasonable approach to take, with the development and
production environments, would be the use of specific IAM roles which
can be attached to EC2 instances.  This allows the EC2 instance to use
temporary credentials, managed by AWS, to access resources in the AWS
environment.  The configured IAM role of course would only have access
to S3 in this case.

A slight drawback here is that running the program locally, I'll still
have to use local credentials, so there may be a slight difference in
how the application acquires it's credentials between local and other
environments.  However, due to the way that the AWS SDK resolves
credentials by default, in practice this shouldn't be a problem at
all.  Between the development and production environments, both on
AWS, the process would be identical.

### SSH Private Keys



















* managing secrets

figure out easy way to share: probably 1password

- make sure private keys are encrypted - for ssh
- can the private key for the website be encrypted too?

https://security.stackexchange.com/questions/39279/stronger-encryption-for-ssh-keys/39293#39293

nginx:
https://serverfault.com/questions/934132/how-to-configure-nginx-ssl-with-an-encrypted-key-in-pem-format



- private key for host login across devices
- private key for dev server and lcoal host -- doesn't really need to be secure I guess (but we'll make it so)

- AWS Credentials: just use 1Password ... look into beter IAM usage



* Terraform - appropriately factored into modules and folders

- define the desired outcome

   - S3 definition for local/dev/prod
   - other resources for dev/prod -- DNS entries, VPC, server, etc

   - ability to interact independently with each environment
   - not embarassing final state

- terraform modules: https://www.hashicorp.com/blog/hashicorp-terraform-modules-as-building-blocks-for/

- folder structure:

- terraform variables and outputs

  - write a few paragraphs about this
  

* S3 Integration - local, dev, prod

* Ansible - handlers, dev/prod in one file? explore composing playbooks

- define the desired outcome

- ansible variables
- ansible inventory
- ansible handlers
- idempotency



* Build and deployment system

* Thinking about testing

