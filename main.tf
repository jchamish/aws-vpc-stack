provider "aws" {
    region = var.region
    profile = var.profile
}

variable "vpc_ip_address" { type = list(string) }
variable "profile" { type = string }
variable "region" { type = string }
variable "vpc_name" { type = string }

# Create a new VPC
module "vpc" {
  source = "./vpc"
  vpc_name = var.vpc_name
  vpc_ip_address = var.vpc_ip_address
}

# subnet  Public
module "subnet-general" {
  source = "./subnet-general"
}


# create Security Groups
module "sg" {
  source = "./sg"
  vpc_id = module.vpc_id
}