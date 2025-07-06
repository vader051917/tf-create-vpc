output "public_ec_ip" {
  value = aws_instance.vm["public"].public_ip
}

output "private_ec2_ip" {
  value = aws_instance.vm["private"].private_ip
}
