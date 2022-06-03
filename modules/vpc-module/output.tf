output "vpc_id" {
  value       = aws_vpc.sr-vpc.id
}

output "pr-subnets" {
  value = [
    for sbn in aws_subnet.private_subnets : sbn.id
  ]
}


output "pu-subnets" {
  value = [
    for sbn in aws_subnet.public_subnets : sbn.id
  ]
}