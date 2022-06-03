output "dns_name" {
   value = aws_lb.balancer.dns_name
}

output ids {
    value = data.aws_instances.test.ids
}