variable "subnets" {
  type = list(string)
}

variable "sec_id" {
  type = string
}

variable "vpc_id" {
  type = string  
}

variable "instances" {
  type = list(string) 
  default = []
}