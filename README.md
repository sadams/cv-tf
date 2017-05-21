# terraform cv

## usage

If you don't know what this does or how to plan the runs first, don't do this:

    terraform apply -var-file terraform.tfvars

## prereqs

1. have domain name registered with any registrar
1. have aws cli setup with credentials files in home dir
1. clone/download this repo
1. copy `terraform.tfvars.example` to `terraform.tfvars` and fill
1. manually create aws route53 Hosted Zone with the name matching `terraform.tfvars`:
    web_cv_domain = "yakspa.com" # (has trailing dot in aws HZ)
1. with external registrar, point domain to above Hosted Zone nameservers (get from aws console in the default record sets NS type)
1. have an ansible repo from which to install the app


## what does it do?

1. sets up EC2 (in eu-west-1 by default):
  1. vpc
  1. subnet
  1. gateway
  1. routing table
  1. t2.nano, ubuntu 16 instance
    1. includes userdata to bootstrap the instance with ansible installation and
    `ansible-pull` cron to given repo (see `terraform.tfvars`)
  1. elastic IP (EIP) to instance
  1. security groups (ssh and http)
1. sets up Route53 Record Sets (`example.com` and `www.example.com`) against your
existing Hosted Zone to point to the public EIP of the webserver.

## Associated repos

The source code for generating the html/css/js that makes up the release package:
https://github.com/sadams/cv

To deploy this application to the web servers:
https://github.com/sadams/cv-ansible
