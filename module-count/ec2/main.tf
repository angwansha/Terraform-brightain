data "aws_vpc" "BKvpc" {
  filter{
    name = "tag:Name" 
    values = ["Non-prod-Domain-VPC-vpc"]

  }
}

data "aws_subnet" "mypublicSN" {
    vpc_id = data.aws_vpc.BKvpc.id
  filter {
    name = "tag:Name" 
    values = ["Non-prod-Domain-VPC-subnet-public1-us-east-1a"]
  }
}
resource "aws_instance" "ec2" {
  ami = var.ami_id
  instance_type = var.instance_type 
  availability_zone = var.az
  associate_public_ip_address = "true"
  iam_instance_profile = var.instance-profile
  user_data = "${file("apache.sh")}"
  key_name = var.keyname
  subnet_id = data.aws_subnet.mypublicSN.id
  security_groups = var.SecurityGroup
  count = length(var.server_names)

  tags = {
    Name = var.server_names[count.index]
  }
}