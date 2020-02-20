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

So the following needs to be reviewed:

1. IAM permissions that the EC2 instance operates under
2. IAM account for S3 access between environments, and managment of
secrets













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

