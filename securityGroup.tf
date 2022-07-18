# create security group for instances ingress traffic

resource "aws_security_group" "instances_sg" {
  name        = "allow_http-instances"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.softserve.id

  ingress {
    description      = "http from alb"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.alb-sg.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}

# Create load balancer security group

resource "aws_security_group" "alb-sg" {
  name        = "allow_http-alb"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.softserve.id

  ingress {
    description      = "http from outside"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}