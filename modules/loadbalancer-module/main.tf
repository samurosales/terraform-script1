
resource "aws_lb_target_group" "sr-target" {
  name     = "sr-lb-tg"
  port     = 80
  protocol = "HTTP"
  # target_type = "ip"
  vpc_id   = var.vpc_id
}

data "aws_instances" "test" {
  instance_tags = {
    Name = "sr-instance"
  }

  instance_state_names = ["running", "stopped"]
}


resource "aws_lb_target_group_attachment" "target-att" {
  count = length(data.aws_instances.test.ids)
  target_group_arn = aws_lb_target_group.sr-target.arn
  target_id        = data.aws_instances.test.ids[count.index]
  port             = 80
}

resource "aws_lb" "balancer" {
  name               = "sr-lb-tf"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sec_id]
  subnets            = var.subnets #[for subnet in aws_subnet.public : subnet.id]

  tags = {
      name = "sr-balancer"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.sr-target.arn
  }
}