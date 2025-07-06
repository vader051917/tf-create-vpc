vpc_name = "tf-vpc"

subnet_config = {
  "public"  = "10.0.0.0/27",
  "private" = "10.0.0.32/27"
}

subnet_az = {
  "public"  = "us-east-1a",
  "private" = "us-east-1b"
}

public_routes = ["0.0.0.0/0"]

sg_ports = ["22", "80"]
