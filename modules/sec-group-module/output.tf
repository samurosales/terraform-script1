output "id" {
  value       = try(aws_security_group.allow_trafic.id, "")
}