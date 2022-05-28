output "name" {
  value       = try(aws_launch_configuration.as_conf.name, "")
}