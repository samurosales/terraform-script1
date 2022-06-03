data "aws_availability_zones" "all" {}

resource "aws_autoscaling_group" "sr-auto" {
  name                 = var.name
  launch_configuration = var.launch-name # aws_launch_configuration.as_conf.name
  min_size             = var.min
  max_size             = var.max
  desired_capacity     = var.desired

  # availability_zones   = data.aws_availability_zones.all.names
  vpc_zone_identifier = var.av_zones
  tag {
    key                 = "Name"
    value               = "sr-instance"
    propagate_at_launch = true
  } 

  lifecycle {
    create_before_destroy = true
  }
}