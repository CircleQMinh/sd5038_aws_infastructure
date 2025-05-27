terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.6.2"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-east-1"
  profile = "default"
}
resource "aws_key_pair" "devops_eks_key" {
  key_name   = "devops_eks_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKwxQFO0XtTKNDtjVFiK9fvcFloFIqzB27DTKOxGd2md admin@DESKTOP-I1S5SR8"
}

resource "aws_security_group" "sg" {
  name        = "devops_eks"
  description = "Security group for EC2 instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
      Name = "sg"
    }
} 


resource "aws_instance" "devops_eks_2" {
  ami           = "ami-09f4814ae750baed6"
  instance_type = "t3.small"
  key_name      = "devops_eks_key"
  security_groups = [aws_security_group.sg.name]
  tags = {
    Name = "devops_ec2"
  }
}