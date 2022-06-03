output "vpc_id_value" {
    value = module.vpc-mod.vpc_id
}

output "sg-id" {
    value = module.sec-mod.id  
}

output "launch_name" {
  value = module.launch-mod.name
}

output "ami-id" {
 value = module.launch-mod.ami_id 
}

output "balancer_dns" {
  value = module.balancer-mod.dns_name
}

output "autosc" {
  value = module.balancer-mod.ids
}