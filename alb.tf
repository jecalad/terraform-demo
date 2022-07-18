resource "aws_alb" "softserve_alb" {
  name = "softserve-demo"
  internal = false
  load_balancer_type = "application"
  security_groups = [ aws_security_group.alb-sg.id ]
  subnets = [aws_subnet.softserve_public1.id, aws_subnet.softserve_public2.id]

  enable_deletion_protection = false

  tags = {
    Environment = "SOFTSERVE_DEMO"
  }
}

resource "aws_alb_target_group" "softserve-instances-tg" {
	name = "softserve-demo"
	port = 80
	protocol = "HTTP"
	vpc_id = aws_vpc.softserve.id
}

resource "aws_alb_listener" "softserve_alb_listener" {
  load_balancer_arn = aws_alb.softserve_alb.arn
  port = 80
  protocol = "HTTP"

	default_action {
		type = "forward"
		target_group_arn = aws_alb_target_group.softserve-instances-tg.arn
	}
}

resource "aws_alb_target_group_attachment" "instances-tg-attachment" {
	count = length(aws_instance.softserveDemo)
	target_group_arn = aws_alb_target_group.softserve-instances-tg.arn
	target_id = aws_instance.softserveDemo[count.index].id
	port = 80
}

output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value = concat(aws_alb.this.*.dns_name, [""])[0]
}