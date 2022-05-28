

data "aws_ami" "amazon-linux-2" {
 most_recent = true

 owners = ["amazon"]

 filter {
   name   = "owner-alias"
   values = ["amazon"]
 }


 filter {
   name   = "name"
   values = ["amzn2-ami-hvm*"]
 }
}

resource "aws_launch_configuration" "as_conf" {
  name          = var.name
  image_id      = data.aws_ami.amazon-linux-2.id
  instance_type = var.instance_type
  security_groups = [ var.sg_id ]

   user_data = "${file("${path.module}/user-data.sh")}"

}