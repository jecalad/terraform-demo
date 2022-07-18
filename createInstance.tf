data "aws_availability_zones" "available" {}

resource "aws_instance" "softserveDemo" {
	count = 3
  ami = lookup(var.AMIS, var.AWS_REGION)
  instance_type = "t2.micro"
	availability_zone = data.aws_availability_zones.available.names[0]
  security_groups = [aws_security_group.instances_sg.id]
  subnet_id = aws_subnet.softserve_public1.id
  

  user_data = "#!/bin/bash\napt-get update\napt-get install -y nginx\nservice start nginx\nami=$(curl http://169.254.169.254/latest/meta-data/instance-id)\necho $ami > /var/www/html/index.html"
  
  tags = {
    Name = "Crash_Server_${count.index}"
  }
}

