provider "aws" {
  region = "us-east-2"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow-ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from any IP address
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

# Create a new EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0c9921088121ad00b" # Amazon Linux 2 AMI in us-east-2
  instance_type = "t2.micro" 
  key_name      = "ansible-kp" 
  vpc_security_group_ids = [aws_security_group.allow_ssh.id] # Associate the security group

  tags = {
    Name = "Tommy-Jenkins"
  }
}
