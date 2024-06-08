provider "aws" {
  region = "us-east-2"
}

# Create a new EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0fb653ca2d3203ac1" # Amazon Linux 2 AMI in us-east-2
  instance_type = "t2.micro"

  tags = {
    Name = "Tommy-Jenkins"
  }
}
