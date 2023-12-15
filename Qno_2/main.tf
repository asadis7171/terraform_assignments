provider "aws" {
  region = "us-east-1"
}


resource "aws_default_security_group" "default" {
  vpc_id = aws_default_vpc.default.id
  
  ingress  {
    description     = "ssh access"
    from_port       = "22"
    to_port         = "22"
    protocol        = "tcp"
    cidr_blocks     = ["0.0.0.0/0"]
   }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
}

}

resource "aws_default_subnet" "default" {
    availability_zone = "us-east-1a"
}

resource "aws_default_vpc" "default" {}

resource "aws_eip" "one" {
  domain                  = "vpc"
  instance                = aws_instance.web.id

}

resource "aws_instance" "web" {
  ami           = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  key_name      = "cloudethix"

  network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index = 0
    
  }

tags = {
    Name = "Asad"
  }
}



resource "aws_network_interface" "test" {
    subnet_id = aws_default_subnet.default.id
    security_groups = [aws_default_security_group.default.id]
    }






