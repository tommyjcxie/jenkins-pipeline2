provider "aws" {
    region = "us-east-2"  
}

resource "aws_instance" "wordpress_instance" {
  ami           = "ami-05fa00d4c63e32376" # us-west-2
  instance_type = "t2.micro"
  tags = {
      Name = "TF-Instance"
  }
}
