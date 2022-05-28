variable "vpc_id" {
 type = string 
}

variable "ports_list" {
 type = list(any) 
 default = [ {
     port = 80
     protocol = "tcp"
     source = "0.0.0.0/0"

 } ]
}
