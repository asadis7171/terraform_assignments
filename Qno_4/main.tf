# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "existing" {
  id = "vpc-0d6ea0ef2223ed351"
}

data "aws_subnet" "existing" {
  id = "subnet-0d6287b4f94af698b"
}


resource "aws_security_group" "new_instance" {
  vpc_id = data.aws_vpc.existing.id
  
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


resource "aws_instance" "web" {
  ami             = "ami-0230bd60aa48260c6"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.new.id
  subnet_id       = data.aws_subnet.existing.id
  security_groups = [aws_security_group.new_instance.id]

  

 /* network_interface {
    network_interface_id = aws_network_interface.test.id
    device_index = 0
    
  }*/

tags = {
    Name = "Asad"
  }
}

resource "aws_key_pair" "new" {
  key_name   = "terraform-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCgv48+kBiHswDcX9R1QBNCa+dtoZPhasjUsrDkHmIkjQbcDye6m7lt9qX0XfXH2ewOM8Zg5LpEGnNiOXTHke6/BBwceoJu+uSXzRZz1krrKw9zHDd6ILipNCMPOMjnWbAy8607Le0rLz4jKkFMpuZRcQ+p9musxoI/9PxyHUixFTaqvPMV/g3FZeC0PwT+Lm9PmLYLdrJOcYsNpt774rjiuwaj+RU4t39pUFvsGEFAWzwSQudu/0dXCNlAenX70kIAJhw65hAa8Dln7666am86xxvjbbXzDK30IHwxGNu8IN/eTb3oBgtxPyoiRHaXQUrmVcaVw7nb+k2PxAvo705eJiIdJ+gC75ijxG2qiHBEuPPqfB9sfFbGz9qz1mChQ6iFc1sCKtiEGIBvVfA1Gib+ZjoNPv4E4vaqGvabHr5Ni7tE+Km8jiFU3WXhdSxuMZ/dVnL/ryqohy84/hrTjnF/f3O2fhdgPpTi1xx83jykfKO2Q5h9yqH0pKSviR3HLb8="
}



resource "aws_network_interface" "test" {
    subnet_id       = data.aws_subnet.existing.id
    security_groups = [aws_security_group.new_instance.id]
    } 