---
title: "Deploying a Web App with Ansible and Terraform on AWS, part 2"
date: 2021-01-16
draft: true
series: tech
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
* Terraform
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
the ones that if they were lost, would cost me money, or allow for
private information to become available.

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
able to do bad things with my AWS account if it gets hacked.

There are two sets of credentials here that need to be managed.

One is for the deployment of the environments using Terraform.  This
set of credentials needs access to create resources in AWS, such as
the EC2 instance, S3 Bucket, and associated required resources (VPC,
internet gateway, etc).

This set of credentials needs to be setup in Terraform Cloud in
addition to being setup locally for anything deployed not using
Terraform Cloud.

There is also an API key generated within Terraform Cloud to enable
communication between the cloud and the CLI which needs to be managed.

I've decided to just store these credentials in 1Password and be done
with it.

The other set of credentials is for access to S3 from the application.
While these credentials won't need to be able to create the buckets,
they will need to be able to read and write to them.

It looks like a reasonable approach to take, with the development and
production environments, would be the use of specific IAM roles which
can be attached to EC2 instances.  This allows the EC2 instance to use
temporary credentials, managed by AWS, to access resources in the AWS
environment.  The configured IAM role of course would only have access
to S3 in this case.

I followed an easy guide that I found on
[Medium](https://medium.com/@kulasangar/creating-and-attaching-an-aws-iam-role-with-a-policy-to-an-ec2-instance-using-terraform-scripts-aa85f3e6dfff)
to set this up and get it running.  It involves creating some AWS
resources including an IAM role, IAM policy, and them linking them
together, dumping them in a profile, and attaching the profile to the
EC2 instance.  The code for this is in the repository.

* limit EC2 access for the role and validate



A slight drawback here is that running the program locally, I'll still
have to use local credentials, so there may be a slight difference in
how the application acquires it's credentials between local and other
environments.  However, due to the way that the AWS SDK resolves
credentials by default, in practice this shouldn't be a problem at
all.  Between the development and production environments, both on
AWS, the process would be identical.


-- Do this and write about it




### SSH Private Keys

There will be a public-private keypair for both development and
production, which will be used for authenticating to the EC2 instance
via SSH.  This keypair needs to be identified during the environment
creation, and specified in the Terraform code.

One mistake that I've made so far is that my private key isn't
protected with a password, which is a good measure, in addition to not
checking into source control on accident.

This is pretty easy to remedy, and can be done with the following
command:

```
ssh-keygen -p -f ~/.ssh/id_rsa
```

Of note is that this changes the actualy file and doesn't produce a
new file.  The key is encrypted with a password, and using it with the
SSH client will result in you being prompted for the password.  Also,
there is no way to recover the password if you lose it.  The
authentication keys would have to be replaced.

While it may not be the best way to manage the private key, again I'm
just going to use 1Password and store the password protected key there
to share between computers when needed.

### nginx SSL Certificate

In production I'm planning on using Let's Encrypt for the public key,
and I think managing that key like I need to do with the development
environment is basically a moot point.

I'm even thinking of just setting up Let's Encrypt for the development
environment as well, but for now I have simply generated a certificate
that is part of the deployment process.  

I'm not really worried about the security of this certificate at all.
It's basically just used for development to have the connection over
SSL.  If hackers "decrypt" the communications of my development
environment I could basically care less.  It's more or less keeping
track of it from a management perspective.

So while it's probably "bad-form" I'm just going to check in the
private key to source control to make it easier.  I suppose there is
some risk if I use a password here that I use for production or for
some other services, but my "highly secure" development passwords
usually aren't like that.

## Terraform

I am still not a Terraform expert by any means, but know that this
project is simple enough that it's best not to get carried away.

My current understanding is that each environment basically needs its
own root directory to work from.  

When Terraform processes the files it locates the code in the working
directory to plan, apply, or destroy the infrastructure.  I have yet
to find a way where the development and production Terraform code can
live in the same directory, which is fine, and makes sense.

My Terraform code involves setting up some infrastructure around EC2,
S3, and the networking.  I have only done development so far, but
production is basically going to look identical to this.  Even if this
project were to need to scale, I think that would involve just adding
in a load balancer and increasing the number of EC2 instances.

While I could factor out some of the code into modules, at this point
it's just not worth the effort.

I'll live with some duplication of code here.

One thing that I could potentially do is move a few of the variables I
have in the Terraform into their own file.  One spot production will
look different is the DNS configuration, but it will be different
enough where it probably won't just be swapping out a variable.

I'll punt on that a bit until I actually put production up.

## Ansible

- seperate inventory by dev and prod: for certificate installation

- How to limit ansible tasks: set intersection

https://www.digitalocean.com/community/tutorials/how-to-manage-multistage-environments-with-ansible

https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html

* variables / templates

* handlers

Approach seems to be put common web_server tasks under one play, then
have additional plays for dev and prod, where the tasks are customized
to the environment.

Introduce handlers for restarting services as required.

May not need variables of templating.

























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
- ansible.cfg file


* Build and deployment system

* Thinking about testing

