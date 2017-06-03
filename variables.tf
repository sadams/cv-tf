# required to be defined in terraform.tfvars:
variable "aws_key_name" {}

variable "web_cv_domain" {
  description = "Domain name to host the cv on (see README.md)"
}

variable "web_cv_ansible_repo" {
  description = "Non-authenticated git repo for ansible pull"
}

variable "web_cv_ansible_playbook" {
  description = "Path to the ansible playbook used in the web_cv_ansible_repo"
}

variable "web_cv_ansible_branch" {
  description = "Branch checked out by ansible on web_cv_ansible_repo"
  default = "master"
}

variable "web_cv_ansible_beta_branch" {
  description = "Branch checke dout for beta machines on web_cv_ansible_repo"
  default = "develop"
}

variable "web_cv_ansible_checkout_dir" {
  description = "The directory into which ansible-pull will checkout the latest version of the ansible repo to deploy the website"
  default = "/opt/cv-web_ansible-pull-repo"
}

# optionally overridable vars:

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "eu-west-1"
}

variable "aws_az" {
  description = "ECS Availability Zone"
  default = "eu-west-1a"
}

variable "web_cv_region_amis" {
    description = "AMIs by region"
    default = {
        # ubuntu 16 AMIs by region
        # eu-west-1 = "ami-ebe2e78d" # instance-store for use with m1.*
        eu-west-1 = "ami-c9e5e0af" # t2.* require hvm and ebs type amis (hvm:ebs-ssd)
    }
}

variable "web_instance_type" {
    description = "Instance type to use for web serving tier"
    default = "t2.nano"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}
