provider "aws" {
  region = "us-east-2"
}

# Data source to fetch the existing Elastic IP
data "aws_eip" "existing_eip" {
  public_ip = "13.58.73.5" # Replace with your existing Elastic IP
}

resource "aws_security_group" "allow_web_traffic" {
  name        = "allow-web-traffic"
  description = "Allow HTTP/HTTPS inbound traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP access from any IP address
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTPS access from any IP address
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH access from any IP address
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create a new EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0ca2e925753ca2fb4" # Amazon Linux AMI in us-east-2
  instance_type = "t2.micro"
  key_name      = "ansible-kp"
  vpc_security_group_ids = [aws_security_group.allow_web_traffic.id] # Associate the security group

  tags = {
    Name = "Tommy-Jenkins"
  }
}

# Associate the existing Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.example.id
  allocation_id = data.aws_eip.existing_eip.id
}
