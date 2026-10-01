
#Key pair
resource "aws_key_pair" "my-key" {

  key_name = "terra-ec2-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCyaJzCyemxXR09we/DraFcRMsCIV4Crc4eKfuPw9dcAtRKutXE/CO2EW377cDq7Q5x7yFyil2iGgCq0tYNk2pB794nEyQ9SNAgqwxD/lza6t8HEm7kIEkbDuY212AtT/dkEUUYDkkM5T/TvbUW1BcwoSAMDbdkAUTKJj9TSVtB6qkPRoK+jgoeLkx0x+BT8gvvGUYy38x29px4eClPu7dP/AwGL2TtdX/Gu5AY4WS9DDdd+SKDd6oI6Qa69rR9icH5M6yuYIRNJ1jmr80XrCyh87qvfupZ0g273Kv7ml+VZAjTrZtZIWpYgpIktc7xwh4tAUrF9fNL2Ki/XNFpsPtZ docker-new-key"
  tags = {
    Environment = var.env 
  }
}

#Default VPC
resource "aws_default_vpc" "default" {
  
}

# Security Group
resource "aws_security_group" "my-sec-g" {
  name = "automate-sg"
  description = "This will add a TF generated Security group"
  vpc_id = aws_default_vpc.default.id     #Interpolation 

  tags = {
    name = "${var.env}automate-sg"
    Environment = var.env
  }

  #Inbound Rules
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks= ["0.0.0.0/0"]
    description = "SSH Open"

  }

  ingress {

    from_port =80
    to_port = 80
    protocol = "tcp"
    cidr_blocks= ["0.0.0.0/0"]
    description = "HTTP Open"

  }

  #Outbound Rules
 egress {
  
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]

 }

}

#EC2 creation
resource "aws_instance" "my-instance" {
   #count = 1 # Dynamic Metadata Argument
   for_each = tomap({
     TWS-dev01= "t3.micro"
     TWS-dev02 = "t3.micro"
     


   })
   key_name = aws_key_pair.my-key.key_name
   security_groups = [aws_security_group.my-sec-g.name]
   instance_type = each.value
   ami = var.ec2_ami_id

   root_block_device {
     volume_size = var.env == "prod" ? 20 : var.ec2_root_storage_size 
     volume_type = "gp3"

   }

   tags = {

    Name = "TWS-EC2-${var.env}"
    Environment = var.env


   }

  
}

