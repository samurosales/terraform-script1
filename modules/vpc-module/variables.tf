
variable "vpc_cidr" {
  type = string
}

variable "prv_cidrs" {
  type = list(string)
}

variable "pub_cidrs" {
  type = list(string)
}


variable "avzone" {
  type = list(string)
}


