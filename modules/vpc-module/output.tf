output "vpc_id" {
  value       = try(aws_vpc.sr-vpc.id, "")
}

output "av_ids" {
  value = [
    for sbn in aws_subnet.private_subnets : sbn.id
  ]
}