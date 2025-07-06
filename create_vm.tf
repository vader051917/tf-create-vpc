# Create ec2 in public and private subnet

resource "aws_instance" "vm" {
  for_each      = var.subnet_config
  ami           = "ami-020cba7c55df1f615"
  instance_type = "t2.micro"
  tags = {
    Name = "ec2_${each.key}"
  }
  subnet_id              = aws_subnet.subnets[each.key].id
  key_name               = aws_key_pair.ec2-key-pair.key_name #Assign created key to ec2
  vpc_security_group_ids = each.key == "public" ? [aws_security_group.sg-public-ec2.id] : [aws_vpc.vpc.default_security_group_id]

}

resource "null_resource" "run_scripts_in_public_ec2" {

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(local_file.private-key.filename)
    host        = aws_instance.vm["public"].public_ip
  }

  provisioner "file" {
    source      = "tf-mkp-private.pem"
    destination = "/tmp/tf-mkp-private.pem"
  }
  provisioner "file" {
    source      = "host_static.sh"
    destination = "/tmp/host_static.sh"
  }
}

# # Create ec2 in public subnet
# resource "aws_instance" "ec2_public" {
#   ami           = "ami-020cba7c55df1f615"
#   instance_type = "t2.micro"
#   tags = {
#     Name = "ec2_public"
#   }
#   subnet_id              = aws_subnet.subnets["public_subnet"].id
#   key_name               = aws_key_pair.ec2-key-pair.key_name #Assign created key to ec2
#   vpc_security_group_ids = [aws_security_group.sg-public-ec2.id]

#   connection {
#     type        = "ssh"
#     user        = "ubuntu"
#     private_key = file(local_file.private-key.filename)
#     host        = self.public_ip
#   }

#   provisioner "file" {
#     source      = "tf-mkp-private.pem"
#     destination = "/tmp/tf-mkp-private.pem"
#   }

#   provisioner "local-exec" {
#     command = "chmod 400 ${local_file.private-key.filename}"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt update -y",
#       "sudo apt install nginx -y",
#       "sudo mkdir -p /var/www/html",
#       "echo '<html><body><h1>Welcome</h1></body></html>' | sudo tee /var/www/html/index.html",
#       "sudo chown -R www-data:www-data /var/www/html",
#       "sudo systemctl start nginx",
#       "sudo systemctl enable nginx",
#     ]
#   }

# }
