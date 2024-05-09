# 1] Create VPC 
resource "aws_vpc" "my-vpc" {
    cidr_block = "10.0.0.0/16"
  
  tags = {
    Name = "tf-vpc"
  }
}

# 2] Create subnet

resource "aws_subnet" "my-sub" {
    cidr_block = "10.0.1.0/24"
    vpc_id = aws_vpc.my-vpc.id
    availability_zone = "ap-south-1a"
  
  tags = {
    Name= "tf-subnet"
  }
}

# 3] Create Internet gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my-vpc.id

  tags = {
    Name = "tf-igw"
  }
}

# 4] Create Route Table
resource "aws_route_table" "tf-route" {
  vpc_id = aws_vpc.my-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
        }
        tags = {
         Name = "tf-route-table"
  }
}

# 5] Subnet Association with route table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.my-sub.id
  route_table_id = aws_route_table.tf-route.id
}

#6] Create Key Pair
resource "aws_key_pair" "tf_key_new" {
  key_name   = "tf_key_new"
  public_key = file("${path.module}/id_rsa.pub")

}
# 7 ]Create Security Group


resource "aws_security_group" "tf-sg" {
    description = "Allow ssh and http traffic"
    name = "tf-sg"
    vpc_id = aws_vpc.my-vpc.id

    # 8] Set Inbound Rules
    dynamic "ingress" {
        for_each = [ 22,80,443,3306 ]
        iterator = port
        content {
            description="TLS FROM VPC"
            to_port=port.value
            from_port=port.value
            protocol="tcp"
            cidr_blocks=["0.0.0.0/0"]
        }
        
    }
    # 9] Set Outbound Rules
    dynamic egress {
    for_each = [22,80,443]    
    iterator = shubh 
    content {
          to_port = shubh.value
          from_port = shubh.value
          protocol = "tcp"
          cidr_blocks = [ "0.0.0.0/0" ]
        #   ipv6_cidr_blocks = [ "::/0" ]
        }
     }       
 }

 # 10] Create Instance with key,vpc
resource "aws_instance" "tf_server" {
    ami = "ami-0f58b397bc5c1f2e8"
    instance_type = "t2.micro"
    key_name = "${aws_key_pair.tf_key_new.key_name}"
    subnet_id = aws_subnet.my-sub.id
    associate_public_ip_address = true
    vpc_security_group_ids = [ "${aws_security_group.tf-sg.id}" ]
    availability_zone = "ap-south-1a"

    user_data = file("${path.module}/script.sh")
 
 tags = {
      Name = "tf-server"
    }
    
    
              
}

 


  


