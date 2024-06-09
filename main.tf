provider "aws" {
  region = "us-east-2"
}

# Data source to fetch the existing Elastic IP
data "aws_eip" "existing_eip" {
  public_ip = "13.58.73.5" # Use elastic IP from AWS
}

# Security Group for ALB
resource "aws_security_group" "alb_sg" {
  name        = "allow-alb-traffic"
  description = "Allow HTTP/HTTPS inbound traffic for ALB"

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

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Security Group for EC2 instances
resource "aws_security_group" "ec2_sg" {
  name        = "allow-ec2-traffic"
  description = "Allow HTTP/HTTPS inbound traffic for EC2 instances"

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
resource "aws_instance" "wordpress" {
  ami           = "ami-0ca2e925753ca2fb4" # Amazon Linux AMI in us-east-2
  instance_type = "t2.micro"
  key_name      = "ansible-kp"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id] # Associate the security group

  tags = {
    Name = "Tommy-Jenkins"
  }
}

# Create a Load Balancer
resource "aws_lb" "wordpress-lb" {
  name               = "wordpress-tf-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = ["subnet-0dbbac279d1703f37", "subnet-041ff5d291aa144d7"] # Public subnets in NASDAQ VPC
}

# Create a Target Group
resource "aws_lb_target_group" "tftargetgroup" {
  name     = "wordpress-tf-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-0a9bb416daf758d68" 

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200-399"
  }
}

# Create a Listener for the Load Balancer
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.wordpress-lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tftargetgroup.arn
  }
}

# Create a Launch Template
resource "aws_launch_template" "launch-template" {
  name_prefix   = "tflaunch-"
  image_id      = "ami-0ca2e925753ca2fb4" # Amazon Linux AMI in us-east-2
  instance_type = "t2.micro"
  key_name      = "ansible-kp"

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.ec2_sg.id]
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "Tommy-Jenkins"
    }
  }
}

# Create an Auto Scaling Group
resource "aws_autoscaling_group" "terraform-asg" {
  desired_capacity     = 1  
  max_size             = 3
  min_size             = 1
  vpc_zone_identifier  = ["subnet-12345678", "subnet-87654321"] # Replace with your public subnets
  launch_template {
    id      = aws_launch_template.launch-template.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tftargetgroup.arn]

  tag {
    key                 = "Name"
    value               = "Tommy-Jenkins"
    propagate_at_launch = true
  }
}

# Associate the existing Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.wordpress.id
  allocation_id = data.aws_eip.existing_eip.id
}
