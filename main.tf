terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# locals {
#   now = formatdate("YYYY-MM-DD", timestamp())
# }
# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"

  #   default_tags {
  #   tags = {
  #     creation_date  = formatdate("YYYY-MM-DD", timestamp())
  #   }
  # }
}


module "vpc-mod" {
  source = "./modules/vpc-module" 
  vpc_cidr    = "172.10.0.0/16"
}

module "sec-mod" {
  source = "./modules/sec-group-module" 
  vpc_id = module.vpc-mod.vpc_id
  depends_on = [ module.vpc-mod ]
}

module "launch-mod" {

  source = "./modules/launch-conf-module" 

  name  = "sr-config"
  instance_type = "t2.micro"
  sg_id = module.sec-mod.id

  depends_on = [
    module.sec-mod
  ]

}

module "autoscaling-mod"{
  source = "./modules/autoscaling-module"

  name = "sr-autosc"
  launch-name = module.launch-mod.name # aws_launch_configuration.as_conf.name
  min = 1
  max = 2
  desired = 2
  av_zones = module.vpc-mod.pr-subnets
 
}

module "balancer-mod" {
  source = "./modules/loadbalancer-module"

  subnets = module.vpc-mod.pu-subnets
  sec_id = module.sec-mod.id
  vpc_id = module.vpc-mod.vpc_id
  depends_on = [ module.vpc-mod ]
}