output "name" {
  value       = try(aws_launch_configuration.as_conf.name, "")
}

output "ami_id" {
  value = data.aws_ami.amazon-linux-2.id
}
