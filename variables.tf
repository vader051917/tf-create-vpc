variable "vpc_name" {
  type = string
}

variable "subnet_config" {
  type = map(string)
}

variable "subnet_az" {
  type = map(string)
}

variable "public_routes" {
  type = set(string)
}


variable "sg_ports" {
  type = set(string)
}