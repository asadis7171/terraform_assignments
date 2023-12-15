# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc" "vpc_01" {
  cidr_block            = "10.0.0.0/16"
  enable_dns_hostnames  = true
  enable_dns_support    = true

    tags = {
    Name = "assig-01"
  }
}


resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc_01.id

    tags = {
       Name =  "Test IGW" 
    }
  
}

#Create Public Subnet 1
resource "aws_subnet" "public-web-subnet-1" {
    vpc_id                  = aws_vpc.vpc_01.id
    cidr_block              = "10.0.0.0/18"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = true
    
    tags = {
        Name = "Public Subnet 1"
    } 
}

#Create Public Subnet 2
resource "aws_subnet" "public-web-subnet-2" {
    vpc_id                  = aws_vpc.vpc_01.id
    cidr_block              = "10.0.64.0/18"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = true

    tags = {
        Name = "Public Subnet 2"
    } 
}

#Create Public Route Table

resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc_01.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }



  tags = {
    Name = "Public Route Table"
  }
}

#Route table association

resource "aws_route_table_association" "public-subnet-1-route-table-association" {
    subnet_id       = aws_subnet.public-web-subnet-1.id
    route_table_id  = aws_route_table.public-route-table.id 
  
}

resource "aws_route_table_association" "public-subnet-2-route-table-association" {
    subnet_id       = aws_subnet.public-web-subnet-2.id
    route_table_id  = aws_route_table.public-route-table.id 
  
}


# Create Private Subnet 1 

resource "aws_subnet" "private-app-subnet-1" {
    vpc_id                  = aws_vpc.vpc_01.id
    cidr_block              = "10.0.128.0/18"
    availability_zone       = "us-east-1a"
    map_public_ip_on_launch = false

    tags = {
        Name = "Private Subnet 1 "
    } 
}


#Create Private  Subnet 2 
resource "aws_subnet" "private-app-subnet-2" {
    vpc_id                  = aws_vpc.vpc_01.id
    cidr_block              = "10.0.192.0/18"
    availability_zone       = "us-east-1b"
    map_public_ip_on_launch = false

    tags = {
        Name = "Private Subnet 2 "
    } 
}


# NAT gateway

resource "aws_eip" "eip_nat" {
   
   domain = "vpc"
   tags = {
      Name = "eip1"
    }
}

resource "aws_nat_gateway" "nat_1" {
    allocation_id = aws_eip.eip_nat.id
    subnet_id     = aws_subnet.public-web-subnet-2.id

    tags = {

      "Name" = "nat1"
      
    }
}


# Route Table for Private Subnet

resource "aws_route_table" "private-route-table" {
    vpc_id = aws_vpc.vpc_01.id

    route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.nat_1.id
    }

    tags = {
        Name = "Private Route Table"
    }
  
}

# Route table association Private subnet


resource "aws_route_table_association" "nat_route_1" {
    subnet_id       = aws_subnet.private-app-subnet-1.id
    route_table_id  = aws_route_table.private-route-table.id
  
}

resource "aws_route_table_association" "nat_route_2" {
    subnet_id       = aws_subnet.private-app-subnet-2.id
    route_table_id  = aws_route_table.private-route-table.id
  
}





