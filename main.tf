terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

locals {
  createdAt = formatdate("YYYY-MM-DD", timestamp())
}
# Configure the AWS Provider
provider "aws" {
  region = "us-west-2"

    default_tags {
    tags = {
      creation_date  = local.now
    }
  }
}


module "vpc-mod" {

  source = "./modules/vpc-module" 

  vpc_cidr    = "172.10.0.0/16"
  prv_cidrs   = ["172.10.0.0/24","172.10.1.0/24","172.10.2.0/24"]
  pub_cidrs   = ["172.10.3.0/24","172.10.4.0/24","172.10.5.0/24"]
  avzone      = ["us-west-2a", "us-west-2b", "us-west-2c"]
  
}

module "sec-mod" {

  source = "./modules/sec-group-module" 

  vpc_id = module.vpc-mod.vpc_id

  depends_on = [
    module.vpc-mod ]
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

# module "autoscaling-mod"{
#   source = "./modules/autoscaling-module"

#   name = "sr-autosc"
#   launch-name = module.launch-mod.name # aws_launch_configuration.as_conf.name
#   min = 1
#   max = 2
#   desired = 2
#   av_zones = module.vpc-mod.av_ids
 
# }