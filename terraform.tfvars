vpc_name = "tf-vpc"

subnet_config = {
  "public_subnet"  = "10.0.0.0/27",
  "private_subnet" = "10.0.0.32/27"
}

subnet_az = {
  "public_subnet"  = "us-east-1a",
  "private_subnet" = "us-east-1b"
}

public_routes = ["0.0.0.0/0"]

sg_ports = ["22", "80"]